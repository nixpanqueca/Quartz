/* Cubic System Software - Quartz Kernel */

#include "quartz.h"
#include "console.h"
#include "fs.h"
#include "interrupt.h"
#include "keyboard.h"
#include "mem.h"
#include "multiboot.h"
#include "openfirmware.h"
#include "rtc.h"
#include "service.h"
#include "shell.h"
#include "thread.h"
#include "timer.h"

// Code by NixPanqueca -w-

/* Still the crash path the Prism build used, kept so the parked prism.c
 * keeps compiling. The screen behind it is MacCrash(). */
__attribute__((noreturn))
void kernel_crash(uint32_t crashcode) {
    MacCrash("kernel_crash() was called", crashcode, 0);
}

void quartz_main(uint32_t mb_magic, uint32_t mb_info_addr) {
    /* console_init() puts the card into 80x25 text mode before this, so from here on
 * everything reaches both the screen and the serial mirror. */
console_init();

    console_printf("%s %s - a text mode kernel\n", QUARTZ_NAME, QUARTZ_VERSION);
    console_printf("built %s %s\n", QUARTZ_BUILD_DATE, QUARTZ_BUILD_TIME);

    if (mb_magic != MULTIBOOT_MAGIC)
        MacCrash("bad multiboot magic, is GRUB booting us with 'multiboot'?",
                 mb_magic, 0);

    if (mb_info_addr == 0)
        MacCrash("multiboot gave us a null info pointer", 0, 0);

    const multiboot_info_t* mb = (const multiboot_info_t*)(uintptr_t)mb_info_addr;

    console_printf("[boot] multiboot flags 0x%08x", mb->flags);

    if (mb->flags & MB_CMDLINE)
        console_printf(", cmdline \"%s\"", (const char*)(uintptr_t)mb->cmdline);

    console_putc('\n');

    mem_init(mb_info_addr);
    if (mb->flags & MB_MEMINFO)
        console_printf("[boot] %u KB reported, %u MB usable, %d map entries\n",
                       mem_total_kb(), mem_available_mb(), mem_region_count());

    fs_init(mb_info_addr);
    rtc_init();

    /* IDT and PIC first, but interrupts stay masked until every driver is
     * ready: a timer tick before timer_init() would divide by nothing. */
    interrupt_init();
    timer_init();
    keyboard_init();
    thread_init();

    interrupts_enable();

    console_printf("[boot] timer armed at %u Hz, keyboard live\n", (uint32_t)TIMER_HZ);

    /* Banner plus the o+f chord. Runs on the timer, so it sits after
     * interrupts_enable(). */
    OFinit();

    console_printf("[boot] handing over to the shell\n");

    console_clear();
    shell_init();
    shell_run();

    /* shell_run() never returns. */
    MacCrash("the shell returned, which should be impossible", 0, 0);
}