	.file "video.pas"
# Begin asmlist al_procedures

.section .text.n_video_$$_packpix$byte$byte$byte$$longword,"x"
	.balign 16,0x90
VIDEO_$$_PACKPIX$BYTE$BYTE$BYTE$$LONGWORD:
# [video.pas]
# [53] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-16(%esp),%esp
# Var R located at ebp-4, size=OS_8
# Var G located at ebp-8, size=OS_8
# Var B located at ebp-12, size=OS_8
# Var $result located at ebp-16, size=OS_32
	movb	%al,-4(%ebp)
	movb	%dl,-8(%ebp)
	movb	%cl,-12(%ebp)
# [54] PackPix := LongWord(R) or (LongWord(G) shl 8) or (LongWord(B) shl 16);
	movzbl	-8(%ebp),%eax
	shll	$8,%eax
	movzbl	-4(%ebp),%edx
	orl	%edx,%eax
	movzbl	-12(%ebp),%edx
	shll	$16,%edx
	orl	%edx,%eax
	movl	%eax,-16(%ebp)
# [55] end;
	movl	-16(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_video_$$_palcolor$byte$$longword,"x"
	.balign 16,0x90
VIDEO_$$_PALCOLOR$BYTE$$LONGWORD:
# [59] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var C located at ebp-4, size=OS_8
# Var $result located at ebp-8, size=OS_32
	movb	%al,-4(%ebp)
# [60] PalColor := PackPix(PalR[C], PalG[C], PalB[C]);
	movzbl	-4(%ebp),%eax
	movb	U_$VIDEO_$$_PALB(,%eax,1),%cl
	movzbl	-4(%ebp),%eax
	movb	U_$VIDEO_$$_PALG(,%eax,1),%dl
	movzbl	-4(%ebp),%eax
	movb	U_$VIDEO_$$_PALR(,%eax,1),%al
	call	VIDEO_$$_PACKPIX$BYTE$BYTE$BYTE$$LONGWORD
	movl	%eax,-8(%ebp)
# [61] end;
	movl	-8(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_video_$$_initpalette,"x"
	.balign 16,0x90
VIDEO_$$_INITPALETTE:
# [67] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-56(%esp),%esp
# Var i located at ebp-4, size=OS_S32
# Var lvl located at ebp-8, size=OS_S32
# Var BClr located at ebp-56, size=OS_NO
# [69] BClr[1][0] := 0;    BClr[1][1] := 0;    BClr[1][2] := 170;   // azul
	movb	$0,-53(%ebp)
	movb	$0,-52(%ebp)
	movb	$170,-51(%ebp)
# [70] BClr[2][0] := 0;    BClr[2][1] := 170;  BClr[2][2] := 0;     // verde
	movb	$0,-50(%ebp)
	movb	$170,-49(%ebp)
	movb	$0,-48(%ebp)
# [71] BClr[3][0] := 0;    BClr[3][1] := 170;  BClr[3][2] := 170;   // ciano
	movb	$0,-47(%ebp)
	movb	$170,-46(%ebp)
	movb	$170,-45(%ebp)
# [72] BClr[4][0] := 170;  BClr[4][1] := 0;    BClr[4][2] := 0;     // vermelho
	movb	$170,-44(%ebp)
	movb	$0,-43(%ebp)
	movb	$0,-42(%ebp)
# [73] BClr[5][0] := 170;  BClr[5][1] := 0;    BClr[5][2] := 170;   // magenta
	movb	$170,-41(%ebp)
	movb	$0,-40(%ebp)
	movb	$170,-39(%ebp)
# [74] BClr[6][0] := 170;  BClr[6][1] := 85;   BClr[6][2] := 0;     // marrom
	movb	$170,-38(%ebp)
	movb	$85,-37(%ebp)
	movb	$0,-36(%ebp)
# [75] BClr[7][0] := 170;  BClr[7][1] := 170;  BClr[7][2] := 170;   // cinza claro
	movb	$170,-35(%ebp)
	movb	$170,-34(%ebp)
	movb	$170,-33(%ebp)
# [76] BClr[8][0] := 85;   BClr[8][1] := 85;   BClr[8][2] := 85;    // cinza escuro
	movb	$85,-32(%ebp)
	movb	$85,-31(%ebp)
	movb	$85,-30(%ebp)
# [77] BClr[9][0] := 85;   BClr[9][1] := 85;   BClr[9][2] := 255;   // azul claro
	movb	$85,-29(%ebp)
	movb	$85,-28(%ebp)
	movb	$255,-27(%ebp)
# [78] BClr[10][0] := 85;  BClr[10][1] := 255; BClr[10][2] := 85;   // verde claro
	movb	$85,-26(%ebp)
	movb	$255,-25(%ebp)
	movb	$85,-24(%ebp)
# [79] BClr[11][0] := 85;  BClr[11][1] := 255; BClr[11][2] := 255;  // ciano claro
	movb	$85,-23(%ebp)
	movb	$255,-22(%ebp)
	movb	$255,-21(%ebp)
# [80] BClr[12][0] := 255; BClr[12][1] := 85;  BClr[12][2] := 85;   // vermelho claro
	movb	$255,-20(%ebp)
	movb	$85,-19(%ebp)
	movb	$85,-18(%ebp)
# [81] BClr[13][0] := 255; BClr[13][1] := 85;  BClr[13][2] := 255;  // magenta claro
	movb	$255,-17(%ebp)
	movb	$85,-16(%ebp)
	movb	$255,-15(%ebp)
# [82] BClr[14][0] := 255; BClr[14][1] := 255; BClr[14][2] := 85;   // amarelo
	movb	$255,-14(%ebp)
	movb	$255,-13(%ebp)
	movb	$85,-12(%ebp)
# [84] PalR[0] := 0; PalG[0] := 0; PalB[0] := 0;
	movb	$0,U_$VIDEO_$$_PALR
	movb	$0,U_$VIDEO_$$_PALG
	movb	$0,U_$VIDEO_$$_PALB
# [85] for i := 1 to 14 do
	movl	$0,-4(%ebp)
	.balign 8,0x90
.Lj9:
	movl	-4(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-4(%ebp)
# [87] PalR[i] := BClr[i][0];
	movl	-4(%ebp),%edx
	movl	-4(%ebp),%eax
	leal	(%eax,%eax,2),%eax
	movb	-56(%ebp,%eax),%al
	movb	%al,U_$VIDEO_$$_PALR(,%edx,1)
# [88] PalG[i] := BClr[i][1];
	movl	-4(%ebp),%edx
	movl	-4(%ebp),%eax
	leal	(%eax,%eax,2),%eax
	movb	-55(%ebp,%eax),%al
	movb	%al,U_$VIDEO_$$_PALG(,%edx,1)
# [89] PalB[i] := BClr[i][2];
	movl	-4(%ebp),%edx
	movl	-4(%ebp),%eax
	leal	(%eax,%eax,2),%eax
	movb	-54(%ebp,%eax),%al
	movb	%al,U_$VIDEO_$$_PALB(,%edx,1)
	cmpl	$14,-4(%ebp)
	jge	.Lj11
	jmp	.Lj9
.Lj11:
# [91] PalR[15] := 255; PalG[15] := 255; PalB[15] := 255;
	movb	$255,U_$VIDEO_$$_PALR+15
	movb	$255,U_$VIDEO_$$_PALG+15
	movb	$255,U_$VIDEO_$$_PALB+15
# [94] for i := 0 to 215 do
	movl	$-1,-4(%ebp)
	.balign 8,0x90
.Lj12:
	movl	-4(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-4(%ebp)
# [96] lvl := (i div 36) * 51;
	movl	-4(%ebp),%ecx
	movl	$954437177,%eax
	imull	%ecx
	sarl	$3,%edx
	shrl	$31,%ecx
	addl	%ecx,%edx
	imull	$51,%edx
	movl	%edx,-8(%ebp)
# [97] PalR[16 + i] := Byte(lvl);
	movl	-4(%ebp),%eax
	leal	16(%eax),%eax
	movb	-8(%ebp),%dl
	movb	%dl,U_$VIDEO_$$_PALR(,%eax,1)
# [98] lvl := ((i mod 36) div 6) * 51;
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
	movl	%edx,-8(%ebp)
# [99] PalG[16 + i] := Byte(lvl);
	movl	-4(%ebp),%eax
	leal	16(%eax),%eax
	movb	-8(%ebp),%dl
	movb	%dl,U_$VIDEO_$$_PALG(,%eax,1)
# [100] lvl := (i mod 6) * 51;
	movl	-4(%ebp),%eax
	cltd
	movl	$6,%ecx
	idivl	%ecx
	imull	$51,%edx
	movl	%edx,-8(%ebp)
# [101] PalB[16 + i] := Byte(lvl);
	movl	-4(%ebp),%eax
	leal	16(%eax),%eax
	movb	-8(%ebp),%dl
	movb	%dl,U_$VIDEO_$$_PALB(,%eax,1)
	cmpl	$215,-4(%ebp)
	jge	.Lj14
	jmp	.Lj12
.Lj14:
# [105] for i := 0 to 23 do
	movl	$-1,-4(%ebp)
	.balign 8,0x90
.Lj15:
	movl	-4(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-4(%ebp)
# [107] lvl := i * 11;
	movl	-4(%ebp),%eax
	imull	$11,%eax,%eax
	movl	%eax,-8(%ebp)
# [108] if lvl > 255 then lvl := 255;
	cmpl	$255,-8(%ebp)
	jg	.Lj18
	jmp	.Lj19
.Lj18:
	movl	$255,-8(%ebp)
	.balign 4,0x90
.Lj19:
# [109] PalR[232 + i] := Byte(lvl);
	movl	-4(%ebp),%eax
	leal	232(%eax),%eax
	movb	-8(%ebp),%dl
	movb	%dl,U_$VIDEO_$$_PALR(,%eax,1)
# [110] PalG[232 + i] := Byte(lvl);
	movl	-4(%ebp),%eax
	leal	232(%eax),%eax
	movb	-8(%ebp),%dl
	movb	%dl,U_$VIDEO_$$_PALG(,%eax,1)
# [111] PalB[232 + i] := Byte(lvl);
	movl	-4(%ebp),%eax
	leal	232(%eax),%eax
	movb	-8(%ebp),%dl
	movb	%dl,U_$VIDEO_$$_PALB(,%eax,1)
	cmpl	$23,-4(%ebp)
	jge	.Lj17
	jmp	.Lj15
.Lj17:
# [113] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_video_$$_videoinit,"x"
	.balign 16,0x90
.globl	VIDEO_$$_VIDEOINIT
VIDEO_$$_VIDEOINIT:
# [116] begin
	pushl	%ebp
	movl	%esp,%ebp
# [117] Framebuffer := PByte(PLongWord($1000)^);
	movl	4096,%eax
	movl	%eax,U_$VIDEO_$$_FRAMEBUFFER
# [118] RWidth := Integer(PWord($1004)^);
	movzwl	4100,%eax
	movl	%eax,U_$VIDEO_$$_RWIDTH
# [119] RHeight := Integer(PWord($1006)^);
	movzwl	4102,%eax
	movl	%eax,U_$VIDEO_$$_RHEIGHT
# [120] VPitch := Integer(PWord($1008)^);
	movzwl	4104,%eax
	movl	%eax,U_$VIDEO_$$_VPITCH
# [121] if VPitch < RWidth * BPP then
	movl	U_$VIDEO_$$_RWIDTH,%eax
	shll	$2,%eax
	cmpl	U_$VIDEO_$$_VPITCH,%eax
	jg	.Lj22
	jmp	.Lj23
.Lj22:
# [122] VPitch := RWidth * BPP;
	movl	U_$VIDEO_$$_RWIDTH,%eax
	shll	$2,%eax
	movl	%eax,U_$VIDEO_$$_VPITCH
	.balign 4,0x90
.Lj23:
# [123] InitPalette;
	call	VIDEO_$$_INITPALETTE
# [124] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_video_$$_putpixel$longint$longint$byte,"x"
	.balign 16,0x90
.globl	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE:
# [127] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-12(%esp),%esp
# Var X located at ebp-4, size=OS_S32
# Var Y located at ebp-8, size=OS_S32
# Var Color located at ebp-12, size=OS_8
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movb	%cl,-12(%ebp)
# [128] PLongWord(PByte(Framebuffer) + Y * VPitch + X * BPP)^ := PalColor(Color);
	movb	-12(%ebp),%al
	call	VIDEO_$$_PALCOLOR$BYTE$$LONGWORD
	movl	-8(%ebp),%ecx
	movl	U_$VIDEO_$$_VPITCH,%edx
	imull	%ecx,%edx
	addl	U_$VIDEO_$$_FRAMEBUFFER,%edx
	movl	-4(%ebp),%ecx
	shll	$2,%ecx
	leal	(%edx,%ecx),%edx
	movl	%eax,(%edx)
# [129] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_video_$$_drawline$longint$longint$longint$longint$byte,"x"
	.balign 16,0x90
.globl	VIDEO_$$_DRAWLINE$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
VIDEO_$$_DRAWLINE$LONGINT$LONGINT$LONGINT$LONGINT$BYTE:
# [137] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-40(%esp),%esp
# Var X0 located at ebp-4, size=OS_S32
# Var Y0 located at ebp-8, size=OS_S32
# Var X1 located at ebp-12, size=OS_S32
# Var Y1 located at ebp+12, size=OS_S32
# Var Color located at ebp+8, size=OS_8
# Var DX located at ebp-16, size=OS_S32
# Var DY located at ebp-20, size=OS_S32
# Var SX located at ebp-24, size=OS_S32
# Var SY located at ebp-28, size=OS_S32
# Var Err located at ebp-32, size=OS_S32
# Var E2 located at ebp-36, size=OS_S32
# Var Pix located at ebp-40, size=OS_32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [138] DX := X1 - X0;
	movl	-12(%ebp),%eax
	movl	-4(%ebp),%edx
	subl	%edx,%eax
	movl	%eax,-16(%ebp)
# [139] if DX < 0 then DX := -DX;
	cmpl	$0,-16(%ebp)
	jl	.Lj28
	jmp	.Lj29
.Lj28:
	movl	-16(%ebp),%eax
	negl	%eax
	movl	%eax,-16(%ebp)
	.balign 4,0x90
.Lj29:
# [140] DY := Y1 - Y0;
	movl	12(%ebp),%eax
	movl	-8(%ebp),%edx
	subl	%edx,%eax
	movl	%eax,-20(%ebp)
# [141] if DY < 0 then DY := -DY;
	cmpl	$0,-20(%ebp)
	jl	.Lj30
	jmp	.Lj31
.Lj30:
	movl	-20(%ebp),%eax
	negl	%eax
	movl	%eax,-20(%ebp)
	.balign 4,0x90
.Lj31:
# [142] if X0 < X1 then SX := 1 else SX := -1;
	movl	-4(%ebp),%eax
	cmpl	-12(%ebp),%eax
	jl	.Lj32
	jmp	.Lj33
.Lj32:
	movl	$1,-24(%ebp)
	jmp	.Lj34
.Lj33:
	movl	$-1,-24(%ebp)
.Lj34:
# [143] if Y0 < Y1 then SY := 1 else SY := -1;
	movl	-8(%ebp),%eax
	cmpl	12(%ebp),%eax
	jl	.Lj35
	jmp	.Lj36
.Lj35:
	movl	$1,-28(%ebp)
	jmp	.Lj37
.Lj36:
	movl	$-1,-28(%ebp)
.Lj37:
# [144] Err := DX - DY;
	movl	-16(%ebp),%eax
	movl	-20(%ebp),%edx
	subl	%edx,%eax
	movl	%eax,-32(%ebp)
# [145] Pix := PalColor(Color);
	movb	8(%ebp),%al
	call	VIDEO_$$_PALCOLOR$BYTE$$LONGWORD
	movl	%eax,-40(%ebp)
# [146] while True do
	jmp	.Lj39
	.balign 8,0x90
.Lj38:
# [148] if (X0 >= 0) and (X0 < RWidth) and (Y0 >= 0) and (Y0 < RHeight) then
	cmpl	$0,-4(%ebp)
	jge	.Lj41
	jmp	.Lj42
.Lj41:
	movl	-4(%ebp),%eax
	cmpl	U_$VIDEO_$$_RWIDTH,%eax
	jl	.Lj43
	jmp	.Lj42
.Lj43:
	cmpl	$0,-8(%ebp)
	jge	.Lj44
	jmp	.Lj42
.Lj44:
	movl	-8(%ebp),%eax
	cmpl	U_$VIDEO_$$_RHEIGHT,%eax
	jl	.Lj45
	jmp	.Lj42
.Lj45:
# [149] PLongWord(PByte(Framebuffer) + Y0 * VPitch + X0 * BPP)^ := Pix;
	movl	-8(%ebp),%edx
	movl	U_$VIDEO_$$_VPITCH,%eax
	imull	%edx,%eax
	addl	U_$VIDEO_$$_FRAMEBUFFER,%eax
	movl	-4(%ebp),%edx
	shll	$2,%edx
	leal	(%eax,%edx),%eax
	movl	-40(%ebp),%edx
	movl	%edx,(%eax)
	.balign 4,0x90
.Lj42:
# [150] if (X0 = X1) and (Y0 = Y1) then
	movl	-4(%ebp),%eax
	cmpl	-12(%ebp),%eax
	je	.Lj46
	jmp	.Lj47
.Lj46:
	movl	-8(%ebp),%eax
	cmpl	12(%ebp),%eax
	je	.Lj48
	jmp	.Lj47
.Lj48:
# [151] Break;
	jmp	.Lj40
	.balign 4,0x90
.Lj47:
# [152] E2 := 2 * Err;
	movl	-32(%ebp),%eax
	shll	$1,%eax
	movl	%eax,-36(%ebp)
# [153] if E2 > -DY then
	movl	-20(%ebp),%eax
	negl	%eax
	cmpl	-36(%ebp),%eax
	jl	.Lj49
	jmp	.Lj50
.Lj49:
# [155] Err := Err - DY;
	movl	-32(%ebp),%eax
	movl	-20(%ebp),%edx
	subl	%edx,%eax
	movl	%eax,-32(%ebp)
# [156] X0 := X0 + SX;
	movl	-4(%ebp),%eax
	movl	-24(%ebp),%edx
	leal	(%eax,%edx),%eax
	movl	%eax,-4(%ebp)
	.balign 4,0x90
.Lj50:
# [158] if E2 < DX then
	movl	-36(%ebp),%eax
	cmpl	-16(%ebp),%eax
	jl	.Lj51
	jmp	.Lj52
.Lj51:
# [160] Err := Err + DX;
	movl	-32(%ebp),%eax
	movl	-16(%ebp),%edx
	leal	(%eax,%edx),%eax
	movl	%eax,-32(%ebp)
# [161] Y0 := Y0 + SY;
	movl	-8(%ebp),%eax
	movl	-28(%ebp),%edx
	leal	(%eax,%edx),%eax
	movl	%eax,-8(%ebp)
	.balign 4,0x90
.Lj52:
.Lj39:
	jmp	.Lj38
.Lj40:
# [164] end;
	movl	%ebp,%esp
	popl	%ebp
	ret	$8

.section .text.n_video_$$_fillrect$longint$longint$longint$longint$byte,"x"
	.balign 16,0x90
.globl	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE:
# [170] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-24(%esp),%esp
	pushl	%ebx
# Var X located at ebp-4, size=OS_S32
# Var Y located at ebp-8, size=OS_S32
# Var W located at ebp-12, size=OS_S32
# Var H located at ebp+12, size=OS_S32
# Var Color located at ebp+8, size=OS_8
# Var YY located at ebp-16, size=OS_S32
# Var XX located at ebp-20, size=OS_S32
# Var Pix located at ebp-24, size=OS_32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [171] Pix := PalColor(Color);
	movb	8(%ebp),%al
	call	VIDEO_$$_PALCOLOR$BYTE$$LONGWORD
	movl	%eax,-24(%ebp)
# [172] for YY := Y to Y + H - 1 do
	movl	-8(%ebp),%eax
	movl	12(%ebp),%edx
	leal	(%eax,%edx),%eax
	subl	$1,%eax
	cmpl	-8(%ebp),%eax
	jge	.Lj55
	jmp	.Lj56
.Lj55:
	movl	-8(%ebp),%edx
	leal	-1(%edx),%edx
	movl	%edx,-16(%ebp)
	.balign 8,0x90
.Lj57:
	movl	-16(%ebp),%edx
	leal	1(%edx),%edx
	movl	%edx,-16(%ebp)
# [173] if (YY >= 0) and (YY < RHeight) then
	cmpl	$0,-16(%ebp)
	jge	.Lj60
	jmp	.Lj61
.Lj60:
	movl	-16(%ebp),%edx
	cmpl	U_$VIDEO_$$_RHEIGHT,%edx
	jl	.Lj62
	jmp	.Lj61
.Lj62:
# [174] for XX := X to X + W - 1 do
	movl	-4(%ebp),%edx
	movl	-12(%ebp),%ecx
	leal	(%edx,%ecx),%edx
	subl	$1,%edx
	cmpl	-4(%ebp),%edx
	jge	.Lj63
	jmp	.Lj64
.Lj63:
	movl	-4(%ebp),%ecx
	leal	-1(%ecx),%ecx
	movl	%ecx,-20(%ebp)
	.balign 8,0x90
.Lj65:
	movl	-20(%ebp),%ecx
	leal	1(%ecx),%ecx
	movl	%ecx,-20(%ebp)
# [175] if (XX >= 0) and (XX < RWidth) then
	cmpl	$0,-20(%ebp)
	jge	.Lj68
	jmp	.Lj69
.Lj68:
	movl	-20(%ebp),%ecx
	cmpl	U_$VIDEO_$$_RWIDTH,%ecx
	jl	.Lj70
	jmp	.Lj69
.Lj70:
# [176] PLongWord(PByte(Framebuffer) + YY * VPitch + XX * BPP)^ := Pix;
	movl	-16(%ebp),%ebx
	movl	U_$VIDEO_$$_VPITCH,%ecx
	imull	%ebx,%ecx
	addl	U_$VIDEO_$$_FRAMEBUFFER,%ecx
	movl	-20(%ebp),%ebx
	shll	$2,%ebx
	leal	(%ecx,%ebx),%ebx
	movl	-24(%ebp),%ecx
	movl	%ecx,(%ebx)
	.balign 4,0x90
.Lj69:
	cmpl	-20(%ebp),%edx
	jle	.Lj67
	jmp	.Lj65
.Lj67:
	.balign 4,0x90
.Lj64:
	.balign 4,0x90
.Lj61:
	cmpl	-16(%ebp),%eax
	jle	.Lj59
	jmp	.Lj57
.Lj59:
	.balign 4,0x90
.Lj56:
# [177] end;
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret	$8

.section .text.n_video_$$_clearscreen$byte,"x"
	.balign 16,0x90
.globl	VIDEO_$$_CLEARSCREEN$BYTE
VIDEO_$$_CLEARSCREEN$BYTE:
# [184] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-16(%esp),%esp
# Var Color located at ebp-4, size=OS_8
# Var i located at ebp-8, size=OS_S32
# Var Pix located at ebp-12, size=OS_32
# Var P located at ebp-16, size=OS_32
	movb	%al,-4(%ebp)
# [185] Pix := PalColor(Color);
	movb	-4(%ebp),%al
	call	VIDEO_$$_PALCOLOR$BYTE$$LONGWORD
	movl	%eax,-12(%ebp)
# [186] P := Framebuffer;
	movl	U_$VIDEO_$$_FRAMEBUFFER,%eax
	movl	%eax,-16(%ebp)
# [187] for i := 0 to (RWidth * RHeight) - 1 do
	movl	U_$VIDEO_$$_RWIDTH,%edx
	movl	U_$VIDEO_$$_RHEIGHT,%eax
	imull	%edx,%eax
	subl	$1,%eax
	cmpl	$0,%eax
	jge	.Lj73
	jmp	.Lj74
.Lj73:
	movl	$-1,-8(%ebp)
	.balign 8,0x90
.Lj75:
	movl	-8(%ebp),%edx
	leal	1(%edx),%edx
	movl	%edx,-8(%ebp)
# [189] PLongWord(P)^ := Pix;
	movl	-16(%ebp),%edx
	movl	-12(%ebp),%ecx
	movl	%ecx,(%edx)
# [190] Inc(P, BPP);
	addl	$4,-16(%ebp)
	cmpl	-8(%ebp),%eax
	jle	.Lj77
	jmp	.Lj75
.Lj77:
	.balign 4,0x90
.Lj74:
# [192] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_video_$$_fillpattern8x8$array_of_byte$byte$byte,"x"
	.balign 16,0x90
.globl	VIDEO_$$_FILLPATTERN8X8$array_of_BYTE$BYTE$BYTE
VIDEO_$$_FILLPATTERN8X8$array_of_BYTE$BYTE$BYTE:
# [199] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-28(%esp),%esp
	pushl	%ebx
	pushl	%esi
# Var Pattern located at ebp-4, size=OS_32
# Var On located at ebp-8, size=OS_8
# Var Off located at ebp+8, size=OS_8
# Var $highPATTERN located at ebp-12, size=OS_S32
# Var Y located at ebp-16, size=OS_S32
# Var X located at ebp-20, size=OS_S32
# Var P located at ebp-24, size=OS_32
# Var Pix located at ebp-28, size=OS_32
	movl	%eax,-4(%ebp)
	movl	%edx,-12(%ebp)
	movb	%cl,-8(%ebp)
# [200] for Y := 0 to RHeight - 1 do
	movl	U_$VIDEO_$$_RHEIGHT,%eax
	leal	-1(%eax),%ebx
	cmpl	$0,%ebx
	jge	.Lj80
	jmp	.Lj81
.Lj80:
	movl	$-1,-16(%ebp)
	.balign 8,0x90
.Lj82:
	movl	-16(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-16(%ebp)
# [202] P := PByte(Framebuffer) + Y * VPitch;
	movl	-16(%ebp),%edx
	movl	U_$VIDEO_$$_VPITCH,%eax
	imull	%edx,%eax
	addl	U_$VIDEO_$$_FRAMEBUFFER,%eax
	movl	%eax,-24(%ebp)
# [203] for X := 0 to RWidth - 1 do
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-1(%eax),%esi
	cmpl	$0,%esi
	jge	.Lj85
	jmp	.Lj86
.Lj85:
	movl	$-1,-20(%ebp)
	.balign 8,0x90
.Lj87:
	movl	-20(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-20(%ebp)
# [205] if (Pattern[Y and 7] and ($80 shr (X and 7))) <> 0 then
	movl	-4(%ebp),%edx
	movl	-16(%ebp),%eax
	andl	$7,%eax
	movzbl	(%edx,%eax,1),%eax
	movl	-20(%ebp),%ecx
	andl	$7,%ecx
	movl	$128,%edx
	shrl	%cl,%edx
	andl	%edx,%eax
	testl	$-1,%eax
	jne	.Lj90
	jmp	.Lj91
.Lj90:
# [206] Pix := PalColor(On)
	movb	-8(%ebp),%al
	call	VIDEO_$$_PALCOLOR$BYTE$$LONGWORD
	movl	%eax,-28(%ebp)
	jmp	.Lj92
.Lj91:
# [208] Pix := PalColor(Off);
	movb	8(%ebp),%al
	call	VIDEO_$$_PALCOLOR$BYTE$$LONGWORD
	movl	%eax,-28(%ebp)
.Lj92:
# [209] PLongWord(P)^ := Pix;
	movl	-24(%ebp),%edx
	movl	-28(%ebp),%eax
	movl	%eax,(%edx)
# [210] Inc(P, BPP);
	addl	$4,-24(%ebp)
	cmpl	-20(%ebp),%esi
	jle	.Lj89
	jmp	.Lj87
.Lj89:
	.balign 4,0x90
.Lj86:
	cmpl	-16(%ebp),%ebx
	jle	.Lj84
	jmp	.Lj82
.Lj84:
	.balign 4,0x90
.Lj81:
# [213] end;
	popl	%esi
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret	$4

.section .text.n_video_$$_fillpatternrect$longint$longint$longint$longint$array_of_byte$byte$byte,"x"
	.balign 16,0x90
.globl	VIDEO_$$_FILLPATTERNRECT$LONGINT$LONGINT$LONGINT$LONGINT$array_of_BYTE$BYTE$BYTE
VIDEO_$$_FILLPATTERNRECT$LONGINT$LONGINT$LONGINT$LONGINT$array_of_BYTE$BYTE$BYTE:
# [218] begin
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
# [219] for YY := Y to Y + H - 1 do
	movl	-8(%ebp),%eax
	movl	24(%ebp),%edx
	leal	(%eax,%edx),%ebx
	subl	$1,%ebx
	cmpl	-8(%ebp),%ebx
	jge	.Lj95
	jmp	.Lj96
.Lj95:
	movl	-8(%ebp),%eax
	leal	-1(%eax),%eax
	movl	%eax,-16(%ebp)
	.balign 8,0x90
.Lj97:
	movl	-16(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-16(%ebp)
# [220] if (YY >= 0) and (YY < RHeight) then
	cmpl	$0,-16(%ebp)
	jge	.Lj100
	jmp	.Lj101
.Lj100:
	movl	-16(%ebp),%eax
	cmpl	U_$VIDEO_$$_RHEIGHT,%eax
	jl	.Lj102
	jmp	.Lj101
.Lj102:
# [221] for XX := X to X + W - 1 do
	movl	-4(%ebp),%eax
	movl	-12(%ebp),%edx
	leal	(%eax,%edx),%esi
	subl	$1,%esi
	cmpl	-4(%ebp),%esi
	jge	.Lj103
	jmp	.Lj104
.Lj103:
	movl	-4(%ebp),%eax
	leal	-1(%eax),%eax
	movl	%eax,-20(%ebp)
	.balign 8,0x90
.Lj105:
	movl	-20(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-20(%ebp)
# [222] if (XX >= 0) and (XX < RWidth) then
	cmpl	$0,-20(%ebp)
	jge	.Lj108
	jmp	.Lj109
.Lj108:
	movl	-20(%ebp),%eax
	cmpl	U_$VIDEO_$$_RWIDTH,%eax
	jl	.Lj110
	jmp	.Lj109
.Lj110:
# [223] if (Pattern[YY and 7] and ($80 shr (XX and 7))) <> 0 then
	movl	20(%ebp),%edx
	movl	-16(%ebp),%eax
	andl	$7,%eax
	movzbl	(%edx,%eax,1),%eax
	movl	-20(%ebp),%ecx
	andl	$7,%ecx
	movl	$128,%edx
	shrl	%cl,%edx
	andl	%edx,%eax
	testl	$-1,%eax
	jne	.Lj111
	jmp	.Lj112
.Lj111:
# [224] PLongWord(PByte(Framebuffer) + YY * VPitch + XX * BPP)^ := PalColor(On)
	movb	12(%ebp),%al
	call	VIDEO_$$_PALCOLOR$BYTE$$LONGWORD
	movl	-16(%ebp),%ecx
	movl	U_$VIDEO_$$_VPITCH,%edx
	imull	%ecx,%edx
	addl	U_$VIDEO_$$_FRAMEBUFFER,%edx
	movl	-20(%ebp),%ecx
	shll	$2,%ecx
	leal	(%edx,%ecx),%edx
	movl	%eax,(%edx)
	jmp	.Lj113
.Lj112:
# [226] PLongWord(PByte(Framebuffer) + YY * VPitch + XX * BPP)^ := PalColor(Off);
	movb	8(%ebp),%al
	call	VIDEO_$$_PALCOLOR$BYTE$$LONGWORD
	movl	-16(%ebp),%ecx
	movl	U_$VIDEO_$$_VPITCH,%edx
	imull	%ecx,%edx
	addl	U_$VIDEO_$$_FRAMEBUFFER,%edx
	movl	-20(%ebp),%ecx
	shll	$2,%ecx
	leal	(%edx,%ecx),%edx
	movl	%eax,(%edx)
.Lj113:
	.balign 4,0x90
.Lj109:
	cmpl	-20(%ebp),%esi
	jle	.Lj107
	jmp	.Lj105
.Lj107:
	.balign 4,0x90
.Lj104:
	.balign 4,0x90
.Lj101:
	cmpl	-16(%ebp),%ebx
	jle	.Lj99
	jmp	.Lj97
.Lj99:
	.balign 4,0x90
.Lj96:
# [227] end;
	popl	%esi
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret	$20

.section .text.n_video_$$_drawcursorshape$array_of_word$longint$longint$byte,"x"
	.balign 16,0x90
VIDEO_$$_DRAWCURSORSHAPE$array_of_WORD$LONGINT$LONGINT$BYTE:
# [247] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-24(%esp),%esp
# Var Shape located at ebp-4, size=OS_32
# Var X located at ebp-8, size=OS_S32
# Var Y located at ebp+12, size=OS_S32
# Var Color located at ebp+8, size=OS_8
# Var $highSHAPE located at ebp-12, size=OS_S32
# Var R located at ebp-16, size=OS_S32
# Var C located at ebp-20, size=OS_S32
# Var Pix located at ebp-24, size=OS_32
	movl	%eax,-4(%ebp)
	movl	%edx,-12(%ebp)
	movl	%ecx,-8(%ebp)
# [248] Pix := PalColor(Color);
	movb	8(%ebp),%al
	call	VIDEO_$$_PALCOLOR$BYTE$$LONGWORD
	movl	%eax,-24(%ebp)
# [249] for R := 0 to 15 do
	movl	$-1,-16(%ebp)
	.balign 8,0x90
.Lj116:
	movl	-16(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-16(%ebp)
# [251] if (Y + R < 0) or (Y + R >= RHeight) then
	movl	12(%ebp),%eax
	movl	-16(%ebp),%edx
	leal	(%eax,%edx),%eax
	cmpl	$0,%eax
	jl	.Lj119
	jmp	.Lj120
.Lj120:
	movl	12(%ebp),%eax
	movl	-16(%ebp),%edx
	leal	(%eax,%edx),%eax
	cmpl	U_$VIDEO_$$_RHEIGHT,%eax
	jge	.Lj119
	jmp	.Lj121
.Lj119:
# [252] Continue;
	jmp	.Lj117
	.balign 4,0x90
.Lj121:
# [253] for C := 0 to 15 do
	movl	$-1,-20(%ebp)
	.balign 8,0x90
.Lj122:
	movl	-20(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-20(%ebp)
# [255] if (X + C < 0) or (X + C >= RWidth) then
	movl	-8(%ebp),%eax
	movl	-20(%ebp),%edx
	leal	(%eax,%edx),%eax
	cmpl	$0,%eax
	jl	.Lj125
	jmp	.Lj126
.Lj126:
	movl	-8(%ebp),%eax
	movl	-20(%ebp),%edx
	leal	(%eax,%edx),%eax
	cmpl	U_$VIDEO_$$_RWIDTH,%eax
	jge	.Lj125
	jmp	.Lj127
.Lj125:
# [256] Continue;
	jmp	.Lj123
	.balign 4,0x90
.Lj127:
# [257] if (Shape[R] and (1 shl (15 - C))) <> 0 then
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
	jne	.Lj128
	jmp	.Lj129
.Lj128:
# [258] PLongWord(PByte(Framebuffer) + (Y + R) * VPitch + (X + C) * BPP)^ := Pix;
	movl	12(%ebp),%eax
	movl	-16(%ebp),%edx
	leal	(%eax,%edx),%ecx
	movl	U_$VIDEO_$$_VPITCH,%eax
	imull	%eax,%ecx
	addl	U_$VIDEO_$$_FRAMEBUFFER,%ecx
	movl	-8(%ebp),%eax
	movl	-20(%ebp),%edx
	leal	(%eax,%edx),%eax
	shll	$2,%eax
	leal	(%ecx,%eax),%eax
	movl	-24(%ebp),%edx
	movl	%edx,(%eax)
	.balign 4,0x90
.Lj129:
.Lj123:
	cmpl	$15,-20(%ebp)
	jge	.Lj124
	jmp	.Lj122
.Lj124:
.Lj117:
	cmpl	$15,-16(%ebp)
	jge	.Lj118
	jmp	.Lj116
.Lj118:
# [261] end;
	movl	%ebp,%esp
	popl	%ebp
	ret	$8

.section .text.n_video_$$_drawcursor$longint$longint,"x"
	.balign 16,0x90
.globl	VIDEO_$$_DRAWCURSOR$LONGINT$LONGINT
VIDEO_$$_DRAWCURSOR$LONGINT$LONGINT:
# [264] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var X located at ebp-4, size=OS_S32
# Var Y located at ebp-8, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
# [265] DrawCursorShape(CursorMask, X, Y, $0F);
	pushl	-8(%ebp)
	pushl	$15
	movl	-4(%ebp),%ecx
	movl	$TC_$VIDEO_$$_CURSORMASK,%eax
	movl	$15,%edx
	call	VIDEO_$$_DRAWCURSORSHAPE$array_of_WORD$LONGINT$LONGINT$BYTE
# [266] DrawCursorShape(CursorData, X, Y, 0);
	pushl	-8(%ebp)
	pushl	$0
	movl	-4(%ebp),%ecx
	movl	$TC_$VIDEO_$$_CURSORDATA,%eax
	movl	$15,%edx
	call	VIDEO_$$_DRAWCURSORSHAPE$array_of_WORD$LONGINT$LONGINT$BYTE
# [267] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_video_$$_savecursorarea$longint$longint,"x"
	.balign 16,0x90
.globl	VIDEO_$$_SAVECURSORAREA$LONGINT$LONGINT
VIDEO_$$_SAVECURSORAREA$LONGINT$LONGINT:
# [279] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-16(%esp),%esp
# Var X located at ebp-4, size=OS_S32
# Var Y located at ebp-8, size=OS_S32
# Var R located at ebp-12, size=OS_S32
# Var C located at ebp-16, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
# [280] for R := 0 to CursorH - 1 do
	movl	$-1,-12(%ebp)
	.balign 8,0x90
.Lj134:
	movl	-12(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-12(%ebp)
# [281] for C := 0 to CursorW - 1 do
	movl	$-1,-16(%ebp)
	.balign 8,0x90
.Lj137:
	movl	-16(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-16(%ebp)
# [283] if (Y - 1 + R >= 0) and (Y - 1 + R < RHeight) and
	movl	-8(%ebp),%eax
	leal	-1(%eax),%eax
	addl	-12(%ebp),%eax
	cmpl	$0,%eax
	jge	.Lj140
	jmp	.Lj141
.Lj140:
	movl	-8(%ebp),%eax
	leal	-1(%eax),%eax
	addl	-12(%ebp),%eax
	cmpl	U_$VIDEO_$$_RHEIGHT,%eax
	jl	.Lj142
	jmp	.Lj141
.Lj142:
# [284] (X - 1 + C >= 0) and (X - 1 + C < RWidth) then
	movl	-4(%ebp),%eax
	leal	-1(%eax),%eax
	addl	-16(%ebp),%eax
	cmpl	$0,%eax
	jge	.Lj143
	jmp	.Lj141
.Lj143:
	movl	-4(%ebp),%eax
	leal	-1(%eax),%eax
	addl	-16(%ebp),%eax
	cmpl	U_$VIDEO_$$_RWIDTH,%eax
	jl	.Lj144
	jmp	.Lj141
.Lj144:
# [286] (Y - 1 + R) * VPitch + (X - 1 + C) * BPP)^
	movl	-8(%ebp),%eax
	leal	-1(%eax),%edx
	addl	-12(%ebp),%edx
	movl	U_$VIDEO_$$_VPITCH,%eax
	imull	%eax,%edx
# [285] CursorBack[R * CursorW + C] := PLongWord(PByte(Framebuffer) +
	addl	U_$VIDEO_$$_FRAMEBUFFER,%edx
	movl	-4(%ebp),%eax
	leal	-1(%eax),%eax
	addl	-16(%ebp),%eax
	shll	$2,%eax
	leal	(%edx,%eax),%ecx
	movl	-12(%ebp),%eax
	imull	$18,%eax,%edx
	addl	-16(%ebp),%edx
	movl	(%ecx),%eax
	movl	%eax,U_$VIDEO_$$_CURSORBACK(,%edx,4)
	jmp	.Lj145
.Lj141:
# [288] CursorBack[R * CursorW + C] := 0;
	movl	-12(%ebp),%eax
	imull	$18,%eax,%eax
	addl	-16(%ebp),%eax
	movl	$0,U_$VIDEO_$$_CURSORBACK(,%eax,4)
.Lj145:
	cmpl	$17,-16(%ebp)
	jge	.Lj139
	jmp	.Lj137
.Lj139:
	cmpl	$17,-12(%ebp)
	jge	.Lj136
	jmp	.Lj134
.Lj136:
# [290] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_video_$$_restorecursorarea$longint$longint,"x"
	.balign 16,0x90
.globl	VIDEO_$$_RESTORECURSORAREA$LONGINT$LONGINT
VIDEO_$$_RESTORECURSORAREA$LONGINT$LONGINT:
# [295] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-16(%esp),%esp
# Var X located at ebp-4, size=OS_S32
# Var Y located at ebp-8, size=OS_S32
# Var R located at ebp-12, size=OS_S32
# Var C located at ebp-16, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
# [296] for R := 0 to CursorH - 1 do
	movl	$-1,-12(%ebp)
	.balign 8,0x90
.Lj148:
	movl	-12(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-12(%ebp)
# [297] for C := 0 to CursorW - 1 do
	movl	$-1,-16(%ebp)
	.balign 8,0x90
.Lj151:
	movl	-16(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-16(%ebp)
# [299] if (Y - 1 + R >= 0) and (Y - 1 + R < RHeight) and
	movl	-8(%ebp),%eax
	leal	-1(%eax),%eax
	addl	-12(%ebp),%eax
	cmpl	$0,%eax
	jge	.Lj154
	jmp	.Lj155
.Lj154:
	movl	-8(%ebp),%eax
	leal	-1(%eax),%eax
	addl	-12(%ebp),%eax
	cmpl	U_$VIDEO_$$_RHEIGHT,%eax
	jl	.Lj156
	jmp	.Lj155
.Lj156:
# [300] (X - 1 + C >= 0) and (X - 1 + C < RWidth) then
	movl	-4(%ebp),%eax
	leal	-1(%eax),%eax
	addl	-16(%ebp),%eax
	cmpl	$0,%eax
	jge	.Lj157
	jmp	.Lj155
.Lj157:
	movl	-4(%ebp),%eax
	leal	-1(%eax),%eax
	addl	-16(%ebp),%eax
	cmpl	U_$VIDEO_$$_RWIDTH,%eax
	jl	.Lj158
	jmp	.Lj155
.Lj158:
# [301] PLongWord(PByte(Framebuffer) + (Y - 1 + R) * VPitch + (X - 1 + C) * BPP)^ :=
	movl	-8(%ebp),%eax
	leal	-1(%eax),%edx
	addl	-12(%ebp),%edx
	movl	U_$VIDEO_$$_VPITCH,%eax
	imull	%eax,%edx
	addl	U_$VIDEO_$$_FRAMEBUFFER,%edx
	movl	-4(%ebp),%eax
	leal	-1(%eax),%eax
	addl	-16(%ebp),%eax
	shll	$2,%eax
	leal	(%edx,%eax),%edx
# [302] CursorBack[R * CursorW + C];
	movl	-12(%ebp),%eax
	imull	$18,%eax,%eax
	addl	-16(%ebp),%eax
	movl	U_$VIDEO_$$_CURSORBACK(,%eax,4),%eax
	movl	%eax,(%edx)
	.balign 4,0x90
.Lj155:
	cmpl	$17,-16(%ebp)
	jge	.Lj153
	jmp	.Lj151
.Lj153:
	cmpl	$17,-12(%ebp)
	jge	.Lj150
	jmp	.Lj148
.Lj150:
# [304] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_video_$$_savescreenarea$longint$longint$longint$longint,"x"
	.balign 16,0x90
.globl	VIDEO_$$_SAVESCREENAREA$LONGINT$LONGINT$LONGINT$LONGINT
VIDEO_$$_SAVESCREENAREA$LONGINT$LONGINT$LONGINT$LONGINT:
# [323] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-24(%esp),%esp
	pushl	%ebx
	pushl	%esi
# Var X located at ebp-4, size=OS_S32
# Var Y located at ebp-8, size=OS_S32
# Var W located at ebp-12, size=OS_S32
# Var H located at ebp+8, size=OS_S32
# Var R located at ebp-16, size=OS_S32
# Var C located at ebp-20, size=OS_S32
# Var idx located at ebp-24, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [324] if (W > MaxAreaW) or (H > MaxAreaH) then
	cmpl	$165,-12(%ebp)
	jg	.Lj161
	jmp	.Lj162
.Lj162:
	cmpl	$250,8(%ebp)
	jg	.Lj161
	jmp	.Lj163
.Lj161:
# [325] Exit;
	jmp	.Lj159
	.balign 4,0x90
.Lj163:
# [326] ScreenArea.W := W;
	movl	-12(%ebp),%eax
	movl	%eax,U_$VIDEO_$$_SCREENAREA
# [327] ScreenArea.H := H;
	movl	8(%ebp),%eax
	movl	%eax,U_$VIDEO_$$_SCREENAREA+4
# [328] ScreenArea.Buf := @ScreenAreaBuf[0];
	movl	$U_$VIDEO_$$_SCREENAREABUF,%eax
	movl	%eax,U_$VIDEO_$$_SCREENAREA+8
# [329] idx := 0;
	movl	$0,-24(%ebp)
# [330] for R := 0 to H - 1 do
	movl	8(%ebp),%eax
	leal	-1(%eax),%eax
	cmpl	$0,%eax
	jge	.Lj164
	jmp	.Lj165
.Lj164:
	movl	$-1,-16(%ebp)
	.balign 8,0x90
.Lj166:
	movl	-16(%ebp),%edx
	leal	1(%edx),%edx
	movl	%edx,-16(%ebp)
# [331] for C := 0 to W - 1 do
	movl	-12(%ebp),%edx
	leal	-1(%edx),%edx
	cmpl	$0,%edx
	jge	.Lj169
	jmp	.Lj170
.Lj169:
	movl	$-1,-20(%ebp)
	.balign 8,0x90
.Lj171:
	movl	-20(%ebp),%ecx
	leal	1(%ecx),%ecx
	movl	%ecx,-20(%ebp)
# [333] if (Y + R >= 0) and (Y + R < RHeight) and
	movl	-8(%ebp),%ebx
	movl	-16(%ebp),%ecx
	leal	(%ebx,%ecx),%ecx
	cmpl	$0,%ecx
	jge	.Lj174
	jmp	.Lj175
.Lj174:
	movl	-8(%ebp),%ecx
	movl	-16(%ebp),%ebx
	leal	(%ecx,%ebx),%ecx
	cmpl	U_$VIDEO_$$_RHEIGHT,%ecx
	jl	.Lj176
	jmp	.Lj175
.Lj176:
# [334] (X + C >= 0) and (X + C < RWidth) then
	movl	-4(%ebp),%ecx
	movl	-20(%ebp),%ebx
	leal	(%ecx,%ebx),%ecx
	cmpl	$0,%ecx
	jge	.Lj177
	jmp	.Lj175
.Lj177:
	movl	-4(%ebp),%ecx
	movl	-20(%ebp),%ebx
	leal	(%ecx,%ebx),%ecx
	cmpl	U_$VIDEO_$$_RWIDTH,%ecx
	jl	.Lj178
	jmp	.Lj175
.Lj178:
# [336] (Y + R) * VPitch + (X + C) * BPP)^
	movl	-8(%ebp),%ecx
	movl	-16(%ebp),%ebx
	leal	(%ecx,%ebx),%ebx
	movl	U_$VIDEO_$$_VPITCH,%ecx
	imull	%ecx,%ebx
# [335] ScreenAreaBuf[idx] := PLongWord(PByte(Framebuffer) +
	addl	U_$VIDEO_$$_FRAMEBUFFER,%ebx
	movl	-4(%ebp),%ecx
	movl	-20(%ebp),%esi
	leal	(%ecx,%esi),%ecx
	shll	$2,%ecx
	leal	(%ebx,%ecx),%ecx
	movl	-24(%ebp),%ebx
	movl	(%ecx),%ecx
	movl	%ecx,U_$VIDEO_$$_SCREENAREABUF(,%ebx,4)
	jmp	.Lj179
.Lj175:
# [338] ScreenAreaBuf[idx] := 0;
	movl	-24(%ebp),%ecx
	movl	$0,U_$VIDEO_$$_SCREENAREABUF(,%ecx,4)
.Lj179:
# [339] Inc(idx);
	addl	$1,-24(%ebp)
	cmpl	-20(%ebp),%edx
	jle	.Lj173
	jmp	.Lj171
.Lj173:
	.balign 4,0x90
.Lj170:
	cmpl	-16(%ebp),%eax
	jle	.Lj168
	jmp	.Lj166
.Lj168:
	.balign 4,0x90
.Lj165:
.Lj159:
# [341] end;
	popl	%esi
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret	$4

.section .text.n_video_$$_restorescreenarea$longint$longint$longint$longint,"x"
	.balign 16,0x90
.globl	VIDEO_$$_RESTORESCREENAREA$LONGINT$LONGINT$LONGINT$LONGINT
VIDEO_$$_RESTORESCREENAREA$LONGINT$LONGINT$LONGINT$LONGINT:
# [346] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-24(%esp),%esp
	pushl	%ebx
	pushl	%esi
# Var X located at ebp-4, size=OS_S32
# Var Y located at ebp-8, size=OS_S32
# Var W located at ebp-12, size=OS_S32
# Var H located at ebp+8, size=OS_S32
# Var R located at ebp-16, size=OS_S32
# Var C located at ebp-20, size=OS_S32
# Var idx located at ebp-24, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [347] if (ScreenArea.Buf = nil) or (W > MaxAreaW) or (H > MaxAreaH) then
	cmpl	$0,U_$VIDEO_$$_SCREENAREA+8
	je	.Lj182
	jmp	.Lj183
.Lj183:
	cmpl	$165,-12(%ebp)
	jg	.Lj182
	jmp	.Lj184
.Lj184:
	cmpl	$250,8(%ebp)
	jg	.Lj182
	jmp	.Lj185
.Lj182:
# [348] Exit;
	jmp	.Lj180
	.balign 4,0x90
.Lj185:
# [349] idx := 0;
	movl	$0,-24(%ebp)
# [350] for R := 0 to H - 1 do
	movl	8(%ebp),%eax
	leal	-1(%eax),%eax
	cmpl	$0,%eax
	jge	.Lj186
	jmp	.Lj187
.Lj186:
	movl	$-1,-16(%ebp)
	.balign 8,0x90
.Lj188:
	movl	-16(%ebp),%edx
	leal	1(%edx),%edx
	movl	%edx,-16(%ebp)
# [351] for C := 0 to W - 1 do
	movl	-12(%ebp),%edx
	leal	-1(%edx),%edx
	cmpl	$0,%edx
	jge	.Lj191
	jmp	.Lj192
.Lj191:
	movl	$-1,-20(%ebp)
	.balign 8,0x90
.Lj193:
	movl	-20(%ebp),%ecx
	leal	1(%ecx),%ecx
	movl	%ecx,-20(%ebp)
# [353] if (Y + R >= 0) and (Y + R < RHeight) and
	movl	-8(%ebp),%ebx
	movl	-16(%ebp),%ecx
	leal	(%ebx,%ecx),%ecx
	cmpl	$0,%ecx
	jge	.Lj196
	jmp	.Lj197
.Lj196:
	movl	-8(%ebp),%ebx
	movl	-16(%ebp),%ecx
	leal	(%ebx,%ecx),%ecx
	cmpl	U_$VIDEO_$$_RHEIGHT,%ecx
	jl	.Lj198
	jmp	.Lj197
.Lj198:
# [354] (X + C >= 0) and (X + C < RWidth) then
	movl	-4(%ebp),%ecx
	movl	-20(%ebp),%ebx
	leal	(%ecx,%ebx),%ecx
	cmpl	$0,%ecx
	jge	.Lj199
	jmp	.Lj197
.Lj199:
	movl	-4(%ebp),%ecx
	movl	-20(%ebp),%ebx
	leal	(%ecx,%ebx),%ecx
	cmpl	U_$VIDEO_$$_RWIDTH,%ecx
	jl	.Lj200
	jmp	.Lj197
.Lj200:
# [355] PLongWord(PByte(Framebuffer) + (Y + R) * VPitch + (X + C) * BPP)^ :=
	movl	-8(%ebp),%ecx
	movl	-16(%ebp),%ebx
	leal	(%ecx,%ebx),%ebx
	movl	U_$VIDEO_$$_VPITCH,%ecx
	imull	%ecx,%ebx
	addl	U_$VIDEO_$$_FRAMEBUFFER,%ebx
	movl	-4(%ebp),%esi
	movl	-20(%ebp),%ecx
	leal	(%esi,%ecx),%ecx
	shll	$2,%ecx
	leal	(%ebx,%ecx),%ebx
# [356] ScreenAreaBuf[idx];
	movl	-24(%ebp),%ecx
	movl	U_$VIDEO_$$_SCREENAREABUF(,%ecx,4),%ecx
	movl	%ecx,(%ebx)
	.balign 4,0x90
.Lj197:
# [357] Inc(idx);
	addl	$1,-24(%ebp)
	cmpl	-20(%ebp),%edx
	jle	.Lj195
	jmp	.Lj193
.Lj195:
	.balign 4,0x90
.Lj192:
	cmpl	-16(%ebp),%eax
	jle	.Lj190
	jmp	.Lj188
.Lj190:
	.balign 4,0x90
.Lj187:
.Lj180:
# [359] end;
	popl	%esi
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret	$4

.section .text.n_video_$$_writeatcol$longint$longint$pchar$longint$byte,"x"
	.balign 16,0x90
.globl	VIDEO_$$_WRITEATCOL$LONGINT$LONGINT$PCHAR$LONGINT$BYTE
VIDEO_$$_WRITEATCOL$LONGINT$LONGINT$PCHAR$LONGINT$BYTE:
# [467] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-32(%esp),%esp
	pushl	%ebx
	pushl	%esi
	pushl	%edi
# Var X located at ebp-4, size=OS_S32
# Var Y located at ebp-8, size=OS_S32
# Var Text located at ebp-12, size=OS_32
# Var Size located at ebp+12, size=OS_S32
# Var Color located at ebp+8, size=OS_8
# Var i located at ebp-16, size=OS_S32
# Var R located at ebp-20, size=OS_S32
# Var C located at ebp-24, size=OS_S32
# Var G located at ebp-28, size=OS_S32
# Var Pix located at ebp-32, size=OS_32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [468] if Text = nil then
	cmpl	$0,-12(%ebp)
	je	.Lj203
	jmp	.Lj204
.Lj203:
# [469] Exit;
	jmp	.Lj201
	.balign 4,0x90
.Lj204:
# [470] if Size < 8 then
	cmpl	$8,12(%ebp)
	jl	.Lj205
	jmp	.Lj206
.Lj205:
# [471] Size := 8;
	movl	$8,12(%ebp)
	.balign 4,0x90
.Lj206:
# [472] Pix := PalColor(Color);
	movb	8(%ebp),%al
	call	VIDEO_$$_PALCOLOR$BYTE$$LONGWORD
	movl	%eax,-32(%ebp)
# [473] i := 0;
	movl	$0,-16(%ebp)
# [474] while Text[i] <> #0 do
	jmp	.Lj208
	.balign 8,0x90
.Lj207:
# [476] if Text[i] = #10 then
	movl	-12(%ebp),%eax
	movl	-16(%ebp),%edx
	cmpb	$10,(%eax,%edx,1)
	je	.Lj210
	jmp	.Lj211
.Lj210:
# [478] Y := Y + Size;
	movl	-8(%ebp),%edx
	movl	12(%ebp),%eax
	leal	(%edx,%eax),%eax
	movl	%eax,-8(%ebp)
# [479] i := i + 1;
	movl	-16(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-16(%ebp)
# [480] Continue;
	jmp	.Lj208
	.balign 4,0x90
.Lj211:
# [482] if (Ord(Text[i]) >= 32) and (Ord(Text[i]) <= 127) then
	movl	-12(%ebp),%eax
	movl	-16(%ebp),%edx
	cmpb	$32,(%eax,%edx,1)
	jae	.Lj212
	jmp	.Lj213
.Lj212:
	movl	-12(%ebp),%edx
	movl	-16(%ebp),%eax
	cmpb	$127,(%edx,%eax,1)
	jbe	.Lj214
	jmp	.Lj213
.Lj214:
# [484] G := Ord(Text[i]) - 32;
	movl	-12(%ebp),%edx
	movl	-16(%ebp),%eax
	movzbl	(%edx,%eax,1),%eax
	subl	$32,%eax
	movl	%eax,-28(%ebp)
# [485] for R := 0 to Size - 1 do
	movl	12(%ebp),%eax
	leal	-1(%eax),%ebx
	cmpl	$0,%ebx
	jge	.Lj215
	jmp	.Lj216
.Lj215:
	movl	$-1,-20(%ebp)
	.balign 8,0x90
.Lj217:
	movl	-20(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-20(%ebp)
# [486] for C := 0 to Size - 1 do
	movl	12(%ebp),%eax
	leal	-1(%eax),%esi
	cmpl	$0,%esi
	jge	.Lj220
	jmp	.Lj221
.Lj220:
	movl	$-1,-24(%ebp)
	.balign 8,0x90
.Lj222:
	movl	-24(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-24(%ebp)
# [487] if (Font8x8[G, (R * 8) div Size] and (1 shl ((C * 8) div Size))) <> 0 then
	movl	-28(%ebp),%ecx
	movl	-20(%ebp),%eax
	shll	$3,%eax
	cltd
	idivl	12(%ebp)
	shll	$3,%ecx
	movzbl	TC_$VIDEO_$$_FONT8X8(%ecx,%eax,1),%edi
	movl	-24(%ebp),%eax
	shll	$3,%eax
	cltd
	idivl	12(%ebp)
	movl	%eax,%ecx
	movl	$1,%eax
	shll	%cl,%eax
	andl	%eax,%edi
	testl	$-1,%edi
	jne	.Lj225
	jmp	.Lj226
.Lj225:
# [488] if (X + C >= 0) and (X + C < RWidth) and
	movl	-4(%ebp),%edx
	movl	-24(%ebp),%eax
	leal	(%edx,%eax),%eax
	cmpl	$0,%eax
	jge	.Lj227
	jmp	.Lj228
.Lj227:
	movl	-4(%ebp),%eax
	movl	-24(%ebp),%edx
	leal	(%eax,%edx),%eax
	cmpl	U_$VIDEO_$$_RWIDTH,%eax
	jl	.Lj229
	jmp	.Lj228
.Lj229:
# [489] (Y + R >= 0) and (Y + R < RHeight) then
	movl	-8(%ebp),%edx
	movl	-20(%ebp),%eax
	leal	(%edx,%eax),%eax
	cmpl	$0,%eax
	jge	.Lj230
	jmp	.Lj228
.Lj230:
	movl	-8(%ebp),%edx
	movl	-20(%ebp),%eax
	leal	(%edx,%eax),%eax
	cmpl	U_$VIDEO_$$_RHEIGHT,%eax
	jl	.Lj231
	jmp	.Lj228
.Lj231:
# [490] PLongWord(PByte(Framebuffer) + (Y + R) * VPitch + (X + C) * BPP)^ := Pix;
	movl	-8(%ebp),%eax
	movl	-20(%ebp),%edx
	leal	(%eax,%edx),%edx
	movl	U_$VIDEO_$$_VPITCH,%eax
	imull	%eax,%edx
	addl	U_$VIDEO_$$_FRAMEBUFFER,%edx
	movl	-4(%ebp),%ecx
	movl	-24(%ebp),%eax
	leal	(%ecx,%eax),%eax
	shll	$2,%eax
	leal	(%edx,%eax),%eax
	movl	-32(%ebp),%edx
	movl	%edx,(%eax)
	.balign 4,0x90
.Lj228:
	.balign 4,0x90
.Lj226:
	cmpl	-24(%ebp),%esi
	jle	.Lj224
	jmp	.Lj222
.Lj224:
	.balign 4,0x90
.Lj221:
	cmpl	-20(%ebp),%ebx
	jle	.Lj219
	jmp	.Lj217
.Lj219:
	.balign 4,0x90
.Lj216:
# [491] X := X + Size;
	movl	-4(%ebp),%edx
	movl	12(%ebp),%eax
	leal	(%edx,%eax),%eax
	movl	%eax,-4(%ebp)
	.balign 4,0x90
.Lj213:
# [493] i := i + 1;
	movl	-16(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-16(%ebp)
.Lj208:
	movl	-12(%ebp),%eax
	movl	-16(%ebp),%edx
	cmpb	$0,(%eax,%edx,1)
	jne	.Lj207
	jmp	.Lj209
.Lj209:
.Lj201:
# [495] end;
	popl	%edi
	popl	%esi
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret	$8

.section .text.n_video_$$_writeat$longint$longint$pchar$longint,"x"
	.balign 16,0x90
.globl	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT:
# [498] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-12(%esp),%esp
# Var X located at ebp-4, size=OS_S32
# Var Y located at ebp-8, size=OS_S32
# Var Text located at ebp-12, size=OS_32
# Var Size located at ebp+8, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [499] WriteAtCol(X, Y, Text, Size, 0);
	pushl	8(%ebp)
	pushl	$0
	movl	-12(%ebp),%ecx
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	call	VIDEO_$$_WRITEATCOL$LONGINT$LONGINT$PCHAR$LONGINT$BYTE
# [500] end;
	movl	%ebp,%esp
	popl	%ebp
	ret	$4

.section .text.n_video_$$_putsymbol$longint$longint$char$longint,"x"
	.balign 16,0x90
.globl	VIDEO_$$_PUTSYMBOL$LONGINT$LONGINT$CHAR$LONGINT
VIDEO_$$_PUTSYMBOL$LONGINT$LONGINT$CHAR$LONGINT:
# [516] begin
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
# [517] if Size < 8 then
	cmpl	$8,8(%ebp)
	jl	.Lj236
	jmp	.Lj237
.Lj236:
# [518] Size := 8;
	movl	$8,8(%ebp)
	.balign 4,0x90
.Lj237:
# [519] for i := Low(SymbolFont) to High(SymbolFont) do
	movl	$-1,-16(%ebp)
	.balign 8,0x90
.Lj238:
	movl	-16(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-16(%ebp)
# [520] if SymbolFont[i].Ch = Symbol then
	movl	-16(%ebp),%eax
	leal	(%eax,%eax,8),%eax
	movb	TC_$VIDEO_$$_SYMBOLFONT(,%eax),%al
	cmpb	-12(%ebp),%al
	je	.Lj241
	jmp	.Lj242
.Lj241:
# [522] for R := 0 to Size - 1 do
	movl	8(%ebp),%eax
	leal	-1(%eax),%ebx
	cmpl	$0,%ebx
	jge	.Lj243
	jmp	.Lj244
.Lj243:
	movl	$-1,-20(%ebp)
	.balign 8,0x90
.Lj245:
	movl	-20(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-20(%ebp)
# [523] for C := 0 to Size - 1 do
	movl	8(%ebp),%eax
	leal	-1(%eax),%esi
	cmpl	$0,%esi
	jge	.Lj248
	jmp	.Lj249
.Lj248:
	movl	$-1,-24(%ebp)
	.balign 8,0x90
.Lj250:
	movl	-24(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-24(%ebp)
# [524] if (SymbolFont[i].G[(R * 8) div Size] and (1 shl ((C * 8) div Size))) <> 0 then
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
	jne	.Lj253
	jmp	.Lj254
.Lj253:
# [525] if (X + C >= 0) and (X + C < RWidth) and
	movl	-4(%ebp),%eax
	movl	-24(%ebp),%edx
	leal	(%eax,%edx),%eax
	cmpl	$0,%eax
	jge	.Lj255
	jmp	.Lj256
.Lj255:
	movl	-4(%ebp),%edx
	movl	-24(%ebp),%eax
	leal	(%edx,%eax),%eax
	cmpl	U_$VIDEO_$$_RWIDTH,%eax
	jl	.Lj257
	jmp	.Lj256
.Lj257:
# [526] (Y + R >= 0) and (Y + R < RHeight) then
	movl	-8(%ebp),%eax
	movl	-20(%ebp),%edx
	leal	(%eax,%edx),%eax
	cmpl	$0,%eax
	jge	.Lj258
	jmp	.Lj256
.Lj258:
	movl	-8(%ebp),%eax
	movl	-20(%ebp),%edx
	leal	(%eax,%edx),%eax
	cmpl	U_$VIDEO_$$_RHEIGHT,%eax
	jl	.Lj259
	jmp	.Lj256
.Lj259:
# [527] PLongWord(PByte(Framebuffer) + (Y + R) * VPitch + (X + C) * BPP)^ := PalColor(0);
	movb	$0,%al
	call	VIDEO_$$_PALCOLOR$BYTE$$LONGWORD
	movl	-8(%ebp),%edx
	movl	-20(%ebp),%ecx
	leal	(%edx,%ecx),%ecx
	movl	U_$VIDEO_$$_VPITCH,%edx
	imull	%edx,%ecx
	addl	U_$VIDEO_$$_FRAMEBUFFER,%ecx
	movl	-4(%ebp),%edi
	movl	-24(%ebp),%edx
	leal	(%edi,%edx),%edx
	shll	$2,%edx
	leal	(%ecx,%edx),%edx
	movl	%eax,(%edx)
	.balign 4,0x90
.Lj256:
	.balign 4,0x90
.Lj254:
	cmpl	-24(%ebp),%esi
	jle	.Lj252
	jmp	.Lj250
.Lj252:
	.balign 4,0x90
.Lj249:
	cmpl	-20(%ebp),%ebx
	jle	.Lj247
	jmp	.Lj245
.Lj247:
	.balign 4,0x90
.Lj244:
# [528] Exit;
	jmp	.Lj234
	.balign 4,0x90
.Lj242:
	cmpl	$0,-16(%ebp)
	jge	.Lj240
	jmp	.Lj238
.Lj240:
.Lj234:
# [530] end;
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
# [538] begin
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
# Var C located at ebp-24, size=OS_32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [539] for Y := 0 to SrcH - 1 do
	movl	-12(%ebp),%eax
	leal	-1(%eax),%eax
	cmpl	$0,%eax
	jge	.Lj262
	jmp	.Lj263
.Lj262:
	movl	$-1,-20(%ebp)
	.balign 8,0x90
.Lj264:
	movl	-20(%ebp),%edx
	leal	1(%edx),%edx
	movl	%edx,-20(%ebp)
# [540] for X := 0 to SrcW - 1 do
	movl	-8(%ebp),%edx
	leal	-1(%edx),%edx
	cmpl	$0,%edx
	jge	.Lj267
	jmp	.Lj268
.Lj267:
	movl	$-1,-16(%ebp)
	.balign 8,0x90
.Lj269:
	movl	-16(%ebp),%ecx
	leal	1(%ecx),%ecx
	movl	%ecx,-16(%ebp)
# [542] C := PLongWord(PByte(Src) + (Y * SrcW + X) * BPP)^;
	movl	-20(%ebp),%ebx
	movl	-8(%ebp),%ecx
	imull	%ebx,%ecx
	addl	-16(%ebp),%ecx
	shll	$2,%ecx
	addl	-4(%ebp),%ecx
	movl	(%ecx),%ecx
	movl	%ecx,-24(%ebp)
# [543] if (C and $FF000000) <> 0 then
	movl	-24(%ebp),%ecx
	andl	$-16777216,%ecx
	testl	$-1,%ecx
	jne	.Lj272
	jmp	.Lj273
.Lj272:
# [544] if (DstX + X >= 0) and (DstX + X < RWidth) and
	movl	12(%ebp),%ebx
	movl	-16(%ebp),%ecx
	leal	(%ebx,%ecx),%ecx
	cmpl	$0,%ecx
	jge	.Lj274
	jmp	.Lj275
.Lj274:
	movl	12(%ebp),%ebx
	movl	-16(%ebp),%ecx
	leal	(%ebx,%ecx),%ecx
	cmpl	U_$VIDEO_$$_RWIDTH,%ecx
	jl	.Lj276
	jmp	.Lj275
.Lj276:
# [545] (DstY + Y >= 0) and (DstY + Y < RHeight) then
	movl	8(%ebp),%ecx
	movl	-20(%ebp),%ebx
	leal	(%ecx,%ebx),%ecx
	cmpl	$0,%ecx
	jge	.Lj277
	jmp	.Lj275
.Lj277:
	movl	8(%ebp),%ecx
	movl	-20(%ebp),%ebx
	leal	(%ecx,%ebx),%ecx
	cmpl	U_$VIDEO_$$_RHEIGHT,%ecx
	jl	.Lj278
	jmp	.Lj275
.Lj278:
# [546] PLongWord(PByte(Framebuffer) + (DstY + Y) * VPitch + (DstX + X) * BPP)^ :=
	movl	8(%ebp),%ecx
	movl	-20(%ebp),%ebx
	leal	(%ecx,%ebx),%ebx
	movl	U_$VIDEO_$$_VPITCH,%ecx
	imull	%ecx,%ebx
	addl	U_$VIDEO_$$_FRAMEBUFFER,%ebx
	movl	12(%ebp),%ecx
	movl	-16(%ebp),%esi
	leal	(%ecx,%esi),%ecx
	shll	$2,%ecx
	leal	(%ebx,%ecx),%ebx
# [547] C and $00FFFFFF;
	movl	-24(%ebp),%ecx
	andl	$16777215,%ecx
	movl	%ecx,(%ebx)
	.balign 4,0x90
.Lj275:
	.balign 4,0x90
.Lj273:
	cmpl	-16(%ebp),%edx
	jle	.Lj271
	jmp	.Lj269
.Lj271:
	.balign 4,0x90
.Lj268:
	cmpl	-20(%ebp),%eax
	jle	.Lj266
	jmp	.Lj264
.Lj266:
	.balign 4,0x90
.Lj263:
# [549] end;
	popl	%esi
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret	$8

.section .text.n_video_$$_drawbmp$pchar$longint$longint,"x"
	.balign 16,0x90
.globl	VIDEO_$$_DRAWBMP$PCHAR$LONGINT$LONGINT
VIDEO_$$_DRAWBMP$PCHAR$LONGINT$LONGINT:
# [555] begin
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
# [556] W := 0;
	movl	$0,-20(%ebp)
# [557] H := 0;
	movl	$0,-24(%ebp)
# [558] N := FSReadFile(Name, @AssetBuf[0], SizeOf(AssetBuf));
	movl	$U_$VIDEO_$$_ASSETBUF,%eax
	movl	%eax,%edx
	movl	-4(%ebp),%eax
	movl	$65536,%ecx
	call	CDROM_$$_FSREADFILE$PCHAR$PBYTE$LONGWORD$$LONGINT
	movl	%eax,-16(%ebp)
# [559] if N < 0 then Exit;
	cmpl	$0,-16(%ebp)
	jl	.Lj281
	jmp	.Lj282
.Lj281:
	jmp	.Lj279
	.balign 4,0x90
.Lj282:
# [560] BMPDecode(@AssetBuf[0], LongWord(N), W, H, @DrawBuf[0], SizeOf(DrawBuf) div BPP);
	leal	-24(%ebp),%eax
	pushl	%eax
	movl	$U_$VIDEO_$$_DRAWBUF,%eax
	pushl	%eax
	pushl	$16384
	movl	$U_$VIDEO_$$_ASSETBUF,%eax
	leal	-20(%ebp),%ecx
	movl	-16(%ebp),%edx
	call	BMP_$$_BMPDECODE$PBYTE$LONGWORD$LONGINT$LONGINT$PBYTE$LONGWORD$$BOOLEAN
# [561] if (W = 0) or (H = 0) then Exit;
	cmpl	$0,-20(%ebp)
	je	.Lj283
	jmp	.Lj284
.Lj284:
	cmpl	$0,-24(%ebp)
	je	.Lj283
	jmp	.Lj285
.Lj283:
	jmp	.Lj279
	.balign 4,0x90
.Lj285:
# [562] DrawSprite(@DrawBuf[0], W, H, X, Y);
	pushl	-8(%ebp)
	pushl	-12(%ebp)
	movl	$U_$VIDEO_$$_DRAWBUF,%eax
	movl	-24(%ebp),%ecx
	movl	-20(%ebp),%edx
	call	VIDEO_$$_DRAWSPRITE$PBYTE$LONGINT$LONGINT$LONGINT$LONGINT
.Lj279:
# [563] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_video_$$_drawspriteblack$pbyte$longint$longint$longint$longint,"x"
	.balign 16,0x90
VIDEO_$$_DRAWSPRITEBLACK$PBYTE$LONGINT$LONGINT$LONGINT$LONGINT:
# [571] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-24(%esp),%esp
	pushl	%ebx
	pushl	%esi
	pushl	%edi
# Var Src located at ebp-4, size=OS_32
# Var SrcW located at ebp-8, size=OS_S32
# Var SrcH located at ebp-12, size=OS_S32
# Var DstX located at ebp+12, size=OS_S32
# Var DstY located at ebp+8, size=OS_S32
# Var X located at ebp-16, size=OS_S32
# Var Y located at ebp-20, size=OS_S32
# Var C located at ebp-24, size=OS_32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [572] for Y := 0 to SrcH - 1 do
	movl	-12(%ebp),%eax
	leal	-1(%eax),%ebx
	cmpl	$0,%ebx
	jge	.Lj288
	jmp	.Lj289
.Lj288:
	movl	$-1,-20(%ebp)
	.balign 8,0x90
.Lj290:
	movl	-20(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-20(%ebp)
# [573] for X := 0 to SrcW - 1 do
	movl	-8(%ebp),%eax
	leal	-1(%eax),%esi
	cmpl	$0,%esi
	jge	.Lj293
	jmp	.Lj294
.Lj293:
	movl	$-1,-16(%ebp)
	.balign 8,0x90
.Lj295:
	movl	-16(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-16(%ebp)
# [575] C := PLongWord(PByte(Src) + (Y * SrcW + X) * BPP)^;
	movl	-20(%ebp),%edx
	movl	-8(%ebp),%eax
	imull	%edx,%eax
	addl	-16(%ebp),%eax
	shll	$2,%eax
	addl	-4(%ebp),%eax
	movl	(%eax),%eax
	movl	%eax,-24(%ebp)
# [576] if (C and $FF000000) <> 0 then
	movl	-24(%ebp),%eax
	andl	$-16777216,%eax
	testl	$-1,%eax
	jne	.Lj298
	jmp	.Lj299
.Lj298:
# [577] if (DstX + X >= 0) and (DstX + X < RWidth) and
	movl	12(%ebp),%edx
	movl	-16(%ebp),%eax
	leal	(%edx,%eax),%eax
	cmpl	$0,%eax
	jge	.Lj300
	jmp	.Lj301
.Lj300:
	movl	12(%ebp),%edx
	movl	-16(%ebp),%eax
	leal	(%edx,%eax),%eax
	cmpl	U_$VIDEO_$$_RWIDTH,%eax
	jl	.Lj302
	jmp	.Lj301
.Lj302:
# [578] (DstY + Y >= 0) and (DstY + Y < RHeight) then
	movl	8(%ebp),%eax
	movl	-20(%ebp),%edx
	leal	(%eax,%edx),%eax
	cmpl	$0,%eax
	jge	.Lj303
	jmp	.Lj301
.Lj303:
	movl	8(%ebp),%edx
	movl	-20(%ebp),%eax
	leal	(%edx,%eax),%eax
	cmpl	U_$VIDEO_$$_RHEIGHT,%eax
	jl	.Lj304
	jmp	.Lj301
.Lj304:
# [580] PalColor(0);
	movb	$0,%al
	call	VIDEO_$$_PALCOLOR$BYTE$$LONGWORD
# [579] PLongWord(PByte(Framebuffer) + (DstY + Y) * VPitch + (DstX + X) * BPP)^ :=
	movl	8(%ebp),%edx
	movl	-20(%ebp),%ecx
	leal	(%edx,%ecx),%ecx
	movl	U_$VIDEO_$$_VPITCH,%edx
	imull	%edx,%ecx
	addl	U_$VIDEO_$$_FRAMEBUFFER,%ecx
	movl	12(%ebp),%edi
	movl	-16(%ebp),%edx
	leal	(%edi,%edx),%edx
	shll	$2,%edx
	leal	(%ecx,%edx),%edx
	movl	%eax,(%edx)
	.balign 4,0x90
.Lj301:
	.balign 4,0x90
.Lj299:
	cmpl	-16(%ebp),%esi
	jle	.Lj297
	jmp	.Lj295
.Lj297:
	.balign 4,0x90
.Lj294:
	cmpl	-20(%ebp),%ebx
	jle	.Lj292
	jmp	.Lj290
.Lj292:
	.balign 4,0x90
.Lj289:
# [582] end;
	popl	%edi
	popl	%esi
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret	$8

.section .text.n_video_$$_drawbmpblack$pchar$longint$longint,"x"
	.balign 16,0x90
.globl	VIDEO_$$_DRAWBMPBLACK$PCHAR$LONGINT$LONGINT
VIDEO_$$_DRAWBMPBLACK$PCHAR$LONGINT$LONGINT:
# [589] begin
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
# [590] W := 0;
	movl	$0,-20(%ebp)
# [591] H := 0;
	movl	$0,-24(%ebp)
# [592] N := FSReadFile(Name, @AssetBuf[0], SizeOf(AssetBuf));
	movl	$U_$VIDEO_$$_ASSETBUF,%eax
	movl	%eax,%edx
	movl	-4(%ebp),%eax
	movl	$65536,%ecx
	call	CDROM_$$_FSREADFILE$PCHAR$PBYTE$LONGWORD$$LONGINT
	movl	%eax,-16(%ebp)
# [593] if N < 0 then Exit;
	cmpl	$0,-16(%ebp)
	jl	.Lj307
	jmp	.Lj308
.Lj307:
	jmp	.Lj305
	.balign 4,0x90
.Lj308:
# [594] BMPDecode(@AssetBuf[0], LongWord(N), W, H, @DrawBuf[0], SizeOf(DrawBuf) div BPP);
	leal	-24(%ebp),%eax
	pushl	%eax
	movl	$U_$VIDEO_$$_DRAWBUF,%eax
	pushl	%eax
	pushl	$16384
	movl	$U_$VIDEO_$$_ASSETBUF,%eax
	leal	-20(%ebp),%ecx
	movl	-16(%ebp),%edx
	call	BMP_$$_BMPDECODE$PBYTE$LONGWORD$LONGINT$LONGINT$PBYTE$LONGWORD$$BOOLEAN
# [595] if (W = 0) or (H = 0) then Exit;
	cmpl	$0,-20(%ebp)
	je	.Lj309
	jmp	.Lj310
.Lj310:
	cmpl	$0,-24(%ebp)
	je	.Lj309
	jmp	.Lj311
.Lj309:
	jmp	.Lj305
	.balign 4,0x90
.Lj311:
# [596] DrawSpriteBlack(@DrawBuf[0], W, H, X, Y);
	pushl	-8(%ebp)
	pushl	-12(%ebp)
	movl	$U_$VIDEO_$$_DRAWBUF,%eax
	movl	-24(%ebp),%ecx
	movl	-20(%ebp),%edx
	call	VIDEO_$$_DRAWSPRITEBLACK$PBYTE$LONGINT$LONGINT$LONGINT$LONGINT
.Lj305:
# [597] end;
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
# [11] VPitch: integer;       // bytes por linha do framebuffer (4 por pixel)
	.globl U_$VIDEO_$$_VPITCH
U_$VIDEO_$$_VPITCH:
	.zero 4

.section .bss
	.balign 4
# [12] Framebuffer: PByte;
	.globl U_$VIDEO_$$_FRAMEBUFFER
U_$VIDEO_$$_FRAMEBUFFER:
	.zero 4

.section .bss
# [41] AssetBuf: array[0..65535] of Byte;
U_$VIDEO_$$_ASSETBUF:
	.zero 65536

.section .bss
# [42] DrawBuf:  array[0..65535] of Byte;
U_$VIDEO_$$_DRAWBUF:
	.zero 65536

.section .bss
# [47] PalR: array[0..255] of Byte;
U_$VIDEO_$$_PALR:
	.zero 256

.section .bss
# [48] PalG: array[0..255] of Byte;
U_$VIDEO_$$_PALG:
	.zero 256

.section .bss
# [49] PalB: array[0..255] of Byte;
U_$VIDEO_$$_PALB:
	.zero 256

.section .bss
	.balign 4
# [274] CursorBack: array[0..(CursorW * CursorH) - 1] of LongWord;
U_$VIDEO_$$_CURSORBACK:
	.zero 1296

.section .bss
	.balign 4
# [317] ScreenArea: TScreenArea;
U_$VIDEO_$$_SCREENAREA:
	.zero 12

.section .bss
	.balign 4
# [318] ScreenAreaBuf: array[0..(MaxAreaW * MaxAreaH) - 1] of LongWord;
U_$VIDEO_$$_SCREENAREABUF:
	.zero 165000
# End asmlist al_globals
# Begin asmlist al_typedconsts

.section .data.n_TC_$VIDEO_$$_CURSORDATA,"d"
	.balign 2
TC_$VIDEO_$$_CURSORDATA:
	.short	0,16384,24576,28672,30720,31744,32256,32512,32640,31744,27648,17920,1536,768,768,0
# [236] CursorMask: array[0..15] of Word = (

.section .data.n_TC_$VIDEO_$$_CURSORMASK,"d"
	.balign 2
TC_$VIDEO_$$_CURSORMASK:
	.short	49152,57344,61440,63488,64512,65024,65280,65408,65472,65472,65024,61184,52992,34688,1920
	.short	896
# [243] procedure DrawCursorShape(const Shape: array of Word; X, Y: Integer; Color: Byte);

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
# [463] procedure WriteAtCol(X, Y: Integer; Text: PChar; Size: Integer; Color: Byte);

.section .data.n_TC_$VIDEO_$$_SYMBOLFONT,"d"
TC_$VIDEO_$$_SYMBOLFONT:
	.byte	35,60,102,195,129,129,195,102,60
# [513] procedure PutSymbol(X, Y: Integer; Symbol: Char; Size: Integer);
# End asmlist al_typedconsts

