/* Cubic System Software - CMOS Real Time Clock */

#ifndef RTC_H
#define RTC_H

#include <stdint.h>

void rtc_init(void);

/* 24 hour clock, decimal. Hours are 0..23. */
void rtc_get_time(uint8_t* hour, uint8_t* minute, uint8_t* second);

/* Two digit year: 70..99 map to 1970..1999, 00..69 to 2000..2069. */
void rtc_get_date(uint16_t* year, uint8_t* month, uint8_t* day, uint8_t* weekday);

#endif