	.file "windows.pas"
# Begin asmlist al_procedures

.section .text.n_windows_$$_offx$longint$$longint,"x"
	.balign 16,0x90
WINDOWS_$$_OFFX$LONGINT$$LONGINT:
# [windows.pas]
# [124] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var X located at ebp-4, size=OS_S32
# Var $result located at ebp-8, size=OS_S32
	movl	%eax,-4(%ebp)
# [125] if WOpen then OffX := X + ClientX else OffX := X;
	cmpb	$0,U_$WINDOWS_$$_WOPEN
	jne	.Lj5
	jmp	.Lj6
.Lj5:
	movl	-4(%ebp),%eax
	movl	U_$WINDOWS_$$_CLIENTX,%edx
	leal	(%eax,%edx),%eax
	movl	%eax,-8(%ebp)
	jmp	.Lj7
.Lj6:
	movl	-4(%ebp),%eax
	movl	%eax,-8(%ebp)
.Lj7:
# [126] end;
	movl	-8(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_windows_$$_offy$longint$$longint,"x"
	.balign 16,0x90
WINDOWS_$$_OFFY$LONGINT$$LONGINT:
# [129] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var Y located at ebp-4, size=OS_S32
# Var $result located at ebp-8, size=OS_S32
	movl	%eax,-4(%ebp)
# [130] if WOpen then OffY := Y + ClientY else OffY := Y;
	cmpb	$0,U_$WINDOWS_$$_WOPEN
	jne	.Lj10
	jmp	.Lj11
.Lj10:
	movl	-4(%ebp),%eax
	movl	U_$WINDOWS_$$_CLIENTY,%edx
	leal	(%eax,%edx),%eax
	movl	%eax,-8(%ebp)
	jmp	.Lj12
.Lj11:
	movl	-4(%ebp),%eax
	movl	%eax,-8(%ebp)
.Lj12:
# [131] end;
	movl	-8(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_windows_$$_svcclearscreen$byte,"x"
	.balign 16,0x90
.globl	WINDOWS_$$_SVCCLEARSCREEN$BYTE
WINDOWS_$$_SVCCLEARSCREEN$BYTE:
# [134] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-4(%esp),%esp
# Var Color located at ebp-4, size=OS_8
	movb	%al,-4(%ebp)
# [135] if WOpen then
	cmpb	$0,U_$WINDOWS_$$_WOPEN
	jne	.Lj15
	jmp	.Lj16
.Lj15:
# [136] FillRect(ClientX, ClientY, ClientW, ClientH, Color)
	pushl	U_$WINDOWS_$$_CLIENTH
	movzbl	-4(%ebp),%eax
	pushl	%eax
	movl	U_$WINDOWS_$$_CLIENTW,%ecx
	movl	U_$WINDOWS_$$_CLIENTY,%edx
	movl	U_$WINDOWS_$$_CLIENTX,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
	jmp	.Lj17
.Lj16:
# [138] ClearScreen(Color);
	movb	-4(%ebp),%al
	call	VIDEO_$$_CLEARSCREEN$BYTE
.Lj17:
# [139] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_windows_$$_svcwriteat$longint$longint$pchar$longint,"x"
	.balign 16,0x90
.globl	WINDOWS_$$_SVCWRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
WINDOWS_$$_SVCWRITEAT$LONGINT$LONGINT$PCHAR$LONGINT:
# [142] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-12(%esp),%esp
	pushl	%ebx
# Var X located at ebp-4, size=OS_S32
# Var Y located at ebp-8, size=OS_S32
# Var Text located at ebp-12, size=OS_32
# Var Size located at ebp+8, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [143] WriteAt(OffX(X), OffY(Y), Text, Size);
	pushl	8(%ebp)
	movl	-8(%ebp),%eax
	call	WINDOWS_$$_OFFY$LONGINT$$LONGINT
	movl	%eax,%ebx
	movl	-4(%ebp),%eax
	call	WINDOWS_$$_OFFX$LONGINT$$LONGINT
	movl	-12(%ebp),%ecx
	movl	%ebx,%edx
	call	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
# [144] end;
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret	$4

.section .text.n_windows_$$_svcwriteatcol$longint$longint$pchar$longint$byte,"x"
	.balign 16,0x90
.globl	WINDOWS_$$_SVCWRITEATCOL$LONGINT$LONGINT$PCHAR$LONGINT$BYTE
WINDOWS_$$_SVCWRITEATCOL$LONGINT$LONGINT$PCHAR$LONGINT$BYTE:
# [147] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-12(%esp),%esp
	pushl	%ebx
# Var X located at ebp-4, size=OS_S32
# Var Y located at ebp-8, size=OS_S32
# Var Text located at ebp-12, size=OS_32
# Var Size located at ebp+12, size=OS_S32
# Var Color located at ebp+8, size=OS_8
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [148] WriteAtCol(OffX(X), OffY(Y), Text, Size, Color);
	pushl	12(%ebp)
	movzbl	8(%ebp),%eax
	pushl	%eax
	movl	-8(%ebp),%eax
	call	WINDOWS_$$_OFFY$LONGINT$$LONGINT
	movl	%eax,%ebx
	movl	-4(%ebp),%eax
	call	WINDOWS_$$_OFFX$LONGINT$$LONGINT
	movl	-12(%ebp),%ecx
	movl	%ebx,%edx
	call	VIDEO_$$_WRITEATCOL$LONGINT$LONGINT$PCHAR$LONGINT$BYTE
# [149] end;
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret	$8

.section .text.n_windows_$$_svcfillrect$longint$longint$longint$longint$byte,"x"
	.balign 16,0x90
.globl	WINDOWS_$$_SVCFILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
WINDOWS_$$_SVCFILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE:
# [152] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-12(%esp),%esp
	pushl	%ebx
# Var X located at ebp-4, size=OS_S32
# Var Y located at ebp-8, size=OS_S32
# Var W located at ebp-12, size=OS_S32
# Var H located at ebp+12, size=OS_S32
# Var Color located at ebp+8, size=OS_8
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [153] FillRect(OffX(X), OffY(Y), W, H, Color);
	pushl	12(%ebp)
	movzbl	8(%ebp),%eax
	pushl	%eax
	movl	-8(%ebp),%eax
	call	WINDOWS_$$_OFFY$LONGINT$$LONGINT
	movl	%eax,%ebx
	movl	-4(%ebp),%eax
	call	WINDOWS_$$_OFFX$LONGINT$$LONGINT
	movl	-12(%ebp),%ecx
	movl	%ebx,%edx
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [154] end;
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret	$8

.section .text.n_windows_$$_svcputpixel$longint$longint$byte,"x"
	.balign 16,0x90
.globl	WINDOWS_$$_SVCPUTPIXEL$LONGINT$LONGINT$BYTE
WINDOWS_$$_SVCPUTPIXEL$LONGINT$LONGINT$BYTE:
# [157] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-12(%esp),%esp
	pushl	%ebx
# Var X located at ebp-4, size=OS_S32
# Var Y located at ebp-8, size=OS_S32
# Var Color located at ebp-12, size=OS_8
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movb	%cl,-12(%ebp)
# [158] PutPixel(OffX(X), OffY(Y), Color);
	movl	-8(%ebp),%eax
	call	WINDOWS_$$_OFFY$LONGINT$$LONGINT
	movl	%eax,%ebx
	movl	-4(%ebp),%eax
	call	WINDOWS_$$_OFFX$LONGINT$$LONGINT
	movb	-12(%ebp),%cl
	movl	%ebx,%edx
	call	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
# [159] end;
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_windows_$$_svcdrawline$longint$longint$longint$longint$byte,"x"
	.balign 16,0x90
.globl	WINDOWS_$$_SVCDRAWLINE$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
WINDOWS_$$_SVCDRAWLINE$LONGINT$LONGINT$LONGINT$LONGINT$BYTE:
# [162] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-12(%esp),%esp
	pushl	%ebx
	pushl	%esi
# Var X0 located at ebp-4, size=OS_S32
# Var Y0 located at ebp-8, size=OS_S32
# Var X1 located at ebp-12, size=OS_S32
# Var Y1 located at ebp+12, size=OS_S32
# Var Color located at ebp+8, size=OS_8
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [163] DrawLine(OffX(X0), OffY(Y0), OffX(X1), OffY(Y1), Color);
	movl	12(%ebp),%eax
	call	WINDOWS_$$_OFFY$LONGINT$$LONGINT
	pushl	%eax
	movzbl	8(%ebp),%eax
	pushl	%eax
	movl	-12(%ebp),%eax
	call	WINDOWS_$$_OFFX$LONGINT$$LONGINT
	movl	%eax,%ebx
	movl	-8(%ebp),%eax
	call	WINDOWS_$$_OFFY$LONGINT$$LONGINT
	movl	%eax,%esi
	movl	-4(%ebp),%eax
	call	WINDOWS_$$_OFFX$LONGINT$$LONGINT
	movl	%esi,%edx
	movl	%ebx,%ecx
	call	VIDEO_$$_DRAWLINE$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [164] end;
	popl	%esi
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret	$8

.section .text.n_windows_$$_svcdrawbmp$pchar$longint$longint,"x"
	.balign 16,0x90
.globl	WINDOWS_$$_SVCDRAWBMP$PCHAR$LONGINT$LONGINT
WINDOWS_$$_SVCDRAWBMP$PCHAR$LONGINT$LONGINT:
# [167] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-12(%esp),%esp
	pushl	%ebx
# Var Name located at ebp-4, size=OS_32
# Var X located at ebp-8, size=OS_S32
# Var Y located at ebp-12, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [168] DrawBMP(Name, OffX(X), OffY(Y));
	movl	-12(%ebp),%eax
	call	WINDOWS_$$_OFFY$LONGINT$$LONGINT
	movl	%eax,%ebx
	movl	-8(%ebp),%eax
	call	WINDOWS_$$_OFFX$LONGINT$$LONGINT
	movl	%eax,%edx
	movl	-4(%ebp),%eax
	movl	%ebx,%ecx
	call	VIDEO_$$_DRAWBMP$PCHAR$LONGINT$LONGINT
# [169] end;
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_windows_$$_svcdrawbmpblack$pchar$longint$longint,"x"
	.balign 16,0x90
.globl	WINDOWS_$$_SVCDRAWBMPBLACK$PCHAR$LONGINT$LONGINT
WINDOWS_$$_SVCDRAWBMPBLACK$PCHAR$LONGINT$LONGINT:
# [172] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-12(%esp),%esp
	pushl	%ebx
# Var Name located at ebp-4, size=OS_32
# Var X located at ebp-8, size=OS_S32
# Var Y located at ebp-12, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [173] DrawBMPBlack(Name, OffX(X), OffY(Y));
	movl	-12(%ebp),%eax
	call	WINDOWS_$$_OFFY$LONGINT$$LONGINT
	movl	%eax,%ebx
	movl	-8(%ebp),%eax
	call	WINDOWS_$$_OFFX$LONGINT$$LONGINT
	movl	%eax,%edx
	movl	-4(%ebp),%eax
	movl	%ebx,%ecx
	call	VIDEO_$$_DRAWBMPBLACK$PCHAR$LONGINT$LONGINT
# [174] end;
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_windows_$$_svcgetmousex$$longint,"x"
	.balign 16,0x90
.globl	WINDOWS_$$_SVCGETMOUSEX$$LONGINT
WINDOWS_$$_SVCGETMOUSEX$$LONGINT:
# [177] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-4(%esp),%esp
# Var $result located at ebp-4, size=OS_S32
# [178] if WOpen then SvcGetMouseX := GetMouseX - ClientX
	cmpb	$0,U_$WINDOWS_$$_WOPEN
	jne	.Lj34
	jmp	.Lj35
.Lj34:
	call	MOUSE_$$_GETMOUSEX$$LONGINT
	subl	U_$WINDOWS_$$_CLIENTX,%eax
	movl	%eax,-4(%ebp)
	jmp	.Lj36
.Lj35:
# [179] else SvcGetMouseX := GetMouseX;
	call	MOUSE_$$_GETMOUSEX$$LONGINT
	movl	%eax,-4(%ebp)
.Lj36:
# [180] end;
	movl	-4(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_windows_$$_svcgetmousey$$longint,"x"
	.balign 16,0x90
.globl	WINDOWS_$$_SVCGETMOUSEY$$LONGINT
WINDOWS_$$_SVCGETMOUSEY$$LONGINT:
# [183] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-4(%esp),%esp
# Var $result located at ebp-4, size=OS_S32
# [184] if WOpen then SvcGetMouseY := GetMouseY - ClientY
	cmpb	$0,U_$WINDOWS_$$_WOPEN
	jne	.Lj39
	jmp	.Lj40
.Lj39:
	call	MOUSE_$$_GETMOUSEY$$LONGINT
	subl	U_$WINDOWS_$$_CLIENTY,%eax
	movl	%eax,-4(%ebp)
	jmp	.Lj41
.Lj40:
# [185] else SvcGetMouseY := GetMouseY;
	call	MOUSE_$$_GETMOUSEY$$LONGINT
	movl	%eax,-4(%ebp)
.Lj41:
# [186] end;
	movl	-4(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_windows_$$_capturerect$plongword$longint$longint$longint$longint,"x"
	.balign 16,0x90
WINDOWS_$$_CAPTURERECT$PLONGWORD$LONGINT$LONGINT$LONGINT$LONGINT:
# [195] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-24(%esp),%esp
	pushl	%ebx
	pushl	%esi
# Var Buf located at ebp-4, size=OS_32
# Var X located at ebp-8, size=OS_S32
# Var Y located at ebp-12, size=OS_S32
# Var W located at ebp+12, size=OS_S32
# Var H located at ebp+8, size=OS_S32
# Var R located at ebp-16, size=OS_S32
# Var C located at ebp-20, size=OS_S32
# Var idx located at ebp-24, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [196] if (W <= 0) or (H <= 0) then
	cmpl	$0,12(%ebp)
	jle	.Lj44
	jmp	.Lj45
.Lj45:
	cmpl	$0,8(%ebp)
	jle	.Lj44
	jmp	.Lj46
.Lj44:
# [197] Exit;
	jmp	.Lj42
	.balign 4,0x90
.Lj46:
# [198] idx := 0;
	movl	$0,-24(%ebp)
# [199] for R := 0 to H - 1 do
	movl	8(%ebp),%eax
	leal	-1(%eax),%eax
	cmpl	$0,%eax
	jge	.Lj47
	jmp	.Lj48
.Lj47:
	movl	$-1,-16(%ebp)
	.balign 8,0x90
.Lj49:
	movl	-16(%ebp),%edx
	leal	1(%edx),%edx
	movl	%edx,-16(%ebp)
# [200] for C := 0 to W - 1 do
	movl	12(%ebp),%edx
	leal	-1(%edx),%edx
	cmpl	$0,%edx
	jge	.Lj52
	jmp	.Lj53
.Lj52:
	movl	$-1,-20(%ebp)
	.balign 8,0x90
.Lj54:
	movl	-20(%ebp),%ecx
	leal	1(%ecx),%ecx
	movl	%ecx,-20(%ebp)
# [202] if (Y + R >= 0) and (Y + R < RHeight) and
	movl	-12(%ebp),%ebx
	movl	-16(%ebp),%ecx
	leal	(%ebx,%ecx),%ecx
	cmpl	$0,%ecx
	jge	.Lj57
	jmp	.Lj58
.Lj57:
	movl	-12(%ebp),%ebx
	movl	-16(%ebp),%ecx
	leal	(%ebx,%ecx),%ecx
	cmpl	U_$VIDEO_$$_RHEIGHT,%ecx
	jl	.Lj59
	jmp	.Lj58
.Lj59:
# [203] (X + C >= 0) and (X + C < RWidth) then
	movl	-8(%ebp),%ecx
	movl	-20(%ebp),%ebx
	leal	(%ecx,%ebx),%ecx
	cmpl	$0,%ecx
	jge	.Lj60
	jmp	.Lj58
.Lj60:
	movl	-8(%ebp),%ecx
	movl	-20(%ebp),%ebx
	leal	(%ecx,%ebx),%ecx
	cmpl	U_$VIDEO_$$_RWIDTH,%ecx
	jl	.Lj61
	jmp	.Lj58
.Lj61:
# [204] Buf[idx] := PLongWord(PByte(Framebuffer) + (Y + R) * VPitch + (X + C) * 4)^
	movl	-12(%ebp),%ecx
	movl	-16(%ebp),%ebx
	leal	(%ecx,%ebx),%ebx
	movl	U_$VIDEO_$$_VPITCH,%ecx
	imull	%ecx,%ebx
	addl	U_$VIDEO_$$_FRAMEBUFFER,%ebx
	movl	-8(%ebp),%ecx
	movl	-20(%ebp),%esi
	leal	(%ecx,%esi),%ecx
	shll	$2,%ecx
	leal	(%ebx,%ecx),%ecx
	movl	-4(%ebp),%esi
	movl	-24(%ebp),%ebx
	movl	(%ecx),%ecx
	movl	%ecx,(%esi,%ebx,4)
	jmp	.Lj62
.Lj58:
# [206] Buf[idx] := 0;
	movl	-4(%ebp),%ecx
	movl	-24(%ebp),%ebx
	movl	$0,(%ecx,%ebx,4)
.Lj62:
# [207] Inc(idx);
	addl	$1,-24(%ebp)
	cmpl	-20(%ebp),%edx
	jle	.Lj56
	jmp	.Lj54
.Lj56:
	.balign 4,0x90
.Lj53:
	cmpl	-16(%ebp),%eax
	jle	.Lj51
	jmp	.Lj49
.Lj51:
	.balign 4,0x90
.Lj48:
.Lj42:
# [209] end;
	popl	%esi
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret	$8

.section .text.n_windows_$$_blitrect$plongword$longint$longint$longint$longint,"x"
	.balign 16,0x90
WINDOWS_$$_BLITRECT$PLONGWORD$LONGINT$LONGINT$LONGINT$LONGINT:
# [215] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-24(%esp),%esp
	pushl	%ebx
	pushl	%esi
# Var Buf located at ebp-4, size=OS_32
# Var X located at ebp-8, size=OS_S32
# Var Y located at ebp-12, size=OS_S32
# Var W located at ebp+12, size=OS_S32
# Var H located at ebp+8, size=OS_S32
# Var R located at ebp-16, size=OS_S32
# Var C located at ebp-20, size=OS_S32
# Var idx located at ebp-24, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [216] if (W <= 0) or (H <= 0) then
	cmpl	$0,12(%ebp)
	jle	.Lj65
	jmp	.Lj66
.Lj66:
	cmpl	$0,8(%ebp)
	jle	.Lj65
	jmp	.Lj67
.Lj65:
# [217] Exit;
	jmp	.Lj63
	.balign 4,0x90
.Lj67:
# [218] idx := 0;
	movl	$0,-24(%ebp)
# [219] for R := 0 to H - 1 do
	movl	8(%ebp),%eax
	leal	-1(%eax),%eax
	cmpl	$0,%eax
	jge	.Lj68
	jmp	.Lj69
.Lj68:
	movl	$-1,-16(%ebp)
	.balign 8,0x90
.Lj70:
	movl	-16(%ebp),%edx
	leal	1(%edx),%edx
	movl	%edx,-16(%ebp)
# [220] for C := 0 to W - 1 do
	movl	12(%ebp),%edx
	leal	-1(%edx),%edx
	cmpl	$0,%edx
	jge	.Lj73
	jmp	.Lj74
.Lj73:
	movl	$-1,-20(%ebp)
	.balign 8,0x90
.Lj75:
	movl	-20(%ebp),%ecx
	leal	1(%ecx),%ecx
	movl	%ecx,-20(%ebp)
# [222] if (Y + R >= 0) and (Y + R < RHeight) and
	movl	-12(%ebp),%ebx
	movl	-16(%ebp),%ecx
	leal	(%ebx,%ecx),%ecx
	cmpl	$0,%ecx
	jge	.Lj78
	jmp	.Lj79
.Lj78:
	movl	-12(%ebp),%ebx
	movl	-16(%ebp),%ecx
	leal	(%ebx,%ecx),%ecx
	cmpl	U_$VIDEO_$$_RHEIGHT,%ecx
	jl	.Lj80
	jmp	.Lj79
.Lj80:
# [223] (X + C >= 0) and (X + C < RWidth) then
	movl	-8(%ebp),%ecx
	movl	-20(%ebp),%ebx
	leal	(%ecx,%ebx),%ecx
	cmpl	$0,%ecx
	jge	.Lj81
	jmp	.Lj79
.Lj81:
	movl	-8(%ebp),%ecx
	movl	-20(%ebp),%ebx
	leal	(%ecx,%ebx),%ecx
	cmpl	U_$VIDEO_$$_RWIDTH,%ecx
	jl	.Lj82
	jmp	.Lj79
.Lj82:
# [224] PLongWord(PByte(Framebuffer) + (Y + R) * VPitch + (X + C) * 4)^ := Buf[idx];
	movl	-12(%ebp),%ecx
	movl	-16(%ebp),%ebx
	leal	(%ecx,%ebx),%ebx
	movl	U_$VIDEO_$$_VPITCH,%ecx
	imull	%ecx,%ebx
	addl	U_$VIDEO_$$_FRAMEBUFFER,%ebx
	movl	-8(%ebp),%ecx
	movl	-20(%ebp),%esi
	leal	(%ecx,%esi),%ecx
	shll	$2,%ecx
	leal	(%ebx,%ecx),%esi
	movl	-4(%ebp),%ebx
	movl	-24(%ebp),%ecx
	movl	(%ebx,%ecx,4),%ecx
	movl	%ecx,(%esi)
	.balign 4,0x90
.Lj79:
# [225] Inc(idx);
	addl	$1,-24(%ebp)
	cmpl	-20(%ebp),%edx
	jle	.Lj77
	jmp	.Lj75
.Lj77:
	.balign 4,0x90
.Lj74:
	cmpl	-16(%ebp),%eax
	jle	.Lj72
	jmp	.Lj70
.Lj72:
	.balign 4,0x90
.Lj69:
.Lj63:
# [227] end;
	popl	%esi
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret	$8

.section .text.n_windows_$$_savebg,"x"
	.balign 16,0x90
WINDOWS_$$_SAVEBG:
# [232] begin
	pushl	%ebp
	movl	%esp,%ebp
# [233] WinSavedValid := (FrameW <= MaxWinW) and (FrameH <= MaxWinH) and
	cmpl	$640,U_$WINDOWS_$$_FRAMEW
	jle	.Lj85
	jmp	.Lj86
.Lj85:
	cmpl	$480,U_$WINDOWS_$$_FRAMEH
	jle	.Lj87
	jmp	.Lj86
.Lj87:
# [234] (FrameW > 0) and (FrameH > 0);
	cmpl	$0,U_$WINDOWS_$$_FRAMEW
	jg	.Lj88
	jmp	.Lj86
.Lj88:
	cmpl	$0,U_$WINDOWS_$$_FRAMEH
	jg	.Lj89
	jmp	.Lj86
.Lj89:
	movb	$1,U_$WINDOWS_$$_WINSAVEDVALID
	jmp	.Lj90
.Lj86:
	movb	$0,U_$WINDOWS_$$_WINSAVEDVALID
.Lj90:
# [235] if not WinSavedValid then
	cmpb	$0,U_$WINDOWS_$$_WINSAVEDVALID
	je	.Lj91
	jmp	.Lj92
.Lj91:
# [236] Exit;
	jmp	.Lj83
	.balign 4,0x90
.Lj92:
# [237] CaptureRect(@WinBuf[0], FrameX, FrameY, FrameW, FrameH);
	pushl	U_$WINDOWS_$$_FRAMEW
	pushl	U_$WINDOWS_$$_FRAMEH
	movl	$U_$WINDOWS_$$_WINBUF,%eax
	movl	U_$WINDOWS_$$_FRAMEY,%ecx
	movl	U_$WINDOWS_$$_FRAMEX,%edx
	call	WINDOWS_$$_CAPTURERECT$PLONGWORD$LONGINT$LONGINT$LONGINT$LONGINT
.Lj83:
# [238] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_windows_$$_restorebg,"x"
	.balign 16,0x90
WINDOWS_$$_RESTOREBG:
# [241] begin
	pushl	%ebp
	movl	%esp,%ebp
# [242] if not WinSavedValid then
	cmpb	$0,U_$WINDOWS_$$_WINSAVEDVALID
	je	.Lj95
	jmp	.Lj96
.Lj95:
# [243] Exit;
	jmp	.Lj93
	.balign 4,0x90
.Lj96:
# [244] BlitRect(@WinBuf[0], FrameX, FrameY, FrameW, FrameH);
	pushl	U_$WINDOWS_$$_FRAMEW
	pushl	U_$WINDOWS_$$_FRAMEH
	movl	$U_$WINDOWS_$$_WINBUF,%eax
	movl	U_$WINDOWS_$$_FRAMEY,%ecx
	movl	U_$WINDOWS_$$_FRAMEX,%edx
	call	WINDOWS_$$_BLITRECT$PLONGWORD$LONGINT$LONGINT$LONGINT$LONGINT
.Lj93:
# [245] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_windows_$$_updateclosepos,"x"
	.balign 16,0x90
WINDOWS_$$_UPDATECLOSEPOS:
# [250] begin
	pushl	%ebp
	movl	%esp,%ebp
# [251] CloseX := FrameX + Border + 3;
	movl	U_$WINDOWS_$$_FRAMEX,%eax
	leal	1(%eax),%eax
	leal	3(%eax),%eax
	movl	%eax,U_$WINDOWS_$$_CLOSEX
# [252] CloseY := FrameY + Border + (TitleH - Border - CloseIconH) div 2;
	movl	U_$WINDOWS_$$_FRAMEY,%eax
	leal	1(%eax),%eax
	leal	5(%eax),%eax
	movl	%eax,U_$WINDOWS_$$_CLOSEY
# [253] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_windows_$$_drawcloseicon$boolean,"x"
	.balign 16,0x90
WINDOWS_$$_DRAWCLOSEICON$BOOLEAN:
# [257] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-4(%esp),%esp
# Var Hovered located at ebp-4, size=OS_8
	movb	%al,-4(%ebp)
# [258] if Hovered then
	cmpb	$0,-4(%ebp)
	jne	.Lj101
	jmp	.Lj102
.Lj101:
# [259] DrawBMP(CloseIconPath2, CloseX, CloseY)
	movl	U_$WINDOWS_$$_CLOSEY,%ecx
	movl	U_$WINDOWS_$$_CLOSEX,%edx
	movl	$_$WINDOWS$_Ld1,%eax
	call	VIDEO_$$_DRAWBMP$PCHAR$LONGINT$LONGINT
	jmp	.Lj103
.Lj102:
# [261] DrawBMP(CloseIconPath, CloseX, CloseY);
	movl	U_$WINDOWS_$$_CLOSEY,%ecx
	movl	U_$WINDOWS_$$_CLOSEX,%edx
	movl	$_$WINDOWS$_Ld2,%eax
	call	VIDEO_$$_DRAWBMP$PCHAR$LONGINT$LONGINT
.Lj103:
# [262] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_windows_$$_drawframe$pchar,"x"
	.balign 16,0x90
WINDOWS_$$_DRAWFRAME$PCHAR:
# [268] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-16(%esp),%esp
# Var Title located at ebp-4, size=OS_32
# Var TX located at ebp-8, size=OS_S32
# Var TY located at ebp-12, size=OS_S32
# Var TW located at ebp-16, size=OS_S32
	movl	%eax,-4(%ebp)
# [270] FillRect(FrameX, FrameY, FrameW, FrameH, 0);
	pushl	U_$WINDOWS_$$_FRAMEH
	pushl	$0
	movl	U_$WINDOWS_$$_FRAMEW,%ecx
	movl	U_$WINDOWS_$$_FRAMEY,%edx
	movl	U_$WINDOWS_$$_FRAMEX,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [272] FillRect(FrameX + Border, FrameY + Border, FrameW - 2 * Border, TitleH - Border, $0F);
	pushl	$19
	pushl	$15
	movl	U_$WINDOWS_$$_FRAMEW,%eax
	leal	-2(%eax),%ecx
	movl	U_$WINDOWS_$$_FRAMEY,%eax
	leal	1(%eax),%edx
	movl	U_$WINDOWS_$$_FRAMEX,%eax
	leal	1(%eax),%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [274] FillRect(ClientX, ClientY, ClientW, ClientH, 0);
	pushl	U_$WINDOWS_$$_CLIENTH
	pushl	$0
	movl	U_$WINDOWS_$$_CLIENTW,%ecx
	movl	U_$WINDOWS_$$_CLIENTY,%edx
	movl	U_$WINDOWS_$$_CLIENTX,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [277] TW := 0;
	movl	$0,-16(%ebp)
# [278] if Title <> nil then
	cmpl	$0,-4(%ebp)
	jne	.Lj106
	jmp	.Lj107
.Lj106:
# [279] while Title[TW] <> #0 do
	jmp	.Lj109
	.balign 8,0x90
.Lj108:
# [280] Inc(TW);
	addl	$1,-16(%ebp)
.Lj109:
	movl	-4(%ebp),%edx
	movl	-16(%ebp),%eax
	cmpb	$0,(%edx,%eax,1)
	jne	.Lj108
	jmp	.Lj110
.Lj110:
	.balign 4,0x90
.Lj107:
# [281] TX := FrameX + (FrameW - TW * 8) div 2;
	movl	-16(%ebp),%eax
	shll	$3,%eax
	movl	U_$WINDOWS_$$_FRAMEW,%edx
	subl	%eax,%edx
	movl	%edx,%eax
	shrl	$31,%eax
	addl	%eax,%edx
	sarl	$1,%edx
	addl	U_$WINDOWS_$$_FRAMEX,%edx
	movl	%edx,-8(%ebp)
# [282] TY := FrameY + Border + (TitleH - Border - 8) div 2;
	movl	U_$WINDOWS_$$_FRAMEY,%eax
	leal	1(%eax),%eax
	leal	5(%eax),%eax
	movl	%eax,-12(%ebp)
# [283] if TX < FrameX + Border then
	movl	U_$WINDOWS_$$_FRAMEX,%eax
	leal	1(%eax),%eax
	cmpl	-8(%ebp),%eax
	jg	.Lj111
	jmp	.Lj112
.Lj111:
# [284] TX := FrameX + Border;
	movl	U_$WINDOWS_$$_FRAMEX,%eax
	leal	1(%eax),%eax
	movl	%eax,-8(%ebp)
	.balign 4,0x90
.Lj112:
# [285] if Title <> nil then
	cmpl	$0,-4(%ebp)
	jne	.Lj113
	jmp	.Lj114
.Lj113:
# [286] WriteAtCol(TX, TY, Title, 8, 0);
	pushl	$8
	pushl	$0
	movl	-4(%ebp),%ecx
	movl	-12(%ebp),%edx
	movl	-8(%ebp),%eax
	call	VIDEO_$$_WRITEATCOL$LONGINT$LONGINT$PCHAR$LONGINT$BYTE
	.balign 4,0x90
.Lj114:
# [289] UpdateClosePos;
	call	WINDOWS_$$_UPDATECLOSEPOS
# [290] CloseHover := False;
	movb	$0,U_$WINDOWS_$$_CLOSEHOVER
# [291] DrawCloseIcon(False);
	movb	$0,%al
	call	WINDOWS_$$_DRAWCLOSEICON$BOOLEAN
# [292] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_windows_$$_ptinrect$longint$longint$longint$longint$longint$longint$$boolean,"x"
	.balign 16,0x90
WINDOWS_$$_PTINRECT$LONGINT$LONGINT$LONGINT$LONGINT$LONGINT$LONGINT$$BOOLEAN:
# [297] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-16(%esp),%esp
# Var PX located at ebp-4, size=OS_S32
# Var PY located at ebp-8, size=OS_S32
# Var RX located at ebp-12, size=OS_S32
# Var RY located at ebp+16, size=OS_S32
# Var RW located at ebp+12, size=OS_S32
# Var RH located at ebp+8, size=OS_S32
# Var $result located at ebp-16, size=OS_8
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [298] PtInRect := (PX >= RX) and (PX < RX + RW) and
	movl	-4(%ebp),%eax
	cmpl	-12(%ebp),%eax
	jge	.Lj117
	jmp	.Lj118
.Lj117:
	movl	-12(%ebp),%edx
	movl	12(%ebp),%eax
	leal	(%edx,%eax),%eax
	cmpl	-4(%ebp),%eax
	jg	.Lj119
	jmp	.Lj118
.Lj119:
# [299] (PY >= RY) and (PY < RY + RH);
	movl	-8(%ebp),%eax
	cmpl	16(%ebp),%eax
	jge	.Lj120
	jmp	.Lj118
.Lj120:
	movl	16(%ebp),%edx
	movl	8(%ebp),%eax
	leal	(%edx,%eax),%eax
	cmpl	-8(%ebp),%eax
	jg	.Lj121
	jmp	.Lj118
.Lj121:
	movb	$1,-16(%ebp)
	jmp	.Lj122
.Lj118:
	movb	$0,-16(%ebp)
.Lj122:
# [300] end;
	movb	-16(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret	$12

.section .text.n_windows_$$_clampframe$longint$longint,"x"
	.balign 16,0x90
WINDOWS_$$_CLAMPFRAME$LONGINT$LONGINT:
# [304] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var NFX located at ebp-4, size=OS_32
# Var NFY located at ebp-8, size=OS_32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
# [305] if NFX < 2 then NFX := 2;
	movl	-4(%ebp),%eax
	cmpl	$2,(%eax)
	jl	.Lj125
	jmp	.Lj126
.Lj125:
	movl	-4(%ebp),%eax
	movl	$2,(%eax)
	.balign 4,0x90
.Lj126:
# [306] if NFX + FrameW > RWidth - 2 then NFX := RWidth - 2 - FrameW;
	movl	-4(%ebp),%eax
	movl	(%eax),%eax
	movl	U_$WINDOWS_$$_FRAMEW,%edx
	leal	(%eax,%edx),%edx
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-2(%eax),%eax
	cmpl	%eax,%edx
	jg	.Lj127
	jmp	.Lj128
.Lj127:
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-2(%eax),%edx
	subl	U_$WINDOWS_$$_FRAMEW,%edx
	movl	-4(%ebp),%eax
	movl	%edx,(%eax)
	.balign 4,0x90
.Lj128:
# [307] if NFX < 2 then NFX := 2;
	movl	-4(%ebp),%eax
	cmpl	$2,(%eax)
	jl	.Lj129
	jmp	.Lj130
.Lj129:
	movl	-4(%ebp),%eax
	movl	$2,(%eax)
	.balign 4,0x90
.Lj130:
# [308] if NFY < 2 then NFY := 2;
	movl	-8(%ebp),%eax
	cmpl	$2,(%eax)
	jl	.Lj131
	jmp	.Lj132
.Lj131:
	movl	-8(%ebp),%eax
	movl	$2,(%eax)
	.balign 4,0x90
.Lj132:
# [309] if NFY + FrameH > RHeight - 2 then NFY := RHeight - 2 - FrameH;
	movl	-8(%ebp),%eax
	movl	(%eax),%edx
	movl	U_$WINDOWS_$$_FRAMEH,%eax
	leal	(%edx,%eax),%edx
	movl	U_$VIDEO_$$_RHEIGHT,%eax
	leal	-2(%eax),%eax
	cmpl	%eax,%edx
	jg	.Lj133
	jmp	.Lj134
.Lj133:
	movl	U_$VIDEO_$$_RHEIGHT,%eax
	leal	-2(%eax),%eax
	subl	U_$WINDOWS_$$_FRAMEH,%eax
	movl	-8(%ebp),%edx
	movl	%eax,(%edx)
	.balign 4,0x90
.Lj134:
# [310] if NFY < 2 then NFY := 2;
	movl	-8(%ebp),%eax
	cmpl	$2,(%eax)
	jl	.Lj135
	jmp	.Lj136
.Lj135:
	movl	-8(%ebp),%eax
	movl	$2,(%eax)
	.balign 4,0x90
.Lj136:
# [311] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_windows_$$_startdrag$longint$longint,"x"
	.balign 16,0x90
WINDOWS_$$_STARTDRAG$LONGINT$LONGINT:
# [314] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var MX located at ebp-4, size=OS_S32
# Var MY located at ebp-8, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
# [316] if (CurX >= 0) and (CurY >= 0) then
	cmpl	$0,U_$WINDOWS_$$_CURX
	jge	.Lj139
	jmp	.Lj140
.Lj139:
	cmpl	$0,U_$WINDOWS_$$_CURY
	jge	.Lj141
	jmp	.Lj140
.Lj141:
# [318] RestoreCursorArea(CurX, CurY);
	movl	U_$WINDOWS_$$_CURY,%edx
	movl	U_$WINDOWS_$$_CURX,%eax
	call	VIDEO_$$_RESTORECURSORAREA$LONGINT$LONGINT
# [319] CurX := -1;
	movl	$-1,U_$WINDOWS_$$_CURX
# [320] CurY := -1;
	movl	$-1,U_$WINDOWS_$$_CURY
	.balign 4,0x90
.Lj140:
# [322] CaptureRect(@DragBuf[0], FrameX, FrameY, FrameW, FrameH);
	pushl	U_$WINDOWS_$$_FRAMEW
	pushl	U_$WINDOWS_$$_FRAMEH
	movl	$U_$WINDOWS_$$_DRAGBUF,%eax
	movl	U_$WINDOWS_$$_FRAMEY,%ecx
	movl	U_$WINDOWS_$$_FRAMEX,%edx
	call	WINDOWS_$$_CAPTURERECT$PLONGWORD$LONGINT$LONGINT$LONGINT$LONGINT
# [323] Dragging := True;
	movb	$1,U_$WINDOWS_$$_DRAGGING
# [324] DragDX := MX - FrameX;
	movl	-4(%ebp),%eax
	movl	U_$WINDOWS_$$_FRAMEX,%edx
	subl	%edx,%eax
	movl	%eax,U_$WINDOWS_$$_DRAGDX
# [325] DragDY := MY - FrameY;
	movl	-8(%ebp),%eax
	movl	U_$WINDOWS_$$_FRAMEY,%edx
	subl	%edx,%eax
	movl	%eax,U_$WINDOWS_$$_DRAGDY
# [326] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_windows_$$_movewindowto$longint$longint,"x"
	.balign 16,0x90
WINDOWS_$$_MOVEWINDOWTO$LONGINT$LONGINT:
# [330] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var NFX located at ebp-4, size=OS_S32
# Var NFY located at ebp-8, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
# [331] if not WinSavedValid then
	cmpb	$0,U_$WINDOWS_$$_WINSAVEDVALID
	je	.Lj144
	jmp	.Lj145
.Lj144:
# [332] Exit;
	jmp	.Lj142
	.balign 4,0x90
.Lj145:
# [334] RestoreBg;
	call	WINDOWS_$$_RESTOREBG
# [336] FrameX := NFX;
	movl	-4(%ebp),%eax
	movl	%eax,U_$WINDOWS_$$_FRAMEX
# [337] FrameY := NFY;
	movl	-8(%ebp),%eax
	movl	%eax,U_$WINDOWS_$$_FRAMEY
# [338] ClientX := FrameX + Border;
	movl	U_$WINDOWS_$$_FRAMEX,%eax
	leal	1(%eax),%eax
	movl	%eax,U_$WINDOWS_$$_CLIENTX
# [339] ClientY := FrameY + Border + TitleH;
	movl	U_$WINDOWS_$$_FRAMEY,%eax
	leal	1(%eax),%eax
	leal	20(%eax),%eax
	movl	%eax,U_$WINDOWS_$$_CLIENTY
# [340] UpdateClosePos;
	call	WINDOWS_$$_UPDATECLOSEPOS
# [342] CaptureRect(@WinBuf[0], FrameX, FrameY, FrameW, FrameH);
	pushl	U_$WINDOWS_$$_FRAMEW
	pushl	U_$WINDOWS_$$_FRAMEH
	movl	$U_$WINDOWS_$$_WINBUF,%eax
	movl	U_$WINDOWS_$$_FRAMEY,%ecx
	movl	U_$WINDOWS_$$_FRAMEX,%edx
	call	WINDOWS_$$_CAPTURERECT$PLONGWORD$LONGINT$LONGINT$LONGINT$LONGINT
# [344] BlitRect(@DragBuf[0], FrameX, FrameY, FrameW, FrameH);
	pushl	U_$WINDOWS_$$_FRAMEW
	pushl	U_$WINDOWS_$$_FRAMEH
	movl	$U_$WINDOWS_$$_DRAGBUF,%eax
	movl	U_$WINDOWS_$$_FRAMEY,%ecx
	movl	U_$WINDOWS_$$_FRAMEX,%edx
	call	WINDOWS_$$_BLITRECT$PLONGWORD$LONGINT$LONGINT$LONGINT$LONGINT
.Lj142:
# [345] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_windows_$$_wincreate$pchar$longint$longint$$longint,"x"
	.balign 16,0x90
.globl	WINDOWS_$$_WINCREATE$PCHAR$LONGINT$LONGINT$$LONGINT
WINDOWS_$$_WINCREATE$PCHAR$LONGINT$LONGINT$$LONGINT:
# [352] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-20(%esp),%esp
# Var Title located at ebp-4, size=OS_32
# Var W located at ebp-8, size=OS_S32
# Var H located at ebp-12, size=OS_S32
# Var $result located at ebp-16, size=OS_S32
# Var s located at ebp-20, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [353] if WOpen then
	cmpb	$0,U_$WINDOWS_$$_WOPEN
	jne	.Lj148
	jmp	.Lj149
.Lj148:
# [355] WinCreate := 0;
	movl	$0,-16(%ebp)
# [356] Exit;
	jmp	.Lj146
	.balign 4,0x90
.Lj149:
# [358] if (W <= 0) or (H <= 0) then
	cmpl	$0,-8(%ebp)
	jle	.Lj150
	jmp	.Lj151
.Lj151:
	cmpl	$0,-12(%ebp)
	jle	.Lj150
	jmp	.Lj152
.Lj150:
# [360] WinCreate := 0;
	movl	$0,-16(%ebp)
# [361] Exit;
	jmp	.Lj146
	.balign 4,0x90
.Lj152:
# [365] ClientW := W;
	movl	-8(%ebp),%eax
	movl	%eax,U_$WINDOWS_$$_CLIENTW
# [366] ClientH := H;
	movl	-12(%ebp),%eax
	movl	%eax,U_$WINDOWS_$$_CLIENTH
# [367] ClientX := (RWidth - W) div 2;
	movl	U_$VIDEO_$$_RWIDTH,%eax
	movl	-8(%ebp),%edx
	subl	%edx,%eax
	movl	%eax,%edx
	shrl	$31,%edx
	addl	%edx,%eax
	sarl	$1,%eax
	movl	%eax,U_$WINDOWS_$$_CLIENTX
# [368] ClientY := (RHeight - H) div 2;
	movl	U_$VIDEO_$$_RHEIGHT,%eax
	movl	-12(%ebp),%edx
	subl	%edx,%eax
	movl	%eax,%edx
	shrl	$31,%edx
	addl	%edx,%eax
	sarl	$1,%eax
	movl	%eax,U_$WINDOWS_$$_CLIENTY
# [369] FrameX := ClientX - Border;
	movl	U_$WINDOWS_$$_CLIENTX,%eax
	leal	-1(%eax),%eax
	movl	%eax,U_$WINDOWS_$$_FRAMEX
# [370] FrameY := ClientY - Border - TitleH;
	movl	U_$WINDOWS_$$_CLIENTY,%eax
	leal	-1(%eax),%eax
	subl	$20,%eax
	movl	%eax,U_$WINDOWS_$$_FRAMEY
# [371] FrameW := W + 2 * Border;
	movl	-8(%ebp),%eax
	leal	2(%eax),%eax
	movl	%eax,U_$WINDOWS_$$_FRAMEW
# [372] FrameH := TitleH + H + Border;
	movl	-12(%ebp),%eax
	leal	20(%eax),%eax
	leal	1(%eax),%eax
	movl	%eax,U_$WINDOWS_$$_FRAMEH
# [375] SaveBg;
	call	WINDOWS_$$_SAVEBG
# [378] WOpen := True;
	movb	$1,U_$WINDOWS_$$_WOPEN
# [379] WinLastKey := #0;
	movb	$0,U_$WINDOWS_$$_WINLASTKEY
# [380] PrevBtnDown := False;
	movb	$0,U_$WINDOWS_$$_PREVBTNDOWN
# [381] for s := 0 to 127 do
	movl	$-1,-20(%ebp)
	.balign 8,0x90
.Lj153:
	movl	-20(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-20(%ebp)
# [382] PrevScan[s] := False;
	movl	-20(%ebp),%eax
	movb	$0,U_$WINDOWS_$$_PREVSCAN(,%eax,1)
	cmpl	$127,-20(%ebp)
	jge	.Lj155
	jmp	.Lj153
.Lj155:
# [383] CurX := -1;
	movl	$-1,U_$WINDOWS_$$_CURX
# [384] CurY := -1;
	movl	$-1,U_$WINDOWS_$$_CURY
# [385] Dragging := False;
	movb	$0,U_$WINDOWS_$$_DRAGGING
# [386] CloseHover := False;
	movb	$0,U_$WINDOWS_$$_CLOSEHOVER
# [388] DrawFrame(Title);
	movl	-4(%ebp),%eax
	call	WINDOWS_$$_DRAWFRAME$PCHAR
# [391] FillRect(ClientX, ClientY, ClientW, ClientH, 0);
	pushl	U_$WINDOWS_$$_CLIENTH
	pushl	$0
	movl	U_$WINDOWS_$$_CLIENTW,%ecx
	movl	U_$WINDOWS_$$_CLIENTY,%edx
	movl	U_$WINDOWS_$$_CLIENTX,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [393] WinCreate := 1;
	movl	$1,-16(%ebp)
.Lj146:
# [394] end;
	movl	-16(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_windows_$$_windestroy,"x"
	.balign 16,0x90
.globl	WINDOWS_$$_WINDESTROY
WINDOWS_$$_WINDESTROY:
# [397] begin
	pushl	%ebp
	movl	%esp,%ebp
# [398] if not WOpen then
	cmpb	$0,U_$WINDOWS_$$_WOPEN
	je	.Lj158
	jmp	.Lj159
.Lj158:
# [399] Exit;
	jmp	.Lj156
	.balign 4,0x90
.Lj159:
# [400] Dragging := False;
	movb	$0,U_$WINDOWS_$$_DRAGGING
# [402] if (CurX >= 0) and (CurY >= 0) then
	cmpl	$0,U_$WINDOWS_$$_CURX
	jge	.Lj160
	jmp	.Lj161
.Lj160:
	cmpl	$0,U_$WINDOWS_$$_CURY
	jge	.Lj162
	jmp	.Lj161
.Lj162:
# [404] RestoreCursorArea(CurX, CurY);
	movl	U_$WINDOWS_$$_CURY,%edx
	movl	U_$WINDOWS_$$_CURX,%eax
	call	VIDEO_$$_RESTORECURSORAREA$LONGINT$LONGINT
# [405] CurX := -1;
	movl	$-1,U_$WINDOWS_$$_CURX
# [406] CurY := -1;
	movl	$-1,U_$WINDOWS_$$_CURY
	.balign 4,0x90
.Lj161:
# [408] RestoreBg;
	call	WINDOWS_$$_RESTOREBG
# [409] WOpen := False;
	movb	$0,U_$WINDOWS_$$_WOPEN
# [410] WinSavedValid := False;
	movb	$0,U_$WINDOWS_$$_WINSAVEDVALID
.Lj156:
# [411] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_windows_$$_scanchar$byte$$char,"x"
	.balign 16,0x90
WINDOWS_$$_SCANCHAR$BYTE$$CHAR:
# [416] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-12(%esp),%esp
# Var Sc located at ebp-4, size=OS_8
# Var $result located at ebp-8, size=OS_8
# Var i located at ebp-12, size=OS_S32
	movb	%al,-4(%ebp)
# [417] ScanChar := #0;
	movb	$0,-8(%ebp)
# [418] for i := Low(ScanToCharMap) to High(ScanToCharMap) do
	movl	$-1,-12(%ebp)
	.balign 8,0x90
.Lj165:
	movl	-12(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-12(%ebp)
# [419] if ScanToCharMap[i].Scan = Sc then
	movl	-12(%ebp),%eax
	movb	TC_$WINDOWS_$$_SCANTOCHARMAP(,%eax,2),%al
	cmpb	-4(%ebp),%al
	je	.Lj168
	jmp	.Lj169
.Lj168:
# [421] ScanChar := ScanToCharMap[i].Ch;
	movl	-12(%ebp),%eax
	movb	TC_$WINDOWS_$$_SCANTOCHARMAP+1(,%eax,2),%al
	movb	%al,-8(%ebp)
# [422] Exit;
	jmp	.Lj163
	.balign 4,0x90
.Lj169:
	cmpl	$37,-12(%ebp)
	jge	.Lj167
	jmp	.Lj165
.Lj167:
.Lj163:
# [424] end;
	movb	-8(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_windows_$$_winpoll$$longint,"x"
	.balign 16,0x90
.globl	WINDOWS_$$_WINPOLL$$LONGINT
WINDOWS_$$_WINPOLL$$LONGINT:
# [432] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-40(%esp),%esp
# Var $result located at ebp-4, size=OS_S32
# Var s located at ebp-8, size=OS_S32
# Var MX located at ebp-12, size=OS_S32
# Var MY located at ebp-16, size=OS_S32
# Var NFX located at ebp-20, size=OS_S32
# Var NFY located at ebp-24, size=OS_S32
# Var B located at ebp-28, size=OS_8
# Var LeftDown located at ebp-32, size=OS_8
# Var Hov located at ebp-36, size=OS_8
# Var ch located at ebp-40, size=OS_8
# [433] if not WOpen then
	cmpb	$0,U_$WINDOWS_$$_WOPEN
	je	.Lj172
	jmp	.Lj173
.Lj172:
# [435] WinPoll := 0;
	movl	$0,-4(%ebp)
# [436] Exit;
	jmp	.Lj170
	.balign 4,0x90
.Lj173:
# [439] KeyboardPoll;
	call	KEYBOARD_$$_KEYBOARDPOLL
# [440] MousePoll;
	call	MOUSE_$$_MOUSEPOLL
# [443] for s := 0 to 127 do
	movl	$-1,-8(%ebp)
	.balign 8,0x90
.Lj174:
	movl	-8(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-8(%ebp)
# [445] if ScanIsPressed(s) and (not PrevScan[s]) then
	movb	-8(%ebp),%al
	call	KEYBOARD_$$_SCANISPRESSED$BYTE$$BOOLEAN
	testb	%al,%al
	jne	.Lj177
	jmp	.Lj178
.Lj177:
	movl	-8(%ebp),%eax
	cmpb	$0,U_$WINDOWS_$$_PREVSCAN(,%eax,1)
	je	.Lj179
	jmp	.Lj178
.Lj179:
# [447] ch := ScanChar(s);
	movb	-8(%ebp),%al
	call	WINDOWS_$$_SCANCHAR$BYTE$$CHAR
	movb	%al,-40(%ebp)
# [448] if ch <> #0 then
	cmpb	$0,-40(%ebp)
	jne	.Lj180
	jmp	.Lj181
.Lj180:
# [449] WinLastKey := ch;
	movb	-40(%ebp),%al
	movb	%al,U_$WINDOWS_$$_WINLASTKEY
	.balign 4,0x90
.Lj181:
	.balign 4,0x90
.Lj178:
# [451] PrevScan[s] := ScanIsPressed(s);
	movb	-8(%ebp),%al
	call	KEYBOARD_$$_SCANISPRESSED$BYTE$$BOOLEAN
	movl	-8(%ebp),%edx
	movb	%al,U_$WINDOWS_$$_PREVSCAN(,%edx,1)
	cmpl	$127,-8(%ebp)
	jge	.Lj176
	jmp	.Lj174
.Lj176:
# [454] MX := GetMouseX;
	call	MOUSE_$$_GETMOUSEX$$LONGINT
	movl	%eax,-12(%ebp)
# [455] MY := GetMouseY;
	call	MOUSE_$$_GETMOUSEY$$LONGINT
	movl	%eax,-16(%ebp)
# [456] B := GetMouseButtons;
	call	MOUSE_$$_GETMOUSEBUTTONS$$BYTE
	movb	%al,-28(%ebp)
# [457] LeftDown := (B and 1) <> 0;
	movzbw	-28(%ebp),%ax
	andw	$1,%ax
	testw	$-1,%ax
	setneb	-32(%ebp)
# [460] if Dragging then
	cmpb	$0,U_$WINDOWS_$$_DRAGGING
	jne	.Lj182
	jmp	.Lj183
.Lj182:
# [462] if not LeftDown then
	cmpb	$0,-32(%ebp)
	je	.Lj184
	jmp	.Lj185
.Lj184:
# [463] Dragging := False
	movb	$0,U_$WINDOWS_$$_DRAGGING
	jmp	.Lj186
.Lj185:
# [466] NFX := MX - DragDX;
	movl	-12(%ebp),%eax
	movl	U_$WINDOWS_$$_DRAGDX,%edx
	subl	%edx,%eax
	movl	%eax,-20(%ebp)
# [467] NFY := MY - DragDY;
	movl	-16(%ebp),%eax
	movl	U_$WINDOWS_$$_DRAGDY,%edx
	subl	%edx,%eax
	movl	%eax,-24(%ebp)
# [468] ClampFrame(NFX, NFY);
	leal	-24(%ebp),%edx
	leal	-20(%ebp),%eax
	call	WINDOWS_$$_CLAMPFRAME$LONGINT$LONGINT
# [469] if (NFX <> FrameX) or (NFY <> FrameY) then
	movl	-20(%ebp),%eax
	cmpl	U_$WINDOWS_$$_FRAMEX,%eax
	jne	.Lj187
	jmp	.Lj188
.Lj188:
	movl	-24(%ebp),%eax
	cmpl	U_$WINDOWS_$$_FRAMEY,%eax
	jne	.Lj187
	jmp	.Lj189
.Lj187:
# [470] MoveWindowTo(NFX, NFY);
	movl	-24(%ebp),%edx
	movl	-20(%ebp),%eax
	call	WINDOWS_$$_MOVEWINDOWTO$LONGINT$LONGINT
	.balign 4,0x90
.Lj189:
.Lj186:
	jmp	.Lj190
.Lj183:
# [473] else if LeftDown and (not PrevBtnDown) then
	cmpb	$0,-32(%ebp)
	jne	.Lj191
	jmp	.Lj192
.Lj191:
	cmpb	$0,U_$WINDOWS_$$_PREVBTNDOWN
	je	.Lj193
	jmp	.Lj192
.Lj193:
# [476] if PtInRect(MX, MY, CloseX, CloseY, CloseW, CloseH) then
	pushl	U_$WINDOWS_$$_CLOSEY
	pushl	$12
	pushl	$12
	movl	U_$WINDOWS_$$_CLOSEX,%ecx
	movl	-16(%ebp),%edx
	movl	-12(%ebp),%eax
	call	WINDOWS_$$_PTINRECT$LONGINT$LONGINT$LONGINT$LONGINT$LONGINT$LONGINT$$BOOLEAN
	testb	%al,%al
	jne	.Lj194
	jmp	.Lj195
.Lj194:
# [478] WinPoll := 1;   // WINEV_CLOSE
	movl	$1,-4(%ebp)
# [479] Exit;
	jmp	.Lj170
	jmp	.Lj196
.Lj195:
# [481] else if PtInRect(MX, MY, FrameX, FrameY, FrameW, ClientY - FrameY) then
	pushl	U_$WINDOWS_$$_FRAMEY
	pushl	U_$WINDOWS_$$_FRAMEW
	movl	U_$WINDOWS_$$_CLIENTY,%eax
	movl	U_$WINDOWS_$$_FRAMEY,%edx
	subl	%edx,%eax
	pushl	%eax
	movl	U_$WINDOWS_$$_FRAMEX,%ecx
	movl	-16(%ebp),%edx
	movl	-12(%ebp),%eax
	call	WINDOWS_$$_PTINRECT$LONGINT$LONGINT$LONGINT$LONGINT$LONGINT$LONGINT$$BOOLEAN
	testb	%al,%al
	jne	.Lj197
	jmp	.Lj198
.Lj197:
# [482] if (FrameW <= MaxWinW) and (FrameH <= MaxWinH) then
	cmpl	$640,U_$WINDOWS_$$_FRAMEW
	jle	.Lj199
	jmp	.Lj200
.Lj199:
	cmpl	$480,U_$WINDOWS_$$_FRAMEH
	jle	.Lj201
	jmp	.Lj200
.Lj201:
# [483] StartDrag(MX, MY);
	movl	-16(%ebp),%edx
	movl	-12(%ebp),%eax
	call	WINDOWS_$$_STARTDRAG$LONGINT$LONGINT
	.balign 4,0x90
.Lj200:
	.balign 4,0x90
.Lj198:
.Lj196:
	.balign 4,0x90
.Lj192:
.Lj190:
# [486] PrevBtnDown := LeftDown;
	movb	-32(%ebp),%al
	movb	%al,U_$WINDOWS_$$_PREVBTNDOWN
# [489] Hov := PtInRect(MX, MY, CloseX, CloseY, CloseW, CloseH) and (not Dragging);
	pushl	U_$WINDOWS_$$_CLOSEY
	pushl	$12
	pushl	$12
	movl	U_$WINDOWS_$$_CLOSEX,%ecx
	movl	-16(%ebp),%edx
	movl	-12(%ebp),%eax
	call	WINDOWS_$$_PTINRECT$LONGINT$LONGINT$LONGINT$LONGINT$LONGINT$LONGINT$$BOOLEAN
	testb	%al,%al
	jne	.Lj202
	jmp	.Lj203
.Lj202:
	cmpb	$0,U_$WINDOWS_$$_DRAGGING
	je	.Lj204
	jmp	.Lj203
.Lj204:
	movb	$1,-36(%ebp)
	jmp	.Lj205
.Lj203:
	movb	$0,-36(%ebp)
.Lj205:
# [490] if Hov <> CloseHover then
	movb	-36(%ebp),%al
	cmpb	U_$WINDOWS_$$_CLOSEHOVER,%al
	jne	.Lj206
	jmp	.Lj207
.Lj206:
# [492] CloseHover := Hov;
	movb	-36(%ebp),%al
	movb	%al,U_$WINDOWS_$$_CLOSEHOVER
# [493] DrawCloseIcon(Hov);
	movb	-36(%ebp),%al
	call	WINDOWS_$$_DRAWCLOSEICON$BOOLEAN
	.balign 4,0x90
.Lj207:
# [499] if (MX <> CurX) or (MY <> CurY) then
	movl	-12(%ebp),%eax
	cmpl	U_$WINDOWS_$$_CURX,%eax
	jne	.Lj208
	jmp	.Lj209
.Lj209:
	movl	-16(%ebp),%eax
	cmpl	U_$WINDOWS_$$_CURY,%eax
	jne	.Lj208
	jmp	.Lj210
.Lj208:
# [501] if (CurX >= 0) and (CurY >= 0) then
	cmpl	$0,U_$WINDOWS_$$_CURX
	jge	.Lj211
	jmp	.Lj212
.Lj211:
	cmpl	$0,U_$WINDOWS_$$_CURY
	jge	.Lj213
	jmp	.Lj212
.Lj213:
# [502] RestoreCursorArea(CurX, CurY);
	movl	U_$WINDOWS_$$_CURY,%edx
	movl	U_$WINDOWS_$$_CURX,%eax
	call	VIDEO_$$_RESTORECURSORAREA$LONGINT$LONGINT
	.balign 4,0x90
.Lj212:
# [503] SaveCursorArea(MX, MY);
	movl	-16(%ebp),%edx
	movl	-12(%ebp),%eax
	call	VIDEO_$$_SAVECURSORAREA$LONGINT$LONGINT
# [504] DrawCursor(MX, MY);
	movl	-16(%ebp),%edx
	movl	-12(%ebp),%eax
	call	VIDEO_$$_DRAWCURSOR$LONGINT$LONGINT
# [505] CurX := MX;
	movl	-12(%ebp),%eax
	movl	%eax,U_$WINDOWS_$$_CURX
# [506] CurY := MY;
	movl	-16(%ebp),%eax
	movl	%eax,U_$WINDOWS_$$_CURY
	.balign 4,0x90
.Lj210:
# [509] WinPoll := 0;
	movl	$0,-4(%ebp)
.Lj170:
# [510] end;
	movl	-4(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_windows_$$_winkey$$char,"x"
	.balign 16,0x90
.globl	WINDOWS_$$_WINKEY$$CHAR
WINDOWS_$$_WINKEY$$CHAR:
# [513] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-4(%esp),%esp
# Var $result located at ebp-4, size=OS_8
# [514] WinKey := WinLastKey;
	movb	U_$WINDOWS_$$_WINLASTKEY,%al
	movb	%al,-4(%ebp)
# [515] end;
	movb	-4(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret
# End asmlist al_procedures
# Begin asmlist al_globals

.section .bss
# [95] WOpen: Boolean;
U_$WINDOWS_$$_WOPEN:
	.zero 1

.section .bss
	.balign 4
# [96] FrameX, FrameY, FrameW, FrameH: Integer;       // moldura total
U_$WINDOWS_$$_FRAMEX:
	.zero 4

.section .bss
	.balign 4
U_$WINDOWS_$$_FRAMEY:
	.zero 4

.section .bss
	.balign 4
U_$WINDOWS_$$_FRAMEW:
	.zero 4

.section .bss
	.balign 4
U_$WINDOWS_$$_FRAMEH:
	.zero 4

.section .bss
	.balign 4
# [97] ClientX, ClientY, ClientW, ClientH: Integer;   // area de desenho do programa
U_$WINDOWS_$$_CLIENTX:
	.zero 4

.section .bss
	.balign 4
U_$WINDOWS_$$_CLIENTY:
	.zero 4

.section .bss
	.balign 4
U_$WINDOWS_$$_CLIENTW:
	.zero 4

.section .bss
	.balign 4
U_$WINDOWS_$$_CLIENTH:
	.zero 4

.section .bss
	.balign 4
# [98] CloseX, CloseY: Integer;                       // canto sup. esquerdo do icone
U_$WINDOWS_$$_CLOSEX:
	.zero 4

.section .bss
	.balign 4
U_$WINDOWS_$$_CLOSEY:
	.zero 4

.section .bss
# [99] WinLastKey: Char;
U_$WINDOWS_$$_WINLASTKEY:
	.zero 1

.section .bss
# [100] PrevScan: array[0..127] of Boolean;
U_$WINDOWS_$$_PREVSCAN:
	.zero 128

.section .bss
# [101] PrevBtnDown: Boolean;
U_$WINDOWS_$$_PREVBTNDOWN:
	.zero 1

.section .bss
	.balign 4
# [102] CurX, CurY: Integer;
U_$WINDOWS_$$_CURX:
	.zero 4

.section .bss
	.balign 4
U_$WINDOWS_$$_CURY:
	.zero 4

.section .bss
# [105] Dragging: Boolean;
U_$WINDOWS_$$_DRAGGING:
	.zero 1

.section .bss
	.balign 4
# [106] DragDX, DragDY: Integer;
U_$WINDOWS_$$_DRAGDX:
	.zero 4

.section .bss
	.balign 4
U_$WINDOWS_$$_DRAGDY:
	.zero 4

.section .bss
# [107] CloseHover: Boolean;
U_$WINDOWS_$$_CLOSEHOVER:
	.zero 1

.section .bss
	.balign 4
# [112] WinBuf: array[0 .. MaxWinW * MaxWinH - 1] of LongWord;
U_$WINDOWS_$$_WINBUF:
	.zero 1228800

.section .bss
	.balign 4
# [113] DragBuf: array[0 .. MaxWinW * MaxWinH - 1] of LongWord;
U_$WINDOWS_$$_DRAGBUF:
	.zero 1228800

.section .bss
# [114] WinSavedValid: Boolean;
U_$WINDOWS_$$_WINSAVEDVALID:
	.zero 1
# End asmlist al_globals
# Begin asmlist al_typedconsts

.section .data.n_TC_$WINDOWS_$$_SCANTOCHARMAP,"d"
TC_$WINDOWS_$$_SCANTOCHARMAP:
	.byte	2,49,3,50,4,51,5,52,6,53,7,54,8,55,9,56,10,57,11,48,16,113,17,119,18,101,19,114,20,116,21,121,22,117,23,105
	.byte	24,111,25,112,30,97,31,115,32,100,33,102,34,103,35,104,36,106,37,107,38,108,44,122,45,120,46,99,47,118
	.byte	48,98,49,110,50,109,57,32,28,13
# [88] const

.section .rodata.n__$WINDOWS$_Ld1,"d"
	.balign 4
.globl	_$WINDOWS$_Ld1
_$WINDOWS$_Ld1:
	.ascii	"SYSTEM\\COMPILED\\PRISM\\WINDOWMANAGER\\CLOSE@2.BMP"
	.ascii	"\000"

.section .rodata.n__$WINDOWS$_Ld2,"d"
	.balign 4
.globl	_$WINDOWS$_Ld2
_$WINDOWS$_Ld2:
	.ascii	"SYSTEM\\COMPILED\\PRISM\\WINDOWMANAGER\\CLOSE.BMP\000"
# End asmlist al_typedconsts

