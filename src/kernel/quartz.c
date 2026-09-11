/* Cubic System Software - Quartz Kernel */

#include "framebuffer.h"
#include "openfirmware.h"
#include "keyboard.h"
#include "prism.h"
#include "mouse.h"
#include "fs.h"
#include "service.h"

void quartz_main(uint32_t mb_magic, uint32_t mb_info_addr) {
    int fb_ok = framebuffer_init(mb_magic, mb_info_addr);

    if (fb_ok) {
        fb_clear(255, 255, 255);
        OFinit();
        mouse_init();
    }

    fs_init(mb_info_addr);
    /* service_init_all();
    service_start_all(); */

    // boot background
    FB_drawrect(0,0, screen_width, screen_height, 0x009999cb);

    /* Welcome to Cubic */
    uint32_t w = screen_width;
    uint32_t h = screen_height;
    // outer window
    FB_drawrect(w/7, h/6-32, w*6/7, h*3/4, 0x00000000);
    FB_drawrect(w/7+1, h/6+1-32, w*6/7-1, h*3/4-1, 0x00DDDDDD);
    // inner window
    FB_drawrect(w/7+40, h/6, w*6/7-40, h*3/4-88, 0x00000000);
    FB_drawrect(w/7+41, h/6+1, w*6/7-41, h*3/4-89, 0x00B2B2B2);
    FB_drawrect(w/7+42, h/6+2, w*6/7-41, h*3/4-89, 0x00FFFFFF);
    FB_write(w/2 - 14*8/2, h/2 - 8+95, "Starting Up...", 0x00000000, 1);
    fb_cursor_update();

    delay(2000);

    PrismInit();

    /* Main loop */
    while (1) {
        PrismUpdateClock();
        PrismUpdate();
        fb_cursor_update();
        keyboard_poll();
        if (keyboard_key_pressed('h')) {
            FB_write(0,50, "Happy Mac!", 0x00000000, 1);
        }
        __asm__ __volatile__("hlt");
    }
}
