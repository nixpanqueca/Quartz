; Cubic System Software - ISR Stubs

[bits 32]

; Last scancode received (C will poll this)
global g_scancode
section .data
g_scancode: db 0

; ISR 33 - IRQ1 (Keyboard)
section .text
global isr33
isr33:
    pusha
    mov dx, 0x3F8
    mov al, 'K'
    out dx, al
    in al, 0x60
    mov [g_scancode], al
    mov al, 0x20
    out 0x20, al
    popa
    iret

; Generic ISR stub (no error code pushed by CPU)
%macro ISR_STUB 1
global isr%1
isr%1:
    pusha
    mov al, 0x20
    out 0x20, al
    popa
    iret
%endmacro

; ISR stub for exceptions that push error code (must discard it first)
%macro ISR_STUB_ERR 1
global isr%1
isr%1:
    add esp, 4
    pusha
    mov al, 0x20
    out 0x20, al
    popa
    iret
%endmacro

ISR_STUB 0
ISR_STUB 1
ISR_STUB 2
ISR_STUB 3
ISR_STUB 4
ISR_STUB 5
ISR_STUB 6
ISR_STUB 7
ISR_STUB_ERR 8    ; Double Fault (error code)
ISR_STUB 9
ISR_STUB_ERR 10   ; Invalid TSS (error code)
ISR_STUB_ERR 11   ; Segment Not Present (error code)
ISR_STUB_ERR 12   ; Stack-Segment Fault (error code)
ISR_STUB_ERR 13   ; General Protection Fault (error code)
ISR_STUB_ERR 14   ; Page Fault (error code)
ISR_STUB 15
ISR_STUB_ERR 17   ; Alignment Check (error code)
ISR_STUB 16
ISR_STUB 18
ISR_STUB 19
ISR_STUB 20
ISR_STUB_ERR 21   ; Machine Check (error code)
ISR_STUB 22
ISR_STUB 23
ISR_STUB 24
ISR_STUB 25
ISR_STUB 26
ISR_STUB 27
ISR_STUB 28
ISR_STUB 29
ISR_STUB_ERR 30   ; Security Exception (error code)
ISR_STUB 31
ISR_STUB 32
ISR_STUB 34
ISR_STUB 35
ISR_STUB 36
ISR_STUB 37
ISR_STUB 38
ISR_STUB 39

; ISR 44 - IRQ12 (Mouse)
extern mouse_handler
global isr44
isr44:
    pusha
    mov dx, 0x3F8
    mov al, 'Z'
    out dx, al
    call mouse_handler
    mov al, 0x20
    out 0xA0, al
    out 0x20, al
    popa
    iret
