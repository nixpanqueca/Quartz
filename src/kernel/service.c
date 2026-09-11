/* Cubic System Software - Service Manager */

#include "service.h"
#include "framebuffer.h"

extern service_entry_t __services_start[];
extern service_entry_t __services_end[];

static void outb(uint16_t port, uint8_t val) {
    __asm__ __volatile__("outb %0, %1" : : "a"(val), "Nd"(port));
}

static uint8_t inb(uint16_t port) {
    uint8_t ret;
    __asm__ __volatile__("inb %1, %0" : "=a"(ret) : "Nd"(port));
    return ret;
}

static void dbg(char c) {
    while (!(inb(0x3F8 + 5) & 0x20));
    outb(0x3F8, c);
}

static void dbg_str(const char* s) {
    for (int i = 0; s[i]; i++) dbg(s[i]);
}

uint32_t service_count(void) {
    return (uint32_t)(__services_end - __services_start);
}

const service_entry_t* service_get(uint32_t index) {
    if (index >= service_count()) return 0;
    return &__services_start[index];
}

const service_entry_t* service_find(const char* name) {
    for (uint32_t i = 0; i < service_count(); i++) {
        const char* a = __services_start[i].name;
        const char* b = name;
        while (*a && *b && *a == *b) { a++; b++; }
        if (*a == *b) return &__services_start[i];
    }
    return 0;
}

void service_init_all(void) {
    uint32_t count = service_count();
    dbg_str("[SVC] init: ");
    dbg('0' + count);
    dbg_str(" services\n");

    for (uint32_t i = 0; i < count; i++) {
        if (__services_start[i].init) {
            dbg_str("[SVC] init: ");
            dbg_str(__services_start[i].name);
            dbg('\n');
            __services_start[i].init();
        }
    }
}

void service_start_all(void) {
    uint32_t count = service_count();
    for (uint32_t i = 0; i < count; i++) {
        if (__services_start[i].start) {
            dbg_str("[SVC] start: ");
            dbg_str(__services_start[i].name);
            dbg('\n');
            __services_start[i].start();
        }
    }
}

void service_stop_all(void) {
    uint32_t count = service_count();
    for (uint32_t i = 0; i < count; i++) {
        if (__services_start[i].stop) {
            dbg_str("[SVC] stop: ");
            dbg_str(__services_start[i].name);
            dbg('\n');
            __services_start[i].stop();
        }
    }
}

void service_shutdown_all(void) {
    uint32_t count = service_count();
    for (uint32_t i = 0; i < count; i++) {
        if (__services_start[i].shutdown) {
            dbg_str("[SVC] shutdown: ");
            dbg_str(__services_start[i].name);
            dbg('\n');
            __services_start[i].shutdown();
        }
    }
}

void service_start(const char* name) {
    const service_entry_t* svc = service_find(name);
    if (svc && svc->start) {
        dbg_str("[SVC] start: ");
        dbg_str(svc->name);
        dbg('\n');
        svc->start();
    }
}

void service_stop(const char* name) {
    const service_entry_t* svc = service_find(name);
    if (svc && svc->stop) {
        dbg_str("[SVC] stop: ");
        dbg_str(svc->name);
        dbg('\n');
        svc->stop();
    }
}
