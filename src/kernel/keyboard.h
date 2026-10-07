/* Cubic System Software - PS/2 Keyboard */

#ifndef KEYBOARD_H
#define KEYBOARD_H

#include <stdint.h>

/* Key codes are split in two:
 *   0x01-0x7F  the ASCII value the key produces (KEY_ENTER is '\r' and friends)
 *   0x80+      keys with no printable character
 * That way the shell can compare event.code against 'q' directly. */
#define KEY_NONE       0x00
#define KEY_BACKSPACE  0x08
#define KEY_TAB        0x09
#define KEY_ENTER      0x0D
#define KEY_ESCAPE     0x1B

#define KEY_UP         0x80
#define KEY_DOWN       0x81
#define KEY_LEFT       0x82
#define KEY_RIGHT      0x83
#define KEY_HOME       0x84
#define KEY_END        0x85
#define KEY_PAGEUP     0x86
#define KEY_PAGEDOWN   0x87
#define KEY_INSERT     0x88
#define KEY_DELETE     0x89
#define KEY_F1         0x90
#define KEY_F2         0x91
#define KEY_F3         0x92
#define KEY_F4         0x93
#define KEY_F5         0x94
#define KEY_F6         0x95
#define KEY_F7         0x96
#define KEY_F8         0x97
#define KEY_F9         0x98
#define KEY_F10        0x99
#define KEY_F11        0x9A
#define KEY_F12        0x9B

#define KBD_FLAG_CTRL    0x01
#define KBD_FLAG_SHIFT   0x02
#define KBD_FLAG_ALT     0x04
#define KBD_FLAG_REPEAT  0x08

typedef struct {
    uint8_t code;
    uint8_t flags;
} keyboard_event_t;

void keyboard_init(void);

/* Called from the IRQ1 stub: reads one scancode and queues an event. */
void keyboard_irq(void);

/* Called from the IRQ0 stub: drives auto-repeat for held keys. */
void keyboard_tick(void);

/* Non-blocking: returns 1 and fills event when one is queued. */
int keyboard_get_event(keyboard_event_t* event);

/* Blocks in hlt until a key is pressed. */
int keyboard_wait_event(keyboard_event_t* event);

void keyboard_flush(void);

int keyboard_shift_held(void);
int keyboard_caps_lock(void);

#endif