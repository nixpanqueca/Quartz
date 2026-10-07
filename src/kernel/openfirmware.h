/* Cubic System Software - Open Firmware and the crash screen */

#ifndef OPENFIRMWARE_H
#define OPENFIRMWARE_H

#include <stdint.h>

/* The crash screen, in text. Same name as the framebuffer era, now with the
 * reason and the register state folded in.
 *
 * `reason` is a short description of what asked to stop and `code` is whatever
 * number makes sense to the caller. `frame` is the register state the exception
 * stubs in src/boot/isr.asm build, and is what makes a real fault readable;
 * pass 0 when there is nothing to show, which is every deliberate panic.
 *
 * Never returns: it halts the CPU with interrupts off.
 *
 * This is the only crash screen. There used to be a panic() / panic_registers()
 * pair in panic.c drawing a second, slightly richer box over the same thing; two
 * screens for one failure meant two places to edit a crash report. */
__attribute__((noreturn))
void MacCrash(const char* reason, uint32_t code, const uint32_t* frame);

/* The firmware screen: a text stand-in for the OpenFirmware dialog. Returns
 * when a key is pressed. */
void OpenFirmware(void);

/* Boot time hook. Prints the startup banner and watches for the o+f chord,
 * which drops into OpenFirmware(). Needs interrupts and the keyboard already
 * initialised, so it has to run after interrupts_enable(). */
void OFinit(void);

#endif