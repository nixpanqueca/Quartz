	.file "buttons.pas"
# Begin asmlist al_procedures

.section .text.n_buttons_$$_strlen$pchar$$longint,"x"
	.balign 16,0x90
BUTTONS_$$_STRLEN$PCHAR$$LONGINT:
# [buttons.pas]
# [54] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var S located at ebp-4, size=OS_32
# Var $result located at ebp-8, size=OS_S32
	movl	%eax,-4(%ebp)
# [55] Result := 0;
	movl	$0,-8(%ebp)
# [56] if S = nil then
	cmpl	$0,-4(%ebp)
	je	.Lj5
	jmp	.Lj6
.Lj5:
# [57] Exit;
	jmp	.Lj3
	.balign 4,0x90
.Lj6:
# [58] while S[Result] <> #0 do
	jmp	.Lj8
	.balign 8,0x90
.Lj7:
# [59] Result := Result + 1;
	movl	-8(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-8(%ebp)
.Lj8:
	movl	-4(%ebp),%eax
	movl	-8(%ebp),%edx
	cmpb	$0,(%eax,%edx,1)
	jne	.Lj7
	jmp	.Lj9
.Lj9:
.Lj3:
# [60] end;
	movl	-8(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_buttons_$$_strequal$pchar$pchar$$boolean,"x"
	.balign 16,0x90
.globl	BUTTONS_$$_STREQUAL$PCHAR$PCHAR$$BOOLEAN
BUTTONS_$$_STREQUAL$PCHAR$PCHAR$$BOOLEAN:
# [65] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-16(%esp),%esp
	pushl	%ebx
# Var A located at ebp-4, size=OS_32
# Var B located at ebp-8, size=OS_32
# Var $result located at ebp-12, size=OS_8
# Var i located at ebp-16, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
# [66] if A = nil then
	cmpl	$0,-4(%ebp)
	je	.Lj12
	jmp	.Lj13
.Lj12:
# [67] Exit(false);
	movb	$0,-12(%ebp)
	jmp	.Lj10
	.balign 4,0x90
.Lj13:
# [68] if B = nil then
	cmpl	$0,-8(%ebp)
	je	.Lj14
	jmp	.Lj15
.Lj14:
# [69] Exit(false);
	movb	$0,-12(%ebp)
	jmp	.Lj10
	.balign 4,0x90
.Lj15:
# [70] i := 0;
	movl	$0,-16(%ebp)
# [71] while True do
	jmp	.Lj17
	.balign 8,0x90
.Lj16:
# [73] if A[i] <> B[i] then
	movl	-4(%ebp),%eax
	movl	-16(%ebp),%edx
	movl	-8(%ebp),%ecx
	movl	-16(%ebp),%ebx
	movb	(%eax,%edx,1),%al
	cmpb	(%ecx,%ebx,1),%al
	jne	.Lj19
	jmp	.Lj20
.Lj19:
# [74] Exit(false);
	movb	$0,-12(%ebp)
	jmp	.Lj10
	.balign 4,0x90
.Lj20:
# [75] if A[i] = #0 then
	movl	-4(%ebp),%eax
	movl	-16(%ebp),%edx
	cmpb	$0,(%eax,%edx,1)
	je	.Lj21
	jmp	.Lj22
.Lj21:
# [76] Break;
	jmp	.Lj18
	.balign 4,0x90
.Lj22:
# [77] Inc(i);
	addl	$1,-16(%ebp)
.Lj17:
	jmp	.Lj16
.Lj18:
# [79] Result := True;
	movb	$1,-12(%ebp)
.Lj10:
# [80] end;
	movb	-12(%ebp),%al
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_buttons_$$_addbutton$longint$longint$longint$longint$pointer$$longint,"x"
	.balign 16,0x90
.globl	BUTTONS_$$_ADDBUTTON$LONGINT$LONGINT$LONGINT$LONGINT$POINTER$$LONGINT
BUTTONS_$$_ADDBUTTON$LONGINT$LONGINT$LONGINT$LONGINT$POINTER$$LONGINT:
# [83] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-16(%esp),%esp
# Var X located at ebp-4, size=OS_S32
# Var Y located at ebp-8, size=OS_S32
# Var W located at ebp-12, size=OS_S32
# Var H located at ebp+12, size=OS_S32
# Var OnClick located at ebp+8, size=OS_32
# Var $result located at ebp-16, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [84] if ButtonCount >= MaxButtons then
	cmpl	$64,U_$BUTTONS_$$_BUTTONCOUNT
	jge	.Lj25
	jmp	.Lj26
.Lj25:
# [85] Exit(-1);
	movl	$-1,-16(%ebp)
	jmp	.Lj23
	.balign 4,0x90
.Lj26:
# [86] ButtonList[ButtonCount].X := X;
	movl	U_$BUTTONS_$$_BUTTONCOUNT,%eax
	imull	$20,%eax,%edx
	movl	-4(%ebp),%eax
	movl	%eax,U_$BUTTONS_$$_BUTTONLIST(,%edx)
# [87] ButtonList[ButtonCount].Y := Y;
	movl	U_$BUTTONS_$$_BUTTONCOUNT,%eax
	imull	$20,%eax,%edx
	movl	-8(%ebp),%eax
	movl	%eax,U_$BUTTONS_$$_BUTTONLIST+4(,%edx)
# [88] ButtonList[ButtonCount].W := W;
	movl	U_$BUTTONS_$$_BUTTONCOUNT,%eax
	imull	$20,%eax,%edx
	movl	-12(%ebp),%eax
	movl	%eax,U_$BUTTONS_$$_BUTTONLIST+8(,%edx)
# [89] ButtonList[ButtonCount].H := H;
	movl	U_$BUTTONS_$$_BUTTONCOUNT,%eax
	imull	$20,%eax,%eax
	movl	12(%ebp),%edx
	movl	%edx,U_$BUTTONS_$$_BUTTONLIST+12(,%eax)
# [90] ButtonList[ButtonCount].OnClick := OnClick;
	movl	U_$BUTTONS_$$_BUTTONCOUNT,%eax
	imull	$20,%eax,%eax
	movl	8(%ebp),%edx
	movl	%edx,U_$BUTTONS_$$_BUTTONLIST+16(,%eax)
# [91] Result := ButtonCount;
	movl	U_$BUTTONS_$$_BUTTONCOUNT,%eax
	movl	%eax,-16(%ebp)
# [92] Inc(ButtonCount);
	addl	$1,U_$BUTTONS_$$_BUTTONCOUNT
.Lj23:
# [93] end;
	movl	-16(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret	$8

.section .text.n_buttons_$$_removebutton$longint,"x"
	.balign 16,0x90
.globl	BUTTONS_$$_REMOVEBUTTON$LONGINT
BUTTONS_$$_REMOVEBUTTON$LONGINT:
# [98] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
	pushl	%esi
	pushl	%edi
# Var Index located at ebp-4, size=OS_S32
# Var i located at ebp-8, size=OS_S32
	movl	%eax,-4(%ebp)
# [99] if (Index < 0) or (Index >= ButtonCount) then
	cmpl	$0,-4(%ebp)
	jl	.Lj29
	jmp	.Lj30
.Lj30:
	movl	-4(%ebp),%eax
	cmpl	U_$BUTTONS_$$_BUTTONCOUNT,%eax
	jge	.Lj29
	jmp	.Lj31
.Lj29:
# [100] Exit;
	jmp	.Lj27
	.balign 4,0x90
.Lj31:
# [101] for i := Index to ButtonCount - 2 do
	movl	U_$BUTTONS_$$_BUTTONCOUNT,%eax
	leal	-2(%eax),%eax
	cmpl	-4(%ebp),%eax
	jge	.Lj32
	jmp	.Lj33
.Lj32:
	movl	-4(%ebp),%edx
	leal	-1(%edx),%edx
	movl	%edx,-8(%ebp)
	.balign 8,0x90
.Lj34:
	movl	-8(%ebp),%edx
	leal	1(%edx),%edx
	movl	%edx,-8(%ebp)
# [102] ButtonList[i] := ButtonList[i + 1];
	movl	-8(%ebp),%edx
	leal	1(%edx),%edx
	imull	$20,%edx,%ecx
	movl	-8(%ebp),%edx
	imull	$20,%edx,%edx
	leal	U_$BUTTONS_$$_BUTTONLIST(,%edx),%edi
	leal	U_$BUTTONS_$$_BUTTONLIST(,%ecx),%esi
	movl	$5,%ecx
	rep
	movsl
	cmpl	-8(%ebp),%eax
	jle	.Lj36
	jmp	.Lj34
.Lj36:
	.balign 4,0x90
.Lj33:
# [103] Dec(ButtonCount);
	subl	$1,U_$BUTTONS_$$_BUTTONCOUNT
.Lj27:
# [104] end;
	popl	%edi
	popl	%esi
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_buttons_$$_clearbuttons,"x"
	.balign 16,0x90
.globl	BUTTONS_$$_CLEARBUTTONS
BUTTONS_$$_CLEARBUTTONS:
# [107] begin
	pushl	%ebp
	movl	%esp,%ebp
# [108] ButtonCount := 0;
	movl	$0,U_$BUTTONS_$$_BUTTONCOUNT
# [109] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_buttons_$$_getbuttoncount$$longint,"x"
	.balign 16,0x90
.globl	BUTTONS_$$_GETBUTTONCOUNT$$LONGINT
BUTTONS_$$_GETBUTTONCOUNT$$LONGINT:
# [112] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-4(%esp),%esp
# Var $result located at ebp-4, size=OS_S32
# [113] Result := ButtonCount;
	movl	U_$BUTTONS_$$_BUTTONCOUNT,%eax
	movl	%eax,-4(%ebp)
# [114] end;
	movl	-4(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_buttons_$$_drawbutton$longint$longint$longint$longint$pchar,"x"
	.balign 16,0x90
.globl	BUTTONS_$$_DRAWBUTTON$LONGINT$LONGINT$LONGINT$LONGINT$PCHAR
BUTTONS_$$_DRAWBUTTON$LONGINT$LONGINT$LONGINT$LONGINT$PCHAR:
# [121] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-20(%esp),%esp
# Var X located at ebp-4, size=OS_S32
# Var Y located at ebp-8, size=OS_S32
# Var W located at ebp-12, size=OS_S32
# Var H located at ebp+12, size=OS_S32
# Var Text located at ebp+8, size=OS_32
# Var TX located at ebp-16, size=OS_S32
# Var TY located at ebp-20, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [122] FillRect(X, Y, W, H, $0F);
	pushl	12(%ebp)
	pushl	$15
	movl	-12(%ebp),%ecx
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [123] FillRect(X, Y, W, 1, 0);          // borda superior
	pushl	$1
	pushl	$0
	movl	-12(%ebp),%ecx
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [124] FillRect(X, Y + H - 1, W, 1, 0);  // borda inferior
	pushl	$1
	pushl	$0
	movl	-8(%ebp),%edx
	movl	12(%ebp),%eax
	leal	(%edx,%eax),%edx
	subl	$1,%edx
	movl	-12(%ebp),%ecx
	movl	-4(%ebp),%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [125] FillRect(X, Y, 1, H, 0);          // borda esquerda
	pushl	12(%ebp)
	pushl	$0
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	movl	$1,%ecx
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [126] FillRect(X + W - 1, Y, 1, H, 0);  // borda direita
	pushl	12(%ebp)
	pushl	$0
	movl	-4(%ebp),%eax
	movl	-12(%ebp),%edx
	leal	(%eax,%edx),%eax
	subl	$1,%eax
	movl	-8(%ebp),%edx
	movl	$1,%ecx
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [127] TX := X + (W - StrLen(Text) * Size) div 2;
	movl	8(%ebp),%eax
	call	BUTTONS_$$_STRLEN$PCHAR$$LONGINT
	imull	$12,%eax
	movl	-12(%ebp),%edx
	subl	%eax,%edx
	movl	%edx,%eax
	shrl	$31,%eax
	addl	%eax,%edx
	sarl	$1,%edx
	addl	-4(%ebp),%edx
	movl	%edx,-16(%ebp)
# [128] TY := Y + (H - Size) div 2;
	movl	12(%ebp),%eax
	leal	-12(%eax),%eax
	movl	%eax,%edx
	shrl	$31,%edx
	addl	%edx,%eax
	sarl	$1,%eax
	addl	-8(%ebp),%eax
	movl	%eax,-20(%ebp)
# [129] WriteAt(TX, TY, Text, Size);
	pushl	$12
	movl	8(%ebp),%ecx
	movl	-20(%ebp),%edx
	movl	-16(%ebp),%eax
	call	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
# [130] end;
	movl	%ebp,%esp
	popl	%ebp
	ret	$8

.section .text.n_buttons_$$_createbutton$longint$longint$longint$longint$pchar$pointer$$longint,"x"
	.balign 16,0x90
.globl	BUTTONS_$$_CREATEBUTTON$LONGINT$LONGINT$LONGINT$LONGINT$PCHAR$POINTER$$LONGINT
BUTTONS_$$_CREATEBUTTON$LONGINT$LONGINT$LONGINT$LONGINT$PCHAR$POINTER$$LONGINT:
# [133] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-16(%esp),%esp
# Var X located at ebp-4, size=OS_S32
# Var Y located at ebp-8, size=OS_S32
# Var W located at ebp-12, size=OS_S32
# Var H located at ebp+16, size=OS_S32
# Var Text located at ebp+12, size=OS_32
# Var OnClick located at ebp+8, size=OS_32
# Var $result located at ebp-16, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [134] DrawButton(X, Y, W, H, Text);
	pushl	16(%ebp)
	pushl	12(%ebp)
	movl	-12(%ebp),%ecx
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	call	BUTTONS_$$_DRAWBUTTON$LONGINT$LONGINT$LONGINT$LONGINT$PCHAR
# [135] Result := AddButton(X, Y, W, H, OnClick);
	pushl	16(%ebp)
	pushl	8(%ebp)
	movl	-12(%ebp),%ecx
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	call	BUTTONS_$$_ADDBUTTON$LONGINT$LONGINT$LONGINT$LONGINT$POINTER$$LONGINT
	movl	%eax,-16(%ebp)
# [136] end;
	movl	-16(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret	$12

.section .text.n_buttons_$$_checkbuttons,"x"
	.balign 16,0x90
.globl	BUTTONS_$$_CHECKBUTTONS
BUTTONS_$$_CHECKBUTTONS:
# [142] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-20(%esp),%esp
	pushl	%ebx
# Var B located at ebp-4, size=OS_S32
# Var i located at ebp-8, size=OS_S32
# Var MX located at ebp-12, size=OS_S32
# Var MY located at ebp-16, size=OS_S32
# Var P located at ebp-20, size=OS_32
# [143] B := GetMouseButtons;
	call	MOUSE_$$_GETMOUSEBUTTONS$$BYTE
	movzbl	%al,%eax
	movl	%eax,-4(%ebp)
# [144] if (B and 1) <> 0 then
	movl	-4(%ebp),%eax
	andl	$1,%eax
	testl	$-1,%eax
	jne	.Lj47
	jmp	.Lj48
.Lj47:
# [145] if (PrevButtons and 1) = 0 then
	movzbw	U_$BUTTONS_$$_PREVBUTTONS,%ax
	andw	$1,%ax
	testw	$-1,%ax
	je	.Lj49
	jmp	.Lj50
.Lj49:
# [147] MX := GetMouseX;
	call	MOUSE_$$_GETMOUSEX$$LONGINT
	movl	%eax,-12(%ebp)
# [148] MY := GetMouseY;
	call	MOUSE_$$_GETMOUSEY$$LONGINT
	movl	%eax,-16(%ebp)
# [149] for i := 0 to ButtonCount - 1 do
	movl	U_$BUTTONS_$$_BUTTONCOUNT,%eax
	leal	-1(%eax),%ebx
	cmpl	$0,%ebx
	jge	.Lj51
	jmp	.Lj52
.Lj51:
	movl	$-1,-8(%ebp)
	.balign 8,0x90
.Lj53:
	movl	-8(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-8(%ebp)
# [150] if (MX >= ButtonList[i].X) and (MX < ButtonList[i].X + ButtonList[i].W) and
	movl	-8(%ebp),%eax
	imull	$20,%eax,%eax
	movl	U_$BUTTONS_$$_BUTTONLIST(,%eax),%eax
	cmpl	-12(%ebp),%eax
	jle	.Lj56
	jmp	.Lj57
.Lj56:
	movl	-8(%ebp),%eax
	imull	$20,%eax,%edx
	movl	-8(%ebp),%eax
	imull	$20,%eax,%eax
	movl	U_$BUTTONS_$$_BUTTONLIST(,%edx),%edx
	movl	U_$BUTTONS_$$_BUTTONLIST+8(,%eax),%eax
	leal	(%edx,%eax),%eax
	cmpl	-12(%ebp),%eax
	jg	.Lj58
	jmp	.Lj57
.Lj58:
# [151] (MY >= ButtonList[i].Y) and (MY < ButtonList[i].Y + ButtonList[i].H) then
	movl	-8(%ebp),%eax
	imull	$20,%eax,%eax
	movl	U_$BUTTONS_$$_BUTTONLIST+4(,%eax),%eax
	cmpl	-16(%ebp),%eax
	jle	.Lj59
	jmp	.Lj57
.Lj59:
	movl	-8(%ebp),%eax
	imull	$20,%eax,%edx
	movl	-8(%ebp),%eax
	imull	$20,%eax,%eax
	movl	U_$BUTTONS_$$_BUTTONLIST+4(,%edx),%edx
	movl	U_$BUTTONS_$$_BUTTONLIST+12(,%eax),%eax
	leal	(%edx,%eax),%eax
	cmpl	-16(%ebp),%eax
	jg	.Lj60
	jmp	.Lj57
.Lj60:
# [153] if ButtonList[i].OnClick <> nil then
	movl	-8(%ebp),%eax
	imull	$20,%eax,%eax
	cmpl	$0,U_$BUTTONS_$$_BUTTONLIST+16(,%eax)
	jne	.Lj61
	jmp	.Lj62
.Lj61:
# [155] P := TButtonProc(ButtonList[i].OnClick);
	movl	-8(%ebp),%eax
	imull	$20,%eax,%eax
	movl	U_$BUTTONS_$$_BUTTONLIST+16(,%eax),%eax
	movl	%eax,-20(%ebp)
# [156] P;
	call	*-20(%ebp)
	.balign 4,0x90
.Lj62:
# [158] Break;
	jmp	.Lj55
	.balign 4,0x90
.Lj57:
	cmpl	-8(%ebp),%ebx
	jle	.Lj55
	jmp	.Lj53
.Lj55:
	.balign 4,0x90
.Lj52:
	.balign 4,0x90
.Lj50:
	.balign 4,0x90
.Lj48:
# [161] PrevButtons := B;
	movb	-4(%ebp),%al
	movb	%al,U_$BUTTONS_$$_PREVBUTTONS
# [162] end;
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret
# End asmlist al_procedures
# Begin asmlist al_globals

.section .bss
	.balign 4
# [49] ButtonList: array[0..MaxButtons - 1] of TButton;
U_$BUTTONS_$$_BUTTONLIST:
	.zero 1280

.section .bss
	.balign 4
# [50] ButtonCount: Integer;
U_$BUTTONS_$$_BUTTONCOUNT:
	.zero 4

.section .bss
# [51] PrevButtons: Byte;
U_$BUTTONS_$$_PREVBUTTONS:
	.zero 1
# End asmlist al_globals

