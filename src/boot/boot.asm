; Cubic System Software - Boot Assembly
; Minimal multiboot header for GRUB

MBALIGN  equ 1 << 0
MEMINFO  equ 1 << 1
VIDEO    equ 1 << 2
FLAGS    equ MBALIGN | MEMINFO | VIDEO
MAGIC    equ 0x1BADB002
CHECKSUM equ -(MAGIC + FLAGS)

section .multiboot
align 4
    dd MAGIC
    dd FLAGS
    dd CHECKSUM
    dd 0, 0, 0, 0, 0
    dd 0                        ; Linear graphics mode
    dd 800                      ; Width
    dd 600                      ; Height
    dd 32                       ; BPP

section .bss
align 16
stack_bottom:
    resb 16384
stack_top:

section .text
global _start
extern quartz_main

_start:
    mov esp, stack_top
    push ebx    ; multiboot info pointer (2nd arg)
    push eax    ; multiboot magic (1st arg)
    call quartz_main
    cli
.hang:
    hlt
    jmp .hang
