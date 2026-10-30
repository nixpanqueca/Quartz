// Code by NixPanqueca -w-

#include "quartz.h"
#include "console.h"
#include "prismtu.h"
#include "service.h"
#include "thread.h"
#include "timer.h"

static int running = 0;

/* A thread entry point may never return: the stack it runs on is built by hand
 * and there is nowhere sane to land, so it has to end in thread_exit(). */
static void prismtu_worker(void) {
    for (int i = 5; i > 0; i--) {
        console_printf("[prismtu] worker tick %d, thread %d\n", (uint32_t)i,
                       thread_current());
        timer_sleep(200);
    }

    console_write("[prismtu] worker done\n");

    thread_exit();

    for (;;)
        __asm__ __volatile__("hlt");
}

/* Drives the scheduler, so there is something for `threads` to report. */
static void prismtu_spin(void) {
    int id = thread_create("prismtu", prismtu_worker);

    if (id < 0)
        console_write("[prismtu] could not spawn a worker\n");
    else
        console_printf("[prismtu] worker running as thread %d\n", (uint32_t)id);
}

static void prismtu_threads(void) {
    console_printf("[prismtu] %d thread(s):", (uint32_t)thread_active_count());

    for (int i = 0; i < THREAD_MAX; i++) {
        const thread_t* thread = thread_get(i);

        if (thread && thread->state != THREAD_UNUSED)
            console_printf(" %s(%d)", thread->name, i);
    }

    console_printf("\n[prismtu] scheduler is on thread %d\n",
                   (uint32_t)thread_current());
}

static service_func_t prismtu_funcs[] = {
    /* The drawing ones are the kernel's prismtu.c, exposed here so `call` can
     * reach them the same way it reaches everything else. */
    { "menubar",  prismtu_menubar },
    { "clock",    prismtu_clock },
    { "splash",   prismtu_splash },
    { "about",    prismtu_about },
    { "spin",     prismtu_spin },
    { "threads",  prismtu_threads },
    { 0, 0 }
};

static void Init(void) {
    running = 1;
    console_write("[prismtu] Init\n");
    prismtu_menubar();
}

static void Shutdown(void) {
    running = 0;
    console_write("[prismtu] Shutdown\n");
}

SERVICE_REGISTER("/system/compiled/prismtu/prismtu.service", "PrismT", SERVICE_TYPE_SERVICE, prismtu_funcs)