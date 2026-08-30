; Aether Boot Loader (El Torito no-emulation, CD-ROM)
; Loaded by the BIOS at 0x0060:0000 (org 0x0600). DL = boot CD drive.
;
; Reads KERNEL.BIN from an ISO 9660 filesystem (PVD + root directory),
; loads it at 0x8000, then sets up VBE/PCI/serial/PIC/GDT and switches
; to protected mode.

org 0x0600
bits 16

    jmp short start
BootDrive: db 0
usbMode:   db 0

start:
    cli

    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, 0x9FC00
    mov sp, 0x7C00

    mov [BootDrive], dl

    ; Detect USB boot: MBR writes 0xAB to [0x0500] before jumping here.
    ; CD-ROM (El Torito) boot does not set this flag.
    mov byte [usbMode], 0
    cmp byte [0x0500], 0xAB
    jne .not_usb
    mov byte [usbMode], 0xAB
.not_usb:

    call serial_init
    mov al, 'S'
    call serial_putc

    ; ---------- ISO 9660: read the Primary Volume Descriptor ----------
    ; PVD is at logical block 16. For a no-emulation CD-ROM drive the
    ; int 13h AH=42h DAP LBA/count are already in 2048-byte blocks.
    mov eax, 16
    mov bx, 0x3000
    call read_cd
    jc cd_e1

    ; check "CD001" (strings live at CS; cmpsb uses DS:SI vs ES:DI)
    mov si, 0x3001
    push es
    mov ax, cs
    mov es, ax
    mov di, iso_sig
    mov cx, 5
    repe cmpsb
    pop es
    jne cd_e2

    mov al, 'P'
    call serial_putc

    ; Root directory record is at PVD+136; extent LBA (LE) at +138,
    ; data length (LE) at +146.
    mov eax, [0x3000 + 138]     ; root extent (2048-sector LBA)
    pushad
    mov al, 'E'
    call serial_putc
    mov ebx, eax
    call serial_print_hex32
    mov al, '|'
    call serial_putc
    xor ebx, ebx
    mov bx, word [0x3000 + 138]
    call serial_print_hex32
    popad
    mov bx, 0x3000              ; reuse buffer (root dir < 2048 bytes)
    call read_cd
    jc cd_e3

    mov al, 'R'
    call serial_putc

    ; ---------- scan root directory for KERNEL.BIN ----------
    xor bx, bx
.scan:
    xor eax, eax
    mov al, byte [0x3000 + bx]         ; directory record length
    test al, al
    jz cd_e4                           ; 0 = end of directory
    cmp byte [0x3000 + bx + 32], 11    ; name length must be >= "KERNEL.BIN;1"
    jb .next
    lea si, [0x3000 + bx + 33]
    push es
    mov ax, cs
    mov es, ax
    mov di, kernel_name
    mov cx, 10
    pusha
    repe cmpsb
    popa
    pop es
    jne .next
    cmp byte [0x3000 + bx + 43], ';'   ; name[10] must be ';'
    jne .next

    ; found: extent (LE) at +2, data length (LE) at +10
    mov eax, [0x3000 + bx + 2]
    mov edx, [0x3000 + bx + 10]
    jmp load_kernel
.next:
    add bx, ax
    jmp .scan

    ; ---------- load kernel ----------
    ; EAX = extent (2048-sector LBA), EDX = size in bytes.
    ; NOTE: read_cd clobbers EDX (mov dl, [BootDrive] sets DL=0xE0),
    ; so the sector count must live in EBP.
load_kernel:
    add edx, 2047
    shr edx, 11                     ; number of 2048-byte sectors
    mov ebp, edx
    push es
    mov bx, 0x8000
.kl:
    test ebp, ebp
    jz .kl_done
    pushad
    push eax
    mov al, '#'
    call serial_putc
    mov ebx, eax
    call serial_print_hex32
    mov al, ':'
    call serial_putc
    pop eax
    popad
    call read_cd
    jc cd_e5
    inc eax                         ; next 2048-block
    add bx, 2048
    jnc .kl_cont
    mov ax, es                      ; 64K wrap: bump segment
    add ax, 0x1000
    mov es, ax
.kl_cont:
    dec ebp
    jmp .kl
.kl_done:
    pop es

    mov al, 'K'
    call serial_putc

    ; ---------------- VBE: 640x480x32 (modo 0x112) linear framebuffer ----------------
    ; Buffers do VBE em RAM: 0x5100 (info do modo)
    mov ax, 0x0500
    mov es, ax

    ; VBE: info do modo 0x0112 (640x480x32 true color)
    mov ax, 0x4F01
    mov cx, 0x0112
    mov di, 0x0100
    int 0x10
    cmp ax, 0x004F
    jne video_error

    ; boot info em 0x1000: +0 = endereco do framebuffer (dword),
    ;                      +4 = largura, +6 = altura, +8 = bytes por linha
    mov ax, 0x0500
    mov es, ax
    mov eax, dword [es:0x0128]   ; PhysBasePtr (linear framebuffer)
    mov [0x1000], eax
    mov word [0x1004], 640
    mov word [0x1006], 480
    mov ax, word [es:0x0110]     ; BytesPerScanLine (pitch)
    test ax, ax
    jnz .pitch_ok
    mov ax, 640 * 4              ; fallback: 640 px * 4 bytes
.pitch_ok:
    mov word [0x1008], ax

    ; Se a VGA for PCI (ex: qemu -vga std), o framebuffer real fica no BAR0
    ; da placa, nao no endereco fixo reportado pelo VBE (0xE0000000).
    call pci_find_vga_lfb

    ; debug serial: endereco final do framebuffer que sera usado
    mov si, dbg_fb_msg
    call serial_print_str
    mov ebx, [0x1000]
    call serial_print_hex32
    mov si, dbg_crlf
    call serial_print_str

    ; VBE: ativa modo 0x0112 | bit 14 (linear framebuffer)
    mov ax, 0x4F02
    mov bx, 0x4112
    int 0x10
    cmp ax, 0x004F
    jne video_error

    jmp video_done

video_error:
    ; fallback: VGA 320x200x256 (framebuffer linear em 0xA0000)
    mov ax, 0x0013
    int 0x10
    mov dword [0x1000], 0xA0000
    mov word [0x1004], 320
    mov word [0x1006], 200
    mov word [0x1008], 320

video_done:

    ; mask all PIC IRQs NOW (real mode, before PM switch):
    ; the kernel has no IDT, so no interrupt may fire after this point.
    mov al, 0xFF
    out 0xA1, al   ; slave PIC (IRQ8-15)
    out 0x21, al   ; master PIC (IRQ0-7)

    ; Loads GDT
    lgdt [gdt_descriptor]

    ; Protected Mode
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    ; 32 bits code
    jmp CODE_SEG:protected_mode

cd_e1:
    mov al, '1'
    jmp cd_error
cd_e2:
    mov al, '2'
    jmp cd_error
cd_e3:
    mov al, '3'
    jmp cd_error
cd_e4:
    mov al, '4'
    jmp cd_error
cd_e5:
    mov al, '5'
    jmp cd_error

cd_error:
    call serial_putc
    cli
    hlt
    jmp cd_error

; -------------------------
; Read one 2048-byte logical block via int 13h AH=42h.
; Converts the 2048-byte LBA to 512-byte LBA (×4) and reads 4 sectors.
; in: EAX = logical block (2048 bytes), ES:BX = destination buffer
; out: CF set on error, EAX preserved
; -------------------------
read_cd:
    push eax
    cmp byte [usbMode], 0xAB
    jne .cdrom_mode
    ; USB mode: sector = 512 bytes, LBA ×4, count = 4
    shl eax, 2
    mov word [dap_cnt], 4
    jmp .do_read
.cdrom_mode:
    ; CD-ROM mode: sector = 2048 bytes, LBA as-is, count = 1
    mov word [dap_cnt], 1
.do_read:
    mov word [dap_off], bx
    mov word [dap_seg], es
    mov dword [dap_lba], eax
    mov dword [dap_lba + 4], 0
    mov si, dap
    mov dl, [BootDrive]
    mov ah, 0x42
    int 0x13
    pop eax
    ret

; -------------------------
; PCI: acha o framebuffer da VGA
; Varre o barramento 0 procurando um display controller (classe 0x03)
; e usa o BAR0. Se achar, sobrescreve o boot info em 0x1000.
; -------------------------

pci_find_vga_lfb:
    pushad
    xor di, di          ; dispositivo 0..31

.pci_loop:
    mov ebx, 0x80000000
    movzx ecx, di
    shl ecx, 11         ; (bus 0 | func 0 | reg 0) + dev << 11
    or  ebx, ecx
    mov dx, 0xCF8
    mov eax, ebx
    out dx, eax
    mov dx, 0xCFC
    in  eax, dx
    cmp eax, 0xFFFFFFFF
    je  .pci_next       ; nenhum device aqui

    ; classe base = reg 0x08, bits 31..24
    mov eax, ebx
    or  eax, 0x08
    mov dx, 0xCF8
    out dx, eax
    mov dx, 0xCFC
    in  eax, dx
    shr eax, 24
    cmp al, 0x03        ; display controller?
    jne .pci_next

    ; BAR0 = reg 0x10 (endereco do framebuffer)
    mov eax, ebx
    or  eax, 0x10
    mov dx, 0xCF8
    out dx, eax
    mov dx, 0xCFC
    in  eax, dx
    and eax, 0xFFFFFFF0
    test eax, eax
    jz  .pci_next
    mov [0x1000], eax   ; framebuffer real encontrado
    jmp .pci_done

.pci_next:
    inc di
    cmp di, 32
    jb .pci_loop

.pci_done:
    popad
    ret

; -------------------------
; Serial (COM1) - debug
; -------------------------

serial_init:
    push ax
    push dx
    mov dx, 0x3F9
    mov al, 0x00
    out dx, al          ; sem interrupcoes
    mov dx, 0x3FB
    mov al, 0x80
    out dx, al          ; DLAB = 1
    mov dx, 0x3F8
    mov al, 0x03
    out dx, al          ; divisor baixo (38400)
    mov dx, 0x3F9
    mov al, 0x00
    out dx, al          ; divisor alto
    mov dx, 0x3FB
    mov al, 0x03
    out dx, al          ; 8N1, DLAB = 0
    pop dx
    pop ax
    ret

; in: AL = caracter
serial_putc:
    mov ah, al
.serial_wait:
    mov dx, 0x3FD
    in al, dx
    test al, 0x20
    jz .serial_wait
    mov al, ah
    mov dx, 0x3F8
    out dx, al
    ret

; in: SI = string terminada em 0 (no segmento CS)
serial_print_str:
    push ax
    push si
.serial_str_loop:
    cs lodsb
    test al, al
    jz .serial_str_done
    call serial_putc
    jmp .serial_str_loop
.serial_str_done:
    pop si
    pop ax
    ret

; in: EBX = valor a imprimir (hex)
serial_print_hex32:
    mov cx, 8
.serial_hex_loop:
    rol ebx, 4
    mov al, bl
    and al, 0x0F
    add al, '0'
    cmp al, '9'
    jbe .serial_hex_digit
    add al, 7
.serial_hex_digit:
    call serial_putc
    dec cx
    jnz .serial_hex_loop
    ret

iso_sig:     db 'CD001'
kernel_name: db 'KERNEL.BIN'
dbg_fb_msg:  db 'FB=', 0
dbg_crlf:    db 13, 10, 0

; -------------------------
; GDT
; -------------------------

gdt_start:

gdt_null:
    dq 0

gdt_code:
    dw 0xffff
    dw 0x0000
    db 0x00
    db 10011010b
    db 11001111b
    db 0x00

gdt_data:
    dw 0xffff
    dw 0x0000
    db 0x00
    db 10010010b
    db 11001111b
    db 0x00

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

; -------------------------
; Disk Address Packet (int 13h AH=42h). LBA and count are in
; 512-byte logical blocks (USB). read_cd sets count=4 before each use.
; -------------------------

dap:
    db 16            ; packet size
    db 0
dap_cnt:
    dw 4             ; count = 4 × 512 = 2048 bytes
dap_off:
    dw 0
dap_seg:
    dw 0
dap_lba:
    dq 0

; -------------------------
; Protected Mode
; -------------------------

bits 32

protected_mode:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov ss, ax

    ; calls startup.asm

    jmp CODE_SEG:0x8000

hang:
    cli
    hlt
    jmp hang

; El Torito no-emulation: no 0xAA55 signature is checked and the boot
; image may exceed 512 bytes. Pad to a full 2048-byte sector.
times 2048-($-$$) db 0
