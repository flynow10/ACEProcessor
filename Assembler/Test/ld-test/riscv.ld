__heap_size     = 0x200;    /* required amount of heap  */
__stack_size    = 0x800;    /* required amount of stack */

MEMORY
{
    ROM         (rwx) : ORIGIN = 0x00000000, LENGTH = 0x00200
    RAM         (rwx) : ORIGIN = 0x00000200, LENGTH = 0x01000
    RESERVED    (rwx) : ORIGIN = 0x00018000, LENGTH = 0x12000
    EXCEPTION   (rwx) : ORIGIN = 0x00030000, LENGTH = 0x00400
    IO          (rw)  : ORIGIN = 0x00030400, LENGTH = 0x00010
}
SECTIONS
{
    .text :
    {
        *(.boot)
        *(.text)
        *(.text)
        *(.rodata*)
    } > ROM
    .data :
    {
        *(.sbss)
        *(.data)
        *(.bss)
        *(.rela*)
        *(COMMON)
    } > RAM

    .heap :
    {
        . = ALIGN(4);
        PROVIDE ( end = . );
        _sheap = .;
        . = . + __heap_size;
        . = ALIGN(4);
        _eheap = .;
    } >RAM


    .stack :
    {
        . = ALIGN(4);
        _estack = .;
        . = . + __stack_size;
        . = ALIGN(4);
        _sstack = .;
    } >RAM

    .exception :
    {
        *(.exception)
    } > EXCEPTION
}