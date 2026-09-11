/* Cubic System Software - Linker Script */
/* Tells the linker how to arrange our kernel in memory */

ENTRY(_start)

SECTIONS
{
    . = 1M;  /* Load kernel at 1MB (standard for GRUB) */

    .text BLOCK(4K) : ALIGN(4K)
    {
        *(.multiboot)  /* Put multiboot header first */
        *(.text)
    }

    .rodata BLOCK(4K) : ALIGN(4K)
    {
        *(.rodata)
    }

    .data BLOCK(4K) : ALIGN(4K)
    {
        *(.data)
    }

    __services_start = .;
    .services BLOCK(4K) : ALIGN(4K)
    {
        *(.services)
    }
    __services_end = .;

    .bss BLOCK(4K) : ALIGN(4K)
    {
        *(COMMON)
        *(.bss)
    }
}
