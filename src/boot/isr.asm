; Cubic System Software - ISR Stubs + Thread Context Switch
;
; Exceptions 0-31 land on isr_exc_common, which hands the register frame to
; exception_handler() in C. That function panics and halts, so nothing after the
; call ever runs.
;
; IRQ0 and IRQ1 do real work and come back, which is why they are spelled out
; one by one instead of going through the macro.

[bits 32]

extern thread_scheduler
extern keyboard_irq
extern timer_tick
extern exception_handler

section .text

; ---- IRQ0: PIT timer. Ticks, drives auto-repeat, then maybe switches thread.
global isr32
isr32:
    pusha
    mov al, 0x20
    out 0x20, al                 ; acknowledge on the master PIC
    mov eax, esp                 ; the context we would return to
    push eax
    call timer_tick              ; returns the ESP to run next
    add esp, 4
    mov esp, eax                 ; switch stacks (no-op when it is ours)
    popa
    iret

; ---- IRQ1: keyboard
global isr33
isr33:
    pusha
    call keyboard_irq
    mov al, 0x20
    out 0x20, al
    popa
    iret

; ---- Exceptions ----

; The CPU pushes an error code for some vectors and nothing for the others.
; Both cases are normalised here: vector first, then a code that is 0 when the
; CPU did not supply one.
%macro ISR_STUB 1
global isr%1
isr%1:
    push dword 0
    push dword %1
    jmp isr_exc_common
%endmacro

; Vectors the CPU already pushed an error code for: discard it first so both
; shapes end up identical.
%macro ISR_STUB_ERR 1
global isr%1
isr%1:
    push dword %1
    jmp isr_exc_common
%endmacro

isr_exc_common:
    pusha
    push esp
    call exception_handler
    add esp, 4
    popa
    add esp, 8                  ; step over the vector and the error code
    iret

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
ISR_STUB 16
ISR_STUB_ERR 17
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