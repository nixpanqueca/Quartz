/* Cubic System Software - Thread Scheduler */

#include "thread.h"

static thread_t threads[THREAD_MAX];
static int current_thread = 0;

void thread_init(void) {
    for (int i = 0; i < THREAD_MAX; i++)
        threads[i].state = THREAD_UNUSED;
    threads[0].state = THREAD_RUNNING;
    current_thread = 0;
}

int thread_create(const char* name, void (*entry)(void)) {
    int id = -1;
    for (int i = 1; i < THREAD_MAX; i++) {
        if (threads[i].state == THREAD_UNUSED) {
            id = i;
            break;
        }
    }
    if (id < 0) return -1;

    /* Set up initial stack to look like ISR frame.
     *
     * When first scheduled, the timer ISR does:
     *   pusha           <- saves fake registers (ESP points here)
     *   push esp        <- pushes pointer to pusha frame
     *   call scheduler  <- pushes return address, scheduler saves old_esp and returns new_esp
     *   mov esp, eax    <- loads this thread's ESP (points to our fake pusha frame)
     *   popa            <- restores fake registers
     *   iret            <- pops EIP/CS/EFLAGS -> jumps to entry()
     *
     * Stack layout (high addr -> low addr):
     *   EFLAGS CS EIP     <- iret frame
     *   EDI ESI EBP skip EBX EDX ECX EAX <- pusha frame (ESP points here)
     *
     * CS is read from the running kernel to avoid hardcoding.
     */
    uint32_t* stack = (uint32_t*)(&threads[id].stack[THREAD_STACK]);

    uint16_t cs_val;
    __asm__ __volatile__("mov %%cs, %0" : "=r"(cs_val));

    /* iret frame (pushed first, at higher addresses) */
    *(--stack) = 0x00000202;                  /* EFLAGS: IF=1 */
    *(--stack) = (uint32_t)cs_val;            /* CS: kernel code segment */
    *(--stack) = (uint32_t)entry;             /* EIP = entry point */

    /* pusha frame (on top, ESP will point here) */
    *(--stack) = 0;  /* EDI */
    *(--stack) = 0;  /* ESI */
    *(--stack) = 0;  /* EBP */
    *(--stack) = 0;  /* skip (ESP) */
    *(--stack) = 0;  /* EBX */
    *(--stack) = 0;  /* EDX */
    *(--stack) = 0;  /* ECX */
    *(--stack) = 0;  /* EAX */

    threads[id].esp = (uint32_t)stack;
    threads[id].state = THREAD_READY;

    int i;
    for (i = 0; i < 31 && name[i]; i++)
        threads[id].name[i] = name[i];
    threads[id].name[i] = '\0';

    return id;
}

void thread_exit(void) {
    threads[current_thread].state = THREAD_UNUSED;
}

uint32_t thread_scheduler(uint32_t old_esp) {
    /* Save current thread's ESP from the ISR frame */
    if (threads[current_thread].state == THREAD_RUNNING) {
        threads[current_thread].esp = old_esp;
        threads[current_thread].state = THREAD_READY;
    }

    /* Find next READY thread */
    int next = current_thread;
    for (int i = 0; i < THREAD_MAX; i++) {
        next = (next + 1) % THREAD_MAX;
        if (threads[next].state == THREAD_READY)
            break;
    }
    if (next == current_thread) {
        /* No switch needed, return current ESP */
        return old_esp;
    }

    /* Switch to next thread */
    current_thread = next;
    threads[next].state = THREAD_RUNNING;

    return threads[next].esp;
}

int thread_current(void) {
    return current_thread;
}
