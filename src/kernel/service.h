/* Cubic System Software - Service Manager */

#ifndef SERVICE_H
#define SERVICE_H

#include <stdint.h>

#define SERVICE_TYPE_APP     0
#define SERVICE_TYPE_SERVICE 1

#define SERVICE_STATE_STOPPED  0
#define SERVICE_STATE_RUNNING  1

typedef struct {
    const char* name;
    const char* version;
    uint32_t type;
    void (*init)(void);
    void (*start)(void);
    void (*stop)(void);
    void (*shutdown)(void);
} service_entry_t;

#define SERVICE_REGISTER(n, v, t, init_fn, start_fn, stop_fn, shutdown_fn) \
    static const service_entry_t __service_##n \
    __attribute__((used, section(".services"))) = { \
        .name = #n, \
        .version = v, \
        .type = t, \
        .init = init_fn, \
        .start = start_fn, \
        .stop = stop_fn, \
        .shutdown = shutdown_fn \
    };

void service_init_all(void);
void service_start_all(void);
void service_stop_all(void);
void service_shutdown_all();

uint32_t service_count(void);
const service_entry_t* service_get(uint32_t index);
const service_entry_t* service_find(const char* name);

void service_start(const char* name);
void service_stop(const char* name);

#endif
