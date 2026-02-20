/**
 * @file main.c
 * @brief Xbattery S32K144 application entry
 */

#include <stdint.h>

int main(void)
{
    /* Minimal main: add application logic (e.g. GPIO blink, drivers). */
    volatile uint32_t count = 0u;

    for (;;)
    {
        count++;
        (void)count;
    }

    return 0;
}
