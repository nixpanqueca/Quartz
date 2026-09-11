#include "keyboard.h"
#include <stdint.h>

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

static idt_entry_t idt[256];
static idt_ptr_t idtp;

static uint8_t key_states[256];
static uint8_t extended_scan = 0;

extern volatile uint8_t g_scancode;

static const uint8_t scancode_table[128] = {
    KEY_NONE, KEY_ESC,
    '1','2','3','4','5','6','7','8','9','0','-','=', KEY_BACKSPACE,
    KEY_TAB,
    'q','w','e','r','t','y','u','i','o','p','[',']', KEY_ENTER,
    KEY_LCTRL,
    'a','s','d','f','g','h','j','k','l',';','\'','`',
    KEY_LSHIFT,
    '\\','z','x','c','v','b','n','m',',','.','/',
    KEY_RSHIFT,
    '*',
    KEY_LALT,
    ' ',
    KEY_CAPS,
    KEY_F1,KEY_F2,KEY_F3,KEY_F4,KEY_F5,KEY_F6,KEY_F7,KEY_F8,KEY_F9,KEY_F10,
    KEY_NONE, KEY_NONE,
    '7','8','9','-','4','5','6','+','1','2','3','0','.',
    KEY_NONE,KEY_NONE,KEY_F11,KEY_F12
};

static const uint8_t extended_table[128] = {
    [0x48] = KEY_UP,
    [0x50] = KEY_DOWN,
    [0x4B] = KEY_LEFT,
    [0x4D] = KEY_RIGHT,
    [0x47] = KEY_HOME,
    [0x4F] = KEY_END,
    [0x49] = KEY_PAGEUP,
    [0x51] = KEY_PAGEDOWN,
    [0x52] = KEY_INSERT,
    [0x53] = KEY_DELETE,
    [0x5B] = KEY_SUPER,
};

static void outb(uint16_t port, uint8_t val) {
    __asm__ __volatile__("outb %0, %1" : : "a"(val), "Nd"(port));
}

static uint8_t inb(uint16_t port) {
    uint8_t ret;
    __asm__ __volatile__("inb %1, %0" : "=a"(ret) : "Nd"(port));
    return ret;
}

static void idt_set_gate(uint8_t num, uint32_t base, uint16_t sel, uint8_t flags) {
    idt[num].base_low = base & 0xFFFF;
    idt[num].base_high = (base >> 16) & 0xFFFF;
    idt[num].selector = sel;
    idt[num].zero = 0;
    idt[num].flags = flags;
}

static void pic_remap(void) {
    outb(0x20, 0x11); outb(0xA0, 0x11);
    outb(0x21, 0x20); outb(0xA1, 0x28);
    outb(0x21, 0x04); outb(0xA1, 0x02);
    outb(0x21, 0x01); outb(0xA1, 0x01);
    outb(0x21, 0xFF); outb(0xA1, 0xFF);
}

static void dbg(char c) {
    while (!(inb(0x3F8 + 5) & 0x20));
    outb(0x3F8, c);
}

static void dbg_hex(uint32_t val) {
    int i;
    for (i = 28; i >= 0; i -= 4) {
        uint8_t nibble = (val >> i) & 0xF;
        dbg(nibble < 10 ? '0' + nibble : 'A' + nibble - 10);
    }
}

extern void isr0(void), isr1(void), isr2(void), isr3(void), isr4(void),
            isr5(void), isr6(void), isr7(void), isr8(void), isr9(void),
            isr10(void), isr11(void), isr12(void), isr13(void), isr14(void),
            isr15(void), isr16(void), isr17(void), isr18(void), isr19(void),
            isr20(void), isr21(void), isr22(void), isr23(void), isr24(void),
            isr25(void), isr26(void), isr27(void), isr28(void), isr29(void),
            isr30(void), isr31(void), isr32(void), isr33(void),
            isr34(void), isr35(void), isr36(void), isr37(void), isr38(void), isr39(void),
            isr44(void);

void keyboard_init(void) {
    uint16_t cs_val;
    uint16_t sel;
    int i;

    dbg('A');

    __asm__ __volatile__("mov %%cs, %0" : "=r"(cs_val));
    sel = cs_val;

    idtp.limit = sizeof(idt) - 1;
    idtp.base = (uint32_t)&idt;
    for (i = 0; i < 256; i++) {
        idt_set_gate(i, 0, sel, 0);
    }
    dbg('B');

    pic_remap();
    dbg('C');

    for (i = 0; i < 32; i++) {
        uint32_t addr;
        switch(i) {
            case 0: addr = (uint32_t)isr0; break;
            case 1: addr = (uint32_t)isr1; break;
            case 2: addr = (uint32_t)isr2; break;
            case 3: addr = (uint32_t)isr3; break;
            case 4: addr = (uint32_t)isr4; break;
            case 5: addr = (uint32_t)isr5; break;
            case 6: addr = (uint32_t)isr6; break;
            case 7: addr = (uint32_t)isr7; break;
            case 8: addr = (uint32_t)isr8; break;
            case 9: addr = (uint32_t)isr9; break;
            case 10: addr = (uint32_t)isr10; break;
            case 11: addr = (uint32_t)isr11; break;
            case 12: addr = (uint32_t)isr12; break;
            case 13: addr = (uint32_t)isr13; break;
            case 14: addr = (uint32_t)isr14; break;
            case 15: addr = (uint32_t)isr15; break;
            case 16: addr = (uint32_t)isr16; break;
            case 17: addr = (uint32_t)isr17; break;
            case 18: addr = (uint32_t)isr18; break;
            case 19: addr = (uint32_t)isr19; break;
            case 20: addr = (uint32_t)isr20; break;
            case 21: addr = (uint32_t)isr21; break;
            case 22: addr = (uint32_t)isr22; break;
            case 23: addr = (uint32_t)isr23; break;
            case 24: addr = (uint32_t)isr24; break;
            case 25: addr = (uint32_t)isr25; break;
            case 26: addr = (uint32_t)isr26; break;
            case 27: addr = (uint32_t)isr27; break;
            case 28: addr = (uint32_t)isr28; break;
            case 29: addr = (uint32_t)isr29; break;
            case 30: addr = (uint32_t)isr30; break;
            case 31: addr = (uint32_t)isr31; break;
        }
        idt_set_gate(i, addr, sel, 0x8F);
    }

    idt_set_gate(32, (uint32_t)isr32, sel, 0x8E);
    idt_set_gate(33, (uint32_t)isr33, sel, 0x8E);
    idt_set_gate(34, (uint32_t)isr34, sel, 0x8E);
    idt_set_gate(35, (uint32_t)isr35, sel, 0x8E);
    idt_set_gate(36, (uint32_t)isr36, sel, 0x8E);
    idt_set_gate(37, (uint32_t)isr37, sel, 0x8E);
    idt_set_gate(38, (uint32_t)isr38, sel, 0x8E);
    idt_set_gate(39, (uint32_t)isr39, sel, 0x8E);
    idt_set_gate(44, (uint32_t)isr44, sel, 0x8E);
    dbg('D');

    dbg('S'); dbg_hex(sel);
    dbg('I'); dbg_hex((uint32_t)isr33);
    dbg('L'); dbg_hex(idtp.base);

    __asm__ __volatile__("cli\n\t"
                         "lidt (%0)\n\t"
                         : : "r"(&idtp)
                         : "memory");
    dbg('E');

    uint8_t mask = inb(0x21);
    mask &= ~(1 << 1);
    mask &= ~(1 << 2);
    outb(0x21, mask);

    uint8_t slave_mask = inb(0xA1);
    slave_mask &= ~(1 << 4);
    outb(0xA1, slave_mask);

    for (i = 0; i < 256; i++) key_states[i] = 0;
    dbg('F');

    __asm__ __volatile__("sti");
    dbg('G');
}

void keyboard_poll(void) {
    uint8_t sc = g_scancode;
    if (sc == 0) return;
    g_scancode = 0;

    if (sc == 0xE0) {
        extended_scan = 1;
        return;
    }

    uint8_t key_code = KEY_NONE;

    if (extended_scan) {
        extended_scan = 0;
        if (sc < 128) {
            key_code = extended_table[sc];
        }
    } else {
        if (sc < 128) {
            key_code = scancode_table[sc];
        }
    }

    if (key_code != KEY_NONE) {
        if (sc & 0x80) {
            key_states[key_code] = 0;
        } else {
            key_states[key_code] = 1;
        }
    }
}

int keyboard_key_pressed(uint8_t key) {
    return key_states[key];
}
