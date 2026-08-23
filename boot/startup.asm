; Quartz Kernel startup

bits 32

global _start
extern _Kernel


section .text

_start:

    ; creates stack
    mov esp, stack_top

    ; no interrupts until IDT is set up
    cli

    ; mask all PIC IRQs: the kernel is polled (mouse, serial, keyboard),
    ; so no interrupt may reach the CPU without a valid IDT.
    mov al, 0xFF
    out 0xA1, al   ; slave PIC (IRQ8-15)
    out 0x21, al   ; master PIC (IRQ0-7)

    ; Pascal
    call _Kernel


.loop:
    cli
    hlt
    jmp .loop



section .bss

align 16

stack_bottom:
    resb 16384

stack_top: