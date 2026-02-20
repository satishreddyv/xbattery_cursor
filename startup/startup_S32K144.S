/*
 * Startup code for S32K144 - Xbattery
 * Vector table and Reset_Handler: copy .data, zero .bss, call SystemInit then main.
 */

.syntax unified
.cpu cortex-m4
.fpu fpv4-sp-d16
.thumb

.global Reset_Handler
.global Default_Handler

/* Vector table */
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
    /* IRQ 0-15 and beyond can be added here */
    .size __isr_vector_table, . - __isr_vector_table

/* Flash configuration (S32K144) */
.section .FlashConfig,"a",%progbits
.long 0xFFFFFFFF
.long 0xFFFFFFFF
.long 0xFFFFFFFF
.long 0xFFFFFFFE

.text
.thumb_func
Reset_Handler:
    /* Copy .data from flash to RAM (m_data) */
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

    /* Call SystemInit (C) if present */
    bl   SystemInit

    /* Call main */
    bl   main

    /* If main returns, loop forever */
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

.set NMI_Handler, Default_Handler
.set HardFault_Handler, Default_Handler
.set MemManage_Handler, Default_Handler
.set BusFault_Handler, Default_Handler
.set UsageFault_Handler, Default_Handler
.set SVC_Handler, Default_Handler
.set DebugMon_Handler, Default_Handler
.set PendSV_Handler, Default_Handler
.set SysTick_Handler, Default_Handler

.end
