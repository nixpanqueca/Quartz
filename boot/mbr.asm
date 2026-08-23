; MBR boot code for isohybrid USB boot.
; Loaded by BIOS at 0x7C00. Loads the El Torito boot image
; from LBA 20 and jumps to it at 0x0600.

org 0x7C00
bits 16

    jmp short start
    nop

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    mov [boot_drive], dl

    call serial_init
    mov al, 'M'
    call serial_putc

    mov eax, 80
    mov bx, 0x0600
    call read_sector
    jc .read_fail

    mov al, 'O'
    call serial_putc

    ; Mark USB boot mode for the boot code
    mov byte [0x0500], 0xAB

    jmp 0x0000:0x0600

.read_fail:
    mov al, 'F'
    call serial_putc
    cli
    hlt
    jmp .read_fail

read_sector:
    pusha
    mov dword [dap + 8], eax
    mov word  [dap + 4], bx
    mov word  [dap + 6], 0
    mov si, dap
    mov dl, [boot_drive]
    mov ah, 0x42
    int 0x13
    popa
    ret

; -------------------------
; Serial (COM1) - debug
; -------------------------
serial_init:
    push ax
    push dx
    mov dx, 0x3F9
    mov al, 0x00
    out dx, al
    mov dx, 0x3FB
    mov al, 0x80
    out dx, al
    mov dx, 0x3F8
    mov al, 0x03
    out dx, al
    mov dx, 0x3F9
    mov al, 0x00
    out dx, al
    mov dx, 0x3FB
    mov al, 0x03
    out dx, al
    pop dx
    pop ax
    ret

serial_putc:
    mov ah, al
.wait:
    mov dx, 0x3FD
    in al, dx
    test al, 0x20
    jz .wait
    mov al, ah
    mov dx, 0x3F8
    out dx, al
    ret

boot_drive: db 0

align 4
dap:
    db 16
    db 0
    dw 4
    dw 0
    dw 0
    dd 0
    dd 0

times 446 - ($ - $$) db 0

; Partition table entry 1
db 0x80             ; boot flag (active)
db 0, 1, 0          ; starting CHS (head 0, sector 1, cylinder 0)
db 0x83             ; partition type (Linux)
db 0xFF, 0xFF, 0xFF ; ending CHS
dd 1                ; starting LBA
dd 0                ; sector count (0 = max)

; Partition table entries 2-4 (empty)
times 48 db 0

times 510 - ($ - $$) db 0
dw 0xAA55
