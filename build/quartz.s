	.file "quartz.pas"
# Begin asmlist al_procedures

.section .text.n_quartz_$$_outb$word$byte,"x"
	.balign 16,0x90
QUARTZ_$$_OUTB$WORD$BYTE:
# [quartz.pas]
# [38] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var Addr located at ebp-4, size=OS_16
# Var Value located at ebp-8, size=OS_8
	movw	%ax,-4(%ebp)
	movb	%dl,-8(%ebp)
#  CPU PENTIUM
# [40] mov dx, Addr
	movw	-4(%ebp),%dx
# [41] mov al, Value
	movb	-8(%ebp),%al
# [42] out dx, al
	outb	%al,%dx
#  CPU PENTIUM
# [44] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_quartz_$$_inb$word$$byte,"x"
	.balign 16,0x90
QUARTZ_$$_INB$WORD$$BYTE:
# [49] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-12(%esp),%esp
# Var Addr located at ebp-4, size=OS_16
# Var $result located at ebp-8, size=OS_8
# Var B located at ebp-12, size=OS_8
	movw	%ax,-4(%ebp)
#  CPU PENTIUM
# [51] mov dx, Addr
	movw	-4(%ebp),%dx
# [52] in al, dx
	inb	%dx,%al
# [53] mov B, al
	movb	%al,-12(%ebp)
#  CPU PENTIUM
# [55] InB := B;
	movb	-12(%ebp),%al
	movb	%al,-8(%ebp)
# [56] end;
	movb	-8(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_quartz_$$_delayms$longint,"x"
	.balign 16,0x90
QUARTZ_$$_DELAYMS$LONGINT:
# [62] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-20(%esp),%esp
	pushl	%ebx
# Var Millis located at ebp-4, size=OS_S32
# Var Rounds located at ebp-8, size=OS_S32
# Var R located at ebp-12, size=OS_S32
# Var L located at ebp-16, size=OS_8
# Var H located at ebp-20, size=OS_8
	movl	%eax,-4(%ebp)
# [63] Rounds := (Millis + 54) div 55;
	movl	-4(%ebp),%eax
	leal	54(%eax),%ecx
	movl	$156180629,%eax
	imull	%ecx
	sarl	$1,%edx
	shrl	$31,%ecx
	addl	%ecx,%edx
	movl	%edx,-8(%ebp)
# [64] if Rounds < 1 then
	cmpl	$1,-8(%ebp)
	jl	.Lj9
	jmp	.Lj10
.Lj9:
# [65] Rounds := 1;
	movl	$1,-8(%ebp)
	.balign 4,0x90
.Lj10:
# [66] for R := 0 to Rounds - 1 do
	movl	-8(%ebp),%eax
	leal	-1(%eax),%ebx
	cmpl	$0,%ebx
	jge	.Lj11
	jmp	.Lj12
.Lj11:
	movl	$-1,-12(%ebp)
	.balign 8,0x90
.Lj13:
	movl	-12(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-12(%ebp)
# [68] OutB($43, $30);             // ch0, lobyte/hibyte, mode 0 (one-shot)
	movb	$48,%dl
	movw	$67,%ax
	call	QUARTZ_$$_OUTB$WORD$BYTE
# [69] OutB($40, $FF);             // count low byte
	movb	$255,%dl
	movw	$64,%ax
	call	QUARTZ_$$_OUTB$WORD$BYTE
# [70] OutB($40, $FF);             // count high byte (0xFFFF = ~55ms)
	movb	$255,%dl
	movw	$64,%ax
	call	QUARTZ_$$_OUTB$WORD$BYTE
	.balign 8,0x90
.Lj16:
# [72] OutB($43, $00);           // latch ch0
	movb	$0,%dl
	movw	$67,%ax
	call	QUARTZ_$$_OUTB$WORD$BYTE
# [73] L := InB($40);
	movw	$64,%ax
	call	QUARTZ_$$_INB$WORD$$BYTE
	movb	%al,-16(%ebp)
# [74] H := InB($40);
	movw	$64,%ax
	call	QUARTZ_$$_INB$WORD$$BYTE
	movb	%al,-20(%ebp)
# [75] until (H = 0) and (L = 0);
	cmpb	$0,-20(%ebp)
	je	.Lj19
	jmp	.Lj20
.Lj19:
	cmpb	$0,-16(%ebp)
	je	.Lj21
	jmp	.Lj20
.Lj21:
	jmp	.Lj18
.Lj20:
	jmp	.Lj16
.Lj18:
	cmpl	-12(%ebp),%ebx
	jle	.Lj15
	jmp	.Lj13
.Lj15:
	.balign 4,0x90
.Lj12:
# [77] end;
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_quartz_$$_drawmaclogo$longint$longint,"x"
	.balign 16,0x90
QUARTZ_$$_DRAWMACLOGO$LONGINT$LONGINT:
# [82] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-16(%esp),%esp
# Var X located at ebp-4, size=OS_S32
# Var Y located at ebp-8, size=OS_S32
# Var R located at ebp-12, size=OS_S32
# Var C located at ebp-16, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
# [83] for R := 0 to 31 do
	movl	$-1,-12(%ebp)
	.balign 8,0x90
.Lj24:
	movl	-12(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-12(%ebp)
# [84] for C := 0 to 31 do
	movl	$-1,-16(%ebp)
	.balign 8,0x90
.Lj27:
	movl	-16(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-16(%ebp)
# [85] if (MacLogo[R] and (LongWord(1) shl (31 - C))) <> 0 then
	movl	-16(%ebp),%eax
	movl	$31,%ecx
	subl	%eax,%ecx
	movl	$1,%eax
	shll	%cl,%eax
	movl	-12(%ebp),%edx
	andl	TC_$QUARTZ_$$_MACLOGO(,%edx,4),%eax
	testl	$-1,%eax
	jne	.Lj30
	jmp	.Lj31
.Lj30:
# [86] PutPixel(X + C, Y + R, 0);
	movl	-8(%ebp),%eax
	movl	-12(%ebp),%edx
	leal	(%eax,%edx),%edx
	movl	-4(%ebp),%eax
	movl	-16(%ebp),%ecx
	leal	(%eax,%ecx),%eax
	movb	$0,%cl
	call	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
	.balign 4,0x90
.Lj31:
	cmpl	$31,-16(%ebp)
	jge	.Lj29
	jmp	.Lj27
.Lj29:
	cmpl	$31,-12(%ebp)
	jge	.Lj26
	jmp	.Lj24
.Lj26:
# [87] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_quartz_$$_print$pchar,"x"
	.balign 16,0x90
.globl	QUARTZ_$$_PRINT$PCHAR
QUARTZ_$$_PRINT$PCHAR:
# [92] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
	pushl	%ebx
# Var Text located at ebp-4, size=OS_32
# Var i located at ebp-8, size=OS_S32
	movl	%eax,-4(%ebp)
# [93] i := 0;
	movl	$0,-8(%ebp)
# [95] while Text[i] <> #0 do
	jmp	.Lj35
	.balign 8,0x90
.Lj34:
# [97] VideoMemory[Cursor] := Ord(Text[i]);
	movl	TC_$QUARTZ_$$_VIDEOMEMORY,%ecx
	movl	TC_$QUARTZ_$$_CURSOR,%ebx
	movl	-4(%ebp),%eax
	movl	-8(%ebp),%edx
	movb	(%eax,%edx,1),%al
	movb	%al,(%ecx,%ebx,1)
# [98] VideoMemory[Cursor + 1] := $07;
	movl	TC_$QUARTZ_$$_VIDEOMEMORY,%edx
	movl	TC_$QUARTZ_$$_CURSOR,%eax
	leal	1(%eax),%eax
	movb	$7,(%edx,%eax,1)
# [100] Cursor := Cursor + 2;
	movl	TC_$QUARTZ_$$_CURSOR,%eax
	leal	2(%eax),%eax
	movl	%eax,TC_$QUARTZ_$$_CURSOR
# [101] i := i + 1;
	movl	-8(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-8(%ebp)
.Lj35:
	movl	-4(%ebp),%eax
	movl	-8(%ebp),%edx
	cmpb	$0,(%eax,%edx,1)
	jne	.Lj34
	jmp	.Lj36
.Lj36:
# [103] end;
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_quartz_$$_kernel,"x"
	.balign 16,0x90
.globl	QUARTZ_$$_KERNEL
QUARTZ_$$_KERNEL:
.globl	_Kernel
_Kernel:
# [109] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-24(%esp),%esp
# Var CursorX located at ebp-4, size=OS_S32
# Var CursorY located at ebp-8, size=OS_S32
# Var WinX located at ebp-12, size=OS_S32
# Var WinY located at ebp-16, size=OS_S32
# Var WinW located at ebp-20, size=OS_S32
# Var WinH located at ebp-24, size=OS_S32
# [110] VideoInit;
	call	VIDEO_$$_VIDEOINIT
# [113] FillPattern8x8(MacGray, 0, $0F);
	pushl	$15
	movl	$TC_$QUARTZ_$$_MACGRAY,%eax
	movb	$0,%cl
	movl	$7,%edx
	call	VIDEO_$$_FILLPATTERN8X8$array_of_BYTE$BYTE$BYTE
# [115] WinW := RWidth div 5 * 4;
	movl	U_$VIDEO_$$_RWIDTH,%ecx
	movl	$1717986919,%eax
	imull	%ecx
	sarl	$1,%edx
	shrl	$31,%ecx
	addl	%ecx,%edx
	shll	$2,%edx
	movl	%edx,-20(%ebp)
# [116] WinH := RHeight div 4 * 2;
	movl	U_$VIDEO_$$_RHEIGHT,%edx
	movl	%edx,%eax
	sarl	$31,%eax
	andl	$3,%eax
	addl	%eax,%edx
	sarl	$2,%edx
	shll	$1,%edx
	movl	%edx,-24(%ebp)
# [117] WinX := (RWidth - WinW) div 2;
	movl	U_$VIDEO_$$_RWIDTH,%eax
	movl	-20(%ebp),%edx
	subl	%edx,%eax
	movl	%eax,%edx
	shrl	$31,%edx
	addl	%edx,%eax
	sarl	$1,%eax
	movl	%eax,-12(%ebp)
# [118] WinY := (RHeight - WinH) div 2 - 20;
	movl	U_$VIDEO_$$_RHEIGHT,%eax
	movl	-24(%ebp),%edx
	subl	%edx,%eax
	movl	%eax,%edx
	shrl	$31,%edx
	addl	%edx,%eax
	sarl	$1,%eax
	subl	$20,%eax
	movl	%eax,-16(%ebp)
# [119] FillRect(WinX, WinY, WinW, WinH, $0F);
	pushl	-24(%ebp)
	pushl	$15
	movl	-20(%ebp),%ecx
	movl	-16(%ebp),%edx
	movl	-12(%ebp),%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [121] DrawMacLogo(WinX + 35, WinY + 35);
	movl	-16(%ebp),%eax
	leal	35(%eax),%edx
	movl	-12(%ebp),%eax
	leal	35(%eax),%eax
	call	QUARTZ_$$_DRAWMACLOGO$LONGINT$LONGINT
# [124] WriteAt(WinX + (WinW - Length('Welcome to Aether') * 16) div 2,
	pushl	$16
# [125] WinY + (WinH - 16) div 2,
	movl	-24(%ebp),%eax
	leal	-16(%eax),%edx
	movl	%edx,%eax
	shrl	$31,%eax
	addl	%eax,%edx
	sarl	$1,%edx
	addl	-16(%ebp),%edx
	movl	-20(%ebp),%eax
	leal	-272(%eax),%eax
	movl	%eax,%ecx
	shrl	$31,%ecx
	addl	%ecx,%eax
	sarl	$1,%eax
	addl	-12(%ebp),%eax
# [126] 'Welcome to Aether', 16);
	movl	$_$QUARTZ$_Ld1,%ecx
	call	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
# [128] MouseInit;
	call	MOUSE_$$_MOUSEINIT
# [129] SerialInit;
	call	SERIAL_$$_SERIALINIT
# [130] SerialWriteString('fb=');
	movl	$_$QUARTZ$_Ld2,%eax
	call	SERIAL_$$_SERIALWRITESTRING$PCHAR
# [131] SerialWriteHex32(LongWord(Framebuffer));
	movl	U_$VIDEO_$$_FRAMEBUFFER,%eax
	call	SERIAL_$$_SERIALWRITEHEX32$LONGWORD
# [132] SerialWriteString(' w=');
	movl	$_$QUARTZ$_Ld3,%eax
	call	SERIAL_$$_SERIALWRITESTRING$PCHAR
# [133] SerialWriteHex32(LongWord(RWidth));
	movl	U_$VIDEO_$$_RWIDTH,%eax
	call	SERIAL_$$_SERIALWRITEHEX32$LONGWORD
# [134] SerialWriteString(' h=');
	movl	$_$QUARTZ$_Ld4,%eax
	call	SERIAL_$$_SERIALWRITESTRING$PCHAR
# [135] SerialWriteHex32(LongWord(RHeight));
	movl	U_$VIDEO_$$_RHEIGHT,%eax
	call	SERIAL_$$_SERIALWRITEHEX32$LONGWORD
# [136] SerialWriteChar(#13);
	movb	$13,%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
# [137] SerialWriteChar(#10);
	movb	$10,%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
# [139] CDSelfTest;
	call	CDROM_$$_CDSELFTEST
# [142] DelayMS(2000);
	movl	$2000,%eax
	call	QUARTZ_$$_DELAYMS$LONGINT
# [144] SeekInit;
	call	SEEK_$$_SEEKINIT
# [145] CursorX := GetMouseX;
	call	MOUSE_$$_GETMOUSEX$$LONGINT
	movl	%eax,-4(%ebp)
# [146] CursorY := GetMouseY;
	call	MOUSE_$$_GETMOUSEY$$LONGINT
	movl	%eax,-8(%ebp)
# [147] SaveCursorArea(CursorX, CursorY);
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	call	VIDEO_$$_SAVECURSORAREA$LONGINT$LONGINT
# [148] DrawCursor(CursorX, CursorY);
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	call	VIDEO_$$_DRAWCURSOR$LONGINT$LONGINT
# [150] while True do
	jmp	.Lj40
	.balign 8,0x90
.Lj39:
# [152] MousePoll;
	call	MOUSE_$$_MOUSEPOLL
# [153] if (GetMouseX <> CursorX) or (GetMouseY <> CursorY) then
	call	MOUSE_$$_GETMOUSEX$$LONGINT
	cmpl	-4(%ebp),%eax
	jne	.Lj42
	jmp	.Lj43
.Lj43:
	call	MOUSE_$$_GETMOUSEY$$LONGINT
	cmpl	-8(%ebp),%eax
	jne	.Lj42
	jmp	.Lj44
.Lj42:
# [155] RestoreCursorArea(CursorX, CursorY);
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	call	VIDEO_$$_RESTORECURSORAREA$LONGINT$LONGINT
# [156] CursorX := GetMouseX;
	call	MOUSE_$$_GETMOUSEX$$LONGINT
	movl	%eax,-4(%ebp)
# [157] CursorY := GetMouseY;
	call	MOUSE_$$_GETMOUSEY$$LONGINT
	movl	%eax,-8(%ebp)
# [158] SaveCursorArea(CursorX, CursorY);
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	call	VIDEO_$$_SAVECURSORAREA$LONGINT$LONGINT
# [159] DrawCursor(CursorX, CursorY);
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	call	VIDEO_$$_DRAWCURSOR$LONGINT$LONGINT
	.balign 4,0x90
.Lj44:
# [161] CheckButtons;
	call	BUTTONS_$$_CHECKBUTTONS
.Lj40:
	jmp	.Lj39
# [163] end;
	movl	%ebp,%esp
	popl	%ebp
	ret
# End asmlist al_procedures
# Begin asmlist al_typedconsts

.section .data.n_TC_$QUARTZ_$$_VIDEOMEMORY,"d"
	.balign 4
TC_$QUARTZ_$$_VIDEOMEMORY:
	.long	753664
# [20] Cursor: Integer = 0;

.section .data.n_TC_$QUARTZ_$$_CURSOR,"d"
	.balign 4
TC_$QUARTZ_$$_CURSOR:
	.long	0
# [22] const

.section .data.n_TC_$QUARTZ_$$_MACGRAY,"d"
TC_$QUARTZ_$$_MACGRAY:
	.byte	170,85,170,85,170,85,170,85
# [25] const

.section .data.n_TC_$QUARTZ_$$_MACLOGO,"d"
	.balign 4
TC_$QUARTZ_$$_MACLOGO:
	.long	1476394965,-1,-134217665,-503316721,-469762161,-536870897,-536870897,-535752689
	.long	-535752689,-536805361,-536805361,-536674289,-536870897,-536330225,-536379377,-536870897
	.long	-536870897,-469762161,-503316721,-536870897,-536870897,-536870897,-486523121,-486523121
	.long	-536870897,-536870897,-536870897,-1,-134217761,-268435425,-268435425,-134217761
# [37] procedure OutB(Addr: Word; Value: Byte);

.section .rodata.n__$QUARTZ$_Ld1,"d"
	.balign 4
.globl	_$QUARTZ$_Ld1
_$QUARTZ$_Ld1:
	.ascii	"Welcome to Aether\000"

.section .rodata.n__$QUARTZ$_Ld2,"d"
	.balign 4
.globl	_$QUARTZ$_Ld2
_$QUARTZ$_Ld2:
	.ascii	"fb=\000"

.section .rodata.n__$QUARTZ$_Ld3,"d"
	.balign 4
.globl	_$QUARTZ$_Ld3
_$QUARTZ$_Ld3:
	.ascii	" w=\000"

.section .rodata.n__$QUARTZ$_Ld4,"d"
	.balign 4
.globl	_$QUARTZ$_Ld4
_$QUARTZ$_Ld4:
	.ascii	" h=\000"
# End asmlist al_typedconsts

