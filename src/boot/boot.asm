; Cubic System Software - Boot Assembly
; Minimal multiboot header for GRUB

MBALIGN  equ 1 << 0
MEMINFO  equ 1 << 1
; VIDEO is deliberately not requested. With it set GRUB switches the card to
; a VBE linear framebuffer before jumping to us, and the legacy window at
; 0xB8000 stops being decoded, so the text console has nowhere to draw and
; the screen stays black. Leaving it off hands the machine over in the text
; mode the firmware started in, which console.c writes to directly.
FLAGS    equ MBALIGN | MEMINFO
MAGIC    equ 0x1BADB002
CHECKSUM equ -(MAGIC + FLAGS)

; Bit 3 stays clear on purpose. Multiboot v1 reserves it: only multiboot2 uses
; it to ask for modules, and GRUB 2.14 refuses the whole header with
; "error: unsupported flag" when it is set. Modules need no flag here anyway,
; GRUB hands over whatever the `module` lines in grub.cfg declare.

section .multiboot
align 4
    dd MAGIC
    dd FLAGS
    dd CHECKSUM
    dd 0, 0, 0, 0, 0
    ; No video fields follow: without the VIDEO flag there is nothing to
    ; request, and the firmware's own text mode is what we want.

section .bss
align 16
stack_bottom:
    resb 16384
stack_top:

section .text
global _start
extern quartz_main

_start:
    cli
    mov esp, stack_top           ; GRUB leaves paging off, so this is the top
    push ebx                     ; multiboot info pointer (2nd argument)
    push eax                     ; multiboot magic (1st argument)
    call quartz_main
    cli
.hang:
    hlt
    jmp .hang