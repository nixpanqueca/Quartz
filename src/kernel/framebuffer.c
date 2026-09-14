/* Cubic System Software - Framebuffer */
/* Just the bare minimum to get pixels on screen :D */

#include "framebuffer.h"
#include "font.h"
#include "prism.h"

#define MULTIBOOT_MAGIC 0x2BADB002
#define MULTIBOOT_FRAMEBUFFER_INFO (1 << 12)

static uint32_t* fb = 0;
static uint32_t fb_pitch = 0;
static int fb_ready = 0;

uint32_t screen_width = 0;
uint32_t screen_height = 0;

/* Multiboot info struct */
typedef struct {
    uint32_t flags;
    uint32_t mem_lower;
    uint32_t mem_upper;
    uint32_t boot_device;
    uint32_t cmdline;
    uint32_t mods_count;
    uint32_t mods_addr;
    uint32_t syms[4];
    uint32_t mmap_length;
    uint32_t mmap_addr;
    uint32_t drives_length;
    uint32_t drives_addr;
    uint32_t config_table;
    uint32_t boot_loader_name;
    uint32_t apm_table;
    uint32_t vbe_control_info;
    uint32_t vbe_mode_info;
    uint16_t vbe_mode;
    uint16_t vbe_interface_seg;
    uint16_t vbe_interface_off;
    uint16_t vbe_interface_len;
    uint64_t framebuffer_addr;  /* 88 - 8 bytes per spec! */
    uint32_t framebuffer_pitch; /* 96 */
    uint32_t framebuffer_width; /* 100 */
    uint32_t framebuffer_height;/* 104 */
    uint8_t  framebuffer_bpp;   /* 108 */
    uint8_t  framebuffer_type;  /* 109 */
} __attribute__((packed)) multiboot_info_t;

/* Serial port for debug */
static void outb(uint16_t port, uint8_t val) {
    __asm__ __volatile__("outb %0, %1" : : "a"(val), "Nd"(port));
}

static uint8_t inb(uint16_t port) {
    uint8_t ret;
    __asm__ __volatile__("inb %1, %0" : "=a"(ret) : "Nd"(port));
    return ret;
}

static void serial_init(void) {
    outb(0x3F8 + 1, 0x00);
    outb(0x3F8 + 3, 0x80);
    outb(0x3F8 + 0, 0x03);
    outb(0x3F8 + 1, 0x00);
    outb(0x3F8 + 3, 0x03);
    outb(0x3F8 + 2, 0xC7);
    outb(0x3F8 + 4, 0x0B);
}

static void serial_putc(char c) {
    while (!(inb(0x3F8 + 5) & 0x20));
    outb(0x3F8, c);
}

static void serial_print(const char* str) {
    for (int i = 0; str[i]; i++) serial_putc(str[i]);
}

static void serial_hex(uint32_t val) {
    const char* hex = "0123456789ABCDEF";
    serial_print("0x");
    for (int i = 28; i >= 0; i -= 4) {
        serial_putc(hex[(val >> i) & 0xF]);
    }
}

static void serial_num(uint32_t val) {
    if (val == 0) { serial_putc('0'); return; }
    char buf[12];
    int i = 0;
    while (val) { buf[i++] = '0' + (val % 10); val /= 10; }
    while (i--) serial_putc(buf[i]);
}

int framebuffer_init(uint32_t mb_magic, uint32_t mb_info_addr) {
    serial_init();
    serial_print("\n[QUARTZ] Boot start\n");

    if (mb_magic != MULTIBOOT_MAGIC) {
        serial_print("[QUARTZ] BAD MAGIC: "); serial_hex(mb_magic); serial_print("\n");
        return 0;
    }

    multiboot_info_t* mb = (multiboot_info_t*)mb_info_addr;
    serial_print("[QUARTZ] Flags: "); serial_hex(mb->flags); serial_print("\n");

    /* Check if framebuffer info is available */
    if (!(mb->flags & MULTIBOOT_FRAMEBUFFER_INFO)) {
        serial_print("[QUARTZ] No framebuffer flag\n");
        return 0;
    }

    fb = (uint32_t*)(uint32_t)(mb->framebuffer_addr & 0xFFFFFFFF);
    screen_width = mb->framebuffer_width;
    screen_height = mb->framebuffer_height;
    fb_pitch = mb->framebuffer_pitch;

    serial_print("[QUARTZ] FB addr=");  serial_hex((uint32_t)(uintptr_t)fb);  serial_print("\n");
    serial_print("[QUARTZ] FB pitch="); serial_num(fb_pitch); serial_print("\n");
    serial_print("[QUARTZ] FB w=");     serial_num(screen_width);  serial_print(" h=");
    serial_num(screen_height); serial_print(" bpp=");             serial_num(mb->framebuffer_bpp);
    serial_print("\n");

    if (!fb || screen_width == 0 || screen_height == 0 || mb->framebuffer_bpp != 32) {
        serial_print("[QUARTZ] Invalid FB params\n");
        return 0;
    }

    fb_ready = 1;
    serial_print("[QUARTZ] FB ready!\n");
    return 1;
}

void fb_clear(uint8_t r, uint8_t g, uint8_t b) {
    if (!fb_ready) return;

    uint32_t color = ((uint32_t)r << 16) | ((uint32_t)g << 8) | b;
    uint32_t pixels_per_row = fb_pitch / 4;

    for (uint32_t y = 0; y < screen_height; y++) {
        for (uint32_t x = 0; x < screen_width; x++) {
            fb[y * pixels_per_row + x] = color;
        }
    }
}

void FB_drawpattern(uint32_t x1, uint32_t y1, uint32_t x2, uint32_t y2, uint32_t pattern) {
    if (!fb_ready) return;

    static const uint8_t macgray[8][8] = {
        {1,0,1,0,1,0,1,0},
        {0,1,0,1,0,1,0,1},
        {1,0,1,0,1,0,1,0},
        {0,1,0,1,0,1,0,1},
        {1,0,1,0,1,0,1,0},
        {0,1,0,1,0,1,0,1},
        {1,0,1,0,1,0,1,0},
        {0,1,0,1,0,1,0,1}
    };

    const uint8_t (*pat)[8];
    uint32_t fg, bg;

    if (pattern == FB_PATTERN_MACGRAY) {
        pat = macgray;
        fg = 0x00000000;
        bg = 0x00FFFFFF;
    } else {
        return;
    }

    uint32_t pixels_per_row = fb_pitch / 4;

    for (uint32_t y = y1; y <= y2 && y < screen_height; y++) {
        for (uint32_t x = x1; x <= x2 && x < screen_width; x++) {
            uint32_t py = (y - y1) % 8;
            uint32_t px = (x - x1) % 8;
            fb[y * pixels_per_row + x] = pat[py][px] ? fg : bg;
        }
    }
}

void FB_drawrect(uint32_t x1, uint32_t y1, uint32_t x2, uint32_t y2, uint32_t color) {
    if (!fb_ready) return;

    uint32_t pixels_per_row = fb_pitch / 4;

    for (uint32_t y = y1; y <= y2 && y < screen_height; y++) {
        for (uint32_t x = x1; x <= x2 && x < screen_width; x++) {
            fb[y * pixels_per_row + x] = color;
        }
    }
}

/* PIT timer for delay() */
static volatile uint32_t pit_ticks = 0;

void delay(uint32_t ms) {
    for (uint32_t i = 0; i < ms; i++) {
        for (volatile uint32_t j = 0; j < 250000; j++) {
            __asm__ __volatile__("nop");
        }
    }
}

void FB_putchar(uint32_t x, uint32_t y, char c, uint32_t color, uint32_t size) {
    if (!fb_ready || size < 1 || size > 2) return;

    uint32_t pixels_per_row = fb_pitch / 4;
    const uint8_t* glyph = font_cp437[(uint8_t)c];

    for (uint32_t row = 0; row < FONT_HEIGHT; row++) {
        uint8_t bits = glyph[row];
        for (uint32_t col = 0; col < FONT_WIDTH; col++) {
            if (bits & (0x80 >> col)) {
                for (uint32_t dy = 0; dy < size; dy++) {
                    for (uint32_t dx = 0; dx < size; dx++) {
                        uint32_t px = x + col * size + dx;
                        uint32_t py = y + row * size + dy;
                        if (px < screen_width && py < screen_height) {
                            fb[py * pixels_per_row + px] = color;
                        }
                    }
                }
            }
        }
    }
}

void FB_write(uint32_t x, uint32_t y, const char* str, uint32_t color, uint32_t size) {
    if (size < 1 || size > 2) return;
    uint32_t cx = x;
    uint32_t char_w = FONT_WIDTH * size;
    uint32_t char_h = FONT_HEIGHT * size;
    for (int i = 0; str[i]; i++) {
        if (str[i] == '\n') {
            cx = x;
            y += char_h;
            continue;
        }
        FB_putchar(cx, y, str[i], color, size);
        cx += char_w;
    }
}

/* ---- Cursor ---- */

#include "mouse.h"

/* Exact Macintosh System 6 arrow cursor from QuickDraw source (GrafAsm.a) */
/* Rendering: screen = (screen AND mask) XOR data */
/* For our TrueColor FB: mask=0→transparent, mask=1+data=0→black, mask=1+data=1→white */
static const uint16_t cursor_data[16] = {
    0x0000, 0x4000, 0x6000, 0x7000,
    0x7800, 0x7C00, 0x7E00, 0x7F00,
    0x7F80, 0x7C00, 0x6C00, 0x4600,
    0x0600, 0x0300, 0x0300, 0x0000
};

static const uint16_t cursor_mask[16] = {
    0xC000, 0xE000, 0xF000, 0xF800,
    0xFC00, 0xFE00, 0xFF00, 0xFF80,
    0xFFC0, 0xFFE0, 0xFE00, 0xEF00,
    0xCF00, 0x8780, 0x0780, 0x0380
};

static uint32_t cursor_bg[16 * 16];
static int cursor_px = -1;
static int cursor_py = -1;

static void cursor_save_bg(int x, int y) {
    int cx, cy;
    for (cy = 0; cy < 16; cy++) {
        for (cx = 0; cx < 16; cx++) {
            int px = x + cx;
            int py = y + cy;
            if (px >= 0 && px < (int)screen_width && py >= 0 && py < (int)screen_height) {
                uint32_t pixels_per_row = fb_pitch / 4;
                cursor_bg[cy * 16 + cx] = fb[py * pixels_per_row + px];
            }
        }
    }
    cursor_px = x;
    cursor_py = y;
}

static void cursor_restore_bg(void) {
    if (cursor_px < 0) return;
    int cx, cy;
    uint32_t pixels_per_row = fb_pitch / 4;
    for (cy = 0; cy < 16; cy++) {
        for (cx = 0; cx < 16; cx++) {
            int px = cursor_px + cx;
            int py = cursor_py + cy;
            if (px >= 0 && px < (int)screen_width && py >= 0 && py < (int)screen_height) {
                fb[py * pixels_per_row + px] = cursor_bg[cy * 16 + cx];
            }
        }
    }
}

static void cursor_draw(int x, int y) {
    int cx, cy;
    uint32_t pixels_per_row = fb_pitch / 4;
    for (cy = 0; cy < 16; cy++) {
        for (cx = 0; cx < 16; cx++) {
            int px = x + cx;
            int py = y + cy;
            if (px >= 0 && px < (int)screen_width && py >= 0 && py < (int)screen_height) {
                if (cursor_mask[cy] & (0x8000 >> cx)) {
                    if (cursor_data[cy] & (0x8000 >> cx)) {
                        fb[py * pixels_per_row + px] = 0x00000000;
                    } else {
                        fb[py * pixels_per_row + px] = 0x00FFFFFF;
                    }
                }
            }
        }
    }
}

void fb_cursor_update(void) {
    if (!fb || !fb_ready) return;
    int mx = mouse_x();
    int my = mouse_y();

    cursor_restore_bg();
    cursor_save_bg(mx, my);
    cursor_draw(mx, my);
}

void fb_cursor_invalidate(void) {
    cursor_px = -1;
    cursor_py = -1;
}

/* ---- BMP Loader ---- */

typedef struct {
    uint16_t signature;
    uint32_t file_size;
    uint32_t reserved;
    uint32_t data_offset;
} __attribute__((packed)) bmp_file_header_t;

typedef struct {
    uint32_t header_size;
    int32_t  width;
    int32_t  height;
    uint16_t planes;
    uint16_t bpp;
    uint32_t compression;
    uint32_t image_size;
    int32_t  x_ppm;
    int32_t  y_ppm;
    uint32_t colors_used;
    uint32_t colors_important;
} __attribute__((packed)) bmp_info_header_t;

void FB_drawbmp(uint32_t x, uint32_t y, const void* bmp_data) {
    if (!fb_ready) return;

    const uint8_t* data = (const uint8_t*)bmp_data;
    bmp_file_header_t* fhdr = (bmp_file_header_t*)data;
    bmp_info_header_t* ihdr = (bmp_info_header_t*)(data + 14);

    if (fhdr->signature != 0x4D42) return;

    int w = ihdr->width;
    int h = ihdr->height;
    uint16_t bpp = ihdr->bpp;
    uint32_t offset = fhdr->data_offset;

    int top_down = (h < 0);
    if (h < 0) h = -h;

    uint32_t ppr = fb_pitch / 4;

    for (int row = 0; row < h; row++) {
        int src_row = top_down ? row : (h - 1 - row);
        uint32_t row_bytes = (uint32_t)w * (bpp / 8);
        row_bytes = (row_bytes + 3) & ~3;
        uint32_t row_off = offset + (uint32_t)src_row * row_bytes;

        for (int col = 0; col < w; col++) {
            uint32_t px = x + (uint32_t)col;
            uint32_t py = y + (uint32_t)row;
            if (px >= screen_width || py >= screen_height) continue;

            uint32_t po = row_off + (uint32_t)col * (bpp / 8);
            uint32_t color = 0;

            if (bpp == 24) {
                color = ((uint32_t)data[po + 2] << 16) |
                        ((uint32_t)data[po + 1] << 8)  |
                        data[po];
            } else if (bpp == 32) {
                color = ((uint32_t)data[po + 2] << 16) |
                        ((uint32_t)data[po + 1] << 8)  |
                        data[po];
            } else {
                continue;
            }

            if (color == 0x00FF0000) continue;

            fb[py * ppr + px] = color;
        }
    }
}

static uint8_t cmos_read(uint8_t reg) {
    outb(0x70, reg);
    return inb(0x71);
}

static uint8_t bcd_to_bin(uint8_t bcd) {
    return (bcd >> 4) * 10 + (bcd & 0x0F);
}

void rtc_read(uint8_t* hour, uint8_t* min, uint8_t* sec) {
    *sec = bcd_to_bin(cmos_read(0x00));
    *min = bcd_to_bin(cmos_read(0x02));
    *hour = bcd_to_bin(cmos_read(0x04));
}
