#include "openfirmware.h"
#include "framebuffer.h"
#include "keyboard.h"
#include "fs.h"

void OpenFirmware() {

}

void OFinit() {
    keyboard_init();
    // background
    FB_drawpattern(0, 0, screen_width, screen_height, FB_PATTERN_MACGRAY);
    FB_drawrect(0,0, screen_width,screen_height, 0x007D7D7D);
    const fs_file_t* floppy = fs_find("/system/compiled/bitmap/face@2x.bmp");
    if (floppy) {
        FB_drawbmp(screen_width/2 - 32, screen_height/2 - 38, (const void*)(uint32_t)floppy->mod_start);
    } else {
        FB_write(0,0, "Not found!", 0x00000000, 1);
    }
    delay(1000);
    keyboard_poll();
    if (keyboard_key_pressed('o') && keyboard_key_pressed('f')) {
        FB_drawrect(0,0, screen_width, screen_height, 0x00FFFFCC);
        OpenFirmware();
    }
}
