/*
 * Startup code for S32K344 (Cortex-M7) - Xbattery
 *
 * Differences from S32K1xx startup:
 *  - Cortex-M7 core directives (.cpu cortex-m7, .fpu fpv5-d16)
 *  - NO Flash Configuration Block (S32K3xx uses Boot Header / IVT instead)
 *  - 8-byte stack alignment (same as M4 but enforced more strictly on M7)
 */

.syntax unified
.cpu cortex-m7
.fpu fpv5-d16
.thumb

.global Reset_Handler
.global Default_Handler

/* Vector table - placed in .isr_vector section */
.section .isr_vector,"a",%progbits
.align 2
.type __isr_vector_table, %object
__isr_vector_table:
    .long   __stack
    .long   Reset_Handler
    .long   NMI_Handler
    .long   HardFault_Handler
    .long   MemManage_Handler
    .long   BusFault_Handler
    .long   UsageFault_Handler
    .long   0
    .long   0
    .long   0
    .long   0
    .long   SVC_Handler
    .long   DebugMon_Handler
    .long   0
    .long   PendSV_Handler
    .long   SysTick_Handler
    /* Device-specific IRQs (S32K344 has 122+ IRQs) - extend here as needed */
    .size __isr_vector_table, . - __isr_vector_table

/* No FlashConfig section for S32K3xx - Boot is handled by ROM/IVT */

.text
.thumb_func
Reset_Handler:
    /* Enable FPU (Cortex-M7): set CP10/CP11 full access in CPACR */
    ldr  r0, =0xE000ED88
    ldr  r1, [r0]
    orr  r1, r1, #(0xF << 20)
    str  r1, [r0]
    dsb
    isb

    /* Copy .data from flash (LMA) to SRAM (VMA) */
    ldr  r0, =__etext
    ldr  r1, =_sdata
    ldr  r2, =_edata
copy_loop:
    cmp  r1, r2
    bge  copy_done
    ldr  r3, [r0], #4
    str  r3, [r1], #4
    b    copy_loop
copy_done:

    /* Zero .bss */
    ldr  r0, =_sbss
    ldr  r1, =_ebss
    movs r2, #0
bss_loop:
    cmp  r0, r1
    bge  bss_done
    str  r2, [r0], #4
    b    bss_loop
bss_done:

    /* SystemInit then main */
    bl   SystemInit
    bl   main

main_exit:
    b    main_exit

.thumb_func
Default_Handler:
    b    Default_Handler

.weak NMI_Handler
.weak HardFault_Handler
.weak MemManage_Handler
.weak BusFault_Handler
.weak UsageFault_Handler
.weak SVC_Handler
.weak DebugMon_Handler
.weak PendSV_Handler
.weak SysTick_Handler

.set NMI_Handler,      Default_Handler
.set HardFault_Handler, Default_Handler
.set MemManage_Handler, Default_Handler
.set BusFault_Handler,  Default_Handler
.set UsageFault_Handler,Default_Handler
.set SVC_Handler,       Default_Handler
.set DebugMon_Handler,  Default_Handler
.set PendSV_Handler,    Default_Handler
.set SysTick_Handler,   Default_Handler

.end