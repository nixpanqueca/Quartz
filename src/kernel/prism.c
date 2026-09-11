/* Cubic System Software - Prism Interface */

#include "prism.h"
#include "framebuffer.h"
#include "fs.h"

static uint32_t blend_color(uint32_t c1, uint32_t c2, uint32_t t) {
    uint32_t r1 = (c1 >> 16) & 0xFF;
    uint32_t g1 = (c1 >> 8) & 0xFF;
    uint32_t b1 = c1 & 0xFF;
    uint32_t r2 = (c2 >> 16) & 0xFF;
    uint32_t g2 = (c2 >> 8) & 0xFF;
    uint32_t b2 = c2 & 0xFF;
    uint32_t r = r1 + (r2 - r1) * t / 255;
    uint32_t g = g1 + (g2 - g1) * t / 255;
    uint32_t b = b1 + (b2 - b1) * t / 255;
    return (r << 16) | (g << 8) | b;
}

static void DrawMenubar(void) {
    FB_drawrect(0, 0, screen_width, 18, 0x00DDDDDD); // menu
    FB_drawrect(0, 0, screen_width, 0, 0x00FFFFFF);
    FB_drawrect(0, 18, screen_width, 18, 0x00999999);
    FB_drawrect(0, 19, screen_width, 19, 0x00000000);

    const fs_file_t* menubar = fs_find("/system/compiled/prism/bitmap/icon.bmp");
    if (menubar) {
        FB_drawbmp(12, 2, (const void*)(uint32_t)menubar->mod_start);
    } else {
        FB_write(10,1, "File not found!", 0x00000000, 1);
    }
}

static void DrawDock(void) {
    // Dock background
    FB_drawrect(0,screen_height-24, screen_width/2 -16, screen_height, 0x00000000);
    FB_drawrect(0,screen_height-23, screen_width/2 -17, screen_height, 0x00C0C0C0); // dock
    FB_drawrect(0,screen_height-22, screen_width/2 -19, screen_height-22, 0x00FFFFFF);

    // Dock tiles
    const fs_file_t* tile1 = fs_find("/system/compiled/prism/bitmap/dock/tileT1.bmp");
    const fs_file_t* ratio = fs_find("/system/compiled/prism/bitmap/dock/ratioOUTTER.bmp");
    const fs_file_t* ratio2 = fs_find("/system/compiled/prism/bitmap/dock/ratioINNER.bmp");
    if (ratio && ratio2) {
        FB_drawbmp(0,screen_height-24, (const void*)(uint32_t)ratio->mod_start);
        FB_drawbmp(5,screen_height-14, (const void*)(uint32_t)ratio2->mod_start);
    }
}

static char current_title[64] = "Prism";

void PrismSetTitle(const char* title) {
    int i;
    for (i = 0; i < 63 && title[i]; i++)
        current_title[i] = title[i];
    current_title[i] = '\0';

    DrawMenubar();

    // title on the right: separator [8px] title [12px] clock [8px]
    uint32_t len = 0;
    while (current_title[len]) len++;

    uint8_t hour, min, sec;
    rtc_read(&hour, &min, &sec);

    const char* ampm = hour >= 12 ? "PM" : "AM";
    uint8_t h12 = hour % 12;
    if (h12 == 0) h12 = 12;

    char clock_str[9];
    clock_str[0] = '0' + h12 / 10;
    clock_str[1] = '0' + h12 % 10;
    clock_str[2] = ':';
    clock_str[3] = '0' + min / 10;
    clock_str[4] = '0' + min % 10;
    clock_str[5] = ' ';
    clock_str[6] = ampm[0];
    clock_str[7] = ampm[1];
    clock_str[8] = '\0';

    uint32_t text_w = len * 8;
    uint32_t clock_w = 7 * 8; // "HH:MM XM"
    uint32_t title_x = screen_width - 12 - text_w;
    uint32_t sep_right = title_x - 8;
    uint32_t sep_left = sep_right - 6;
    uint32_t clock_x = sep_left - 8 - clock_w - 8;

    // separator: 6px wide, full menubar height
    // FB_drawrect(sep_left, 2, sep_right, 17, 0x00B2B2B2);
    const fs_file_t* menuseparator = fs_find("/system/compiled/prism/bitmap/separator.bmp");
    if (menuseparator) {
        FB_drawbmp(sep_left, 0, (const void*)(uint32_t)menuseparator->mod_start);
    } else {
        FB_write(sep_left,2, "File not found!", 0x00000000, 1);
    }

    // title text
    FB_write(title_x, 3, current_title, 0x00000000, 1);

    // clock
    FB_write(clock_x, 3, clock_str, 0x00000000, 1);
}

static uint8_t last_sec = 0xFF;

void PrismUpdateClock(void) {
    uint8_t hour, min, sec;
    rtc_read(&hour, &min, &sec);
    if (sec == last_sec) return;
    last_sec = sec;

    const char* ampm = hour >= 12 ? "PM" : "AM";
    uint8_t h12 = hour % 12;
    if (h12 == 0) h12 = 12;

    char clock_str[9];
    clock_str[0] = '0' + h12 / 10;
    clock_str[1] = '0' + h12 % 10;
    clock_str[2] = ':';
    clock_str[3] = '0' + min / 10;
    clock_str[4] = '0' + min % 10;
    clock_str[5] = ' ';
    clock_str[6] = ampm[0];
    clock_str[7] = ampm[1];
    clock_str[8] = '\0';

    uint32_t len = 0;
    while (current_title[len]) len++;
    clock_str[8] = '\0';

    uint32_t text_w = len * 8;
    uint32_t clock_w = 7 * 8;
    uint32_t title_x = screen_width - 12 - text_w;
    uint32_t sep_right = title_x - 8;
    uint32_t sep_left = sep_right - 8;
    uint32_t clock_x = sep_left - 8 - clock_w - 8;

    // clear old clock area with background
    FB_drawrect(clock_x, 0, clock_x + clock_w + 7, 0, 0x00FFFFFF);
    FB_drawrect(clock_x, 0, clock_x + clock_w + 7, 19, 0x00DDDDDD);

    FB_write(clock_x, 3, clock_str, 0x00000000, 1);
}

static void RoundBorders(void) {
    uint32_t r = 7;
    uint32_t x, y;

    for (y = 0; y <= r; y++) {
        for (x = 0; x <= r; x++) {
            uint32_t dx = r - x;
            uint32_t dy = r - y;
            uint32_t d2 = dx * dx + dy * dy;
            if (d2 > r * r) {
                uint32_t d = 0;
                while (d * d < d2 && d < 20) d++;
                uint32_t edge_dist = d - r;
                uint32_t color;
                if (edge_dist <= 2) {
                    color = blend_color(0x00999999, 0x00666666, edge_dist * 127);
                } else if (edge_dist <= 4) {
                    color = blend_color(0x00666666, 0x00333333, (edge_dist - 2) * 127);
                } else {
                    color = blend_color(0x00333333, 0x00000000, (edge_dist - 4) * 127);
                }
                FB_drawrect(x, y, x, y, color);
            }
        }
    }

    for (y = 0; y <= r; y++) {
        for (x = 0; x <= r; x++) {
            uint32_t sx = screen_width - 1 - r + x;
            uint32_t dx = x;
            uint32_t dy = r - y;
            uint32_t d2 = dx * dx + dy * dy;
            if (d2 > r * r) {
                uint32_t d = 0;
                while (d * d < d2 && d < 20) d++;
                uint32_t edge_dist = d - r;
                uint32_t color;
                if (edge_dist <= 2) {
                    color = blend_color(0x00999999, 0x00666666, edge_dist * 127);
                } else if (edge_dist <= 4) {
                    color = blend_color(0x00666666, 0x00333333, (edge_dist - 2) * 127);
                } else {
                    color = blend_color(0x00333333, 0x00000000, (edge_dist - 4) * 127);
                }
                FB_drawrect(sx, y, sx, y, color);
            }
        }
    }
}

void PrismInit(void) {
    FB_drawrect(0, 0, screen_width, screen_height, 0x009999cb);
    PrismSetTitle(current_title);
    DrawDock();
}

void PrismUpdate(void){
    PrismSetTitle(current_title);
    DrawDock();
}