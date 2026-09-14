/* Cubic System Software - Thread Scheduler */

#ifndef THREAD_H
#define THREAD_H

#include <stdint.h>

#define THREAD_MAX     16
#define THREAD_STACK   4096
#define THREAD_UNUSED  0
#define THREAD_READY   1
#define THREAD_RUNNING 2

typedef struct {
    uint32_t esp;
    uint32_t eip;
    uint32_t state;
    char name[32];
    uint8_t stack[THREAD_STACK];
} thread_t;

void thread_init(void);
int  thread_create(const char* name, void (*entry)(void));
void thread_exit(void);
uint32_t thread_scheduler(uint32_t old_esp);
int  thread_current(void);

#endif
