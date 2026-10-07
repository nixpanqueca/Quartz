/* Cubic System Software - CMOS Real Time Clock */
/* Ripped out of framebuffer.c, where it did not belong. */

#include "rtc.h"
#include "io.h"

#define CMOS_ADDRESS  0x70
#define CMOS_DATA     0x71

#define RTC_SECONDS      0x00
#define RTC_MINUTES      0x02
#define RTC_HOURS        0x04
#define RTC_DAY          0x07
#define RTC_MONTH        0x08
#define RTC_YEAR         0x09
#define RTC_STATUS_A     0x0A
#define RTC_STATUS_B     0x0B
#define RTC_CENTURY      0x32

/* The update-in-progress flag clears in well under a millisecond; the bound is
 * only there so a dead RTC cannot hang the kernel. */
#define RTC_WAIT_LIMIT   100000

static uint8_t cmos_read(uint8_t reg) {
    outb(CMOS_ADDRESS, reg);
    return inb(CMOS_DATA);
}

static void wait_for_update(void) {
    int spin = RTC_WAIT_LIMIT;

    while (spin-- > 0) {
        if (!(cmos_read(RTC_STATUS_A) & 0x80))
            return;
    }
}

static uint8_t from_bcd(uint8_t value) {
    return (uint8_t)((value >> 4) * 10u + (value & 0x0Fu));
}

void rtc_init(void) {
    /* Nothing to enable: we poll the registers on demand and never wire up the
     * periodic interrupt, which would only be noise for a shell prompt. */
}

void rtc_get_time(uint8_t* hour, uint8_t* minute, uint8_t* second) {
    uint8_t status_b = cmos_read(RTC_STATUS_B);
    uint8_t raw_hour;
    uint8_t raw_minute;
    uint8_t raw_second;

    wait_for_update();
    raw_second = cmos_read(RTC_SECONDS);
    raw_minute = cmos_read(RTC_MINUTES);
    raw_hour = cmos_read(RTC_HOURS);
    wait_for_update();

    if (status_b & 0x04) {                  /* binary mode, not BCD */
        *hour = (uint8_t)(raw_hour & 0x3F);
        *minute = raw_minute;
        *second = raw_second;
        return;
    }

    *second = from_bcd(raw_second);
    *minute = from_bcd(raw_minute);

    if (status_b & 0x02) {
        /* 24 hour, still BCD. No masking: the hour byte holds tens in its high
         * nibble, and a mask wide enough to clear the 12 hour flag (0x1F) also
         * clears the tens digit, so 20:02 came out as 00:02. Only the 12 hour
         * mode needs the flag cleared. */
        *hour = from_bcd(raw_hour);
    } else {
        uint8_t twelve = from_bcd((uint8_t)(raw_hour & 0x7F));
        int pm = (raw_hour & 0x80) != 0;

        /* Some firmware reports the 12 hour flag but still stores the 24 hour
         * value, so a "twelve" above 12 is already the answer and must not have
         * 12 added to it. Without this the clock prints hours like 25. */
        if (twelve > 12)
            *hour = twelve;
        else {
            if (twelve == 12)
                twelve = 0;
            if (pm)
                twelve = (uint8_t)(twelve + 12);
            *hour = twelve;
        }
    }
}

void rtc_get_date(uint16_t* year, uint8_t* month, uint8_t* day, uint8_t* weekday) {
    uint8_t status_b = cmos_read(RTC_STATUS_B);
    uint8_t raw_year;
    uint8_t raw_month;
    uint8_t raw_day;
    uint8_t raw_century;
    uint16_t full_year;

    wait_for_update();
    raw_day = cmos_read(RTC_DAY);
    raw_month = cmos_read(RTC_MONTH);
    raw_year = cmos_read(RTC_YEAR);
    raw_century = cmos_read(RTC_CENTURY);
    wait_for_update();

    if (status_b & 0x04) {
        *day = raw_day;
        *month = raw_month;
        full_year = (uint16_t)(((uint16_t)(raw_century & 0xFF) * 100u) + raw_year);
    } else {
        *day = from_bcd(raw_day);
        *month = from_bcd(raw_month);
        full_year = (uint16_t)((uint16_t)(from_bcd(raw_century) * 100u) +
                               from_bcd(raw_year));
    }

    if (full_year < 70)
        full_year = (uint16_t)(full_year + 2000);
    else if (full_year < 100)
        full_year = (uint16_t)(full_year + 1900);

    *year = full_year;
    *weekday = (uint8_t)(raw_day & 0x07);
}
