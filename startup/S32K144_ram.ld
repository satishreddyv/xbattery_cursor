/*
 * S32K144 RAM linker script - Xbattery
 * Memory map:
 *   m_interrupts  0x00000000  1 KB   (vector table)
 *   m_flash_config 0x00000400  16 B  (flash config)
 *   m_text        0x00000410  ~512KB (code + rodata)
 *   m_data        0x1FFF8000  32 KB  (SRAM_L - .data)
 *   m_data_2      0x20000000  28 KB  (SRAM_U - .bss, heap, stack)
 */

MEMORY
{
  m_interrupts (RX)  : ORIGIN = 0x00000000, LENGTH = 0x00000400
  m_flash_config (RX): ORIGIN = 0x00000400, LENGTH = 0x00000010
  m_text (RX)       : ORIGIN = 0x00000410, LENGTH = 0x0007FBF0
  m_data (RW)        : ORIGIN = 0x1FFF8000, LENGTH = 0x00008000
  m_data_2 (RW)      : ORIGIN = 0x20000000, LENGTH = 0x00007000
}

/* Entry point */
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

  .flash_config :
  {
    . = ALIGN(4);
    KEEP(*(.FlashConfig))
    . = ALIGN(4);
  } > m_flash_config

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
  } > m_data_2

  .heap :
  {
    . = ALIGN(4);
    __heap_start = .;
    _eheap = .;
    . = ORIGIN(m_data_2) + LENGTH(m_data_2) - 0x800;
    __heap_end = .;
  } > m_data_2

  .stack (NOLOAD) :
  {
    . = ALIGN(8);
    __StackLimit = .;
    . = . + 0x800;
    __StackTop = .;
    __stack = __StackTop;
  } > m_data_2

  _end = .;
}
