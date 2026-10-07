/* Cubic System Software - Quartz Kernel */

#ifndef QUARTZ_H
#define QUARTZ_H

#include <stdint.h>

#define QUARTZ_NAME        "Quartz"
#define QUARTZ_VERSION     "0.2.0"
#define QUARTZ_BUILD_DATE  __DATE__
#define QUARTZ_BUILD_TIME  __TIME__

void quartz_main(uint32_t mb_magic, uint32_t mb_info_addr);

/* Kept for continuity with the old code: panics with a generic reason. */
__attribute__((noreturn))
void kernel_crash(uint32_t crashcode);

#endif