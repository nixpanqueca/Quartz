/* Cubic System Software - Quartz Kernel */

#include "quartz.h"
#include "framebuffer.h"
#include "openfirmware.h"
#include "keyboard.h"
#include "prism.h"
#include "mouse.h"
#include "fs.h"
#include "service.h"
#include "thread.h"

// Code by NixPanqueca -w-

void kernel_crash(uint32_t crashcode) {
    MacCrash(crashcode);
}

void quartz_main(uint32_t mb_magic, uint32_t mb_info_addr) {
    int fb_ok = framebuffer_init(mb_magic, mb_info_addr);

    fs_init(mb_info_addr);

    if (fb_ok) {
        fb_clear(255, 255, 255);
        OFinit();
        mouse_init();
    }

    thread_init();

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

    /* Boot delay - update cursor periodically so mouse moves */
    for (uint32_t i = 0; i < 20; i++) {
        fb_cursor_update();
        delay(100);
    }

    PrismInit();
    service_run_on("/system/compiled/prism/prism.service", 2);
    fb_cursor_invalidate();

    while (1) {
        asm volatile("cli");
        fb_cursor_update();
        asm volatile("sti");
        delay(1);
    }
}
