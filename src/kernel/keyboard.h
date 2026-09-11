#ifndef KEYBOARD_H
#define KEYBOARD_H

#include <stdint.h>

/* Key codes */
#define KEY_NONE     0
#define KEY_ESC      0x01
#define KEY_BACKSPACE 0x0E
#define KEY_TAB      0x0F
#define KEY_ENTER    0x1C
#define KEY_LCTRL    0x1D
#define KEY_LSHIFT   0x2A
#define KEY_RSHIFT   0x36
#define KEY_LALT     0x38
#define KEY_SPACE    0x39
#define KEY_CAPS     0x3A
#define KEY_F1       0x3B
#define KEY_F2       0x3C
#define KEY_F3       0x3D
#define KEY_F4       0x3E
#define KEY_F5       0x3F
#define KEY_F6       0x40
#define KEY_F7       0x41
#define KEY_F8       0x42
#define KEY_F9       0x43
#define KEY_F10      0x44
#define KEY_F11      0x57
#define KEY_F12      0x58
#define KEY_SUPER    0x5B

#define KEY_UP       0x80
#define KEY_DOWN     0x81
#define KEY_LEFT     0x82
#define KEY_RIGHT    0x83
#define KEY_HOME     0x84
#define KEY_END      0x85
#define KEY_PAGEUP   0x86
#define KEY_PAGEDOWN 0x87
#define KEY_INSERT   0x88
#define KEY_DELETE   0x89

void keyboard_init(void);
void keyboard_poll(void);
int keyboard_key_pressed(uint8_t key);

#endif
