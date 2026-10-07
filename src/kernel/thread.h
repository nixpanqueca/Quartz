/* Cubic System Software - Thread Scheduler */

#ifndef THREAD_H
#define THREAD_H

#include <stdint.h>

#define THREAD_MAX     16
#define THREAD_STACK   4096
#define THREAD_UNUSED  0
#define THREAD_READY   1
#define THREAD_RUNNING 2
#define THREAD_DEAD    3

/* The stack comes first and the struct is 16 byte aligned so the top of every
 * thread stack lands on a 16 byte boundary. */
typedef struct {
    uint8_t  stack[THREAD_STACK];
    uint32_t esp;
    uint32_t eip;
    uint32_t state;
    char     name[32];
} __attribute__((aligned(16))) thread_t;

void thread_init(void);
int  thread_create(const char* name, void (*entry)(void));
void thread_exit(void);

/* Called from the timer ISR with the ESP of the interrupted context. Returns
 * the ESP to switch to. */
uint32_t thread_scheduler(uint32_t old_esp);

int thread_current(void);
int thread_active_count(void);
const thread_t* thread_get(int index);
const char* thread_state_name(uint32_t state);

#endif