/* Cubic System Software - Thread Scheduler */

#include "thread.h"
#include "console.h"

static thread_t threads[THREAD_MAX];
static int current_thread = 0;

void thread_init(void) {
    for (int i = 0; i < THREAD_MAX; i++) {
        threads[i].state = THREAD_UNUSED;
        threads[i].esp = 0;
        threads[i].eip = 0;
        threads[i].name[0] = '\0';
    }

    threads[0].state = THREAD_RUNNING;
    threads[0].eip = 0;

    const char* name = "kernel";
    for (int i = 0; name[i] && i < 31; i++)
        threads[0].name[i] = name[i];
    threads[0].name[31] = '\0';

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

    if (id < 0) {
        console_printf("[thread] out of slots, cannot create '%s'\n",
                       name ? name : "?");
        return -1;
    }

    /* The stack is shaped to look like the frame the timer ISR leaves behind,
     * so the very first switch into this thread runs:
     *
     *   mov esp, eax     load our fake ESP
     *   popa             restore the zeroed registers
     *   iret             pop EFLAGS/CS/EIP and jump to entry()
     *
     * Laid out from high address to low:
     *   EFLAGS  CS  EIP      <- consumed by iret
     *   EDI ESI EBP skip EBX EDX ECX EAX  <- consumed by popa
     */
    /* Walk to the top of the stack in bytes first: this is a uint32_t*, so
     * adding THREAD_STACK to it directly would step 4 bytes at a time and land
     * 16KB past the array, in the middle of the threads[] bookkeeping. */
    uint8_t* top = (uint8_t*)(void*)threads[id].stack + THREAD_STACK;
    uint32_t* stack = (uint32_t*)(void*)top;

    uint16_t code_segment;
    __asm__ __volatile__("mov %%cs, %0" : "=r"(code_segment));

    *(--stack) = 0x00000202;                  /* EFLAGS with IF set */
    *(--stack) = (uint32_t)code_segment;      /* CS: whatever we are running in */
    *(--stack) = (uint32_t)(uintptr_t)entry;  /* EIP: the new thread's entry */

    *(--stack) = 0;   /* EDI */
    *(--stack) = 0;   /* ESI */
    *(--stack) = 0;   /* EBP */
    *(--stack) = 0;   /* ESP, skipped by popa */
    *(--stack) = 0;   /* EBX */
    *(--stack) = 0;   /* EDX */
    *(--stack) = 0;   /* ECX */
    *(--stack) = 0;   /* EAX */

    threads[id].esp = (uint32_t)(uintptr_t)stack;
    threads[id].eip = (uint32_t)(uintptr_t)entry;
    threads[id].state = THREAD_READY;

    int i = 0;

    if (name) {
        for (; name[i] && i < 31; i++)
            threads[id].name[i] = name[i];
    }

    threads[id].name[i] = '\0';

    console_printf("[thread] created '%s' as id %d\n", threads[id].name, id);

    return id;
}

void thread_exit(void) {
    console_printf("[thread] '%s' exiting\n", threads[current_thread].name);

    threads[current_thread].state = THREAD_DEAD;

    /* The scheduler skips DEAD threads, so returning here is enough: the next
     * timer tick moves us off this stack. Nothing may run after this point. */
}

uint32_t thread_scheduler(uint32_t old_esp) {
    if (threads[current_thread].state == THREAD_RUNNING) {
        threads[current_thread].esp = old_esp;
        threads[current_thread].state = THREAD_READY;
    }

    int next = current_thread;

    for (int i = 0; i < THREAD_MAX; i++) {
        next = (next + 1) % THREAD_MAX;

        if (threads[next].state == THREAD_READY)
            break;
    }

    if (next == current_thread) {
        /* Staying put. The block above already marked this thread READY on its
         * way in, so it has to be marked RUNNING again: leave it READY and the
         * next tick will skip saving its ESP, because it only saves threads
         * that say RUNNING. The switch back then happens with a stale stack
         * pointer and the iret lands in the weeds. */
        threads[current_thread].state = THREAD_RUNNING;
        return old_esp;
    }

    current_thread = next;
    threads[next].state = THREAD_RUNNING;

    return threads[next].esp;
}

int thread_current(void) {
    return current_thread;
}

int thread_active_count(void) {
    int count = 0;

    for (int i = 0; i < THREAD_MAX; i++) {
        if (threads[i].state != THREAD_UNUSED)
            count++;
    }

    return count;
}

const thread_t* thread_get(int index) {
    if (index < 0 || index >= THREAD_MAX)
        return 0;

    return &threads[index];
}

const char* thread_state_name(uint32_t state) {
    switch (state) {
        case THREAD_UNUSED:  return "unused";
        case THREAD_READY:   return "ready";
        case THREAD_RUNNING: return "running";
        case THREAD_DEAD:    return "dead";
        default:             return "?";
    }
}