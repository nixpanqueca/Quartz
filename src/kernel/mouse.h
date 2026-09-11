/* Cubic System Software - PS/2 Mouse Driver */

#ifndef MOUSE_H
#define MOUSE_H

#include <stdint.h>

void mouse_init(void);
void mouse_handler(void);
int mouse_x(void);
int mouse_y(void);
int mouse_button(int button);

#endif
