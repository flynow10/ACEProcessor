
MEMORY
{
    ram (ax)  : ORIGIN = 0x00000000, LENGTH = 0x0040000
}

SECTIONS 
{
    .text : 
    {
        *(.text*)
    }  > ram

    .rodata ALIGN(4) : 
    {
        *(.rodata*)
        *(.srodata*)
    }  > ram

    .data ALIGN (8) :
    {
        *(.data*)
        *(.sdata*)
        PROVIDE (__global_pointer$ = .);
    } > ram

    .heap ALIGN(8) :
    {
        __heap_start = .;
        __malloc_start = .;
        *(.heap*)
        *(.sheap*)
    } > ram

    .bss ALIGN(8) (NOLOAD) :
    {
        __bss_start = .;
        *(.bss*)
        *(.sbss*)
        *(COMMON)
    } > ram

	_end = .;
}