/* Cubic System Software - Interrupt Descriptor Table + 8259 PIC */
/* Used to live at the top of keyboard.c, which made no sense. */

#include "interrupt.h"
#include "console.h"
#include "io.h"
#include "openfirmware.h"

typedef struct {
    uint16_t base_low;
    uint16_t selector;
    uint8_t  zero;
    uint8_t  flags;
    uint16_t base_high;
} __attribute__((packed)) idt_entry_t;

typedef struct {
    uint16_t limit;
    uint32_t base;
} __attribute__((packed)) idt_ptr_t;

#define PIC1_COMMAND  0x20
#define PIC1_DATA     0x21
#define PIC2_COMMAND  0xA0
#define PIC2_DATA     0xA1

#define IDT_PRESENT_INTERRUPT  0x8E    /* present, ring 0, 32-bit interrupt gate */
#define IDT_NOT_PRESENT        0x00

/* Implemented in src/boot/isr.asm */
extern void isr0(void),  isr1(void),  isr2(void),  isr3(void);
extern void isr4(void),  isr5(void),  isr6(void),  isr7(void);
extern void isr8(void),  isr9(void),  isr10(void), isr11(void);
extern void isr12(void), isr13(void), isr14(void), isr15(void);
extern void isr16(void), isr17(void), isr18(void), isr19(void);
extern void isr20(void), isr21(void), isr22(void), isr23(void);
extern void isr24(void), isr25(void), isr26(void), isr27(void);
extern void isr28(void), isr29(void), isr30(void), isr31(void);
extern void isr32(void);            /* IRQ0 - PIT timer */
extern void isr33(void);            /* IRQ1 - keyboard */

static idt_entry_t idt[256];
static idt_ptr_t   idtp;

static void (*const exception_stubs[32])(void) = {
    isr0,  isr1,  isr2,  isr3,  isr4,  isr5,  isr6,  isr7,
    isr8,  isr9,  isr10, isr11, isr12, isr13, isr14, isr15,
    isr16, isr17, isr18, isr19, isr20, isr21, isr22, isr23,
    isr24, isr25, isr26, isr27, isr28, isr29, isr30, isr31
};

static void idt_set_gate(uint8_t vector, uint32_t handler,
                         uint16_t selector, uint8_t flags) {
    idt[vector].base_low  = (uint16_t)(handler & 0xFFFF);
    idt[vector].base_high = (uint16_t)((handler >> 16) & 0xFFFF);
    idt[vector].selector  = selector;
    idt[vector].zero      = 0;
    idt[vector].flags     = flags;
}

/* ---- 8259A PIC ---- */

static void pic_remap(void) {
    outb(PIC1_COMMAND, 0x11); io_wait();   /* ICW1: edge triggered, expect ICW4 */
    outb(PIC2_COMMAND, 0x11); io_wait();

    outb(PIC1_DATA, 0x20); io_wait();      /* ICW2: master handles IRQ 0..7   */
    outb(PIC2_DATA, 0x28); io_wait();      /*       slave handles IRQ 8..15   */

    outb(PIC1_DATA, 0x04); io_wait();      /* ICW3: slave is on IRQ 2         */
    outb(PIC2_DATA, 0x02); io_wait();

    outb(PIC1_DATA, 0x01); io_wait();      /* ICW4: 8086 mode                 */
    outb(PIC2_DATA, 0x01); io_wait();
}

static void pic_unmask(uint8_t irq) {
    if (irq < 8)
        outb(PIC1_DATA, (uint8_t)(inb(PIC1_DATA) & ~(1u << irq)));
    else
        outb(PIC2_DATA, (uint8_t)(inb(PIC2_DATA) & ~(1u << (irq - 8))));
}

/* ---- Public ---- */

void interrupt_init(void) {
    uint16_t code_segment;

    __asm__ __volatile__("mov %%cs, %0" : "=r"(code_segment));

    idtp.limit = (uint16_t)(sizeof(idt) - 1);
    idtp.base  = (uint32_t)(uintptr_t)&idt;

    /* Start with every vector "not present" so a stray interrupt faults loudly
     * instead of jumping into the weeds. */
    for (int i = 0; i < 256; i++)
        idt_set_gate((uint8_t)i, 0, code_segment, IDT_NOT_PRESENT);

    for (int i = 0; i < 32; i++) {
        idt_set_gate((uint8_t)i,
                     (uint32_t)(uintptr_t)exception_stubs[i],
                     code_segment, IDT_PRESENT_INTERRUPT);
    }

    idt_set_gate(32, (uint32_t)(uintptr_t)isr32, code_segment, IDT_PRESENT_INTERRUPT);
    idt_set_gate(33, (uint32_t)(uintptr_t)isr33, code_segment, IDT_PRESENT_INTERRUPT);

    __asm__ __volatile__("lidt (%0)" : : "r"(&idtp) : "memory");

    pic_remap();

    outb(PIC1_DATA, 0xFF);
    outb(PIC2_DATA, 0xFF);

    pic_unmask(0);     /* PIT timer */
    pic_unmask(1);     /* keyboard */

    console_write("[boot] IDT loaded, PIC remapped, IRQ0 and IRQ1 unmasked\n");
}

void interrupts_enable(void) {
    __asm__ __volatile__("sti");
}

void interrupts_disable(void) {
    __asm__ __volatile__("cli");
}

int interrupts_enabled(void) {
    uint32_t flags;
    __asm__ __volatile__("pushfl\n\tpopl %0" : "=r"(flags));
    return (flags & 0x200u) != 0;
}

const char* exception_name(uint32_t vector) {
    switch (vector) {
        case 0:  return "divide error";
        case 1:  return "debug exception";
        case 2:  return "non-maskable interrupt";
        case 3:  return "breakpoint";
        case 4:  return "overflow";
        case 5:  return "bound range exceeded";
        case 6:  return "invalid opcode";
        case 7:  return "device not available";
        case 8:  return "double fault";
        case 9:  return "coprocessor segment overrun";
        case 10: return "invalid TSS";
        case 11: return "segment not present";
        case 12: return "stack-segment fault";
        case 13: return "general protection fault";
        case 14: return "page fault";
        case 15: return "reserved exception";
        case 16: return "x87 floating-point exception";
        case 17: return "alignment check";
        case 18: return "machine check";
        case 19: return "SIMD floating-point exception";
        case 20: return "virtualisation exception";
        case 21: return "control protection exception";
        case 22: return "reserved exception";
        case 23: return "reserved exception";
        case 24: return "reserved exception";
        case 25: return "reserved exception";
        case 26: return "reserved exception";
        case 27: return "reserved exception";
        case 28: return "hypervisor injection exception";
        case 29: return "VMM communication exception";
        case 30: return "security exception";
        case 31: return "reserved exception";
        default: return "unknown exception";
    }
}

__attribute__((noreturn))
void exception_handler(uint32_t* frame) {
    /* The frame goes to the crash screen as-is: it is the only place the
     * register state of a fault survives, and a panic that cannot say where
     * it died is barely better than a hang. */
    MacCrash(exception_name(frame[REG_VECTOR]), frame[REG_ERROR], frame);
}