/**
 * @file system_S32K344.c
 * @brief System initialization for S32K344 (Cortex-M7) - Xbattery
 */

#include <stdint.h>

extern void SystemInit(void);

/**
 * Minimal SystemInit for S32K344.
 * Expand with clock (FIRC/PLL), MPU, and cache configuration as needed.
 * On S32K3xx the ROM sets a safe default clock (48 MHz FIRC).
 */
void SystemInit(void)
{
    /* Optional: enable I-cache and D-cache for Cortex-M7 */
    /* SCB->ICIALLU = 0; SCB_EnableICache(); SCB_EnableDCache(); */
    (void)0;
}