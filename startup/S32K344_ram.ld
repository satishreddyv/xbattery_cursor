/*
 * S32K344 RAM linker script - Xbattery
 * S32K3xx/4xx (Cortex-M7)
 *
 * Memory map (S32K344):
 *   Flash (Code PF0) : 0x00400000  4 MB
 *   SRAM (SRAM_0..2) : 0x20400000  256 KB
 *   Stack size       : 0x2000 (8 KB)
 *   Heap size        : remaining SRAM after .bss
 *
 * Note: S32K3xx uses an IVT (Interrupt Vector Table) at flash base.
 *       There is NO Flash Configuration Block (FCB) unlike S32K1xx.
 */

MEMORY
{
  m_interrupts (RX)  : ORIGIN = 0x00400000, LENGTH = 0x00000400
  m_text       (RX)  : ORIGIN = 0x00400400, LENGTH = 0x003FFC00
  m_data       (RW)  : ORIGIN = 0x20400000, LENGTH = 0x00040000
}

ENTRY(Reset_Handler)

SECTIONS
{
  .isr_vector :
  {
    __isr_vector_table = .;
    . = ALIGN(4);
    KEEP(*(.isr_vector))
    . = ALIGN(4);
  } > m_interrupts

  .text :
  {
    . = ALIGN(4);
    *(.text)
    *(.text*)
    *(.rodata)
    *(.rodata*)
    . = ALIGN(4);
    _etext = .;
  } > m_text

  .data : AT(_etext)
  {
    . = ALIGN(4);
    _sdata = .;
    *(.data)
    *(.data*)
    . = ALIGN(4);
    _edata = .;
  } > m_data

  __etext = _etext;

  .bss :
  {
    . = ALIGN(4);
    _sbss = .;
    *(.bss)
    *(.bss*)
    *(COMMON)
    . = ALIGN(4);
    _ebss = .;
  } > m_data

  .heap :
  {
    . = ALIGN(4);
    __heap_start = .;
    . = ORIGIN(m_data) + LENGTH(m_data) - 0x2000;
    __heap_end = .;
  } > m_data

  .stack (NOLOAD) :
  {
    . = ALIGN(8);
    __StackLimit = .;
    . = . + 0x2000;
    __StackTop = .;
    __stack = __StackTop;
  } > m_data

  _end = .;
}