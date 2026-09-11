/* Cubic System Software - Prism Service */
/* High-level desktop: dock, icons, window management */

#include "../../src/kernel/service.h"
#include "../../src/kernel/framebuffer.h"
#include "../../src/kernel/prism.h"
#include "../../src/kernel/fs.h"

static int prism_running = 0;

static void prism_init(void) {
    /* Load resources, icons, etc. */
}

static void prism_start(void) {
    prism_running = 1;
    PrismSetTitle("Prism");
}

static void prism_stop(void) {
    prism_running = 0;
}

static void prism_shutdown(void) {
    prism_running = 0;
}

SERVICE_REGISTER(prism, "1.0", SERVICE_TYPE_APP,
                  prism_init, prism_start, prism_stop, prism_shutdown)
