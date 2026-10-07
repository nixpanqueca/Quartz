/* Cubic System Software - PS/2 Keyboard */
/* The old driver kept a single scancode byte that had to be polled by hand, so
 * two keys pressed between two polls turned into one. This one has a queue. */

#include "keyboard.h"
#include "io.h"

/* Scancode set 1, make codes. Break codes are the same value with bit 7 set. */
static const uint8_t keymap_lower[128] = {
    [0x01] = KEY_ESCAPE,

    [0x02] = '1',  [0x03] = '2',  [0x04] = '3',  [0x05] = '4',
    [0x06] = '5',  [0x07] = '6',  [0x08] = '7',  [0x09] = '8',
    [0x0A] = '9',  [0x0B] = '0',  [0x0C] = '-',  [0x0D] = '=',
    [0x0E] = KEY_BACKSPACE,
    [0x0F] = KEY_TAB,

    [0x10] = 'q',  [0x11] = 'w',  [0x12] = 'e',  [0x13] = 'r',
    [0x14] = 't',  [0x15] = 'y',  [0x16] = 'u',  [0x17] = 'i',
    [0x18] = 'o',  [0x19] = 'p',  [0x1A] = '[',  [0x1B] = ']',
    [0x1C] = KEY_ENTER,

    [0x1E] = 'a',  [0x1F] = 's',  [0x20] = 'd',  [0x21] = 'f',
    [0x22] = 'g',  [0x23] = 'h',  [0x24] = 'j',  [0x25] = 'k',
    [0x26] = 'l',  [0x27] = ';',  [0x28] = '\'', [0x29] = '`',

    [0x2B] = '\\',
    [0x2C] = 'z',  [0x2D] = 'x',  [0x2E] = 'c',  [0x2F] = 'v',
    [0x30] = 'b',  [0x31] = 'n',  [0x32] = 'm',  [0x33] = ',',
    [0x34] = '.',  [0x35] = '/',

    [0x37] = '*',                  /* keypad multiply */
    [0x39] = ' ',

    [0x3B] = KEY_F1,  [0x3C] = KEY_F2,  [0x3D] = KEY_F3,  [0x3E] = KEY_F4,
    [0x3F] = KEY_F5,  [0x40] = KEY_F6,  [0x41] = KEY_F7,  [0x42] = KEY_F8,
    [0x43] = KEY_F9,  [0x44] = KEY_F10,
    [0x54] = KEY_F11, [0x55] = KEY_F12,

    /* numeric keypad */
    [0x47] = '7', [0x48] = '8', [0x49] = '9', [0x4A] = '-',
    [0x4B] = '4', [0x4C] = '5', [0x4D] = '6', [0x4E] = '+',
    [0x4F] = '1', [0x50] = '2', [0x51] = '3', [0x52] = '0',
    [0x53] = '.'
};

/* Only punctuation differs from keymap_lower; letters are handled by flipping
 * case afterwards, and caps lock then flips them again. */
static const uint8_t keymap_shifted[128] = {
    [0x02] = '!',  [0x03] = '@',  [0x04] = '#',  [0x05] = '$',
    [0x06] = '%',  [0x07] = '^',  [0x08] = '&',  [0x09] = '*',
    [0x0A] = '(',  [0x0B] = ')',  [0x0C] = '_',  [0x0D] = '+',
    [0x1A] = '{',  [0x1B] = '}',
    [0x27] = ':',  [0x28] = '"',  [0x29] = '~',
    [0x2B] = '|',
    [0x33] = '<',  [0x34] = '>',  [0x35] = '?',
    [0x37] = '+'
};

#define QUEUE_SIZE     64
#define REPEAT_DELAY   50      /* ticks before the first repeat (0.5s) */
#define REPEAT_RATE     3      /* ticks between repeats (30ms)  */

static keyboard_event_t queue[QUEUE_SIZE];
static volatile int queue_head = 0;
static volatile int queue_tail = 0;

static int shift_down = 0;
static int ctrl_down = 0;
static int alt_down = 0;
static int caps_lock = 0;

static int extended_pending = 0;
static int pause_remaining = 0;

static uint8_t  repeat_code = KEY_NONE;
static uint32_t repeat_ticks = 0;
static int      repeat_started = 0;

/* Last raw byte off port 0x60, handy when watching things over the serial line. */
volatile uint8_t g_scancode = 0;

static uint8_t modifier_flags(void) {
    uint8_t flags = 0;

    if (ctrl_down)  flags |= KBD_FLAG_CTRL;
    if (shift_down) flags |= KBD_FLAG_SHIFT;
    if (alt_down)   flags |= KBD_FLAG_ALT;

    return flags;
}

static void queue_push(uint8_t code, uint8_t flags) {
    int next = (queue_head + 1) % QUEUE_SIZE;

    if (next == queue_tail)
        return;                     /* full: drop the keystroke rather than lie */

    queue[queue_head].code = code;
    queue[queue_head].flags = flags;
    queue_head = next;
}

static uint8_t translate(uint8_t index, int shift) {
    uint8_t code = keymap_lower[index];

    if (code == KEY_NONE)
        return KEY_NONE;

    if (code >= 'A' && code <= 'Z')
        code = (uint8_t)(code + 32);        /* normalise to lowercase */

    if (shift) {
        uint8_t shifted = keymap_shifted[index];

        if (shifted != KEY_NONE)
            code = shifted;
        else if (code >= 'a' && code <= 'z')
            code = (uint8_t)(code - 32);
    }

    /* Applied after shift so that caps lock plus shift gives you lowercase,
     * the way a real keyboard does. */
    if (caps_lock) {
        if (code >= 'a' && code <= 'z')
            code = (uint8_t)(code - 32);
        else if (code >= 'A' && code <= 'Z')
            code = (uint8_t)(code + 32);
    }

    return code;
}

static uint8_t extended_translate(uint8_t scancode) {
    switch (scancode) {
        case 0x48: return KEY_UP;
        case 0x50: return KEY_DOWN;
        case 0x4B: return KEY_LEFT;
        case 0x4D: return KEY_RIGHT;
        case 0x47: return KEY_HOME;
        case 0x4F: return KEY_END;
        case 0x49: return KEY_PAGEUP;
        case 0x51: return KEY_PAGEDOWN;
        case 0x52: return KEY_INSERT;
        case 0x53: return KEY_DELETE;
        case 0x1C: return KEY_ENTER;       /* keypad enter */
        case 0x35: return '/';             /* keypad slash */
        default:   return KEY_NONE;
    }
}

void keyboard_irq(void) {
    uint8_t scancode = inb(0x60);

    g_scancode = scancode;

    if (scancode == 0xE0) {
        extended_pending = 1;
        return;
    }

    if (scancode == 0xE1) {
        pause_remaining = 5;               /* the rest of the pause sequence */
        return;
    }

    if (pause_remaining > 0) {
        pause_remaining--;
        return;
    }

    if (extended_pending) {
        extended_pending = 0;

        if (scancode & 0x80) {
            uint8_t index = (uint8_t)(scancode & 0x7F);

            if (index == 0x1D) ctrl_down = 0;       /* right ctrl */
            if (index == 0x38) alt_down = 0;        /* right alt  */
            return;
        }

        uint8_t code = extended_translate(scancode);

        if (code != KEY_NONE) {
            if (code >= 'a' && code <= 'z')
                code = (uint8_t)(code - 32);

            queue_push(code, modifier_flags());
        }
        return;
    }

    int make = (scancode & 0x80) == 0;
    uint8_t index = (uint8_t)(scancode & 0x7F);

    switch (index) {
        case 0x2A:
        case 0x36:                             /* left and right shift */
            shift_down = make;
            return;

        case 0x1D:
            ctrl_down = make;
            return;

        case 0x38:
            alt_down = make;
            return;

        case 0x3A:
            if (make)
                caps_lock = !caps_lock;
            return;

        default:
            break;
    }

    if (!make) {
        /* Any release stops auto-repeat. Tracking which key was held would
         * cost more than it is worth for a shell. */
        repeat_code = KEY_NONE;
        return;
    }

    uint8_t code = translate(index, shift_down);

    if (code == KEY_NONE)
        return;

    queue_push(code, modifier_flags());

    if (code >= 0x20) {                       /* auto-repeat printable keys */
        repeat_code = code;
        repeat_ticks = 0;
        repeat_started = 0;
    } else {
        repeat_code = KEY_NONE;
    }
}

void keyboard_tick(void) {
    if (repeat_code == KEY_NONE)
        return;

    repeat_ticks++;

    uint32_t limit = repeat_started ? REPEAT_RATE : REPEAT_DELAY;

    if (repeat_ticks < limit)
        return;

    repeat_ticks = 0;
    repeat_started = 1;

    queue_push(repeat_code, modifier_flags() | KBD_FLAG_REPEAT);
}

int keyboard_get_event(keyboard_event_t* event) {
    if (queue_tail == queue_head)
        return 0;

    if (event) {
        event->code = queue[queue_tail].code;
        event->flags = queue[queue_tail].flags;
    }

    queue_tail = (queue_tail + 1) % QUEUE_SIZE;

    return 1;
}

int keyboard_wait_event(keyboard_event_t* event) {
    for (;;) {
        if (keyboard_get_event(event))
            return 1;

        __asm__ __volatile__("sti; hlt");
    }
}

void keyboard_flush(void) {
    queue_head = queue_tail;
    repeat_code = KEY_NONE;
}

int keyboard_shift_held(void) {
    return shift_down;
}

int keyboard_caps_lock(void) {
    return caps_lock;
}

void keyboard_init(void) {
    queue_head = queue_tail = 0;
    extended_pending = 0;
    pause_remaining = 0;
    shift_down = 0;
    ctrl_down = 0;
    alt_down = 0;
    caps_lock = 0;
    repeat_code = KEY_NONE;
    repeat_ticks = 0;
    repeat_started = 0;
    g_scancode = 0;

    /* Throw away anything the firmware left sitting in the controller. */
    while (inb(0x64) & 0x01)
        (void)inb(0x60);
}