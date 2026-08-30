	.file "bmp.pas"
# Begin asmlist al_procedures

.section .text.n_bmp_$$_rgbtovga$byte$byte$byte$$byte,"x"
	.balign 16,0x90
.globl	BMP_$$_RGBTOVGA$BYTE$BYTE$BYTE$$BYTE
BMP_$$_RGBTOVGA$BYTE$BYTE$BYTE$$BYTE:
# [bmp.pas]
# [21] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-28(%esp),%esp
# Var R located at ebp-4, size=OS_8
# Var G located at ebp-8, size=OS_8
# Var B located at ebp-12, size=OS_8
# Var $result located at ebp-16, size=OS_8
# Var ri located at ebp-20, size=OS_S32
# Var gi located at ebp-24, size=OS_S32
# Var bi located at ebp-28, size=OS_S32
	movb	%al,-4(%ebp)
	movb	%dl,-8(%ebp)
	movb	%cl,-12(%ebp)
# [22] ri := R * 6 div 256;
	movzbl	-4(%ebp),%eax
	imull	$6,%eax
	movl	%eax,%edx
	sarl	$31,%edx
	andl	$255,%edx
	addl	%edx,%eax
	sarl	$8,%eax
	movl	%eax,-20(%ebp)
# [23] gi := G * 6 div 256;
	movzbl	-8(%ebp),%eax
	imull	$6,%eax
	movl	%eax,%edx
	sarl	$31,%edx
	andl	$255,%edx
	addl	%edx,%eax
	sarl	$8,%eax
	movl	%eax,-24(%ebp)
# [24] bi := B * 6 div 256;
	movzbl	-12(%ebp),%eax
	imull	$6,%eax
	movl	%eax,%edx
	sarl	$31,%edx
	andl	$255,%edx
	addl	%edx,%eax
	sarl	$8,%eax
	movl	%eax,-28(%ebp)
# [25] RGBToVGA := 16 + Byte(ri) * 36 + Byte(gi) * 6 + Byte(bi);
	movzbl	-20(%ebp),%eax
	imull	$36,%eax
	leal	16(%eax),%eax
	movzbl	-24(%ebp),%edx
	imull	$6,%edx
	leal	(%eax,%edx),%eax
	movzbl	-28(%ebp),%edx
	leal	(%eax,%edx),%eax
	movb	%al,-16(%ebp)
# [26] end;
	movb	-16(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_bmp_$$_readle16$pbyte$$word,"x"
	.balign 16,0x90
BMP_$$_READLE16$PBYTE$$WORD:
# [29] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var P located at ebp-4, size=OS_32
# Var $result located at ebp-8, size=OS_16
	movl	%eax,-4(%ebp)
# [30] ReadLE16 := Word(P^) or (Word((P + 1)^) shl 8);
	movl	-4(%ebp),%eax
	movzbw	1(%eax),%ax
	movzwl	%ax,%eax
	shll	$8,%eax
	movl	-4(%ebp),%edx
	movzbw	(%edx),%dx
	movzwl	%dx,%edx
	orl	%edx,%eax
	movw	%ax,-8(%ebp)
# [31] end;
	movw	-8(%ebp),%ax
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_bmp_$$_readle32$pbyte$$longword,"x"
	.balign 16,0x90
BMP_$$_READLE32$PBYTE$$LONGWORD:
# [34] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var P located at ebp-4, size=OS_32
# Var $result located at ebp-8, size=OS_32
	movl	%eax,-4(%ebp)
# [35] ReadLE32 := LongWord(P^) or (LongWord((P + 1)^) shl 8) or
	movl	-4(%ebp),%eax
	movzbl	1(%eax),%eax
	shll	$8,%eax
	movl	-4(%ebp),%edx
	movzbl	(%edx),%edx
	orl	%edx,%eax
# [36] (LongWord((P + 2)^) shl 16) or (LongWord((P + 3)^) shl 24);
	movl	-4(%ebp),%edx
	movzbl	2(%edx),%edx
	shll	$16,%edx
	orl	%edx,%eax
	movl	-4(%ebp),%edx
	movzbl	3(%edx),%edx
	shll	$24,%edx
	orl	%edx,%eax
	movl	%eax,-8(%ebp)
# [37] end;
	movl	-8(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_bmp_$$_bmpdecode$pbyte$longword$longint$longint$pbyte$longword$$boolean,"x"
	.balign 16,0x90
.globl	BMP_$$_BMPDECODE$PBYTE$LONGWORD$LONGINT$LONGINT$PBYTE$LONGWORD$$BOOLEAN
BMP_$$_BMPDECODE$PBYTE$LONGWORD$LONGINT$LONGINT$PBYTE$LONGWORD$$BOOLEAN:
# [56] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-92(%esp),%esp
	pushl	%ebx
	pushl	%esi
# Var Src located at ebp-4, size=OS_32
# Var SrcSize located at ebp-8, size=OS_32
# Var W located at ebp-12, size=OS_32
# Var H located at ebp+16, size=OS_32
# Var Dst located at ebp+12, size=OS_32
# Var MaxPixels located at ebp+8, size=OS_32
# Var $result located at ebp-16, size=OS_8
# Var HdrSize located at ebp-20, size=OS_32
# Var ImgOff located at ebp-24, size=OS_32
# Var Bpp located at ebp-28, size=OS_16
# Var Planes located at ebp-32, size=OS_16
# Var Comp located at ebp-36, size=OS_16
# Var RowBytes located at ebp-40, size=OS_S32
# Var Y located at ebp-44, size=OS_S32
# Var X located at ebp-48, size=OS_S32
# Var DstRow located at ebp-52, size=OS_S32
# Var DstPtr located at ebp-56, size=OS_32
# Var SrcPtr located at ebp-60, size=OS_32
# Var Pad located at ebp-64, size=OS_S32
# Var PixIdx located at ebp-68, size=OS_32
# Var R located at ebp-72, size=OS_8
# Var G located at ebp-76, size=OS_8
# Var B located at ebp-80, size=OS_8
# Var IsTopDown located at ebp-84, size=OS_8
# Var PaletteBase located at ebp-88, size=OS_S32
# Var PalEntry located at ebp-92, size=OS_32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [57] BMPDecode := False;
	movb	$0,-16(%ebp)
# [58] W := 0;
	movl	-12(%ebp),%eax
	movl	$0,(%eax)
# [59] H := 0;
	movl	16(%ebp),%eax
	movl	$0,(%eax)
# [60] if SrcSize < 54 then Exit;
	cmpl	$54,-8(%ebp)
	jb	.Lj11
	jmp	.Lj12
.Lj11:
	jmp	.Lj9
	.balign 4,0x90
.Lj12:
# [61] if Src[0] <> $42 then Exit;
	movl	-4(%ebp),%eax
	cmpb	$66,(%eax)
	jne	.Lj13
	jmp	.Lj14
.Lj13:
	jmp	.Lj9
	.balign 4,0x90
.Lj14:
# [62] if Src[1] <> $4D then Exit;
	movl	-4(%ebp),%eax
	cmpb	$77,1(%eax)
	jne	.Lj15
	jmp	.Lj16
.Lj15:
	jmp	.Lj9
	.balign 4,0x90
.Lj16:
# [63] ImgOff := ReadLE32(Src + 10);
	movl	-4(%ebp),%eax
	leal	10(%eax),%eax
	call	BMP_$$_READLE32$PBYTE$$LONGWORD
	movl	%eax,-24(%ebp)
# [64] HdrSize := ReadLE32(Src + 14);
	movl	-4(%ebp),%eax
	leal	14(%eax),%eax
	call	BMP_$$_READLE32$PBYTE$$LONGWORD
	movl	%eax,-20(%ebp)
# [65] W := LongInt(ReadLE32(Src + 18));
	movl	-4(%ebp),%eax
	leal	18(%eax),%eax
	call	BMP_$$_READLE32$PBYTE$$LONGWORD
	movl	-12(%ebp),%edx
	movl	%eax,(%edx)
# [66] H := LongInt(ReadLE32(Src + 22));
	movl	-4(%ebp),%eax
	leal	22(%eax),%eax
	call	BMP_$$_READLE32$PBYTE$$LONGWORD
	movl	16(%ebp),%edx
	movl	%eax,(%edx)
# [67] Planes := ReadLE16(Src + 26);
	movl	-4(%ebp),%eax
	leal	26(%eax),%eax
	call	BMP_$$_READLE16$PBYTE$$WORD
	movw	%ax,-32(%ebp)
# [68] Bpp := ReadLE16(Src + 28);
	movl	-4(%ebp),%eax
	leal	28(%eax),%eax
	call	BMP_$$_READLE16$PBYTE$$WORD
	movw	%ax,-28(%ebp)
# [69] Comp := ReadLE32(Src + 30);
	movl	-4(%ebp),%eax
	leal	30(%eax),%eax
	call	BMP_$$_READLE32$PBYTE$$LONGWORD
	movw	%ax,-36(%ebp)
# [70] IsTopDown := H < 0;
	movl	16(%ebp),%eax
	cmpl	$0,(%eax)
	setlb	-84(%ebp)
# [71] if IsTopDown then H := -H;
	cmpb	$0,-84(%ebp)
	jne	.Lj17
	jmp	.Lj18
.Lj17:
	movl	16(%ebp),%eax
	movl	(%eax),%eax
	negl	%eax
	movl	16(%ebp),%edx
	movl	%eax,(%edx)
	.balign 4,0x90
.Lj18:
# [72] if Planes <> 1 then begin W := 0; H := 0; Exit; end;
	cmpw	$1,-32(%ebp)
	jne	.Lj19
	jmp	.Lj20
.Lj19:
	movl	-12(%ebp),%eax
	movl	$0,(%eax)
	movl	16(%ebp),%eax
	movl	$0,(%eax)
	jmp	.Lj9
	.balign 4,0x90
.Lj20:
# [73] if (Bpp <> 24) and (Bpp <> 32) and (Bpp <> 8) then
	cmpw	$24,-28(%ebp)
	jne	.Lj21
	jmp	.Lj22
.Lj21:
	cmpw	$32,-28(%ebp)
	jne	.Lj23
	jmp	.Lj22
.Lj23:
	cmpw	$8,-28(%ebp)
	jne	.Lj24
	jmp	.Lj22
.Lj24:
# [75] SerialWriteString('bmp: unsupported bpp=');
	movl	$_$BMP$_Ld1,%eax
	call	SERIAL_$$_SERIALWRITESTRING$PCHAR
# [76] SerialWriteHex32(Bpp);
	movzwl	-28(%ebp),%eax
	call	SERIAL_$$_SERIALWRITEHEX32$LONGWORD
# [77] SerialWriteChar(#13);
	movb	$13,%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
# [78] SerialWriteChar(#10);
	movb	$10,%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
# [79] W := 0;
	movl	-12(%ebp),%eax
	movl	$0,(%eax)
# [80] H := 0;
	movl	16(%ebp),%eax
	movl	$0,(%eax)
# [81] Exit;
	jmp	.Lj9
	.balign 4,0x90
.Lj22:
# [83] if Comp <> 0 then
	cmpw	$0,-36(%ebp)
	jne	.Lj25
	jmp	.Lj26
.Lj25:
# [85] SerialWriteString('bmp: compressed');
	movl	$_$BMP$_Ld2,%eax
	call	SERIAL_$$_SERIALWRITESTRING$PCHAR
# [86] SerialWriteChar(#13);
	movb	$13,%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
# [87] SerialWriteChar(#10);
	movb	$10,%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
# [88] W := 0;
	movl	-12(%ebp),%eax
	movl	$0,(%eax)
# [89] H := 0;
	movl	16(%ebp),%eax
	movl	$0,(%eax)
# [90] Exit;
	jmp	.Lj9
	.balign 4,0x90
.Lj26:
# [92] if (W <= 0) or (H <= 0) then Exit;
	movl	-12(%ebp),%eax
	cmpl	$0,(%eax)
	jle	.Lj27
	jmp	.Lj28
.Lj28:
	movl	16(%ebp),%eax
	cmpl	$0,(%eax)
	jle	.Lj27
	jmp	.Lj29
.Lj27:
	jmp	.Lj9
	.balign 4,0x90
.Lj29:
# [93] if MaxPixels < LongWord(W * H) then
	movl	-12(%ebp),%eax
	movl	16(%ebp),%edx
	movl	(%eax),%ecx
	movl	(%edx),%eax
	imull	%ecx,%eax
	cmpl	8(%ebp),%eax
	ja	.Lj30
	jmp	.Lj31
.Lj30:
# [95] SerialWriteString('bmp: too large');
	movl	$_$BMP$_Ld3,%eax
	call	SERIAL_$$_SERIALWRITESTRING$PCHAR
# [96] SerialWriteChar(#13);
	movb	$13,%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
# [97] SerialWriteChar(#10);
	movb	$10,%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
# [98] W := 0;
	movl	-12(%ebp),%eax
	movl	$0,(%eax)
# [99] H := 0;
	movl	16(%ebp),%eax
	movl	$0,(%eax)
# [100] Exit;
	jmp	.Lj9
	.balign 4,0x90
.Lj31:
# [102] RowBytes := (W * Bpp + 31) div 32 * 4;
	movl	-12(%ebp),%eax
	movzwl	-28(%ebp),%edx
	movl	(%eax),%eax
	imull	%eax,%edx
	leal	31(%edx),%eax
	movl	%eax,%edx
	sarl	$31,%edx
	andl	$31,%edx
	addl	%edx,%eax
	sarl	$5,%eax
	shll	$2,%eax
	movl	%eax,-40(%ebp)
# [103] Pad := RowBytes - (W * Bpp div 8);
	movl	-12(%ebp),%edx
	movzwl	-28(%ebp),%eax
	movl	(%edx),%edx
	imull	%edx,%eax
	movl	%eax,%edx
	sarl	$31,%edx
	andl	$7,%edx
	addl	%edx,%eax
	sarl	$3,%eax
	movl	-40(%ebp),%edx
	subl	%eax,%edx
	movl	%edx,-64(%ebp)
# [104] PaletteBase := 14 + Integer(HdrSize);
	movl	-20(%ebp),%eax
	leal	14(%eax),%eax
	movl	%eax,-88(%ebp)
# [105] PixIdx := 0;
	movl	$0,-68(%ebp)
# [106] for Y := 0 to H - 1 do
	movl	16(%ebp),%eax
	movl	(%eax),%eax
	leal	-1(%eax),%eax
	cmpl	$0,%eax
	jge	.Lj32
	jmp	.Lj33
.Lj32:
	movl	$-1,-44(%ebp)
	.balign 8,0x90
.Lj34:
	movl	-44(%ebp),%edx
	leal	1(%edx),%edx
	movl	%edx,-44(%ebp)
# [108] if IsTopDown then DstRow := Y
	cmpb	$0,-84(%ebp)
	jne	.Lj37
	jmp	.Lj38
.Lj37:
	movl	-44(%ebp),%edx
	movl	%edx,-52(%ebp)
	jmp	.Lj39
.Lj38:
# [109] else DstRow := H - 1 - Y;
	movl	16(%ebp),%edx
	movl	(%edx),%edx
	leal	-1(%edx),%edx
	subl	-44(%ebp),%edx
	movl	%edx,-52(%ebp)
.Lj39:
# [110] DstPtr := Dst;
	movl	12(%ebp),%edx
	movl	%edx,-56(%ebp)
# [111] Inc(DstPtr, DstRow * W * 4);
	movl	-12(%ebp),%edx
	movl	(%edx),%ecx
	movl	-52(%ebp),%edx
	imull	%ecx,%edx
	shll	$2,%edx
	addl	%edx,-56(%ebp)
# [112] SrcPtr := PByte(PByte(Src) + ImgOff + LongWord(Y) * LongWord(RowBytes));
	movl	-44(%ebp),%ecx
	movl	-40(%ebp),%edx
	imull	%ecx,%edx
	movl	-4(%ebp),%ecx
	movl	-24(%ebp),%ebx
	leal	(%ecx,%ebx),%ecx
	leal	(%edx,%ecx),%edx
	movl	%edx,-60(%ebp)
# [113] for X := 0 to W - 1 do
	movl	-12(%ebp),%edx
	movl	(%edx),%edx
	leal	-1(%edx),%edx
	cmpl	$0,%edx
	jge	.Lj40
	jmp	.Lj41
.Lj40:
	movl	$-1,-48(%ebp)
	.balign 8,0x90
.Lj42:
	movl	-48(%ebp),%ecx
	leal	1(%ecx),%ecx
	movl	%ecx,-48(%ebp)
# [115] if Bpp = 8 then
	cmpw	$8,-28(%ebp)
	je	.Lj45
	jmp	.Lj46
.Lj45:
# [117] PalEntry := PByte(PByte(Src) + PaletteBase + Integer(SrcPtr^) * 4);
	movl	-60(%ebp),%ecx
	movzbl	(%ecx),%ecx
	shll	$2,%ecx
	movl	-4(%ebp),%esi
	movl	-88(%ebp),%ebx
	leal	(%esi,%ebx),%ebx
	leal	(%ecx,%ebx),%ecx
	movl	%ecx,-92(%ebp)
# [118] B := PalEntry^; Inc(PalEntry);
	movl	-92(%ebp),%ecx
	movb	(%ecx),%cl
	movb	%cl,-80(%ebp)
	addl	$1,-92(%ebp)
# [119] G := PalEntry^; Inc(PalEntry);
	movl	-92(%ebp),%ecx
	movb	(%ecx),%cl
	movb	%cl,-76(%ebp)
	addl	$1,-92(%ebp)
# [120] R := PalEntry^;
	movl	-92(%ebp),%ecx
	movb	(%ecx),%cl
	movb	%cl,-72(%ebp)
# [121] Inc(SrcPtr);
	addl	$1,-60(%ebp)
	jmp	.Lj47
.Lj46:
# [123] else if Bpp = 24 then
	cmpw	$24,-28(%ebp)
	je	.Lj48
	jmp	.Lj49
.Lj48:
# [125] B := SrcPtr^; Inc(SrcPtr);
	movl	-60(%ebp),%ecx
	movb	(%ecx),%cl
	movb	%cl,-80(%ebp)
	addl	$1,-60(%ebp)
# [126] G := SrcPtr^; Inc(SrcPtr);
	movl	-60(%ebp),%ecx
	movb	(%ecx),%cl
	movb	%cl,-76(%ebp)
	addl	$1,-60(%ebp)
# [127] R := SrcPtr^; Inc(SrcPtr);
	movl	-60(%ebp),%ecx
	movb	(%ecx),%cl
	movb	%cl,-72(%ebp)
	addl	$1,-60(%ebp)
	jmp	.Lj50
.Lj49:
# [131] B := SrcPtr^; Inc(SrcPtr);
	movl	-60(%ebp),%ecx
	movb	(%ecx),%cl
	movb	%cl,-80(%ebp)
	addl	$1,-60(%ebp)
# [132] G := SrcPtr^; Inc(SrcPtr);
	movl	-60(%ebp),%ecx
	movb	(%ecx),%cl
	movb	%cl,-76(%ebp)
	addl	$1,-60(%ebp)
# [133] R := SrcPtr^; Inc(SrcPtr);
	movl	-60(%ebp),%ecx
	movb	(%ecx),%cl
	movb	%cl,-72(%ebp)
	addl	$1,-60(%ebp)
# [134] Inc(SrcPtr);
	addl	$1,-60(%ebp)
.Lj50:
.Lj47:
# [136] if (R = 255) and (G = 0) and (B = 0) then
	cmpb	$255,-72(%ebp)
	je	.Lj51
	jmp	.Lj52
.Lj51:
	cmpb	$0,-76(%ebp)
	je	.Lj53
	jmp	.Lj52
.Lj53:
	cmpb	$0,-80(%ebp)
	je	.Lj54
	jmp	.Lj52
.Lj54:
# [137] PLongWord(DstPtr)^ := $00000000   // transparente
	movl	-56(%ebp),%ecx
	movl	$0,(%ecx)
	jmp	.Lj55
.Lj52:
# [139] PLongWord(DstPtr)^ := $FF000000 or LongWord(R) or
	movzbl	-72(%ebp),%ebx
	orl	$-16777216,%ebx
# [140] (LongWord(G) shl 8) or (LongWord(B) shl 16);
	movzbl	-76(%ebp),%ecx
	shll	$8,%ecx
	orl	%ecx,%ebx
	movzbl	-80(%ebp),%ecx
	shll	$16,%ecx
	orl	%ecx,%ebx
	movl	-56(%ebp),%ecx
	movl	%ebx,(%ecx)
.Lj55:
# [141] Inc(DstPtr, 4);
	addl	$4,-56(%ebp)
# [142] Inc(PixIdx);
	addl	$1,-68(%ebp)
	cmpl	-48(%ebp),%edx
	jle	.Lj44
	jmp	.Lj42
.Lj44:
	.balign 4,0x90
.Lj41:
# [144] Inc(SrcPtr, Pad);
	movl	-64(%ebp),%edx
	addl	%edx,-60(%ebp)
	cmpl	-44(%ebp),%eax
	jle	.Lj36
	jmp	.Lj34
.Lj36:
	.balign 4,0x90
.Lj33:
# [146] BMPDecode := True;
	movb	$1,-16(%ebp)
.Lj9:
# [147] end;
	movb	-16(%ebp),%al
	popl	%esi
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret	$12
# End asmlist al_procedures
# Begin asmlist al_typedconsts

.section .rodata.n__$BMP$_Ld1,"d"
	.balign 4
.globl	_$BMP$_Ld1
_$BMP$_Ld1:
	.ascii	"bmp: unsupported bpp=\000"

.section .rodata.n__$BMP$_Ld2,"d"
	.balign 4
.globl	_$BMP$_Ld2
_$BMP$_Ld2:
	.ascii	"bmp: compressed\000"

.section .rodata.n__$BMP$_Ld3,"d"
	.balign 4
.globl	_$BMP$_Ld3
_$BMP$_Ld3:
	.ascii	"bmp: too large\000"
# End asmlist al_typedconsts

