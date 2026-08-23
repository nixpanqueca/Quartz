	.file "video.pas"
# Begin asmlist al_procedures

.section .text.n_video_$$_outb$word$byte,"x"
	.balign 16,0x90
VIDEO_$$_OUTB$WORD$BYTE:
# [video.pas]
# [36] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var Addr located at ebp-4, size=OS_16
# Var Value located at ebp-8, size=OS_8
	movw	%ax,-4(%ebp)
	movb	%dl,-8(%ebp)
#  CPU PENTIUM
# [38] mov dx, Addr
	movw	-4(%ebp),%dx
# [39] mov al, Value
	movb	-8(%ebp),%al
# [40] out dx, al
	outb	%al,%dx
#  CPU PENTIUM
# [42] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_video_$$_videoinit,"x"
	.balign 16,0x90
.globl	VIDEO_$$_VIDEOINIT
VIDEO_$$_VIDEOINIT:
# [48] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-16(%esp),%esp
# Var i located at ebp-4, size=OS_S32
# Var r located at ebp-8, size=OS_8
# Var g located at ebp-12, size=OS_8
# Var b located at ebp-16, size=OS_8
# [49] Framebuffer := PByte(PLongWord($1000)^);
	movl	4096,%eax
	movl	%eax,U_$VIDEO_$$_FRAMEBUFFER
# [50] RWidth := Integer(PWord($1004)^);
	movzwl	4100,%eax
	movl	%eax,U_$VIDEO_$$_RWIDTH
# [51] RHeight := Integer(PWord($1006)^);
	movzwl	4102,%eax
	movl	%eax,U_$VIDEO_$$_RHEIGHT
# [52] OutB($3C8, 0);
	movb	$0,%dl
	movw	$968,%ax
	call	VIDEO_$$_OUTB$WORD$BYTE
# [53] for i := 0 to 15 do
	movl	$-1,-4(%ebp)
	.balign 8,0x90
.Lj7:
	movl	-4(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-4(%ebp)
# [55] case i of
	movl	-4(%ebp),%eax
	testl	%eax,%eax
	jl	.Lj11
	testl	%eax,%eax
	je	.Lj12
	subl	$15,%eax
	je	.Lj13
	jmp	.Lj11
	.balign 4,0x90
.Lj12:
# [56] 0:  begin r := 0;  g := 0;  b := 0;  end;
	movb	$0,-8(%ebp)
	movb	$0,-12(%ebp)
	movb	$0,-16(%ebp)
	jmp	.Lj10
	.balign 4,0x90
.Lj13:
# [57] 15: begin r := 63; g := 63; b := 63; end;
	movb	$63,-8(%ebp)
	movb	$63,-12(%ebp)
	movb	$63,-16(%ebp)
	jmp	.Lj10
	.balign 4,0x90
.Lj11:
# [59] begin r := 0; g := 0; b := 0; end;
	movb	$0,-8(%ebp)
	movb	$0,-12(%ebp)
	movb	$0,-16(%ebp)
	.balign 4,0x90
.Lj10:
# [61] OutB($3C9, r);
	movb	-8(%ebp),%dl
	movw	$969,%ax
	call	VIDEO_$$_OUTB$WORD$BYTE
# [62] OutB($3C9, g);
	movb	-12(%ebp),%dl
	movw	$969,%ax
	call	VIDEO_$$_OUTB$WORD$BYTE
# [63] OutB($3C9, b);
	movb	-16(%ebp),%dl
	movw	$969,%ax
	call	VIDEO_$$_OUTB$WORD$BYTE
	cmpl	$15,-4(%ebp)
	jge	.Lj9
	jmp	.Lj7
.Lj9:
# [65] for i := 0 to 215 do
	movl	$-1,-4(%ebp)
	.balign 8,0x90
.Lj14:
	movl	-4(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-4(%ebp)
# [67] r := (i div 36) * 51 div 4;
	movl	-4(%ebp),%ecx
	movl	$954437177,%eax
	imull	%ecx
	sarl	$3,%edx
	shrl	$31,%ecx
	addl	%ecx,%edx
	imull	$51,%edx
	movl	%edx,%eax
	sarl	$31,%eax
	andl	$3,%eax
	addl	%eax,%edx
	sarl	$2,%edx
	movb	%dl,-8(%ebp)
# [68] g := ((i mod 36) div 6) * 51 div 4;
	movl	-4(%ebp),%eax
	cltd
	movl	$36,%ecx
	idivl	%ecx
	movl	%edx,%ecx
	movl	$715827883,%eax
	imull	%ecx
	shrl	$31,%ecx
	addl	%ecx,%edx
	imull	$51,%edx
	movl	%edx,%eax
	sarl	$31,%eax
	andl	$3,%eax
	addl	%eax,%edx
	sarl	$2,%edx
	movb	%dl,-12(%ebp)
# [69] b := (i mod 6) * 51 div 4;
	movl	-4(%ebp),%eax
	cltd
	movl	$6,%ecx
	idivl	%ecx
	imull	$51,%edx
	movl	%edx,%eax
	sarl	$31,%eax
	andl	$3,%eax
	addl	%eax,%edx
	sarl	$2,%edx
	movb	%dl,-16(%ebp)
# [70] OutB($3C9, r);
	movb	-8(%ebp),%dl
	movw	$969,%ax
	call	VIDEO_$$_OUTB$WORD$BYTE
# [71] OutB($3C9, g);
	movb	-12(%ebp),%dl
	movw	$969,%ax
	call	VIDEO_$$_OUTB$WORD$BYTE
# [72] OutB($3C9, b);
	movb	-16(%ebp),%dl
	movw	$969,%ax
	call	VIDEO_$$_OUTB$WORD$BYTE
	cmpl	$215,-4(%ebp)
	jge	.Lj16
	jmp	.Lj14
.Lj16:
# [74] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_video_$$_putpixel$longint$longint$byte,"x"
	.balign 16,0x90
.globl	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE:
# [77] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-12(%esp),%esp
# Var X located at ebp-4, size=OS_S32
# Var Y located at ebp-8, size=OS_S32
# Var Color located at ebp-12, size=OS_8
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movb	%cl,-12(%ebp)
# [78] Framebuffer[(Y * RWidth) + X] := Color;
	movl	U_$VIDEO_$$_FRAMEBUFFER,%edx
	movl	-8(%ebp),%ecx
	movl	U_$VIDEO_$$_RWIDTH,%eax
	imull	%ecx,%eax
	addl	-4(%ebp),%eax
	movb	-12(%ebp),%cl
	movb	%cl,(%edx,%eax,1)
# [79] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_video_$$_fillrect$longint$longint$longint$longint$byte,"x"
	.balign 16,0x90
.globl	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE:
# [84] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-20(%esp),%esp
	pushl	%ebx
	pushl	%esi
# Var X located at ebp-4, size=OS_S32
# Var Y located at ebp-8, size=OS_S32
# Var W located at ebp-12, size=OS_S32
# Var H located at ebp+12, size=OS_S32
# Var Color located at ebp+8, size=OS_8
# Var YY located at ebp-16, size=OS_S32
# Var XX located at ebp-20, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [85] for YY := Y to Y + H - 1 do
	movl	-8(%ebp),%eax
	movl	12(%ebp),%edx
	leal	(%eax,%edx),%eax
	subl	$1,%eax
	cmpl	-8(%ebp),%eax
	jge	.Lj21
	jmp	.Lj22
.Lj21:
	movl	-8(%ebp),%edx
	leal	-1(%edx),%edx
	movl	%edx,-16(%ebp)
	.balign 8,0x90
.Lj23:
	movl	-16(%ebp),%edx
	leal	1(%edx),%edx
	movl	%edx,-16(%ebp)
# [86] if (YY >= 0) and (YY < RHeight) then
	cmpl	$0,-16(%ebp)
	jge	.Lj26
	jmp	.Lj27
.Lj26:
	movl	-16(%ebp),%edx
	cmpl	U_$VIDEO_$$_RHEIGHT,%edx
	jl	.Lj28
	jmp	.Lj27
.Lj28:
# [87] for XX := X to X + W - 1 do
	movl	-4(%ebp),%edx
	movl	-12(%ebp),%ecx
	leal	(%edx,%ecx),%edx
	subl	$1,%edx
	cmpl	-4(%ebp),%edx
	jge	.Lj29
	jmp	.Lj30
.Lj29:
	movl	-4(%ebp),%ecx
	leal	-1(%ecx),%ecx
	movl	%ecx,-20(%ebp)
	.balign 8,0x90
.Lj31:
	movl	-20(%ebp),%ecx
	leal	1(%ecx),%ecx
	movl	%ecx,-20(%ebp)
# [88] if (XX >= 0) and (XX < RWidth) then
	cmpl	$0,-20(%ebp)
	jge	.Lj34
	jmp	.Lj35
.Lj34:
	movl	-20(%ebp),%ecx
	cmpl	U_$VIDEO_$$_RWIDTH,%ecx
	jl	.Lj36
	jmp	.Lj35
.Lj36:
# [89] Framebuffer[YY * RWidth + XX] := Color;
	movl	U_$VIDEO_$$_FRAMEBUFFER,%esi
	movl	-16(%ebp),%ecx
	movl	U_$VIDEO_$$_RWIDTH,%ebx
	imull	%ecx,%ebx
	addl	-20(%ebp),%ebx
	movb	8(%ebp),%cl
	movb	%cl,(%esi,%ebx,1)
	.balign 4,0x90
.Lj35:
	cmpl	-20(%ebp),%edx
	jle	.Lj33
	jmp	.Lj31
.Lj33:
	.balign 4,0x90
.Lj30:
	.balign 4,0x90
.Lj27:
	cmpl	-16(%ebp),%eax
	jle	.Lj25
	jmp	.Lj23
.Lj25:
	.balign 4,0x90
.Lj22:
# [90] end;
	popl	%esi
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret	$8

.section .text.n_video_$$_clearscreen$byte,"x"
	.balign 16,0x90
.globl	VIDEO_$$_CLEARSCREEN$BYTE
VIDEO_$$_CLEARSCREEN$BYTE:
# [95] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
	pushl	%ebx
# Var Color located at ebp-4, size=OS_8
# Var i located at ebp-8, size=OS_S32
	movb	%al,-4(%ebp)
# [96] for i := 0 to (RWidth * RHeight) - 1 do
	movl	U_$VIDEO_$$_RWIDTH,%edx
	movl	U_$VIDEO_$$_RHEIGHT,%eax
	imull	%edx,%eax
	subl	$1,%eax
	cmpl	$0,%eax
	jge	.Lj39
	jmp	.Lj40
.Lj39:
	movl	$-1,-8(%ebp)
	.balign 8,0x90
.Lj41:
	movl	-8(%ebp),%edx
	leal	1(%edx),%edx
	movl	%edx,-8(%ebp)
# [98] Framebuffer[i] := Color;
	movl	U_$VIDEO_$$_FRAMEBUFFER,%ecx
	movl	-8(%ebp),%ebx
	movb	-4(%ebp),%dl
	movb	%dl,(%ecx,%ebx,1)
	cmpl	-8(%ebp),%eax
	jle	.Lj43
	jmp	.Lj41
.Lj43:
	.balign 4,0x90
.Lj40:
# [100] end;
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_video_$$_fillpattern8x8$array_of_byte$byte$byte,"x"
	.balign 16,0x90
.globl	VIDEO_$$_FILLPATTERN8X8$array_of_BYTE$BYTE$BYTE
VIDEO_$$_FILLPATTERN8X8$array_of_BYTE$BYTE$BYTE:
# [105] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-20(%esp),%esp
	pushl	%ebx
	pushl	%esi
# Var Pattern located at ebp-4, size=OS_32
# Var On located at ebp-8, size=OS_8
# Var Off located at ebp+8, size=OS_8
# Var $highPATTERN located at ebp-12, size=OS_S32
# Var Y located at ebp-16, size=OS_S32
# Var X located at ebp-20, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-12(%ebp)
	movb	%cl,-8(%ebp)
# [106] for Y := 0 to RHeight - 1 do
	movl	U_$VIDEO_$$_RHEIGHT,%eax
	leal	-1(%eax),%eax
	cmpl	$0,%eax
	jge	.Lj46
	jmp	.Lj47
.Lj46:
	movl	$-1,-16(%ebp)
	.balign 8,0x90
.Lj48:
	movl	-16(%ebp),%edx
	leal	1(%edx),%edx
	movl	%edx,-16(%ebp)
# [108] for X := 0 to RWidth - 1 do
	movl	U_$VIDEO_$$_RWIDTH,%edx
	leal	-1(%edx),%edx
	cmpl	$0,%edx
	jge	.Lj51
	jmp	.Lj52
.Lj51:
	movl	$-1,-20(%ebp)
	.balign 8,0x90
.Lj53:
	movl	-20(%ebp),%ecx
	leal	1(%ecx),%ecx
	movl	%ecx,-20(%ebp)
# [110] if (Pattern[Y and 7] and ($80 shr (X and 7))) <> 0 then
	movl	-4(%ebp),%ebx
	movl	-16(%ebp),%ecx
	andl	$7,%ecx
	movzbl	(%ebx,%ecx,1),%ebx
	movl	-20(%ebp),%ecx
	andl	$7,%ecx
	movl	$128,%esi
	shrl	%cl,%esi
	andl	%esi,%ebx
	testl	$-1,%ebx
	jne	.Lj56
	jmp	.Lj57
.Lj56:
# [111] Framebuffer[Y * RWidth + X] := On
	movl	U_$VIDEO_$$_FRAMEBUFFER,%esi
	movl	-16(%ebp),%ecx
	movl	U_$VIDEO_$$_RWIDTH,%ebx
	imull	%ecx,%ebx
	addl	-20(%ebp),%ebx
	movb	-8(%ebp),%cl
	movb	%cl,(%esi,%ebx,1)
	jmp	.Lj58
.Lj57:
# [113] Framebuffer[Y * RWidth + X] := Off;
	movl	U_$VIDEO_$$_FRAMEBUFFER,%esi
	movl	-16(%ebp),%ecx
	movl	U_$VIDEO_$$_RWIDTH,%ebx
	imull	%ecx,%ebx
	addl	-20(%ebp),%ebx
	movb	8(%ebp),%cl
	movb	%cl,(%esi,%ebx,1)
.Lj58:
	cmpl	-20(%ebp),%edx
	jle	.Lj55
	jmp	.Lj53
.Lj55:
	.balign 4,0x90
.Lj52:
	cmpl	-16(%ebp),%eax
	jle	.Lj50
	jmp	.Lj48
.Lj50:
	.balign 4,0x90
.Lj47:
# [116] end;
	popl	%esi
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret	$4

.section .text.n_video_$$_fillpatternrect$longint$longint$longint$longint$array_of_byte$byte$byte,"x"
	.balign 16,0x90
.globl	VIDEO_$$_FILLPATTERNRECT$LONGINT$LONGINT$LONGINT$LONGINT$array_of_BYTE$BYTE$BYTE
VIDEO_$$_FILLPATTERNRECT$LONGINT$LONGINT$LONGINT$LONGINT$array_of_BYTE$BYTE$BYTE:
# [121] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-20(%esp),%esp
	pushl	%ebx
	pushl	%esi
# Var X located at ebp-4, size=OS_S32
# Var Y located at ebp-8, size=OS_S32
# Var W located at ebp-12, size=OS_S32
# Var H located at ebp+24, size=OS_S32
# Var Pattern located at ebp+20, size=OS_32
# Var On located at ebp+12, size=OS_8
# Var Off located at ebp+8, size=OS_8
# Var $highPATTERN located at ebp+16, size=OS_S32
# Var YY located at ebp-16, size=OS_S32
# Var XX located at ebp-20, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [122] for YY := Y to Y + H - 1 do
	movl	-8(%ebp),%eax
	movl	24(%ebp),%edx
	leal	(%eax,%edx),%eax
	subl	$1,%eax
	cmpl	-8(%ebp),%eax
	jge	.Lj61
	jmp	.Lj62
.Lj61:
	movl	-8(%ebp),%edx
	leal	-1(%edx),%edx
	movl	%edx,-16(%ebp)
	.balign 8,0x90
.Lj63:
	movl	-16(%ebp),%edx
	leal	1(%edx),%edx
	movl	%edx,-16(%ebp)
# [123] if (YY >= 0) and (YY < RHeight) then
	cmpl	$0,-16(%ebp)
	jge	.Lj66
	jmp	.Lj67
.Lj66:
	movl	-16(%ebp),%edx
	cmpl	U_$VIDEO_$$_RHEIGHT,%edx
	jl	.Lj68
	jmp	.Lj67
.Lj68:
# [124] for XX := X to X + W - 1 do
	movl	-4(%ebp),%edx
	movl	-12(%ebp),%ecx
	leal	(%edx,%ecx),%edx
	subl	$1,%edx
	cmpl	-4(%ebp),%edx
	jge	.Lj69
	jmp	.Lj70
.Lj69:
	movl	-4(%ebp),%ecx
	leal	-1(%ecx),%ecx
	movl	%ecx,-20(%ebp)
	.balign 8,0x90
.Lj71:
	movl	-20(%ebp),%ecx
	leal	1(%ecx),%ecx
	movl	%ecx,-20(%ebp)
# [125] if (XX >= 0) and (XX < RWidth) then
	cmpl	$0,-20(%ebp)
	jge	.Lj74
	jmp	.Lj75
.Lj74:
	movl	-20(%ebp),%ecx
	cmpl	U_$VIDEO_$$_RWIDTH,%ecx
	jl	.Lj76
	jmp	.Lj75
.Lj76:
# [126] if (Pattern[YY and 7] and ($80 shr (XX and 7))) <> 0 then
	movl	20(%ebp),%ebx
	movl	-16(%ebp),%ecx
	andl	$7,%ecx
	movzbl	(%ebx,%ecx,1),%ebx
	movl	-20(%ebp),%ecx
	andl	$7,%ecx
	movl	$128,%esi
	shrl	%cl,%esi
	andl	%esi,%ebx
	testl	$-1,%ebx
	jne	.Lj77
	jmp	.Lj78
.Lj77:
# [127] Framebuffer[YY * RWidth + XX] := On
	movl	U_$VIDEO_$$_FRAMEBUFFER,%esi
	movl	-16(%ebp),%ecx
	movl	U_$VIDEO_$$_RWIDTH,%ebx
	imull	%ecx,%ebx
	addl	-20(%ebp),%ebx
	movb	12(%ebp),%cl
	movb	%cl,(%esi,%ebx,1)
	jmp	.Lj79
.Lj78:
# [129] Framebuffer[YY * RWidth + XX] := Off;
	movl	U_$VIDEO_$$_FRAMEBUFFER,%esi
	movl	-16(%ebp),%ecx
	movl	U_$VIDEO_$$_RWIDTH,%ebx
	imull	%ecx,%ebx
	addl	-20(%ebp),%ebx
	movb	8(%ebp),%cl
	movb	%cl,(%esi,%ebx,1)
.Lj79:
	.balign 4,0x90
.Lj75:
	cmpl	-20(%ebp),%edx
	jle	.Lj73
	jmp	.Lj71
.Lj73:
	.balign 4,0x90
.Lj70:
	.balign 4,0x90
.Lj67:
	cmpl	-16(%ebp),%eax
	jle	.Lj65
	jmp	.Lj63
.Lj65:
	.balign 4,0x90
.Lj62:
# [130] end;
	popl	%esi
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret	$20

.section .text.n_video_$$_drawcursorshape$array_of_word$longint$longint$byte,"x"
	.balign 16,0x90
VIDEO_$$_DRAWCURSORSHAPE$array_of_WORD$LONGINT$LONGINT$BYTE:
# [149] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-20(%esp),%esp
# Var Shape located at ebp-4, size=OS_32
# Var X located at ebp-8, size=OS_S32
# Var Y located at ebp+12, size=OS_S32
# Var Color located at ebp+8, size=OS_8
# Var $highSHAPE located at ebp-12, size=OS_S32
# Var R located at ebp-16, size=OS_S32
# Var C located at ebp-20, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-12(%ebp)
	movl	%ecx,-8(%ebp)
# [150] for R := 0 to 15 do
	movl	$-1,-16(%ebp)
	.balign 8,0x90
.Lj82:
	movl	-16(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-16(%ebp)
# [152] if (Y + R < 0) or (Y + R >= RHeight) then
	movl	12(%ebp),%eax
	movl	-16(%ebp),%edx
	leal	(%eax,%edx),%eax
	cmpl	$0,%eax
	jl	.Lj85
	jmp	.Lj86
.Lj86:
	movl	12(%ebp),%eax
	movl	-16(%ebp),%edx
	leal	(%eax,%edx),%eax
	cmpl	U_$VIDEO_$$_RHEIGHT,%eax
	jge	.Lj85
	jmp	.Lj87
.Lj85:
# [153] Continue;
	jmp	.Lj83
	.balign 4,0x90
.Lj87:
# [154] for C := 0 to 15 do
	movl	$-1,-20(%ebp)
	.balign 8,0x90
.Lj88:
	movl	-20(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-20(%ebp)
# [156] if (X + C < 0) or (X + C >= RWidth) then
	movl	-8(%ebp),%eax
	movl	-20(%ebp),%edx
	leal	(%eax,%edx),%eax
	cmpl	$0,%eax
	jl	.Lj91
	jmp	.Lj92
.Lj92:
	movl	-8(%ebp),%eax
	movl	-20(%ebp),%edx
	leal	(%eax,%edx),%eax
	cmpl	U_$VIDEO_$$_RWIDTH,%eax
	jge	.Lj91
	jmp	.Lj93
.Lj91:
# [157] Continue;
	jmp	.Lj89
	.balign 4,0x90
.Lj93:
# [158] if (Shape[R] and (1 shl (15 - C))) <> 0 then
	movl	-20(%ebp),%eax
	movl	$15,%ecx
	subl	%eax,%ecx
	movl	$1,%eax
	shll	%cl,%eax
	movl	-4(%ebp),%ecx
	movl	-16(%ebp),%edx
	movzwl	(%ecx,%edx,2),%edx
	andl	%edx,%eax
	testl	$-1,%eax
	jne	.Lj94
	jmp	.Lj95
.Lj94:
# [159] Framebuffer[(Y + R) * RWidth + X + C] := Color;
	movl	U_$VIDEO_$$_FRAMEBUFFER,%ecx
	movl	12(%ebp),%eax
	movl	-16(%ebp),%edx
	leal	(%eax,%edx),%edx
	movl	U_$VIDEO_$$_RWIDTH,%eax
	imull	%eax,%edx
	addl	-8(%ebp),%edx
	addl	-20(%ebp),%edx
	movb	8(%ebp),%al
	movb	%al,(%ecx,%edx,1)
	.balign 4,0x90
.Lj95:
.Lj89:
	cmpl	$15,-20(%ebp)
	jge	.Lj90
	jmp	.Lj88
.Lj90:
.Lj83:
	cmpl	$15,-16(%ebp)
	jge	.Lj84
	jmp	.Lj82
.Lj84:
# [162] end;
	movl	%ebp,%esp
	popl	%ebp
	ret	$8

.section .text.n_video_$$_drawcursor$longint$longint,"x"
	.balign 16,0x90
.globl	VIDEO_$$_DRAWCURSOR$LONGINT$LONGINT
VIDEO_$$_DRAWCURSOR$LONGINT$LONGINT:
# [165] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var X located at ebp-4, size=OS_S32
# Var Y located at ebp-8, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
# [166] DrawCursorShape(CursorMask, X, Y, $0F);
	pushl	-8(%ebp)
	pushl	$15
	movl	-4(%ebp),%ecx
	movl	$TC_$VIDEO_$$_CURSORMASK,%eax
	movl	$15,%edx
	call	VIDEO_$$_DRAWCURSORSHAPE$array_of_WORD$LONGINT$LONGINT$BYTE
# [167] DrawCursorShape(CursorData, X, Y, 0);
	pushl	-8(%ebp)
	pushl	$0
	movl	-4(%ebp),%ecx
	movl	$TC_$VIDEO_$$_CURSORDATA,%eax
	movl	$15,%edx
	call	VIDEO_$$_DRAWCURSORSHAPE$array_of_WORD$LONGINT$LONGINT$BYTE
# [168] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_video_$$_savecursorarea$longint$longint,"x"
	.balign 16,0x90
.globl	VIDEO_$$_SAVECURSORAREA$LONGINT$LONGINT
VIDEO_$$_SAVECURSORAREA$LONGINT$LONGINT:
# [180] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-16(%esp),%esp
# Var X located at ebp-4, size=OS_S32
# Var Y located at ebp-8, size=OS_S32
# Var R located at ebp-12, size=OS_S32
# Var C located at ebp-16, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
# [181] for R := 0 to CursorH - 1 do
	movl	$-1,-12(%ebp)
	.balign 8,0x90
.Lj100:
	movl	-12(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-12(%ebp)
# [182] for C := 0 to CursorW - 1 do
	movl	$-1,-16(%ebp)
	.balign 8,0x90
.Lj103:
	movl	-16(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-16(%ebp)
# [184] if (Y - 1 + R >= 0) and (Y - 1 + R < RHeight) and
	movl	-8(%ebp),%eax
	leal	-1(%eax),%eax
	addl	-12(%ebp),%eax
	cmpl	$0,%eax
	jge	.Lj106
	jmp	.Lj107
.Lj106:
	movl	-8(%ebp),%eax
	leal	-1(%eax),%eax
	addl	-12(%ebp),%eax
	cmpl	U_$VIDEO_$$_RHEIGHT,%eax
	jl	.Lj108
	jmp	.Lj107
.Lj108:
# [185] (X - 1 + C >= 0) and (X - 1 + C < RWidth) then
	movl	-4(%ebp),%eax
	leal	-1(%eax),%eax
	addl	-16(%ebp),%eax
	cmpl	$0,%eax
	jge	.Lj109
	jmp	.Lj107
.Lj109:
	movl	-4(%ebp),%eax
	leal	-1(%eax),%eax
	addl	-16(%ebp),%eax
	cmpl	U_$VIDEO_$$_RWIDTH,%eax
	jl	.Lj110
	jmp	.Lj107
.Lj110:
# [186] CursorBack[R * CursorW + C] := Framebuffer[(Y - 1 + R) * RWidth + (X - 1 + C)]
	movl	U_$VIDEO_$$_FRAMEBUFFER,%edx
	movl	-8(%ebp),%eax
	leal	-1(%eax),%ecx
	addl	-12(%ebp),%ecx
	movl	U_$VIDEO_$$_RWIDTH,%eax
	imull	%eax,%ecx
	movl	-4(%ebp),%eax
	leal	-1(%eax),%eax
	addl	-16(%ebp),%eax
	leal	(%ecx,%eax),%ecx
	movl	-12(%ebp),%eax
	imull	$18,%eax,%eax
	addl	-16(%ebp),%eax
	movb	(%edx,%ecx,1),%dl
	movb	%dl,U_$VIDEO_$$_CURSORBACK(,%eax,1)
	jmp	.Lj111
.Lj107:
# [188] CursorBack[R * CursorW + C] := 0;
	movl	-12(%ebp),%eax
	imull	$18,%eax,%eax
	addl	-16(%ebp),%eax
	movb	$0,U_$VIDEO_$$_CURSORBACK(,%eax,1)
.Lj111:
	cmpl	$17,-16(%ebp)
	jge	.Lj105
	jmp	.Lj103
.Lj105:
	cmpl	$17,-12(%ebp)
	jge	.Lj102
	jmp	.Lj100
.Lj102:
# [190] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_video_$$_restorecursorarea$longint$longint,"x"
	.balign 16,0x90
.globl	VIDEO_$$_RESTORECURSORAREA$LONGINT$LONGINT
VIDEO_$$_RESTORECURSORAREA$LONGINT$LONGINT:
# [195] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-16(%esp),%esp
# Var X located at ebp-4, size=OS_S32
# Var Y located at ebp-8, size=OS_S32
# Var R located at ebp-12, size=OS_S32
# Var C located at ebp-16, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
# [196] for R := 0 to CursorH - 1 do
	movl	$-1,-12(%ebp)
	.balign 8,0x90
.Lj114:
	movl	-12(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-12(%ebp)
# [197] for C := 0 to CursorW - 1 do
	movl	$-1,-16(%ebp)
	.balign 8,0x90
.Lj117:
	movl	-16(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-16(%ebp)
# [199] if (Y - 1 + R >= 0) and (Y - 1 + R < RHeight) and
	movl	-8(%ebp),%eax
	leal	-1(%eax),%eax
	addl	-12(%ebp),%eax
	cmpl	$0,%eax
	jge	.Lj120
	jmp	.Lj121
.Lj120:
	movl	-8(%ebp),%eax
	leal	-1(%eax),%eax
	addl	-12(%ebp),%eax
	cmpl	U_$VIDEO_$$_RHEIGHT,%eax
	jl	.Lj122
	jmp	.Lj121
.Lj122:
# [200] (X - 1 + C >= 0) and (X - 1 + C < RWidth) then
	movl	-4(%ebp),%eax
	leal	-1(%eax),%eax
	addl	-16(%ebp),%eax
	cmpl	$0,%eax
	jge	.Lj123
	jmp	.Lj121
.Lj123:
	movl	-4(%ebp),%eax
	leal	-1(%eax),%eax
	addl	-16(%ebp),%eax
	cmpl	U_$VIDEO_$$_RWIDTH,%eax
	jl	.Lj124
	jmp	.Lj121
.Lj124:
# [201] Framebuffer[(Y - 1 + R) * RWidth + (X - 1 + C)] := CursorBack[R * CursorW + C];
	movl	U_$VIDEO_$$_FRAMEBUFFER,%edx
	movl	-8(%ebp),%eax
	leal	-1(%eax),%ecx
	addl	-12(%ebp),%ecx
	movl	U_$VIDEO_$$_RWIDTH,%eax
	imull	%eax,%ecx
	movl	-4(%ebp),%eax
	leal	-1(%eax),%eax
	addl	-16(%ebp),%eax
	leal	(%ecx,%eax),%ecx
	movl	-12(%ebp),%eax
	imull	$18,%eax,%eax
	addl	-16(%ebp),%eax
	movb	U_$VIDEO_$$_CURSORBACK(,%eax,1),%al
	movb	%al,(%edx,%ecx,1)
	.balign 4,0x90
.Lj121:
	cmpl	$17,-16(%ebp)
	jge	.Lj119
	jmp	.Lj117
.Lj119:
	cmpl	$17,-12(%ebp)
	jge	.Lj116
	jmp	.Lj114
.Lj116:
# [203] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_video_$$_writeat$longint$longint$pchar$longint,"x"
	.balign 16,0x90
.globl	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT:
# [310] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-28(%esp),%esp
	pushl	%ebx
	pushl	%esi
	pushl	%edi
# Var X located at ebp-4, size=OS_S32
# Var Y located at ebp-8, size=OS_S32
# Var Text located at ebp-12, size=OS_32
# Var Size located at ebp+8, size=OS_S32
# Var i located at ebp-16, size=OS_S32
# Var R located at ebp-20, size=OS_S32
# Var C located at ebp-24, size=OS_S32
# Var G located at ebp-28, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [311] if Text = nil then
	cmpl	$0,-12(%ebp)
	je	.Lj127
	jmp	.Lj128
.Lj127:
# [312] Exit;
	jmp	.Lj125
	.balign 4,0x90
.Lj128:
# [313] if Size < 8 then
	cmpl	$8,8(%ebp)
	jl	.Lj129
	jmp	.Lj130
.Lj129:
# [314] Size := 8;
	movl	$8,8(%ebp)
	.balign 4,0x90
.Lj130:
# [315] i := 0;
	movl	$0,-16(%ebp)
# [316] while Text[i] <> #0 do
	jmp	.Lj132
	.balign 8,0x90
.Lj131:
# [318] if Text[i] = #10 then
	movl	-12(%ebp),%edx
	movl	-16(%ebp),%eax
	cmpb	$10,(%edx,%eax,1)
	je	.Lj134
	jmp	.Lj135
.Lj134:
# [320] Y := Y + Size;
	movl	-8(%ebp),%edx
	movl	8(%ebp),%eax
	leal	(%edx,%eax),%eax
	movl	%eax,-8(%ebp)
# [321] i := i + 1;
	movl	-16(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-16(%ebp)
# [322] Continue;
	jmp	.Lj132
	.balign 4,0x90
.Lj135:
# [324] if (Ord(Text[i]) >= 32) and (Ord(Text[i]) <= 127) then
	movl	-12(%ebp),%eax
	movl	-16(%ebp),%edx
	cmpb	$32,(%eax,%edx,1)
	jae	.Lj136
	jmp	.Lj137
.Lj136:
	movl	-12(%ebp),%eax
	movl	-16(%ebp),%edx
	cmpb	$127,(%eax,%edx,1)
	jbe	.Lj138
	jmp	.Lj137
.Lj138:
# [326] G := Ord(Text[i]) - 32;
	movl	-12(%ebp),%eax
	movl	-16(%ebp),%edx
	movzbl	(%eax,%edx,1),%eax
	subl	$32,%eax
	movl	%eax,-28(%ebp)
# [327] for R := 0 to Size - 1 do
	movl	8(%ebp),%eax
	leal	-1(%eax),%ebx
	cmpl	$0,%ebx
	jge	.Lj139
	jmp	.Lj140
.Lj139:
	movl	$-1,-20(%ebp)
	.balign 8,0x90
.Lj141:
	movl	-20(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-20(%ebp)
# [328] for C := 0 to Size - 1 do
	movl	8(%ebp),%eax
	leal	-1(%eax),%esi
	cmpl	$0,%esi
	jge	.Lj144
	jmp	.Lj145
.Lj144:
	movl	$-1,-24(%ebp)
	.balign 8,0x90
.Lj146:
	movl	-24(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-24(%ebp)
# [329] if (Font8x8[G, (R * 8) div Size] and (1 shl ((C * 8) div Size))) <> 0 then
	movl	-28(%ebp),%ecx
	movl	-20(%ebp),%eax
	shll	$3,%eax
	cltd
	idivl	8(%ebp)
	shll	$3,%ecx
	movzbl	TC_$VIDEO_$$_FONT8X8(%ecx,%eax,1),%edi
	movl	-24(%ebp),%eax
	shll	$3,%eax
	cltd
	idivl	8(%ebp)
	movl	%eax,%ecx
	movl	$1,%eax
	shll	%cl,%eax
	andl	%eax,%edi
	testl	$-1,%edi
	jne	.Lj149
	jmp	.Lj150
.Lj149:
# [330] if (X + C >= 0) and (X + C < RWidth) and
	movl	-4(%ebp),%eax
	movl	-24(%ebp),%edx
	leal	(%eax,%edx),%eax
	cmpl	$0,%eax
	jge	.Lj151
	jmp	.Lj152
.Lj151:
	movl	-4(%ebp),%edx
	movl	-24(%ebp),%eax
	leal	(%edx,%eax),%eax
	cmpl	U_$VIDEO_$$_RWIDTH,%eax
	jl	.Lj153
	jmp	.Lj152
.Lj153:
# [331] (Y + R >= 0) and (Y + R < RHeight) then
	movl	-8(%ebp),%edx
	movl	-20(%ebp),%eax
	leal	(%edx,%eax),%eax
	cmpl	$0,%eax
	jge	.Lj154
	jmp	.Lj152
.Lj154:
	movl	-8(%ebp),%eax
	movl	-20(%ebp),%edx
	leal	(%eax,%edx),%eax
	cmpl	U_$VIDEO_$$_RHEIGHT,%eax
	jl	.Lj155
	jmp	.Lj152
.Lj155:
# [332] Framebuffer[(Y + R) * RWidth + X + C] := 0;
	movl	U_$VIDEO_$$_FRAMEBUFFER,%edx
	movl	-8(%ebp),%eax
	movl	-20(%ebp),%ecx
	leal	(%eax,%ecx),%ecx
	movl	U_$VIDEO_$$_RWIDTH,%eax
	imull	%eax,%ecx
	addl	-4(%ebp),%ecx
	addl	-24(%ebp),%ecx
	movb	$0,(%edx,%ecx,1)
	.balign 4,0x90
.Lj152:
	.balign 4,0x90
.Lj150:
	cmpl	-24(%ebp),%esi
	jle	.Lj148
	jmp	.Lj146
.Lj148:
	.balign 4,0x90
.Lj145:
	cmpl	-20(%ebp),%ebx
	jle	.Lj143
	jmp	.Lj141
.Lj143:
	.balign 4,0x90
.Lj140:
# [333] X := X + Size;
	movl	-4(%ebp),%eax
	movl	8(%ebp),%edx
	leal	(%eax,%edx),%eax
	movl	%eax,-4(%ebp)
	.balign 4,0x90
.Lj137:
# [335] i := i + 1;
	movl	-16(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-16(%ebp)
.Lj132:
	movl	-12(%ebp),%edx
	movl	-16(%ebp),%eax
	cmpb	$0,(%edx,%eax,1)
	jne	.Lj131
	jmp	.Lj133
.Lj133:
.Lj125:
# [337] end;
	popl	%edi
	popl	%esi
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret	$4

.section .text.n_video_$$_putsymbol$longint$longint$char$longint,"x"
	.balign 16,0x90
.globl	VIDEO_$$_PUTSYMBOL$LONGINT$LONGINT$CHAR$LONGINT
VIDEO_$$_PUTSYMBOL$LONGINT$LONGINT$CHAR$LONGINT:
# [353] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-24(%esp),%esp
	pushl	%ebx
	pushl	%esi
	pushl	%edi
# Var X located at ebp-4, size=OS_S32
# Var Y located at ebp-8, size=OS_S32
# Var Symbol located at ebp-12, size=OS_8
# Var Size located at ebp+8, size=OS_S32
# Var i located at ebp-16, size=OS_S32
# Var R located at ebp-20, size=OS_S32
# Var C located at ebp-24, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movb	%cl,-12(%ebp)
# [354] if Size < 8 then
	cmpl	$8,8(%ebp)
	jl	.Lj158
	jmp	.Lj159
.Lj158:
# [355] Size := 8;
	movl	$8,8(%ebp)
	.balign 4,0x90
.Lj159:
# [356] for i := Low(SymbolFont) to High(SymbolFont) do
	movl	$-1,-16(%ebp)
	.balign 8,0x90
.Lj160:
	movl	-16(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-16(%ebp)
# [357] if SymbolFont[i].Ch = Symbol then
	movl	-16(%ebp),%eax
	leal	(%eax,%eax,8),%eax
	movb	TC_$VIDEO_$$_SYMBOLFONT(,%eax),%al
	cmpb	-12(%ebp),%al
	je	.Lj163
	jmp	.Lj164
.Lj163:
# [359] for R := 0 to Size - 1 do
	movl	8(%ebp),%eax
	leal	-1(%eax),%ebx
	cmpl	$0,%ebx
	jge	.Lj165
	jmp	.Lj166
.Lj165:
	movl	$-1,-20(%ebp)
	.balign 8,0x90
.Lj167:
	movl	-20(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-20(%ebp)
# [360] for C := 0 to Size - 1 do
	movl	8(%ebp),%eax
	leal	-1(%eax),%esi
	cmpl	$0,%esi
	jge	.Lj170
	jmp	.Lj171
.Lj170:
	movl	$-1,-24(%ebp)
	.balign 8,0x90
.Lj172:
	movl	-24(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-24(%ebp)
# [361] if (SymbolFont[i].G[(R * 8) div Size] and (1 shl ((C * 8) div Size))) <> 0 then
	movl	-16(%ebp),%eax
	leal	(%eax,%eax,8),%ecx
	movl	-20(%ebp),%eax
	shll	$3,%eax
	cltd
	idivl	8(%ebp)
	movzbl	TC_$VIDEO_$$_SYMBOLFONT+1(%ecx,%eax,1),%edi
	movl	-24(%ebp),%eax
	shll	$3,%eax
	cltd
	idivl	8(%ebp)
	movl	%eax,%ecx
	movl	$1,%eax
	shll	%cl,%eax
	andl	%eax,%edi
	testl	$-1,%edi
	jne	.Lj175
	jmp	.Lj176
.Lj175:
# [362] if (X + C >= 0) and (X + C < RWidth) and
	movl	-4(%ebp),%eax
	movl	-24(%ebp),%edx
	leal	(%eax,%edx),%eax
	cmpl	$0,%eax
	jge	.Lj177
	jmp	.Lj178
.Lj177:
	movl	-4(%ebp),%edx
	movl	-24(%ebp),%eax
	leal	(%edx,%eax),%eax
	cmpl	U_$VIDEO_$$_RWIDTH,%eax
	jl	.Lj179
	jmp	.Lj178
.Lj179:
# [363] (Y + R >= 0) and (Y + R < RHeight) then
	movl	-8(%ebp),%eax
	movl	-20(%ebp),%edx
	leal	(%eax,%edx),%eax
	cmpl	$0,%eax
	jge	.Lj180
	jmp	.Lj178
.Lj180:
	movl	-8(%ebp),%eax
	movl	-20(%ebp),%edx
	leal	(%eax,%edx),%eax
	cmpl	U_$VIDEO_$$_RHEIGHT,%eax
	jl	.Lj181
	jmp	.Lj178
.Lj181:
# [364] Framebuffer[(Y + R) * RWidth + X + C] := 0;
	movl	U_$VIDEO_$$_FRAMEBUFFER,%ecx
	movl	-8(%ebp),%eax
	movl	-20(%ebp),%edx
	leal	(%eax,%edx),%eax
	movl	U_$VIDEO_$$_RWIDTH,%edx
	imull	%edx,%eax
	addl	-4(%ebp),%eax
	addl	-24(%ebp),%eax
	movb	$0,(%ecx,%eax,1)
	.balign 4,0x90
.Lj178:
	.balign 4,0x90
.Lj176:
	cmpl	-24(%ebp),%esi
	jle	.Lj174
	jmp	.Lj172
.Lj174:
	.balign 4,0x90
.Lj171:
	cmpl	-20(%ebp),%ebx
	jle	.Lj169
	jmp	.Lj167
.Lj169:
	.balign 4,0x90
.Lj166:
# [365] Exit;
	jmp	.Lj156
	.balign 4,0x90
.Lj164:
	cmpl	$0,-16(%ebp)
	jge	.Lj162
	jmp	.Lj160
.Lj162:
.Lj156:
# [367] end;
	popl	%edi
	popl	%esi
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret	$4

.section .text.n_video_$$_drawsprite$pbyte$longint$longint$longint$longint,"x"
	.balign 16,0x90
.globl	VIDEO_$$_DRAWSPRITE$PBYTE$LONGINT$LONGINT$LONGINT$LONGINT
VIDEO_$$_DRAWSPRITE$PBYTE$LONGINT$LONGINT$LONGINT$LONGINT:
# [373] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-24(%esp),%esp
	pushl	%ebx
	pushl	%esi
# Var Src located at ebp-4, size=OS_32
# Var SrcW located at ebp-8, size=OS_S32
# Var SrcH located at ebp-12, size=OS_S32
# Var DstX located at ebp+12, size=OS_S32
# Var DstY located at ebp+8, size=OS_S32
# Var X located at ebp-16, size=OS_S32
# Var Y located at ebp-20, size=OS_S32
# Var C located at ebp-24, size=OS_8
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [374] for Y := 0 to SrcH - 1 do
	movl	-12(%ebp),%eax
	leal	-1(%eax),%eax
	cmpl	$0,%eax
	jge	.Lj184
	jmp	.Lj185
.Lj184:
	movl	$-1,-20(%ebp)
	.balign 8,0x90
.Lj186:
	movl	-20(%ebp),%edx
	leal	1(%edx),%edx
	movl	%edx,-20(%ebp)
# [375] for X := 0 to SrcW - 1 do
	movl	-8(%ebp),%edx
	leal	-1(%edx),%edx
	cmpl	$0,%edx
	jge	.Lj189
	jmp	.Lj190
.Lj189:
	movl	$-1,-16(%ebp)
	.balign 8,0x90
.Lj191:
	movl	-16(%ebp),%ecx
	leal	1(%ecx),%ecx
	movl	%ecx,-16(%ebp)
# [377] C := PByte(PByte(Src) + Y * SrcW + X)^;
	movl	-20(%ebp),%ebx
	movl	-8(%ebp),%ecx
	imull	%ebx,%ecx
	addl	-4(%ebp),%ecx
	addl	-16(%ebp),%ecx
	movb	(%ecx),%cl
	movb	%cl,-24(%ebp)
# [378] if C <> 0 then
	cmpb	$0,-24(%ebp)
	jne	.Lj194
	jmp	.Lj195
.Lj194:
# [379] if (DstX + X >= 0) and (DstX + X < RWidth) and
	movl	12(%ebp),%ebx
	movl	-16(%ebp),%ecx
	leal	(%ebx,%ecx),%ecx
	cmpl	$0,%ecx
	jge	.Lj196
	jmp	.Lj197
.Lj196:
	movl	12(%ebp),%ebx
	movl	-16(%ebp),%ecx
	leal	(%ebx,%ecx),%ecx
	cmpl	U_$VIDEO_$$_RWIDTH,%ecx
	jl	.Lj198
	jmp	.Lj197
.Lj198:
# [380] (DstY + Y >= 0) and (DstY + Y < RHeight) then
	movl	8(%ebp),%ecx
	movl	-20(%ebp),%ebx
	leal	(%ecx,%ebx),%ecx
	cmpl	$0,%ecx
	jge	.Lj199
	jmp	.Lj197
.Lj199:
	movl	8(%ebp),%ebx
	movl	-20(%ebp),%ecx
	leal	(%ebx,%ecx),%ecx
	cmpl	U_$VIDEO_$$_RHEIGHT,%ecx
	jl	.Lj200
	jmp	.Lj197
.Lj200:
# [381] Framebuffer[(DstY + Y) * RWidth + DstX + X] := C;
	movl	U_$VIDEO_$$_FRAMEBUFFER,%ebx
	movl	8(%ebp),%ecx
	movl	-20(%ebp),%esi
	leal	(%ecx,%esi),%esi
	movl	U_$VIDEO_$$_RWIDTH,%ecx
	imull	%ecx,%esi
	addl	12(%ebp),%esi
	addl	-16(%ebp),%esi
	movb	-24(%ebp),%cl
	movb	%cl,(%ebx,%esi,1)
	.balign 4,0x90
.Lj197:
	.balign 4,0x90
.Lj195:
	cmpl	-16(%ebp),%edx
	jle	.Lj193
	jmp	.Lj191
.Lj193:
	.balign 4,0x90
.Lj190:
	cmpl	-20(%ebp),%eax
	jle	.Lj188
	jmp	.Lj186
.Lj188:
	.balign 4,0x90
.Lj185:
# [383] end;
	popl	%esi
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret	$8

.section .text.n_video_$$_drawbmp$pchar$longint$longint,"x"
	.balign 16,0x90
.globl	VIDEO_$$_DRAWBMP$PCHAR$LONGINT$LONGINT
VIDEO_$$_DRAWBMP$PCHAR$LONGINT$LONGINT:
# [389] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-24(%esp),%esp
# Var Name located at ebp-4, size=OS_32
# Var X located at ebp-8, size=OS_S32
# Var Y located at ebp-12, size=OS_S32
# Var N located at ebp-16, size=OS_S32
# Var W located at ebp-20, size=OS_S32
# Var H located at ebp-24, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [390] W := 0;
	movl	$0,-20(%ebp)
# [391] H := 0;
	movl	$0,-24(%ebp)
# [392] N := FSReadFile(Name, @AssetBuf[0], SizeOf(AssetBuf));
	movl	$U_$VIDEO_$$_ASSETBUF,%eax
	movl	%eax,%edx
	movl	-4(%ebp),%eax
	movl	$16384,%ecx
	call	CDROM_$$_FSREADFILE$PCHAR$PBYTE$LONGWORD$$LONGINT
	movl	%eax,-16(%ebp)
# [393] if N < 0 then Exit;
	cmpl	$0,-16(%ebp)
	jl	.Lj203
	jmp	.Lj204
.Lj203:
	jmp	.Lj201
	.balign 4,0x90
.Lj204:
# [394] BMPDecode(@AssetBuf[0], LongWord(N), W, H, @DrawBuf[0], SizeOf(DrawBuf));
	leal	-24(%ebp),%eax
	pushl	%eax
	movl	$U_$VIDEO_$$_DRAWBUF,%eax
	pushl	%eax
	pushl	$16384
	movl	$U_$VIDEO_$$_ASSETBUF,%eax
	leal	-20(%ebp),%ecx
	movl	-16(%ebp),%edx
	call	BMP_$$_BMPDECODE$PBYTE$LONGWORD$LONGINT$LONGINT$PBYTE$LONGWORD$$BOOLEAN
# [395] if (W = 0) or (H = 0) then Exit;
	cmpl	$0,-20(%ebp)
	je	.Lj205
	jmp	.Lj206
.Lj206:
	cmpl	$0,-24(%ebp)
	je	.Lj205
	jmp	.Lj207
.Lj205:
	jmp	.Lj201
	.balign 4,0x90
.Lj207:
# [396] DrawSprite(@DrawBuf[0], W, H, X, Y);
	pushl	-8(%ebp)
	pushl	-12(%ebp)
	movl	$U_$VIDEO_$$_DRAWBUF,%eax
	movl	-24(%ebp),%ecx
	movl	-20(%ebp),%edx
	call	VIDEO_$$_DRAWSPRITE$PBYTE$LONGINT$LONGINT$LONGINT$LONGINT
.Lj201:
# [397] end;
	movl	%ebp,%esp
	popl	%ebp
	ret
# End asmlist al_procedures
# Begin asmlist al_globals

.section .bss
	.balign 4
# [10] RWidth, RHeight: integer;
	.globl U_$VIDEO_$$_RWIDTH
U_$VIDEO_$$_RWIDTH:
	.zero 4

.section .bss
	.balign 4
	.globl U_$VIDEO_$$_RHEIGHT
U_$VIDEO_$$_RHEIGHT:
	.zero 4

.section .bss
	.balign 4
# [11] Framebuffer: PByte;
	.globl U_$VIDEO_$$_FRAMEBUFFER
U_$VIDEO_$$_FRAMEBUFFER:
	.zero 4

.section .bss
# [32] AssetBuf: array[0..16383] of Byte;
U_$VIDEO_$$_ASSETBUF:
	.zero 16384

.section .bss
# [33] DrawBuf:  array[0..16383] of Byte;
U_$VIDEO_$$_DRAWBUF:
	.zero 16384

.section .bss
# [175] CursorBack: array[0..(CursorW * CursorH) - 1] of Byte;
U_$VIDEO_$$_CURSORBACK:
	.zero 324
# End asmlist al_globals
# Begin asmlist al_typedconsts

.section .data.n_TC_$VIDEO_$$_CURSORDATA,"d"
	.balign 2
TC_$VIDEO_$$_CURSORDATA:
	.short	0,16384,24576,28672,30720,31744,32256,32512,32640,31744,27648,17920,1536,768,768,0
# [139] CursorMask: array[0..15] of Word = (

.section .data.n_TC_$VIDEO_$$_CURSORMASK,"d"
	.balign 2
TC_$VIDEO_$$_CURSORMASK:
	.short	49152,57344,61440,63488,64512,65024,65280,65408,65472,65472,65024,61184,52992,34688,1920
	.short	896
# [146] procedure DrawCursorShape(const Shape: array of Word; X, Y: Integer; Color: Byte);

.section .data.n_TC_$VIDEO_$$_FONT8X8,"d"
TC_$VIDEO_$$_FONT8X8:
	.byte	0,0,0,0,0,0,0,0,24,60,60,24,24,0,24,0,54,54,0,0,0,0,0,0,54,54,127,54,127,54,54,0,12,62,3,30,48,31,12,0,0,99,51,24,12
	.byte	102,99,0,28,54,28,110,59,51,110,0,6,6,3,0,0,0,0,0,24,12,6,6,6,12,24,0,6,12,24,24,24,12,6,0,0,102,60,255,60,102,0
	.byte	0,0,12,12,63,12,12,0,0,0,0,0,0,0,12,12,6,0,0,0,63,0,0,0,0,0,0,0,0,0,12,12,0,96,48,24,12,6,3,1,0,62,99,115,123,111,103
	.byte	62,0,12,14,12,12,12,12,63,0,30,51,48,28,6,51,63,0,30,51,48,28,48,51,30,0,56,60,54,51,127,48,120,0,63,3,31,48
	.byte	48,51,30,0,28,6,3,31,51,51,30,0,63,51,48,24,12,12,12,0,30,51,51,30,51,51,30,0,30,51,51,62,48,24,14,0,0,12,12,0
	.byte	0,12,12,0,0,12,12,0,0,12,12,6,24,12,6,3,6,12,24,0,0,0,63,0,0,63,0,0,6,12,24,48,24,12,6,0,30,51,48,24,12,0,12,0,62,99
	.byte	123,123,123,3,30,0,12,30,51,51,63,51,51,0,63,102,102,62,102,102,63,0,60,102,3,3,3,102,60,0,31,54,102,102
	.byte	102,54,31,0,127,70,22,30,22,70,127,0,127,70,22,30,22,6,15,0,60,102,3,3,115,102,124,0,51,51,51,63,51,51,51
	.byte	0,30,12,12,12,12,12,30,0,120,48,48,48,51,51,30,0,103,102,54,30,54,102,103,0,15,6,6,6,70,102,127,0,99,119,127
	.byte	127,107,99,99,0,99,103,111,123,115,99,99,0,28,54,99,99,99,54,28,0,63,102,102,62,6,6,15,0,30,51,51,51,59,30
	.byte	56,0,63,102,102,62,54,102,103,0,30,51,7,14,56,51,30,0,63,45,12,12,12,12,30,0,51,51,51,51,51,51,63,0,51,51,51
	.byte	51,51,30,12,0,99,99,99,107,127,119,99,0,99,99,54,28,28,54,99,0,51,51,51,30,12,12,30,0,127,99,49,24,76,102
	.byte	127,0,30,6,6,6,6,6,30,0,3,6,12,24,48,96,64,0,30,24,24,24,24,24,30,0,8,28,54,99,0,0,0,0,0,0,0,0,0,0,0,255,12,12,24,0,0
	.byte	0,0,0,0,0,30,48,62,51,110,0,7,6,6,62,102,102,59,0,0,0,30,51,3,51,30,0,56,48,48,62,51,51,110,0,0,0,30,51,63,3,30,0
	.byte	28,54,6,15,6,6,15,0,0,0,110,51,51,62,48,31,7,6,54,110,102,102,103,0,12,0,14,12,12,12,30,0,48,0,48,48,48,51,51
	.byte	30,7,6,102,54,30,54,103,0,14,12,12,12,12,12,30,0,0,0,51,127,127,107,99,0,0,0,31,51,51,51,51,0,0,0,30,51,51,51
	.byte	30,0,0,0,59,102,102,62,6,15,0,0,110,51,51,62,48,120,0,0,59,110,102,6,15,0,0,0,62,3,30,48,31,0,8,12,62,12,12,44
	.byte	24,0,0,0,51,51,51,51,110,0,0,0,51,51,51,30,12,0,0,0,99,107,127,127,54,0,0,0,99,54,28,54,99,0,0,0,51,51,51,62,48
	.byte	31,0,0,63,25,12,38,63,0,56,12,12,7,12,12,56,0,24,24,24,0,24,24,24,0,7,12,12,56,12,12,7,0,110,59,0,0,0,0,0,0,0,0,0,0
	.byte	0,0,0,0
# [307] procedure WriteAt(X, Y: Integer; Text: PChar; Size: Integer);

.section .data.n_TC_$VIDEO_$$_SYMBOLFONT,"d"
TC_$VIDEO_$$_SYMBOLFONT:
	.byte	35,60,102,195,129,129,195,102,60
# [350] procedure PutSymbol(X, Y: Integer; Symbol: Char; Size: Integer);
# End asmlist al_typedconsts

