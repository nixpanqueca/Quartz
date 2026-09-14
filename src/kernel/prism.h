/* Cubic System Software - Prism Interface */

#ifndef PRISM_H
#define PRISM_H

extern char current_title[64];

void PrismInit(void);
void FB_update(void);
void PrismSetTitle(const char* title);
void PrismUpdateClock(void);

#endif
