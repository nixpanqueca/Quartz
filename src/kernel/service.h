/* Cubic System Software - Service Manager */

#ifndef SERVICE_H
#define SERVICE_H

#include <stdint.h>

#define SERVICE_TYPE_APP     0
#define SERVICE_TYPE_SERVICE 1

typedef struct {
    const char* name;
    void (*func)(void);
} service_func_t;

typedef struct service_entry {
    const char* path;
    const char* name;
    uint32_t type;
    void (*init)(void);
    void (*shutdown)(void);
    const service_func_t* funcs;
} service_entry_t;

#define SERVICE_REGISTER(p, n, t, f) \
    static const service_entry_t __service_entry \
    __attribute__((used, section(".services"))) = { \
        .path = p, \
        .name = n, \
        .type = t, \
        .init = Init, \
        .shutdown = Shutdown, \
        .funcs = f \
    };

uint32_t service_count(void);
const service_entry_t* service_get(uint32_t index);
const service_entry_t* service_find(const char* path);

int service_run(const char* path);
int service_run_on(const char* path, int thread_id);
int service_stop(const char* path);
int service_call(const char* path, const char* func_name);

#endif
