	.file "openfirmware.pas"
# Begin asmlist al_procedures

.section .text.n_openfirmware_$$_outb$word$byte,"x"
	.balign 16,0x90
.globl	OPENFIRMWARE_$$_OUTB$WORD$BYTE
OPENFIRMWARE_$$_OUTB$WORD$BYTE:
# [openfirmware.pas]
# [26] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var Addr located at ebp-4, size=OS_16
# Var Value located at ebp-8, size=OS_8
	movw	%ax,-4(%ebp)
	movb	%dl,-8(%ebp)
#  CPU PENTIUM
# [28] mov dx, Addr
	movw	-4(%ebp),%dx
# [29] mov al, Value
	movb	-8(%ebp),%al
# [30] out dx, al
	outb	%al,%dx
#  CPU PENTIUM
# [32] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_openfirmware_$$_inb$word$$byte,"x"
	.balign 16,0x90
.globl	OPENFIRMWARE_$$_INB$WORD$$BYTE
OPENFIRMWARE_$$_INB$WORD$$BYTE:
# [37] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-12(%esp),%esp
# Var Addr located at ebp-4, size=OS_16
# Var $result located at ebp-8, size=OS_8
# Var B located at ebp-12, size=OS_8
	movw	%ax,-4(%ebp)
#  CPU PENTIUM
# [39] mov dx, Addr
	movw	-4(%ebp),%dx
# [40] in al, dx
	inb	%dx,%al
# [41] mov B, al
	movb	%al,-12(%ebp)
#  CPU PENTIUM
# [43] InB := B;
	movb	-12(%ebp),%al
	movb	%al,-8(%ebp)
# [44] end;
	movb	-8(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_openfirmware_$$_delayms$longint,"x"
	.balign 16,0x90
.globl	OPENFIRMWARE_$$_DELAYMS$LONGINT
OPENFIRMWARE_$$_DELAYMS$LONGINT:
# [50] begin
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
# [51] Rounds := (Millis + 54) div 55;
	movl	-4(%ebp),%eax
	leal	54(%eax),%ecx
	movl	$156180629,%eax
	imull	%ecx
	sarl	$1,%edx
	shrl	$31,%ecx
	addl	%ecx,%edx
	movl	%edx,-8(%ebp)
# [52] if Rounds < 1 then
	cmpl	$1,-8(%ebp)
	jl	.Lj9
	jmp	.Lj10
.Lj9:
# [53] Rounds := 1;
	movl	$1,-8(%ebp)
	.balign 4,0x90
.Lj10:
# [54] for R := 0 to Rounds - 1 do
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
# [56] OutB($43, $30);
	movb	$48,%dl
	movw	$67,%ax
	call	OPENFIRMWARE_$$_OUTB$WORD$BYTE
# [57] OutB($40, $FF);
	movb	$255,%dl
	movw	$64,%ax
	call	OPENFIRMWARE_$$_OUTB$WORD$BYTE
# [58] OutB($40, $FF);
	movb	$255,%dl
	movw	$64,%ax
	call	OPENFIRMWARE_$$_OUTB$WORD$BYTE
	.balign 8,0x90
.Lj16:
# [60] OutB($43, $00);
	movb	$0,%dl
	movw	$67,%ax
	call	OPENFIRMWARE_$$_OUTB$WORD$BYTE
# [61] L := InB($40);
	movw	$64,%ax
	call	OPENFIRMWARE_$$_INB$WORD$$BYTE
	movb	%al,-16(%ebp)
# [62] H := InB($40);
	movw	$64,%ax
	call	OPENFIRMWARE_$$_INB$WORD$$BYTE
	movb	%al,-20(%ebp)
# [63] until (H = 0) and (L = 0);
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
# [65] end;
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_openfirmware_$$_ofinit,"x"
	.balign 16,0x90
.globl	OPENFIRMWARE_$$_OFINIT
OPENFIRMWARE_$$_OFINIT:
# [71] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-16(%esp),%esp
# Var CX located at ebp-4, size=OS_S32
# Var CY located at ebp-8, size=OS_S32
# Var PrevShellKey located at ebp-12, size=OS_8
# Var OpenShellKey located at ebp-16, size=OS_8
# [72] CX := (RWidth - 32) div 2;
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-32(%eax),%eax
	movl	%eax,%edx
	shrl	$31,%edx
	addl	%edx,%eax
	sarl	$1,%eax
	movl	%eax,-4(%ebp)
# [73] CY := (RHeight - 32) div 2;
	movl	U_$VIDEO_$$_RHEIGHT,%eax
	leal	-32(%eax),%eax
	movl	%eax,%edx
	shrl	$31,%edx
	addl	%edx,%eax
	sarl	$1,%eax
	movl	%eax,-8(%ebp)
# [74] DrawBMP('SYSTEM\COMPILED\PRISM\BITMAP\FLOPPY.BMP', CX, CY);
	movl	-8(%ebp),%ecx
	movl	-4(%ebp),%edx
	movl	$_$OPENFIRMWARE$_Ld1,%eax
	call	VIDEO_$$_DRAWBMP$PCHAR$LONGINT$LONGINT
# [75] DelayMS(400);
	movl	$400,%eax
	call	OPENFIRMWARE_$$_DELAYMS$LONGINT
# [76] DrawBMP('SYSTEM\COMPILED\PRISM\BITMAP\FLOPPY@2.BMP', CX, CY);
	movl	-8(%ebp),%ecx
	movl	-4(%ebp),%edx
	movl	$_$OPENFIRMWARE$_Ld2,%eax
	call	VIDEO_$$_DRAWBMP$PCHAR$LONGINT$LONGINT
# [77] DelayMS(400);
	movl	$400,%eax
	call	OPENFIRMWARE_$$_DELAYMS$LONGINT
# [78] DrawBMP('SYSTEM\COMPILED\PRISM\BITMAP\FLOPPY.BMP', CX, CY);
	movl	-8(%ebp),%ecx
	movl	-4(%ebp),%edx
	movl	$_$OPENFIRMWARE$_Ld1,%eax
	call	VIDEO_$$_DRAWBMP$PCHAR$LONGINT$LONGINT
# [79] DelayMS(400);
	movl	$400,%eax
	call	OPENFIRMWARE_$$_DELAYMS$LONGINT
# [80] DrawBMP('SYSTEM\COMPILED\PRISM\BITMAP\FLOPPY@2.BMP', CX, CY);
	movl	-8(%ebp),%ecx
	movl	-4(%ebp),%edx
	movl	$_$OPENFIRMWARE$_Ld2,%eax
	call	VIDEO_$$_DRAWBMP$PCHAR$LONGINT$LONGINT
# [81] DelayMS(400);
	movl	$400,%eax
	call	OPENFIRMWARE_$$_DELAYMS$LONGINT
# [82] DrawBMP('SYSTEM\COMPILED\PRISM\BITMAP\FLOPPY.BMP', CX, CY);
	movl	-8(%ebp),%ecx
	movl	-4(%ebp),%edx
	movl	$_$OPENFIRMWARE$_Ld1,%eax
	call	VIDEO_$$_DRAWBMP$PCHAR$LONGINT$LONGINT
# [83] DelayMS(400);
	movl	$400,%eax
	call	OPENFIRMWARE_$$_DELAYMS$LONGINT
# [84] DrawBMP('SYSTEM\COMPILED\PRISM\BITMAP\FLOPPY@2.BMP', CX, CY);
	movl	-8(%ebp),%ecx
	movl	-4(%ebp),%edx
	movl	$_$OPENFIRMWARE$_Ld2,%eax
	call	VIDEO_$$_DRAWBMP$PCHAR$LONGINT$LONGINT
# [85] DelayMS(400);
	movl	$400,%eax
	call	OPENFIRMWARE_$$_DELAYMS$LONGINT
# [86] DrawBMP('SYSTEM\COMPILED\PRISM\BITMAP\FLOPPY.BMP', CX, CY);
	movl	-8(%ebp),%ecx
	movl	-4(%ebp),%edx
	movl	$_$OPENFIRMWARE$_Ld1,%eax
	call	VIDEO_$$_DRAWBMP$PCHAR$LONGINT$LONGINT
# [87] DelayMS(400);
	movl	$400,%eax
	call	OPENFIRMWARE_$$_DELAYMS$LONGINT
# [88] DrawBMP('SYSTEM\COMPILED\PRISM\BITMAP\FLOPPY@2.BMP', CX, CY);
	movl	-8(%ebp),%ecx
	movl	-4(%ebp),%edx
	movl	$_$OPENFIRMWARE$_Ld2,%eax
	call	VIDEO_$$_DRAWBMP$PCHAR$LONGINT$LONGINT
# [89] DelayMS(400);
	movl	$400,%eax
	call	OPENFIRMWARE_$$_DELAYMS$LONGINT
# [90] KeyboardPoll;
	call	KEYBOARD_$$_KEYBOARDPOLL
# [92] OpenShellKey := (SpecialKeyIsPressed(SCAN_LALT) and KeyIsPressed('o') and KeyIsPressed('f'))
	movb	$56,%al
	call	KEYBOARD_$$_SPECIALKEYISPRESSED$BYTE$$BOOLEAN
	testb	%al,%al
	jne	.Lj24
	jmp	.Lj25
.Lj24:
	movb	$111,%al
	call	KEYBOARD_$$_KEYISPRESSED$CHAR$$BOOLEAN
	testb	%al,%al
	jne	.Lj26
	jmp	.Lj25
.Lj26:
	movb	$102,%al
	call	KEYBOARD_$$_KEYISPRESSED$CHAR$$BOOLEAN
	testb	%al,%al
	jne	.Lj27
	jmp	.Lj25
.Lj25:
# [93] or SpecialKeyIsPressed(SCAN_F9);
	movb	$67,%al
	call	KEYBOARD_$$_SPECIALKEYISPRESSED$BYTE$$BOOLEAN
	testb	%al,%al
	jne	.Lj27
	jmp	.Lj28
.Lj27:
	movb	$1,-16(%ebp)
	jmp	.Lj29
.Lj28:
	movb	$0,-16(%ebp)
.Lj29:
# [94] if KeyIsPressed('o') and KeyIsPressed('f') then
	movb	$111,%al
	call	KEYBOARD_$$_KEYISPRESSED$CHAR$$BOOLEAN
	testb	%al,%al
	jne	.Lj30
	jmp	.Lj31
.Lj30:
	movb	$102,%al
	call	KEYBOARD_$$_KEYISPRESSED$CHAR$$BOOLEAN
	testb	%al,%al
	jne	.Lj32
	jmp	.Lj31
.Lj32:
# [96] ShellLoop;
	call	OPENSHELL_$$_SHELLLOOP
# [97] ClearScreen($0F);
	movb	$15,%al
	call	VIDEO_$$_CLEARSCREEN$BYTE
	.balign 4,0x90
.Lj31:
# [99] PrevShellKey := OpenShellKey;
	movb	-16(%ebp),%al
	movb	%al,-12(%ebp)
# [100] end;
	movl	%ebp,%esp
	popl	%ebp
	ret
# End asmlist al_procedures
# Begin asmlist al_globals

.section .bss
	.balign 4
# [15] Placeholder: Integer;
	.globl U_$OPENFIRMWARE_$$_PLACEHOLDER
U_$OPENFIRMWARE_$$_PLACEHOLDER:
	.zero 4
# End asmlist al_globals
# Begin asmlist al_typedconsts

.section .data.n_TC_$OPENFIRMWARE_$$_MACGRAY,"d"
TC_$OPENFIRMWARE_$$_MACGRAY:
	.byte	170,85,170,85,170,85,170,85
# [25] procedure OutB(Addr: Word; Value: Byte);

.section .rodata.n__$OPENFIRMWARE$_Ld1,"d"
	.balign 4
.globl	_$OPENFIRMWARE$_Ld1
_$OPENFIRMWARE$_Ld1:
	.ascii	"SYSTEM\\COMPILED\\PRISM\\BITMAP\\FLOPPY.BMP\000"

.section .rodata.n__$OPENFIRMWARE$_Ld2,"d"
	.balign 4
.globl	_$OPENFIRMWARE$_Ld2
_$OPENFIRMWARE$_Ld2:
	.ascii	"SYSTEM\\COMPILED\\PRISM\\BITMAP\\FLOPPY@2.BMP\000"
# End asmlist al_typedconsts

