	.file "keyboard.pas"
# Begin asmlist al_procedures

.section .text.n_keyboard_$$_outb$word$byte,"x"
	.balign 16,0x90
KEYBOARD_$$_OUTB$WORD$BYTE:
# [keyboard.pas]
# [53] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var Addr located at ebp-4, size=OS_16
# Var Value located at ebp-8, size=OS_8
	movw	%ax,-4(%ebp)
	movb	%dl,-8(%ebp)
#  CPU PENTIUM
# [55] mov dx, Addr
	movw	-4(%ebp),%dx
# [56] mov al, Value
	movb	-8(%ebp),%al
# [57] out dx, al
	outb	%al,%dx
#  CPU PENTIUM
# [59] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_keyboard_$$_inb$word$$byte,"x"
	.balign 16,0x90
KEYBOARD_$$_INB$WORD$$BYTE:
# [64] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-12(%esp),%esp
# Var Addr located at ebp-4, size=OS_16
# Var $result located at ebp-8, size=OS_8
# Var B located at ebp-12, size=OS_8
	movw	%ax,-4(%ebp)
#  CPU PENTIUM
# [66] mov dx, Addr
	movw	-4(%ebp),%dx
# [67] in al, dx
	inb	%dx,%al
# [68] mov B, al
	movb	%al,-12(%ebp)
#  CPU PENTIUM
# [70] InB := B;
	movb	-12(%ebp),%al
	movb	%al,-8(%ebp)
# [71] end;
	movb	-8(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_keyboard_$$_keyboardinit,"x"
	.balign 16,0x90
.globl	KEYBOARD_$$_KEYBOARDINIT
KEYBOARD_$$_KEYBOARDINIT:
# [80] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-4(%esp),%esp
# Var i located at ebp-4, size=OS_S32
# [81] for i := 0 to 127 do
	movl	$-1,-4(%ebp)
	.balign 8,0x90
.Lj9:
	movl	-4(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-4(%ebp)
# [83] KeyState[i] := False;
	movl	-4(%ebp),%eax
	movb	$0,U_$KEYBOARD_$$_KEYSTATE(,%eax,1)
# [84] SpecialState[i] := False;
	movl	-4(%ebp),%eax
	movb	$0,U_$KEYBOARD_$$_SPECIALSTATE(,%eax,1)
	cmpl	$127,-4(%ebp)
	jge	.Lj11
	jmp	.Lj9
.Lj11:
# [86] while (InB($64) and 1) <> 0 do InB($60);
	jmp	.Lj13
	.balign 8,0x90
.Lj12:
	movw	$96,%ax
	call	KEYBOARD_$$_INB$WORD$$BYTE
.Lj13:
	movw	$100,%ax
	call	KEYBOARD_$$_INB$WORD$$BYTE
	movzbw	%al,%ax
	andw	$1,%ax
	testw	$-1,%ax
	jne	.Lj12
	jmp	.Lj14
.Lj14:
# [87] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_keyboard_$$_keyboardpoll,"x"
	.balign 16,0x90
.globl	KEYBOARD_$$_KEYBOARDPOLL
KEYBOARD_$$_KEYBOARDPOLL:
# [93] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var Sc located at ebp-4, size=OS_8
# Var IsBreak located at ebp-8, size=OS_8
# [94] while (InB($64) and 1) <> 0 do
	jmp	.Lj18
	.balign 8,0x90
.Lj17:
# [96] Sc := InB($60);
	movw	$96,%ax
	call	KEYBOARD_$$_INB$WORD$$BYTE
	movb	%al,-4(%ebp)
# [97] if Sc = $E0 then
	cmpb	$224,-4(%ebp)
	je	.Lj20
	jmp	.Lj21
.Lj20:
# [99] while (InB($64) and 1) = 0 do ;
	jmp	.Lj23
	.balign 8,0x90
.Lj22:
.Lj23:
	movw	$100,%ax
	call	KEYBOARD_$$_INB$WORD$$BYTE
	movzbw	%al,%ax
	andw	$1,%ax
	testw	$-1,%ax
	je	.Lj22
	jmp	.Lj24
.Lj24:
# [100] Sc := InB($60);
	movw	$96,%ax
	call	KEYBOARD_$$_INB$WORD$$BYTE
	movb	%al,-4(%ebp)
# [101] IsBreak := (Sc and $80) <> 0;
	movb	-4(%ebp),%al
	andb	$128,%al
	testb	$-1,%al
	setneb	-8(%ebp)
# [102] if IsBreak then
	cmpb	$0,-8(%ebp)
	jne	.Lj25
	jmp	.Lj26
.Lj25:
# [103] Sc := Sc and $7F;
	movzbw	-4(%ebp),%ax
	andw	$127,%ax
	movb	%al,-4(%ebp)
	.balign 4,0x90
.Lj26:
# [104] SpecialState[Sc] := not IsBreak;
	movzbl	-4(%ebp),%eax
	cmpb	$0,-8(%ebp)
	seteb	U_$KEYBOARD_$$_SPECIALSTATE(,%eax,1)
	jmp	.Lj27
.Lj21:
# [106] else if Sc = $E1 then
	cmpb	$225,-4(%ebp)
	je	.Lj28
	jmp	.Lj29
.Lj28:
# [108] while (InB($64) and 1) <> 0 do InB($60);
	jmp	.Lj31
	.balign 8,0x90
.Lj30:
	movw	$96,%ax
	call	KEYBOARD_$$_INB$WORD$$BYTE
.Lj31:
	movw	$100,%ax
	call	KEYBOARD_$$_INB$WORD$$BYTE
	movzbw	%al,%ax
	andw	$1,%ax
	testw	$-1,%ax
	jne	.Lj30
	jmp	.Lj32
.Lj32:
	jmp	.Lj33
.Lj29:
# [112] IsBreak := (Sc and $80) <> 0;
	movb	-4(%ebp),%al
	andb	$128,%al
	testb	$-1,%al
	setneb	-8(%ebp)
# [113] if IsBreak then
	cmpb	$0,-8(%ebp)
	jne	.Lj34
	jmp	.Lj35
.Lj34:
# [114] Sc := Sc and $7F;
	movzbw	-4(%ebp),%ax
	andw	$127,%ax
	movb	%al,-4(%ebp)
	.balign 4,0x90
.Lj35:
# [115] KeyState[Sc] := not IsBreak;
	movzbl	-4(%ebp),%eax
	cmpb	$0,-8(%ebp)
	seteb	U_$KEYBOARD_$$_KEYSTATE(,%eax,1)
.Lj33:
.Lj27:
.Lj18:
	movw	$100,%ax
	call	KEYBOARD_$$_INB$WORD$$BYTE
	movzbw	%al,%ax
	andw	$1,%ax
	testw	$-1,%ax
	jne	.Lj17
	jmp	.Lj19
.Lj19:
# [118] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_keyboard_$$_keyispressed$char$$boolean,"x"
	.balign 16,0x90
.globl	KEYBOARD_$$_KEYISPRESSED$CHAR$$BOOLEAN
KEYBOARD_$$_KEYISPRESSED$CHAR$$BOOLEAN:
# [146] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-16(%esp),%esp
# Var Ch located at ebp-4, size=OS_8
# Var $result located at ebp-8, size=OS_8
# Var i located at ebp-12, size=OS_S32
# Var L located at ebp-16, size=OS_8
	movb	%al,-4(%ebp)
# [147] KeyIsPressed := False;
	movb	$0,-8(%ebp)
# [148] L := Ch;
	movb	-4(%ebp),%al
	movb	%al,-16(%ebp)
# [149] if (L >= 'A') and (L <= 'Z') then
	cmpb	$65,-16(%ebp)
	jae	.Lj38
	jmp	.Lj39
.Lj38:
	cmpb	$90,-16(%ebp)
	jbe	.Lj40
	jmp	.Lj39
.Lj40:
# [150] L := Char(Ord(L) + 32);
	movzbl	-16(%ebp),%eax
	leal	32(%eax),%eax
	movb	%al,-16(%ebp)
	.balign 4,0x90
.Lj39:
# [151] for i := 0 to High(CharToScan) do
	movl	$-1,-12(%ebp)
	.balign 8,0x90
.Lj41:
	movl	-12(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-12(%ebp)
# [153] if CharToScan[i].Ch = L then
	movl	-12(%ebp),%eax
	movb	TC_$KEYBOARD_$$_CHARTOSCAN(,%eax,2),%al
	cmpb	-16(%ebp),%al
	je	.Lj44
	jmp	.Lj45
.Lj44:
# [155] KeyIsPressed := KeyState[CharToScan[i].Scan];
	movl	-12(%ebp),%eax
	movzbl	TC_$KEYBOARD_$$_CHARTOSCAN+1(,%eax,2),%eax
	movb	U_$KEYBOARD_$$_KEYSTATE(,%eax,1),%al
	movb	%al,-8(%ebp)
# [156] Exit;
	jmp	.Lj36
	.balign 4,0x90
.Lj45:
	cmpl	$36,-12(%ebp)
	jge	.Lj43
	jmp	.Lj41
.Lj43:
.Lj36:
# [159] end;
	movb	-8(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_keyboard_$$_specialkeyispressed$byte$$boolean,"x"
	.balign 16,0x90
.globl	KEYBOARD_$$_SPECIALKEYISPRESSED$BYTE$$BOOLEAN
KEYBOARD_$$_SPECIALKEYISPRESSED$BYTE$$BOOLEAN:
# [162] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var Scan located at ebp-4, size=OS_8
# Var $result located at ebp-8, size=OS_8
	movb	%al,-4(%ebp)
# [163] SpecialKeyIsPressed := SpecialState[Scan];
	movzbl	-4(%ebp),%eax
	movb	U_$KEYBOARD_$$_SPECIALSTATE(,%eax,1),%al
	movb	%al,-8(%ebp)
# [164] end;
	movb	-8(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_keyboard_$$_scanispressed$byte$$boolean,"x"
	.balign 16,0x90
.globl	KEYBOARD_$$_SCANISPRESSED$BYTE$$BOOLEAN
KEYBOARD_$$_SCANISPRESSED$BYTE$$BOOLEAN:
# [167] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var Scan located at ebp-4, size=OS_8
# Var $result located at ebp-8, size=OS_8
	movb	%al,-4(%ebp)
# [168] ScanIsPressed := KeyState[Scan] or SpecialState[Scan];
	movzbl	-4(%ebp),%eax
	cmpb	$0,U_$KEYBOARD_$$_KEYSTATE(,%eax,1)
	jne	.Lj50
	jmp	.Lj51
.Lj51:
	movzbl	-4(%ebp),%eax
	cmpb	$0,U_$KEYBOARD_$$_SPECIALSTATE(,%eax,1)
	jne	.Lj50
	jmp	.Lj52
.Lj50:
	movb	$1,-8(%ebp)
	jmp	.Lj53
.Lj52:
	movb	$0,-8(%ebp)
.Lj53:
# [169] end;
	movb	-8(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_keyboard_$$_anykeypressed$$boolean,"x"
	.balign 16,0x90
.globl	KEYBOARD_$$_ANYKEYPRESSED$$BOOLEAN
KEYBOARD_$$_ANYKEYPRESSED$$BOOLEAN:
# [174] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var $result located at ebp-4, size=OS_8
# Var i located at ebp-8, size=OS_S32
# [175] AnyKeyPressed := False;
	movb	$0,-4(%ebp)
# [176] for i := 0 to 127 do
	movl	$-1,-8(%ebp)
	.balign 8,0x90
.Lj56:
	movl	-8(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-8(%ebp)
# [177] if KeyState[i] or SpecialState[i] then
	movl	-8(%ebp),%eax
	cmpb	$0,U_$KEYBOARD_$$_KEYSTATE(,%eax,1)
	jne	.Lj59
	jmp	.Lj60
.Lj60:
	movl	-8(%ebp),%eax
	cmpb	$0,U_$KEYBOARD_$$_SPECIALSTATE(,%eax,1)
	jne	.Lj59
	jmp	.Lj61
.Lj59:
# [179] AnyKeyPressed := True;
	movb	$1,-4(%ebp)
# [180] Exit;
	jmp	.Lj54
	.balign 4,0x90
.Lj61:
	cmpl	$127,-8(%ebp)
	jge	.Lj58
	jmp	.Lj56
.Lj58:
.Lj54:
# [182] end;
	movb	-4(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret
# End asmlist al_procedures
# Begin asmlist al_globals

.section .bss
# [74] KeyState: array[0..127] of Boolean;
U_$KEYBOARD_$$_KEYSTATE:
	.zero 128

.section .bss
# [75] SpecialState: array[0..127] of Boolean;
U_$KEYBOARD_$$_SPECIALSTATE:
	.zero 128
# End asmlist al_globals
# Begin asmlist al_typedconsts

.section .data.n_TC_$KEYBOARD_$$_CHARTOSCAN,"d"
TC_$KEYBOARD_$$_CHARTOSCAN:
	.byte	49,2,50,3,51,4,52,5,53,6,54,7,55,8,56,9,57,10,48,11,113,16,119,17,101,18,114,19,116,20,121,21,117,22,105,23
	.byte	111,24,112,25,97,30,115,31,100,32,102,33,103,34,104,35,106,36,107,37,108,38,122,44,120,45,99,46,118
	.byte	47,98,48,110,49,109,50,32,57
# [142] function KeyIsPressed(Ch: Char): Boolean;
# End asmlist al_typedconsts

