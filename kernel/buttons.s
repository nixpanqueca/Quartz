	.file "buttons.pas"
# Begin asmlist al_procedures

.section .text.n_buttons_$$_outb$word$byte,"x"
	.balign 16,0x90
BUTTONS_$$_OUTB$WORD$BYTE:
# [buttons.pas]
# [73] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var Addr located at ebp-4, size=OS_16
# Var Value located at ebp-8, size=OS_8
	movw	%ax,-4(%ebp)
	movb	%dl,-8(%ebp)
#  CPU PENTIUM
# [75] mov dx, Addr
	movw	-4(%ebp),%dx
# [76] mov al, Value
	movb	-8(%ebp),%al
# [77] out dx, al
	outb	%al,%dx
#  CPU PENTIUM
# [79] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_buttons_$$_inb$word$$byte,"x"
	.balign 16,0x90
BUTTONS_$$_INB$WORD$$BYTE:
# [84] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-12(%esp),%esp
# Var Addr located at ebp-4, size=OS_16
# Var $result located at ebp-8, size=OS_8
# Var B located at ebp-12, size=OS_8
	movw	%ax,-4(%ebp)
#  CPU PENTIUM
# [86] mov dx, Addr
	movw	-4(%ebp),%dx
# [87] in al, dx
	inb	%dx,%al
# [88] mov B, al
	movb	%al,-12(%ebp)
#  CPU PENTIUM
# [90] InB := B;
	movb	-12(%ebp),%al
	movb	%al,-8(%ebp)
# [91] end;
	movb	-8(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_buttons_$$_rtcmonotonic$$longint,"x"
	.balign 16,0x90
BUTTONS_$$_RTCMONOTONIC$$LONGINT:
# [99] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-28(%esp),%esp
# Var $result located at ebp-4, size=OS_S32
# Var H located at ebp-8, size=OS_8
# Var M located at ebp-12, size=OS_8
# Var S located at ebp-16, size=OS_8
# Var HH located at ebp-20, size=OS_S32
# Var MM located at ebp-24, size=OS_S32
# Var SS located at ebp-28, size=OS_S32
# [100] OutB($70, $04);
	movb	$4,%dl
	movw	$112,%ax
	call	BUTTONS_$$_OUTB$WORD$BYTE
# [101] H := InB($71);
	movw	$113,%ax
	call	BUTTONS_$$_INB$WORD$$BYTE
	movb	%al,-8(%ebp)
# [102] OutB($70, $02);
	movb	$2,%dl
	movw	$112,%ax
	call	BUTTONS_$$_OUTB$WORD$BYTE
# [103] M := InB($71);
	movw	$113,%ax
	call	BUTTONS_$$_INB$WORD$$BYTE
	movb	%al,-12(%ebp)
# [104] OutB($70, $00);
	movb	$0,%dl
	movw	$112,%ax
	call	BUTTONS_$$_OUTB$WORD$BYTE
# [105] S := InB($71);
	movw	$113,%ax
	call	BUTTONS_$$_INB$WORD$$BYTE
	movb	%al,-16(%ebp)
# [106] HH := (H shr 4) * 10 + (H and $0F);
	movzbl	-8(%ebp),%eax
	shrl	$4,%eax
	imull	$10,%eax
	movzbw	-8(%ebp),%dx
	andw	$15,%dx
	movswl	%dx,%edx
	leal	(%eax,%edx),%eax
	movl	%eax,-20(%ebp)
# [107] MM := (M shr 4) * 10 + (M and $0F);
	movzbl	-12(%ebp),%eax
	shrl	$4,%eax
	imull	$10,%eax
	movzbw	-12(%ebp),%dx
	andw	$15,%dx
	movswl	%dx,%edx
	leal	(%eax,%edx),%eax
	movl	%eax,-24(%ebp)
# [108] SS := (S shr 4) * 10 + (S and $0F);
	movzbl	-16(%ebp),%eax
	shrl	$4,%eax
	imull	$10,%eax
	movzbw	-16(%ebp),%dx
	andw	$15,%dx
	movswl	%dx,%edx
	leal	(%eax,%edx),%eax
	movl	%eax,-28(%ebp)
# [109] Result := HH * 3600 + MM * 60 + SS;
	movl	-20(%ebp),%eax
	imull	$3600,%eax,%edx
	movl	-24(%ebp),%eax
	imull	$60,%eax,%eax
	leal	(%edx,%eax),%eax
	addl	-28(%ebp),%eax
	movl	%eax,-4(%ebp)
# [110] end;
	movl	-4(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_buttons_$$_strlen$pchar$$longint,"x"
	.balign 16,0x90
BUTTONS_$$_STRLEN$PCHAR$$LONGINT:
# [113] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var S located at ebp-4, size=OS_32
# Var $result located at ebp-8, size=OS_S32
	movl	%eax,-4(%ebp)
# [114] Result := 0;
	movl	$0,-8(%ebp)
# [115] if S = nil then
	cmpl	$0,-4(%ebp)
	je	.Lj11
	jmp	.Lj12
.Lj11:
# [116] Exit;
	jmp	.Lj9
	.balign 4,0x90
.Lj12:
# [117] while S[Result] <> #0 do
	jmp	.Lj14
	.balign 8,0x90
.Lj13:
# [118] Result := Result + 1;
	movl	-8(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-8(%ebp)
.Lj14:
	movl	-4(%ebp),%eax
	movl	-8(%ebp),%edx
	cmpb	$0,(%eax,%edx,1)
	jne	.Lj13
	jmp	.Lj15
.Lj15:
.Lj9:
# [119] end;
	movl	-8(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_buttons_$$_strequal$pchar$pchar$$boolean,"x"
	.balign 16,0x90
.globl	BUTTONS_$$_STREQUAL$PCHAR$PCHAR$$BOOLEAN
BUTTONS_$$_STREQUAL$PCHAR$PCHAR$$BOOLEAN:
# [124] begin
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
# [125] if A = nil then
	cmpl	$0,-4(%ebp)
	je	.Lj18
	jmp	.Lj19
.Lj18:
# [126] Exit(false);
	movb	$0,-12(%ebp)
	jmp	.Lj16
	.balign 4,0x90
.Lj19:
# [127] if B = nil then
	cmpl	$0,-8(%ebp)
	je	.Lj20
	jmp	.Lj21
.Lj20:
# [128] Exit(false);
	movb	$0,-12(%ebp)
	jmp	.Lj16
	.balign 4,0x90
.Lj21:
# [129] i := 0;
	movl	$0,-16(%ebp)
# [130] while True do
	jmp	.Lj23
	.balign 8,0x90
.Lj22:
# [132] if A[i] <> B[i] then
	movl	-4(%ebp),%eax
	movl	-16(%ebp),%edx
	movl	-8(%ebp),%ecx
	movl	-16(%ebp),%ebx
	movb	(%eax,%edx,1),%al
	cmpb	(%ecx,%ebx,1),%al
	jne	.Lj25
	jmp	.Lj26
.Lj25:
# [133] Exit(false);
	movb	$0,-12(%ebp)
	jmp	.Lj16
	.balign 4,0x90
.Lj26:
# [134] if A[i] = #0 then
	movl	-4(%ebp),%eax
	movl	-16(%ebp),%edx
	cmpb	$0,(%eax,%edx,1)
	je	.Lj27
	jmp	.Lj28
.Lj27:
# [135] Break;
	jmp	.Lj24
	.balign 4,0x90
.Lj28:
# [136] Inc(i);
	addl	$1,-16(%ebp)
.Lj23:
	jmp	.Lj22
.Lj24:
# [138] Result := True;
	movb	$1,-12(%ebp)
.Lj16:
# [139] end;
	movb	-12(%ebp),%al
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_buttons_$$_addbuttonex$longint$longint$longint$longint$pointer$pointer$$longint,"x"
	.balign 16,0x90
.globl	BUTTONS_$$_ADDBUTTONEX$LONGINT$LONGINT$LONGINT$LONGINT$POINTER$POINTER$$LONGINT
BUTTONS_$$_ADDBUTTONEX$LONGINT$LONGINT$LONGINT$LONGINT$POINTER$POINTER$$LONGINT:
# [142] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-16(%esp),%esp
# Var X located at ebp-4, size=OS_S32
# Var Y located at ebp-8, size=OS_S32
# Var W located at ebp-12, size=OS_S32
# Var H located at ebp+16, size=OS_S32
# Var OnClick located at ebp+12, size=OS_32
# Var OnDblClick located at ebp+8, size=OS_32
# Var $result located at ebp-16, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [143] if ButtonCount >= MaxButtons then
	cmpl	$64,U_$BUTTONS_$$_BUTTONCOUNT
	jge	.Lj31
	jmp	.Lj32
.Lj31:
# [144] Exit(-1);
	movl	$-1,-16(%ebp)
	jmp	.Lj29
	.balign 4,0x90
.Lj32:
# [145] ButtonList[ButtonCount].X := X;
	movl	U_$BUTTONS_$$_BUTTONCOUNT,%eax
	imull	$24,%eax,%eax
	movl	-4(%ebp),%edx
	movl	%edx,U_$BUTTONS_$$_BUTTONLIST(,%eax)
# [146] ButtonList[ButtonCount].Y := Y;
	movl	U_$BUTTONS_$$_BUTTONCOUNT,%eax
	imull	$24,%eax,%edx
	movl	-8(%ebp),%eax
	movl	%eax,U_$BUTTONS_$$_BUTTONLIST+4(,%edx)
# [147] ButtonList[ButtonCount].W := W;
	movl	U_$BUTTONS_$$_BUTTONCOUNT,%eax
	imull	$24,%eax,%edx
	movl	-12(%ebp),%eax
	movl	%eax,U_$BUTTONS_$$_BUTTONLIST+8(,%edx)
# [148] ButtonList[ButtonCount].H := H;
	movl	U_$BUTTONS_$$_BUTTONCOUNT,%eax
	imull	$24,%eax,%eax
	movl	16(%ebp),%edx
	movl	%edx,U_$BUTTONS_$$_BUTTONLIST+12(,%eax)
# [149] ButtonList[ButtonCount].OnClick := OnClick;
	movl	U_$BUTTONS_$$_BUTTONCOUNT,%eax
	imull	$24,%eax,%eax
	movl	12(%ebp),%edx
	movl	%edx,U_$BUTTONS_$$_BUTTONLIST+16(,%eax)
# [150] ButtonList[ButtonCount].OnDblClick := OnDblClick;
	movl	U_$BUTTONS_$$_BUTTONCOUNT,%eax
	imull	$24,%eax,%eax
	movl	8(%ebp),%edx
	movl	%edx,U_$BUTTONS_$$_BUTTONLIST+20(,%eax)
# [151] Result := ButtonCount;
	movl	U_$BUTTONS_$$_BUTTONCOUNT,%eax
	movl	%eax,-16(%ebp)
# [152] Inc(ButtonCount);
	addl	$1,U_$BUTTONS_$$_BUTTONCOUNT
.Lj29:
# [153] end;
	movl	-16(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret	$12

.section .text.n_buttons_$$_addbutton$longint$longint$longint$longint$pointer$$longint,"x"
	.balign 16,0x90
.globl	BUTTONS_$$_ADDBUTTON$LONGINT$LONGINT$LONGINT$LONGINT$POINTER$$LONGINT
BUTTONS_$$_ADDBUTTON$LONGINT$LONGINT$LONGINT$LONGINT$POINTER$$LONGINT:
# [156] begin
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
# [157] Result := AddButtonEx(X, Y, W, H, OnClick, nil);
	pushl	12(%ebp)
	pushl	8(%ebp)
	pushl	$0
	movl	-12(%ebp),%ecx
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	call	BUTTONS_$$_ADDBUTTONEX$LONGINT$LONGINT$LONGINT$LONGINT$POINTER$POINTER$$LONGINT
	movl	%eax,-16(%ebp)
# [158] end;
	movl	-16(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret	$8

.section .text.n_buttons_$$_getlasthit$$longint,"x"
	.balign 16,0x90
.globl	BUTTONS_$$_GETLASTHIT$$LONGINT
BUTTONS_$$_GETLASTHIT$$LONGINT:
# [161] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-4(%esp),%esp
# Var $result located at ebp-4, size=OS_S32
# [162] Result := LastHit;
	movl	U_$BUTTONS_$$_LASTHIT,%eax
	movl	%eax,-4(%ebp)
# [163] end;
	movl	-4(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_buttons_$$_getoutsideclick$$boolean,"x"
	.balign 16,0x90
.globl	BUTTONS_$$_GETOUTSIDECLICK$$BOOLEAN
BUTTONS_$$_GETOUTSIDECLICK$$BOOLEAN:
# [166] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-4(%esp),%esp
# Var $result located at ebp-4, size=OS_8
# [167] Result := OutsideHit;
	movb	U_$BUTTONS_$$_OUTSIDEHIT,%al
	movb	%al,-4(%ebp)
# [168] OutsideHit := False;
	movb	$0,U_$BUTTONS_$$_OUTSIDEHIT
# [169] end;
	movb	-4(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_buttons_$$_removebutton$longint,"x"
	.balign 16,0x90
.globl	BUTTONS_$$_REMOVEBUTTON$LONGINT
BUTTONS_$$_REMOVEBUTTON$LONGINT:
# [174] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
	pushl	%esi
	pushl	%edi
# Var Index located at ebp-4, size=OS_S32
# Var i located at ebp-8, size=OS_S32
	movl	%eax,-4(%ebp)
# [175] if (Index < 0) or (Index >= ButtonCount) then
	cmpl	$0,-4(%ebp)
	jl	.Lj41
	jmp	.Lj42
.Lj42:
	movl	-4(%ebp),%eax
	cmpl	U_$BUTTONS_$$_BUTTONCOUNT,%eax
	jge	.Lj41
	jmp	.Lj43
.Lj41:
# [176] Exit;
	jmp	.Lj39
	.balign 4,0x90
.Lj43:
# [177] for i := Index to ButtonCount - 2 do
	movl	U_$BUTTONS_$$_BUTTONCOUNT,%eax
	leal	-2(%eax),%eax
	cmpl	-4(%ebp),%eax
	jge	.Lj44
	jmp	.Lj45
.Lj44:
	movl	-4(%ebp),%edx
	leal	-1(%edx),%edx
	movl	%edx,-8(%ebp)
	.balign 8,0x90
.Lj46:
	movl	-8(%ebp),%edx
	leal	1(%edx),%edx
	movl	%edx,-8(%ebp)
# [178] ButtonList[i] := ButtonList[i + 1];
	movl	-8(%ebp),%edx
	leal	1(%edx),%edx
	imull	$24,%edx,%ecx
	movl	-8(%ebp),%edx
	imull	$24,%edx,%edx
	leal	U_$BUTTONS_$$_BUTTONLIST(,%edx),%edi
	leal	U_$BUTTONS_$$_BUTTONLIST(,%ecx),%esi
	movl	$6,%ecx
	rep
	movsl
	cmpl	-8(%ebp),%eax
	jle	.Lj48
	jmp	.Lj46
.Lj48:
	.balign 4,0x90
.Lj45:
# [179] Dec(ButtonCount);
	subl	$1,U_$BUTTONS_$$_BUTTONCOUNT
.Lj39:
# [180] end;
	popl	%edi
	popl	%esi
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_buttons_$$_clearbuttons,"x"
	.balign 16,0x90
.globl	BUTTONS_$$_CLEARBUTTONS
BUTTONS_$$_CLEARBUTTONS:
# [183] begin
	pushl	%ebp
	movl	%esp,%ebp
# [184] ButtonCount := 0;
	movl	$0,U_$BUTTONS_$$_BUTTONCOUNT
# [185] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_buttons_$$_getbuttoncount$$longint,"x"
	.balign 16,0x90
.globl	BUTTONS_$$_GETBUTTONCOUNT$$LONGINT
BUTTONS_$$_GETBUTTONCOUNT$$LONGINT:
# [188] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-4(%esp),%esp
# Var $result located at ebp-4, size=OS_S32
# [189] Result := ButtonCount;
	movl	U_$BUTTONS_$$_BUTTONCOUNT,%eax
	movl	%eax,-4(%ebp)
# [190] end;
	movl	-4(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_buttons_$$_drawbutton$longint$longint$longint$longint$pchar,"x"
	.balign 16,0x90
.globl	BUTTONS_$$_DRAWBUTTON$LONGINT$LONGINT$LONGINT$LONGINT$PCHAR
BUTTONS_$$_DRAWBUTTON$LONGINT$LONGINT$LONGINT$LONGINT$PCHAR:
# [197] begin
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
# [198] FillRect(X, Y, W, H, $0F);
	pushl	12(%ebp)
	pushl	$15
	movl	-12(%ebp),%ecx
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [199] FillRect(X, Y, W, 1, 0);          // borda superior
	pushl	$1
	pushl	$0
	movl	-12(%ebp),%ecx
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [200] FillRect(X, Y + H - 1, W, 1, 0);  // borda inferior
	pushl	$1
	pushl	$0
	movl	-8(%ebp),%edx
	movl	12(%ebp),%eax
	leal	(%edx,%eax),%edx
	subl	$1,%edx
	movl	-12(%ebp),%ecx
	movl	-4(%ebp),%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [201] FillRect(X, Y, 1, H, 0);          // borda esquerda
	pushl	12(%ebp)
	pushl	$0
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	movl	$1,%ecx
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [202] FillRect(X + W - 1, Y, 1, H, 0);  // borda direita
	pushl	12(%ebp)
	pushl	$0
	movl	-4(%ebp),%eax
	movl	-12(%ebp),%edx
	leal	(%eax,%edx),%eax
	subl	$1,%eax
	movl	-8(%ebp),%edx
	movl	$1,%ecx
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [203] TX := X + (W - StrLen(Text) * Size) div 2;
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
# [204] TY := Y + (H - Size) div 2;
	movl	12(%ebp),%eax
	leal	-12(%eax),%eax
	movl	%eax,%edx
	shrl	$31,%edx
	addl	%edx,%eax
	sarl	$1,%eax
	addl	-8(%ebp),%eax
	movl	%eax,-20(%ebp)
# [205] WriteAt(TX, TY, Text, Size);
	pushl	$12
	movl	8(%ebp),%ecx
	movl	-20(%ebp),%edx
	movl	-16(%ebp),%eax
	call	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
# [206] end;
	movl	%ebp,%esp
	popl	%ebp
	ret	$8

.section .text.n_buttons_$$_createbutton$longint$longint$longint$longint$pchar$pointer$$longint,"x"
	.balign 16,0x90
.globl	BUTTONS_$$_CREATEBUTTON$LONGINT$LONGINT$LONGINT$LONGINT$PCHAR$POINTER$$LONGINT
BUTTONS_$$_CREATEBUTTON$LONGINT$LONGINT$LONGINT$LONGINT$PCHAR$POINTER$$LONGINT:
# [209] begin
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
# [210] DrawButton(X, Y, W, H, Text);
	pushl	16(%ebp)
	pushl	12(%ebp)
	movl	-12(%ebp),%ecx
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	call	BUTTONS_$$_DRAWBUTTON$LONGINT$LONGINT$LONGINT$LONGINT$PCHAR
# [211] Result := AddButton(X, Y, W, H, OnClick);
	pushl	16(%ebp)
	pushl	8(%ebp)
	movl	-12(%ebp),%ecx
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	call	BUTTONS_$$_ADDBUTTON$LONGINT$LONGINT$LONGINT$LONGINT$POINTER$$LONGINT
	movl	%eax,-16(%ebp)
# [212] end;
	movl	-16(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret	$12

.section .text.n_buttons_$$_checkbuttons,"x"
	.balign 16,0x90
.globl	BUTTONS_$$_CHECKBUTTONS
BUTTONS_$$_CHECKBUTTONS:
# [219] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-28(%esp),%esp
# Var B located at ebp-4, size=OS_S32
# Var i located at ebp-8, size=OS_S32
# Var MX located at ebp-12, size=OS_S32
# Var MY located at ebp-16, size=OS_S32
# Var NowSec located at ebp-20, size=OS_S32
# Var P located at ebp-24, size=OS_32
# Var D located at ebp-28, size=OS_32
# [220] B := GetMouseButtons;
	call	MOUSE_$$_GETMOUSEBUTTONS$$BYTE
	movzbl	%al,%eax
	movl	%eax,-4(%ebp)
# [221] if (B and 1) <> 0 then
	movl	-4(%ebp),%eax
	andl	$1,%eax
	testl	$-1,%eax
	jne	.Lj59
	jmp	.Lj60
.Lj59:
# [222] if (PrevButtons and 1) = 0 then
	movzbw	U_$BUTTONS_$$_PREVBUTTONS,%ax
	andw	$1,%ax
	testw	$-1,%ax
	je	.Lj61
	jmp	.Lj62
.Lj61:
# [224] MX := GetMouseX;
	call	MOUSE_$$_GETMOUSEX$$LONGINT
	movl	%eax,-12(%ebp)
# [225] MY := GetMouseY;
	call	MOUSE_$$_GETMOUSEY$$LONGINT
	movl	%eax,-16(%ebp)
# [226] LastHit := -1;
	movl	$-1,U_$BUTTONS_$$_LASTHIT
# [227] for i := 0 to ButtonCount - 1 do
	movl	U_$BUTTONS_$$_BUTTONCOUNT,%eax
	leal	-1(%eax),%eax
	cmpl	$0,%eax
	jge	.Lj63
	jmp	.Lj64
.Lj63:
	movl	$-1,-8(%ebp)
	.balign 8,0x90
.Lj65:
	movl	-8(%ebp),%edx
	leal	1(%edx),%edx
	movl	%edx,-8(%ebp)
# [228] if (MX >= ButtonList[i].X) and (MX < ButtonList[i].X + ButtonList[i].W) and
	movl	-8(%ebp),%edx
	imull	$24,%edx,%edx
	movl	U_$BUTTONS_$$_BUTTONLIST(,%edx),%edx
	cmpl	-12(%ebp),%edx
	jle	.Lj68
	jmp	.Lj69
.Lj68:
	movl	-8(%ebp),%edx
	imull	$24,%edx,%ecx
	movl	-8(%ebp),%edx
	imull	$24,%edx,%edx
	movl	U_$BUTTONS_$$_BUTTONLIST(,%ecx),%ecx
	movl	U_$BUTTONS_$$_BUTTONLIST+8(,%edx),%edx
	leal	(%ecx,%edx),%edx
	cmpl	-12(%ebp),%edx
	jg	.Lj70
	jmp	.Lj69
.Lj70:
# [229] (MY >= ButtonList[i].Y) and (MY < ButtonList[i].Y + ButtonList[i].H) then
	movl	-8(%ebp),%edx
	imull	$24,%edx,%edx
	movl	U_$BUTTONS_$$_BUTTONLIST+4(,%edx),%edx
	cmpl	-16(%ebp),%edx
	jle	.Lj71
	jmp	.Lj69
.Lj71:
	movl	-8(%ebp),%edx
	imull	$24,%edx,%ecx
	movl	-8(%ebp),%edx
	imull	$24,%edx,%edx
	movl	U_$BUTTONS_$$_BUTTONLIST+4(,%ecx),%ecx
	movl	U_$BUTTONS_$$_BUTTONLIST+12(,%edx),%edx
	leal	(%ecx,%edx),%edx
	cmpl	-16(%ebp),%edx
	jg	.Lj72
	jmp	.Lj69
.Lj72:
# [231] LastHit := i;
	movl	-8(%ebp),%edx
	movl	%edx,U_$BUTTONS_$$_LASTHIT
# [232] Break;
	jmp	.Lj67
	.balign 4,0x90
.Lj69:
	cmpl	-8(%ebp),%eax
	jle	.Lj67
	jmp	.Lj65
.Lj67:
	.balign 4,0x90
.Lj64:
# [235] if LastHit >= 0 then
	cmpl	$0,U_$BUTTONS_$$_LASTHIT
	jge	.Lj73
	jmp	.Lj74
.Lj73:
# [237] NowSec := RTCMonotonic;
	call	BUTTONS_$$_RTCMONOTONIC$$LONGINT
	movl	%eax,-20(%ebp)
# [238] if (LastHit = PrevHit) and (PrevHitSec >= 0) and
	movl	U_$BUTTONS_$$_LASTHIT,%eax
	cmpl	U_$BUTTONS_$$_PREVHIT,%eax
	je	.Lj75
	jmp	.Lj76
.Lj75:
	cmpl	$0,U_$BUTTONS_$$_PREVHITSEC
	jge	.Lj77
	jmp	.Lj76
.Lj77:
# [239] (NowSec - PrevHitSec <= 1) then
	movl	-20(%ebp),%eax
	movl	U_$BUTTONS_$$_PREVHITSEC,%edx
	subl	%edx,%eax
	cmpl	$1,%eax
	jle	.Lj78
	jmp	.Lj76
.Lj78:
# [242] PrevHit := -1;
	movl	$-1,U_$BUTTONS_$$_PREVHIT
# [243] PrevHitSec := -1;
	movl	$-1,U_$BUTTONS_$$_PREVHITSEC
# [244] if ButtonList[LastHit].OnDblClick <> nil then
	movl	U_$BUTTONS_$$_LASTHIT,%eax
	imull	$24,%eax,%eax
	cmpl	$0,U_$BUTTONS_$$_BUTTONLIST+20(,%eax)
	jne	.Lj79
	jmp	.Lj80
.Lj79:
# [246] D := TButtonDblProc(ButtonList[LastHit].OnDblClick);
	movl	U_$BUTTONS_$$_LASTHIT,%eax
	imull	$24,%eax,%eax
	movl	U_$BUTTONS_$$_BUTTONLIST+20(,%eax),%eax
	movl	%eax,-28(%ebp)
# [247] D;
	call	*-28(%ebp)
	.balign 4,0x90
.Lj80:
	jmp	.Lj81
.Lj76:
# [253] PrevHit := LastHit;
	movl	U_$BUTTONS_$$_LASTHIT,%eax
	movl	%eax,U_$BUTTONS_$$_PREVHIT
# [254] PrevHitSec := NowSec;
	movl	-20(%ebp),%eax
	movl	%eax,U_$BUTTONS_$$_PREVHITSEC
# [255] if ButtonList[LastHit].OnClick <> nil then
	movl	U_$BUTTONS_$$_LASTHIT,%eax
	imull	$24,%eax,%eax
	cmpl	$0,U_$BUTTONS_$$_BUTTONLIST+16(,%eax)
	jne	.Lj82
	jmp	.Lj83
.Lj82:
# [257] P := TButtonProc(ButtonList[LastHit].OnClick);
	movl	U_$BUTTONS_$$_LASTHIT,%eax
	imull	$24,%eax,%eax
	movl	U_$BUTTONS_$$_BUTTONLIST+16(,%eax),%eax
	movl	%eax,-24(%ebp)
# [258] P;
	call	*-24(%ebp)
	.balign 4,0x90
.Lj83:
.Lj81:
	jmp	.Lj84
.Lj74:
# [265] PrevHit := -1;
	movl	$-1,U_$BUTTONS_$$_PREVHIT
# [266] PrevHitSec := -1;
	movl	$-1,U_$BUTTONS_$$_PREVHITSEC
# [267] OutsideHit := True;
	movb	$1,U_$BUTTONS_$$_OUTSIDEHIT
.Lj84:
	.balign 4,0x90
.Lj62:
	.balign 4,0x90
.Lj60:
# [270] PrevButtons := B;
	movb	-4(%ebp),%al
	movb	%al,U_$BUTTONS_$$_PREVBUTTONS
# [271] end;
	movl	%ebp,%esp
	popl	%ebp
	ret
# End asmlist al_procedures
# Begin asmlist al_globals

.section .bss
	.balign 4
# [64] ButtonList: array[0..MaxButtons - 1] of TButton;
U_$BUTTONS_$$_BUTTONLIST:
	.zero 1536

.section .bss
	.balign 4
# [65] ButtonCount: Integer;
U_$BUTTONS_$$_BUTTONCOUNT:
	.zero 4

.section .bss
# [66] PrevButtons: Byte;
U_$BUTTONS_$$_PREVBUTTONS:
	.zero 1

.section .bss
	.balign 4
# [67] LastHit: Integer;
U_$BUTTONS_$$_LASTHIT:
	.zero 4

.section .bss
	.balign 4
# [68] PrevHit: Integer;
U_$BUTTONS_$$_PREVHIT:
	.zero 4

.section .bss
	.balign 4
# [69] PrevHitSec: Integer;
U_$BUTTONS_$$_PREVHITSEC:
	.zero 4

.section .bss
# [70] OutsideHit: Boolean;
U_$BUTTONS_$$_OUTSIDEHIT:
	.zero 1
# End asmlist al_globals

