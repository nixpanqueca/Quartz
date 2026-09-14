; Cubic System Software - ISR Stubs + Thread Context Switch

[bits 32]

; Last scancode received (C will poll this)
global g_scancode
section .data
g_scancode: db 0

section .text

; ISR 32 - IRQ0 (PIT Timer) - triggers thread scheduler
; Passes current ESP to scheduler, loads returned new ESP
extern thread_scheduler
global isr32
isr32:
    pusha
    mov al, 0x20
    out 0x20, al
    mov eax, esp
    push eax
    call thread_scheduler
    add esp, 4
    mov esp, eax
    popa
    iret

; ISR 33 - IRQ1 (Keyboard)
global isr33
isr33:
    pusha
    in al, 0x60
    mov [g_scancode], al
    mov al, 0x20
    out 0x20, al
    popa
    iret

; ISR 44 - IRQ12 (Mouse)
extern mouse_handler
global isr44
isr44:
    pusha
    call mouse_handler
    mov al, 0x20
    out 0xA0, al
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
ISR_STUB_ERR 8
ISR_STUB 9
ISR_STUB_ERR 10
ISR_STUB_ERR 11
ISR_STUB_ERR 12
ISR_STUB_ERR 13
ISR_STUB_ERR 14
ISR_STUB 15
ISR_STUB_ERR 17
ISR_STUB 16
ISR_STUB 18
ISR_STUB 19
ISR_STUB 20
ISR_STUB_ERR 21
ISR_STUB 22
ISR_STUB 23
ISR_STUB 24
ISR_STUB 25
ISR_STUB 26
ISR_STUB 27
ISR_STUB 28
ISR_STUB 29
ISR_STUB_ERR 30
ISR_STUB 31
ISR_STUB 34
ISR_STUB 35
ISR_STUB 36
ISR_STUB 37
ISR_STUB 38
ISR_STUB 39
