/* Cubic System Software - Service Manager */

#include "service.h"
#include "framebuffer.h"
#include "thread.h"

extern service_entry_t __services_start[];
extern service_entry_t __services_end[];

uint32_t service_count(void) {
    return (uint32_t)(__services_end - __services_start);
}

const service_entry_t* service_get(uint32_t index) {
    if (index >= service_count()) return 0;
    return &__services_start[index];
}

static int str_eq(const char* a, const char* b) {
    while (*a && *b && *a == *b) { a++; b++; }
    return *a == *b;
}

const service_entry_t* service_find(const char* path) {
    for (uint32_t i = 0; i < service_count(); i++) {
        if (str_eq(__services_start[i].path, path))
            return &__services_start[i];
    }
    return 0;
}

int service_run(const char* path) {
    const service_entry_t* svc = service_find(path);
    if (!svc || !svc->init) return -1;
    svc->init();
    return 0;
}

int service_run_on(const char* path, int thread_id) {
    const service_entry_t* svc = service_find(path);
    if (!svc || !svc->init) return -1;
    return thread_create(svc->name, svc->init);
}

int service_stop(const char* path) {
    const service_entry_t* svc = service_find(path);
    if (!svc || !svc->shutdown) return -1;
    svc->shutdown();
    return 0;
}

int service_call(const char* path, const char* func_name) {
    const service_entry_t* svc = service_find(path);
    if (!svc || !svc->funcs) return -1;
    for (int i = 0; svc->funcs[i].name; i++) {
        if (str_eq(svc->funcs[i].name, func_name)) {
            svc->funcs[i].func();
            return 0;
        }
    }
    return -1;
}
