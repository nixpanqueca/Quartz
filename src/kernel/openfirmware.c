#include "openfirmware.h"
#include "framebuffer.h"
#include "keyboard.h"
#include "fs.h"

// Code by NixPanqueca -w-

__attribute__((noreturn))
void MacCrash(uint32_t code) {
    fb_clear(0,0,0);
    const fs_file_t* mac = fs_find("/system/compiled/bitmap/sad@2x.bmp");
    if (mac) {
        FB_drawbmp(screen_width/2 - 23, screen_height/2 - 29, (const void*)(uint32_t)mac->mod_start);
    } else {
        FB_write(0,0, "System corrupted", 0x00FFFFFF, 2);
    }
    if (code == 0x00194) {

    }
    __asm__ __volatile__("cli");
    for (;;)
        __asm__ __volatile__("hlt");
}

void OpenFirmware() {

}

void OFinit() {
    keyboard_init();
    // background
    FB_drawpattern(0, 0, screen_width, screen_height, FB_PATTERN_MACGRAY);
    FB_drawrect(0,0, screen_width,screen_height, 0x007D7D7D);
    const fs_file_t* floppy = fs_find("/system/compiled/bitmap/face@2x.bmp");
    if (floppy) {
        FB_drawbmp(screen_width/2 - 23, screen_height/2 - 29, (const void*)(uint32_t)floppy->mod_start);
    } else {
        MacCrash(0x00194);
    }
    delay(1000);
    keyboard_poll();
    if (keyboard_key_pressed('o') && keyboard_key_pressed('f')) {
        FB_drawrect(0,0, screen_width, screen_height, 0x00FFFFCC);
        OpenFirmware();
    }
}
