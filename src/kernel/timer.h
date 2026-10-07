/* Cubic System Software - 8253/8254 Programmable Interval Timer */
/* Replaces the "spin 250000 times and hope" delay() the framebuffer used. */

#ifndef TIMER_H
#define TIMER_H

#include <stdint.h>

#define TIMER_HZ 100u            /* 10ms tick, plenty for a keyboard + shell */

/* Called by the IRQ0 stub: bumps the tick counter, feeds the keyboard's
 * auto-repeat and asks the scheduler for the next stack. */
uint32_t timer_tick(uint32_t old_esp);

void timer_init(void);

uint32_t timer_ticks(void);
uint32_t timer_ms(void);
uint32_t timer_seconds(void);

/* Blocks for roughly ms milliseconds. Requires a schedulable thread; this is
 * what `hlt` based idling replaced. */
void timer_sleep(uint32_t ms);

#endif