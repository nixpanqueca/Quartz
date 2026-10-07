/* Cubic System Software - 8253/8254 Programmable Interval Timer */
/* Replaces the "spin 250000 times and hope" delay() the framebuffer used. */

#include "timer.h"
#include "io.h"
#include "keyboard.h"
#include "thread.h"

#define PIT_COMMAND    0x43
#define PIT_CHANNEL0   0x40
#define PIT_INPUT_HZ   1193182u

static volatile uint32_t tick_count = 0;

void timer_init(void) {
    uint16_t divisor = (uint16_t)(PIT_INPUT_HZ / TIMER_HZ);

    outb(PIT_COMMAND, 0x36);     /* channel 0, lo/hi byte, rate generator */
    outb(PIT_CHANNEL0, (uint8_t)(divisor & 0xFF));
    outb(PIT_CHANNEL0, (uint8_t)((divisor >> 8) & 0xFF));

    tick_count = 0;
}

uint32_t timer_tick(uint32_t old_esp) {
    tick_count++;
    keyboard_tick();
    return thread_scheduler(old_esp);
}

uint32_t timer_ticks(void) {
    return tick_count;
}

/* Split into whole seconds plus a remainder so this stays correct past the
 * 12 hour mark, where tick_count * 1000 would wrap. */
uint32_t timer_ms(void) {
    uint32_t seconds = tick_count / TIMER_HZ;
    uint32_t remainder = tick_count % TIMER_HZ;

    return seconds * 1000u + (remainder * 1000u) / TIMER_HZ;
}

uint32_t timer_seconds(void) {
    return tick_count / TIMER_HZ;
}

void timer_sleep(uint32_t ms) {
    uint32_t target = tick_count + ((ms * TIMER_HZ + 999u) / 1000u);

    /* Signed difference so the comparison survives the counter wrapping. */
    while ((int32_t)(tick_count - target) < 0)
        __asm__ __volatile__("sti; hlt");
}