	.file "keyboard.pas"
# Begin asmlist al_procedures

.section .text.n_keyboard_$$_outb$word$byte,"x"
	.balign 16,0x90
KEYBOARD_$$_OUTB$WORD$BYTE:
# [keyboard.pas]
# [55] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var Addr located at ebp-4, size=OS_16
# Var Value located at ebp-8, size=OS_8
	movw	%ax,-4(%ebp)
	movb	%dl,-8(%ebp)
#  CPU PENTIUM
# [57] mov dx, Addr
	movw	-4(%ebp),%dx
# [58] mov al, Value
	movb	-8(%ebp),%al
# [59] out dx, al
	outb	%al,%dx
#  CPU PENTIUM
# [61] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_keyboard_$$_inb$word$$byte,"x"
	.balign 16,0x90
KEYBOARD_$$_INB$WORD$$BYTE:
# [66] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-12(%esp),%esp
# Var Addr located at ebp-4, size=OS_16
# Var $result located at ebp-8, size=OS_8
# Var B located at ebp-12, size=OS_8
	movw	%ax,-4(%ebp)
#  CPU PENTIUM
# [68] mov dx, Addr
	movw	-4(%ebp),%dx
# [69] in al, dx
	inb	%dx,%al
# [70] mov B, al
	movb	%al,-12(%ebp)
#  CPU PENTIUM
# [72] InB := B;
	movb	-12(%ebp),%al
	movb	%al,-8(%ebp)
# [73] end;
	movb	-8(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_keyboard_$$_keyboardinit,"x"
	.balign 16,0x90
.globl	KEYBOARD_$$_KEYBOARDINIT
KEYBOARD_$$_KEYBOARDINIT:
# [82] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-4(%esp),%esp
# Var i located at ebp-4, size=OS_S32
# [83] for i := 0 to 127 do
	movl	$-1,-4(%ebp)
	.balign 8,0x90
.Lj9:
	movl	-4(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-4(%ebp)
# [85] KeyState[i] := False;
	movl	-4(%ebp),%eax
	movb	$0,U_$KEYBOARD_$$_KEYSTATE(,%eax,1)
# [86] SpecialState[i] := False;
	movl	-4(%ebp),%eax
	movb	$0,U_$KEYBOARD_$$_SPECIALSTATE(,%eax,1)
	cmpl	$127,-4(%ebp)
	jge	.Lj11
	jmp	.Lj9
.Lj11:
# [88] while (InB($64) and 1) <> 0 do InB($60);
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
# [89] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_keyboard_$$_keyboardpoll,"x"
	.balign 16,0x90
.globl	KEYBOARD_$$_KEYBOARDPOLL
KEYBOARD_$$_KEYBOARDPOLL:
# [95] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var Sc located at ebp-4, size=OS_8
# Var IsBreak located at ebp-8, size=OS_8
# [96] while True do
	jmp	.Lj18
	.balign 8,0x90
.Lj17:
# [98] if (InB($64) and 1) = 0 then
	movw	$100,%ax
	call	KEYBOARD_$$_INB$WORD$$BYTE
	movzbw	%al,%ax
	andw	$1,%ax
	testw	$-1,%ax
	je	.Lj20
	jmp	.Lj21
.Lj20:
# [99] Exit;
	jmp	.Lj15
	.balign 4,0x90
.Lj21:
# [100] if (InB($64) and $20) <> 0 then
	movw	$100,%ax
	call	KEYBOARD_$$_INB$WORD$$BYTE
	movzbw	%al,%ax
	andw	$32,%ax
	testw	$-1,%ax
	jne	.Lj22
	jmp	.Lj23
.Lj22:
# [104] MouseDeliver(InB($60));
	movw	$96,%ax
	call	KEYBOARD_$$_INB$WORD$$BYTE
	call	MOUSE_$$_MOUSEDELIVER$BYTE
# [105] Continue;
	jmp	.Lj18
	.balign 4,0x90
.Lj23:
# [107] Sc := InB($60);
	movw	$96,%ax
	call	KEYBOARD_$$_INB$WORD$$BYTE
	movb	%al,-4(%ebp)
# [108] if Sc = $E0 then
	cmpb	$224,-4(%ebp)
	je	.Lj24
	jmp	.Lj25
.Lj24:
# [110] while (InB($64) and 1) = 0 do ;
	jmp	.Lj27
	.balign 8,0x90
.Lj26:
.Lj27:
	movw	$100,%ax
	call	KEYBOARD_$$_INB$WORD$$BYTE
	movzbw	%al,%ax
	andw	$1,%ax
	testw	$-1,%ax
	je	.Lj26
	jmp	.Lj28
.Lj28:
# [111] Sc := InB($60);
	movw	$96,%ax
	call	KEYBOARD_$$_INB$WORD$$BYTE
	movb	%al,-4(%ebp)
# [112] IsBreak := (Sc and $80) <> 0;
	movb	-4(%ebp),%al
	andb	$128,%al
	testb	$-1,%al
	setneb	-8(%ebp)
# [113] if IsBreak then
	cmpb	$0,-8(%ebp)
	jne	.Lj29
	jmp	.Lj30
.Lj29:
# [114] Sc := Sc and $7F;
	movzbw	-4(%ebp),%ax
	andw	$127,%ax
	movb	%al,-4(%ebp)
	.balign 4,0x90
.Lj30:
# [115] SpecialState[Sc] := not IsBreak;
	movzbl	-4(%ebp),%eax
	cmpb	$0,-8(%ebp)
	seteb	U_$KEYBOARD_$$_SPECIALSTATE(,%eax,1)
	jmp	.Lj31
.Lj25:
# [117] else if Sc = $E1 then
	cmpb	$225,-4(%ebp)
	je	.Lj32
	jmp	.Lj33
.Lj32:
# [119] while (InB($64) and 1) <> 0 do
	jmp	.Lj35
	.balign 8,0x90
.Lj34:
# [120] InB($60);
	movw	$96,%ax
	call	KEYBOARD_$$_INB$WORD$$BYTE
.Lj35:
	movw	$100,%ax
	call	KEYBOARD_$$_INB$WORD$$BYTE
	movzbw	%al,%ax
	andw	$1,%ax
	testw	$-1,%ax
	jne	.Lj34
	jmp	.Lj36
.Lj36:
	jmp	.Lj37
.Lj33:
# [124] IsBreak := (Sc and $80) <> 0;
	movb	-4(%ebp),%al
	andb	$128,%al
	testb	$-1,%al
	setneb	-8(%ebp)
# [125] if IsBreak then
	cmpb	$0,-8(%ebp)
	jne	.Lj38
	jmp	.Lj39
.Lj38:
# [126] Sc := Sc and $7F;
	movzbw	-4(%ebp),%ax
	andw	$127,%ax
	movb	%al,-4(%ebp)
	.balign 4,0x90
.Lj39:
# [127] KeyState[Sc] := not IsBreak;
	movzbl	-4(%ebp),%eax
	cmpb	$0,-8(%ebp)
	seteb	U_$KEYBOARD_$$_KEYSTATE(,%eax,1)
.Lj37:
.Lj31:
.Lj18:
	jmp	.Lj17
.Lj15:
# [130] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_keyboard_$$_keyispressed$char$$boolean,"x"
	.balign 16,0x90
.globl	KEYBOARD_$$_KEYISPRESSED$CHAR$$BOOLEAN
KEYBOARD_$$_KEYISPRESSED$CHAR$$BOOLEAN:
# [158] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-16(%esp),%esp
# Var Ch located at ebp-4, size=OS_8
# Var $result located at ebp-8, size=OS_8
# Var i located at ebp-12, size=OS_S32
# Var L located at ebp-16, size=OS_8
	movb	%al,-4(%ebp)
# [159] KeyIsPressed := False;
	movb	$0,-8(%ebp)
# [160] L := Ch;
	movb	-4(%ebp),%al
	movb	%al,-16(%ebp)
# [161] if (L >= 'A') and (L <= 'Z') then
	cmpb	$65,-16(%ebp)
	jae	.Lj42
	jmp	.Lj43
.Lj42:
	cmpb	$90,-16(%ebp)
	jbe	.Lj44
	jmp	.Lj43
.Lj44:
# [162] L := Char(Ord(L) + 32);
	movzbl	-16(%ebp),%eax
	leal	32(%eax),%eax
	movb	%al,-16(%ebp)
	.balign 4,0x90
.Lj43:
# [163] for i := 0 to High(CharToScan) do
	movl	$-1,-12(%ebp)
	.balign 8,0x90
.Lj45:
	movl	-12(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-12(%ebp)
# [165] if CharToScan[i].Ch = L then
	movl	-12(%ebp),%eax
	movb	TC_$KEYBOARD_$$_CHARTOSCAN(,%eax,2),%al
	cmpb	-16(%ebp),%al
	je	.Lj48
	jmp	.Lj49
.Lj48:
# [167] KeyIsPressed := KeyState[CharToScan[i].Scan];
	movl	-12(%ebp),%eax
	movzbl	TC_$KEYBOARD_$$_CHARTOSCAN+1(,%eax,2),%eax
	movb	U_$KEYBOARD_$$_KEYSTATE(,%eax,1),%al
	movb	%al,-8(%ebp)
# [168] Exit;
	jmp	.Lj40
	.balign 4,0x90
.Lj49:
	cmpl	$36,-12(%ebp)
	jge	.Lj47
	jmp	.Lj45
.Lj47:
.Lj40:
# [171] end;
	movb	-8(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_keyboard_$$_specialkeyispressed$byte$$boolean,"x"
	.balign 16,0x90
.globl	KEYBOARD_$$_SPECIALKEYISPRESSED$BYTE$$BOOLEAN
KEYBOARD_$$_SPECIALKEYISPRESSED$BYTE$$BOOLEAN:
# [174] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var Scan located at ebp-4, size=OS_8
# Var $result located at ebp-8, size=OS_8
	movb	%al,-4(%ebp)
# [175] SpecialKeyIsPressed := SpecialState[Scan];
	movzbl	-4(%ebp),%eax
	movb	U_$KEYBOARD_$$_SPECIALSTATE(,%eax,1),%al
	movb	%al,-8(%ebp)
# [176] end;
	movb	-8(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_keyboard_$$_scanispressed$byte$$boolean,"x"
	.balign 16,0x90
.globl	KEYBOARD_$$_SCANISPRESSED$BYTE$$BOOLEAN
KEYBOARD_$$_SCANISPRESSED$BYTE$$BOOLEAN:
# [179] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var Scan located at ebp-4, size=OS_8
# Var $result located at ebp-8, size=OS_8
	movb	%al,-4(%ebp)
# [180] ScanIsPressed := KeyState[Scan] or SpecialState[Scan];
	movzbl	-4(%ebp),%eax
	cmpb	$0,U_$KEYBOARD_$$_KEYSTATE(,%eax,1)
	jne	.Lj54
	jmp	.Lj55
.Lj55:
	movzbl	-4(%ebp),%eax
	cmpb	$0,U_$KEYBOARD_$$_SPECIALSTATE(,%eax,1)
	jne	.Lj54
	jmp	.Lj56
.Lj54:
	movb	$1,-8(%ebp)
	jmp	.Lj57
.Lj56:
	movb	$0,-8(%ebp)
.Lj57:
# [181] end;
	movb	-8(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_keyboard_$$_anykeypressed$$boolean,"x"
	.balign 16,0x90
.globl	KEYBOARD_$$_ANYKEYPRESSED$$BOOLEAN
KEYBOARD_$$_ANYKEYPRESSED$$BOOLEAN:
# [186] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var $result located at ebp-4, size=OS_8
# Var i located at ebp-8, size=OS_S32
# [187] AnyKeyPressed := False;
	movb	$0,-4(%ebp)
# [188] for i := 0 to 127 do
	movl	$-1,-8(%ebp)
	.balign 8,0x90
.Lj60:
	movl	-8(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-8(%ebp)
# [189] if KeyState[i] or SpecialState[i] then
	movl	-8(%ebp),%eax
	cmpb	$0,U_$KEYBOARD_$$_KEYSTATE(,%eax,1)
	jne	.Lj63
	jmp	.Lj64
.Lj64:
	movl	-8(%ebp),%eax
	cmpb	$0,U_$KEYBOARD_$$_SPECIALSTATE(,%eax,1)
	jne	.Lj63
	jmp	.Lj65
.Lj63:
# [191] AnyKeyPressed := True;
	movb	$1,-4(%ebp)
# [192] Exit;
	jmp	.Lj58
	.balign 4,0x90
.Lj65:
	cmpl	$127,-8(%ebp)
	jge	.Lj62
	jmp	.Lj60
.Lj62:
.Lj58:
# [194] end;
	movb	-4(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret
# End asmlist al_procedures
# Begin asmlist al_globals

.section .bss
# [76] KeyState: array[0..127] of Boolean;
U_$KEYBOARD_$$_KEYSTATE:
	.zero 128

.section .bss
# [77] SpecialState: array[0..127] of Boolean;
U_$KEYBOARD_$$_SPECIALSTATE:
	.zero 128
# End asmlist al_globals
# Begin asmlist al_typedconsts

.section .data.n_TC_$KEYBOARD_$$_CHARTOSCAN,"d"
TC_$KEYBOARD_$$_CHARTOSCAN:
	.byte	49,2,50,3,51,4,52,5,53,6,54,7,55,8,56,9,57,10,48,11,113,16,119,17,101,18,114,19,116,20,121,21,117,22,105,23
	.byte	111,24,112,25,97,30,115,31,100,32,102,33,103,34,104,35,106,36,107,37,108,38,122,44,120,45,99,46,118
	.byte	47,98,48,110,49,109,50,32,57
# [154] function KeyIsPressed(Ch: Char): Boolean;
# End asmlist al_typedconsts

