ENTRY(_start)

MEMORY
{
    FLASH (rx) : ORIGIN = 0x00000000, LENGTH = 0x10000
    RAM   (rw) : ORIGIN = 0x00010000, LENGTH = 0x10000
}

SECTIONS
{
    .text :
    {
        KEEP(*(.vectors))
        *(.text*)
        *(.rodata*)
        KEEP(*(.init))
        KEEP(*(.fini))
    } > FLASH

    .data :
    {
        *(.data*)
        PROVIDE(__global_pointer$ = . + 0x800);
    } > RAM

    .bss :
    {
        __bss_start = .;
        *(.bss*)
        *(COMMON)
        __bss_end = .;
    } > RAM

    .stack :
    {
        . = ALIGN(4);
        _stack_start = .;
        . = . + 0x1000;
        _stack_end = .;
    } > RAM

    .heap :
    {
        _heap_start = .;
        . = . + 0x2000;
        _heap_end = .;
    } > RAM

    _end = .;
}