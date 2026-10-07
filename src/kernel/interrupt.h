/* Cubic System Software - Interrupt Descriptor Table + 8259 PIC */
/* Used to live at the top of keyboard.c, which made no sense. */

#ifndef INTERRUPT_H
#define INTERRUPT_H

#include <stdint.h>

/* Layout of the frame the exception stubs in src/boot/isr.asm hand over:
 *
 *   +0  EDI        +16 EBX        +32 vector
 *   +4  ESI        +20 EDX        +36 error code (0 when the CPU pushed none)
 *   +8  EBP        +24 ECX        +40 EIP
 *   +12 ESP (skip) +28 EAX        +44 CS
 *                                +48 EFLAGS
 */
#define REG_EDI       0
#define REG_ESI       1
#define REG_EBP       2
#define REG_ESP_SKIP  3
#define REG_EBX       4
#define REG_EDX       5
#define REG_ECX       6
#define REG_EAX       7
#define REG_VECTOR    8
#define REG_ERROR     9
#define REG_EIP       10
#define REG_CS        11
#define REG_EFLAGS    12

/* Fill the IDT, reset the PICs and unmask the timer and keyboard.
 * Interrupts stay masked until interrupts_enable() is called. */
void interrupt_init(void);

void interrupts_enable(void);
void interrupts_disable(void);
int  interrupts_enabled(void);

/* Called by the exception stubs. Panics with the vector name and the faulting
 * EIP/registers, then halts. Never returns. */
__attribute__((noreturn))
void exception_handler(uint32_t* frame);

const char* exception_name(uint32_t vector);

#endif