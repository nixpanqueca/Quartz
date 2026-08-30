	.file "quartz.pas"
# Begin asmlist al_procedures

.section .text.n_quartz_$$_drawmaclogo$longint$longint,"x"
	.balign 16,0x90
QUARTZ_$$_DRAWMACLOGO$LONGINT$LONGINT:
# [quartz.pas]
# [40] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-16(%esp),%esp
# Var X located at ebp-4, size=OS_S32
# Var Y located at ebp-8, size=OS_S32
# Var R located at ebp-12, size=OS_S32
# Var C located at ebp-16, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
# [41] for R := 0 to 31 do
	movl	$-1,-12(%ebp)
	.balign 8,0x90
.Lj5:
	movl	-12(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-12(%ebp)
# [42] for C := 0 to 31 do
	movl	$-1,-16(%ebp)
	.balign 8,0x90
.Lj8:
	movl	-16(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-16(%ebp)
# [43] if (MacLogo[R] and (LongWord(1) shl (31 - C))) <> 0 then
	movl	-16(%ebp),%eax
	movl	$31,%ecx
	subl	%eax,%ecx
	movl	$1,%eax
	shll	%cl,%eax
	movl	-12(%ebp),%edx
	andl	TC_$QUARTZ_$$_MACLOGO(,%edx,4),%eax
	testl	$-1,%eax
	jne	.Lj11
	jmp	.Lj12
.Lj11:
# [44] PutPixel(X + C, Y + R, 0);
	movl	-8(%ebp),%eax
	movl	-12(%ebp),%edx
	leal	(%eax,%edx),%edx
	movl	-4(%ebp),%eax
	movl	-16(%ebp),%ecx
	leal	(%eax,%ecx),%eax
	movb	$0,%cl
	call	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
	.balign 4,0x90
.Lj12:
	cmpl	$31,-16(%ebp)
	jge	.Lj10
	jmp	.Lj8
.Lj10:
	cmpl	$31,-12(%ebp)
	jge	.Lj7
	jmp	.Lj5
.Lj7:
# [45] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_quartz_$$_print$pchar,"x"
	.balign 16,0x90
.globl	QUARTZ_$$_PRINT$PCHAR
QUARTZ_$$_PRINT$PCHAR:
# [50] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
	pushl	%ebx
# Var Text located at ebp-4, size=OS_32
# Var i located at ebp-8, size=OS_S32
	movl	%eax,-4(%ebp)
# [51] i := 0;
	movl	$0,-8(%ebp)
# [53] while Text[i] <> #0 do
	jmp	.Lj16
	.balign 8,0x90
.Lj15:
# [55] VideoMemory[Cursor] := Ord(Text[i]);
	movl	TC_$QUARTZ_$$_VIDEOMEMORY,%ecx
	movl	TC_$QUARTZ_$$_CURSOR,%ebx
	movl	-4(%ebp),%eax
	movl	-8(%ebp),%edx
	movb	(%eax,%edx,1),%al
	movb	%al,(%ecx,%ebx,1)
# [56] VideoMemory[Cursor + 1] := $07;
	movl	TC_$QUARTZ_$$_VIDEOMEMORY,%edx
	movl	TC_$QUARTZ_$$_CURSOR,%eax
	leal	1(%eax),%eax
	movb	$7,(%edx,%eax,1)
# [58] Cursor := Cursor + 2;
	movl	TC_$QUARTZ_$$_CURSOR,%eax
	leal	2(%eax),%eax
	movl	%eax,TC_$QUARTZ_$$_CURSOR
# [59] i := i + 1;
	movl	-8(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-8(%ebp)
.Lj16:
	movl	-4(%ebp),%eax
	movl	-8(%ebp),%edx
	cmpb	$0,(%eax,%edx,1)
	jne	.Lj15
	jmp	.Lj17
.Lj17:
# [61] end;
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
# [67] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-24(%esp),%esp
# Var CursorX located at ebp-4, size=OS_S32
# Var CursorY located at ebp-8, size=OS_S32
# Var WinX located at ebp-12, size=OS_S32
# Var WinY located at ebp-16, size=OS_S32
# Var WinW located at ebp-20, size=OS_S32
# Var WinH located at ebp-24, size=OS_S32
# [68] VideoInit;
	call	VIDEO_$$_VIDEOINIT
# [70] FillPattern8x8(MacGray, 0, $0F);
	pushl	$15
	movl	$TC_$QUARTZ_$$_MACGRAY,%eax
	movb	$0,%cl
	movl	$7,%edx
	call	VIDEO_$$_FILLPATTERN8X8$array_of_BYTE$BYTE$BYTE
# [72] CDSelfTest;
	call	CDROM_$$_CDSELFTEST
# [74] MouseInit;
	call	MOUSE_$$_MOUSEINIT
# [75] KeyboardInit;
	call	KEYBOARD_$$_KEYBOARDINIT
# [76] SerialInit;
	call	SERIAL_$$_SERIALINIT
# [77] SerialWriteString('fb=');
	movl	$_$QUARTZ$_Ld1,%eax
	call	SERIAL_$$_SERIALWRITESTRING$PCHAR
# [78] SerialWriteHex32(LongWord(Framebuffer));
	movl	U_$VIDEO_$$_FRAMEBUFFER,%eax
	call	SERIAL_$$_SERIALWRITEHEX32$LONGWORD
# [79] SerialWriteString(' w=');
	movl	$_$QUARTZ$_Ld2,%eax
	call	SERIAL_$$_SERIALWRITESTRING$PCHAR
# [80] SerialWriteHex32(LongWord(RWidth));
	movl	U_$VIDEO_$$_RWIDTH,%eax
	call	SERIAL_$$_SERIALWRITEHEX32$LONGWORD
# [81] SerialWriteString(' h=');
	movl	$_$QUARTZ$_Ld3,%eax
	call	SERIAL_$$_SERIALWRITESTRING$PCHAR
# [82] SerialWriteHex32(LongWord(RHeight));
	movl	U_$VIDEO_$$_RHEIGHT,%eax
	call	SERIAL_$$_SERIALWRITEHEX32$LONGWORD
# [83] SerialWriteChar(#13);
	movb	$13,%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
# [84] SerialWriteChar(#10);
	movb	$10,%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
# [86] ProgramSvcInit;
	call	SVC_$$_PROGRAMSVCINIT
# [88] OFinit;
	call	OPENFIRMWARE_$$_OFINIT
# [90] ClearScreen($0F);
	movb	$15,%al
	call	VIDEO_$$_CLEARSCREEN$BYTE
# [91] FillPattern8x8(MacGray, 0, $0F);
	pushl	$15
	movl	$TC_$QUARTZ_$$_MACGRAY,%eax
	movb	$0,%cl
	movl	$7,%edx
	call	VIDEO_$$_FILLPATTERN8X8$array_of_BYTE$BYTE$BYTE
# [92] WinW := RWidth div 5 * 4;
	movl	U_$VIDEO_$$_RWIDTH,%ecx
	movl	$1717986919,%eax
	imull	%ecx
	sarl	$1,%edx
	shrl	$31,%ecx
	addl	%ecx,%edx
	shll	$2,%edx
	movl	%edx,-20(%ebp)
# [93] WinH := RHeight div 4 * 2;
	movl	U_$VIDEO_$$_RHEIGHT,%edx
	movl	%edx,%eax
	sarl	$31,%eax
	andl	$3,%eax
	addl	%eax,%edx
	sarl	$2,%edx
	shll	$1,%edx
	movl	%edx,-24(%ebp)
# [94] WinX := (RWidth - WinW) div 2;
	movl	U_$VIDEO_$$_RWIDTH,%eax
	movl	-20(%ebp),%edx
	subl	%edx,%eax
	movl	%eax,%edx
	shrl	$31,%edx
	addl	%edx,%eax
	sarl	$1,%eax
	movl	%eax,-12(%ebp)
# [95] WinY := (RHeight - WinH) div 2 - 20;
	movl	U_$VIDEO_$$_RHEIGHT,%eax
	movl	-24(%ebp),%edx
	subl	%edx,%eax
	movl	%eax,%edx
	shrl	$31,%edx
	addl	%edx,%eax
	sarl	$1,%eax
	subl	$20,%eax
	movl	%eax,-16(%ebp)
# [96] FillRect(WinX, WinY, WinW, WinH, $0F);
	pushl	-24(%ebp)
	pushl	$15
	movl	-20(%ebp),%ecx
	movl	-16(%ebp),%edx
	movl	-12(%ebp),%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [97] FillRect(WinX+4, WinY+4, WinW-8, WinH-8, 0);
	movl	-24(%ebp),%eax
	leal	-8(%eax),%eax
	pushl	%eax
	pushl	$0
	movl	-20(%ebp),%eax
	leal	-8(%eax),%ecx
	movl	-16(%ebp),%eax
	leal	4(%eax),%edx
	movl	-12(%ebp),%eax
	leal	4(%eax),%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [98] FillRect(WinX+6, WinY+6, WinW-12, WinH-12, $0F);
	movl	-24(%ebp),%eax
	leal	-12(%eax),%eax
	pushl	%eax
	pushl	$15
	movl	-20(%ebp),%eax
	leal	-12(%eax),%ecx
	movl	-16(%ebp),%eax
	leal	6(%eax),%edx
	movl	-12(%ebp),%eax
	leal	6(%eax),%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [99] WriteAt(WinX + (WinW - Length('Welcome to Aether') * 12) div 2,
	pushl	$16
# [100] WinY + (WinH - 16) div 3,
	movl	-24(%ebp),%eax
	leal	-16(%eax),%ecx
	movl	$1431655766,%eax
	imull	%ecx
	shrl	$31,%ecx
	addl	%ecx,%edx
	addl	-16(%ebp),%edx
	movl	-20(%ebp),%eax
	leal	-204(%eax),%eax
	movl	%eax,%ecx
	shrl	$31,%ecx
	addl	%ecx,%eax
	sarl	$1,%eax
	addl	-12(%ebp),%eax
# [101] 'Welcome to Aether', 16);
	movl	$_$QUARTZ$_Ld4,%ecx
	call	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
# [102] DrawBMP('SYSTEM\COMPILED\PRISM\BITMAP\FACE@2X.BMP', WinX + 35, WinY + 35);
	movl	-16(%ebp),%eax
	leal	35(%eax),%ecx
	movl	-12(%ebp),%eax
	leal	35(%eax),%edx
	movl	$_$QUARTZ$_Ld5,%eax
	call	VIDEO_$$_DRAWBMP$PCHAR$LONGINT$LONGINT
# [103] DelayMS(2000);
	movl	$2000,%eax
	call	OPENFIRMWARE_$$_DELAYMS$LONGINT
# [105] ClearScreen($0F);
	movb	$15,%al
	call	VIDEO_$$_CLEARSCREEN$BYTE
# [106] FillPattern8x8(MacGray, 0, $0F);
	pushl	$15
	movl	$TC_$QUARTZ_$$_MACGRAY,%eax
	movb	$0,%cl
	movl	$7,%edx
	call	VIDEO_$$_FILLPATTERN8X8$array_of_BYTE$BYTE$BYTE
# [107] DelayMS(100);
	movl	$100,%eax
	call	OPENFIRMWARE_$$_DELAYMS$LONGINT
# [108] PrismInit;
	call	PRISM_$$_PRISMINIT
# [109] CursorX := GetMouseX;
	call	MOUSE_$$_GETMOUSEX$$LONGINT
	movl	%eax,-4(%ebp)
# [110] CursorY := GetMouseY;
	call	MOUSE_$$_GETMOUSEY$$LONGINT
	movl	%eax,-8(%ebp)
# [111] SaveCursorArea(CursorX, CursorY);
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	call	VIDEO_$$_SAVECURSORAREA$LONGINT$LONGINT
# [112] DrawCursor(CursorX, CursorY);
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	call	VIDEO_$$_DRAWCURSOR$LONGINT$LONGINT
# [114] while True do
	jmp	.Lj21
	.balign 8,0x90
.Lj20:
# [116] MousePoll;
	call	MOUSE_$$_MOUSEPOLL
# [117] KeyboardPoll;
	call	KEYBOARD_$$_KEYBOARDPOLL
# [118] if (GetMouseX <> CursorX) or (GetMouseY <> CursorY) then
	call	MOUSE_$$_GETMOUSEX$$LONGINT
	cmpl	-4(%ebp),%eax
	jne	.Lj23
	jmp	.Lj24
.Lj24:
	call	MOUSE_$$_GETMOUSEY$$LONGINT
	cmpl	-8(%ebp),%eax
	jne	.Lj23
	jmp	.Lj25
.Lj23:
# [120] RestoreCursorArea(CursorX, CursorY);
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	call	VIDEO_$$_RESTORECURSORAREA$LONGINT$LONGINT
# [121] CursorX := GetMouseX;
	call	MOUSE_$$_GETMOUSEX$$LONGINT
	movl	%eax,-4(%ebp)
# [122] CursorY := GetMouseY;
	call	MOUSE_$$_GETMOUSEY$$LONGINT
	movl	%eax,-8(%ebp)
# [123] SaveCursorArea(CursorX, CursorY);
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	call	VIDEO_$$_SAVECURSORAREA$LONGINT$LONGINT
# [124] DrawCursor(CursorX, CursorY);
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	call	VIDEO_$$_DRAWCURSOR$LONGINT$LONGINT
	.balign 4,0x90
.Lj25:
# [126] CheckButtons;
	call	BUTTONS_$$_CHECKBUTTONS
# [127] if GetOutsideClick then
	call	BUTTONS_$$_GETOUTSIDECLICK$$BOOLEAN
	testb	%al,%al
	jne	.Lj26
	jmp	.Lj27
.Lj26:
# [128] ClearShortcutSelection;
	call	PRISM_$$_CLEARSHORTCUTSELECTION
	.balign 4,0x90
.Lj27:
.Lj21:
	jmp	.Lj20
# [130] end;
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
# [37] procedure DrawMacLogo(X, Y: Integer);

.section .rodata.n__$QUARTZ$_Ld1,"d"
	.balign 4
.globl	_$QUARTZ$_Ld1
_$QUARTZ$_Ld1:
	.ascii	"fb=\000"

.section .rodata.n__$QUARTZ$_Ld2,"d"
	.balign 4
.globl	_$QUARTZ$_Ld2
_$QUARTZ$_Ld2:
	.ascii	" w=\000"

.section .rodata.n__$QUARTZ$_Ld3,"d"
	.balign 4
.globl	_$QUARTZ$_Ld3
_$QUARTZ$_Ld3:
	.ascii	" h=\000"

.section .rodata.n__$QUARTZ$_Ld4,"d"
	.balign 4
.globl	_$QUARTZ$_Ld4
_$QUARTZ$_Ld4:
	.ascii	"Welcome to Aether\000"

.section .rodata.n__$QUARTZ$_Ld5,"d"
	.balign 4
.globl	_$QUARTZ$_Ld5
_$QUARTZ$_Ld5:
	.ascii	"SYSTEM\\COMPILED\\PRISM\\BITMAP\\FACE@2X.BMP\000"
# End asmlist al_typedconsts

