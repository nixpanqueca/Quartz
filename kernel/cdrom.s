	.file "cdrom.pas"
# Begin asmlist al_procedures

.section .text.n_cdrom_$$_outb$word$byte,"x"
	.balign 16,0x90
CDROM_$$_OUTB$WORD$BYTE:
# [cdrom.pas]
# [29] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var Addr located at ebp-4, size=OS_16
# Var Value located at ebp-8, size=OS_8
	movw	%ax,-4(%ebp)
	movb	%dl,-8(%ebp)
#  CPU PENTIUM
# [31] mov dx, Addr
	movw	-4(%ebp),%dx
# [32] mov al, Value
	movb	-8(%ebp),%al
# [33] out dx, al
	outb	%al,%dx
#  CPU PENTIUM
# [35] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_cdrom_$$_inb$word$$byte,"x"
	.balign 16,0x90
CDROM_$$_INB$WORD$$BYTE:
# [40] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-12(%esp),%esp
# Var Addr located at ebp-4, size=OS_16
# Var $result located at ebp-8, size=OS_8
# Var B located at ebp-12, size=OS_8
	movw	%ax,-4(%ebp)
#  CPU PENTIUM
# [42] mov dx, Addr
	movw	-4(%ebp),%dx
# [43] in al, dx
	inb	%dx,%al
# [44] mov B, al
	movb	%al,-12(%ebp)
#  CPU PENTIUM
# [46] InB := B;
	movb	-12(%ebp),%al
	movb	%al,-8(%ebp)
# [47] end;
	movb	-8(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_cdrom_$$_inw$word$$word,"x"
	.balign 16,0x90
CDROM_$$_INW$WORD$$WORD:
# [52] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-12(%esp),%esp
# Var Addr located at ebp-4, size=OS_16
# Var $result located at ebp-8, size=OS_16
# Var W located at ebp-12, size=OS_16
	movw	%ax,-4(%ebp)
#  CPU PENTIUM
# [54] mov dx, Addr
	movw	-4(%ebp),%dx
# [55] in ax, dx
	inw	%dx,%ax
# [56] mov W, ax
	movw	%ax,-12(%ebp)
#  CPU PENTIUM
# [58] InW := W;
	movw	-12(%ebp),%ax
	movw	%ax,-8(%ebp)
# [59] end;
	movw	-8(%ebp),%ax
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_cdrom_$$_outw$word$word,"x"
	.balign 16,0x90
CDROM_$$_OUTW$WORD$WORD:
# [62] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var Addr located at ebp-4, size=OS_16
# Var Value located at ebp-8, size=OS_16
	movw	%ax,-4(%ebp)
	movw	%dx,-8(%ebp)
#  CPU PENTIUM
# [64] mov dx, Addr
	movw	-4(%ebp),%dx
# [65] mov ax, Value
	movw	-8(%ebp),%ax
# [66] out dx, ax
	outw	%ax,%dx
#  CPU PENTIUM
# [68] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_cdrom_$$_atastatusdelay,"x"
	.balign 16,0x90
CDROM_$$_ATASTATUSDELAY:
# [71] begin
	pushl	%ebp
	movl	%esp,%ebp
# [72] OutB(CDBase + $206, $02);   // device control register: nIEN + ~400ns delay
	movzwl	TC_$CDROM_$$_CDBASE,%eax
	leal	518(%eax),%eax
	movb	$2,%dl
	call	CDROM_$$_OUTB$WORD$BYTE
# [73] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_cdrom_$$_cdprobe$word$byte$$boolean,"x"
	.balign 16,0x90
CDROM_$$_CDPROBE$WORD$BYTE$$BOOLEAN:
# [79] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-20(%esp),%esp
# Var Base located at ebp-4, size=OS_16
# Var Sel located at ebp-8, size=OS_8
# Var $result located at ebp-12, size=OS_8
# Var I located at ebp-16, size=OS_S32
# Var St located at ebp-20, size=OS_8
	movw	%ax,-4(%ebp)
	movb	%dl,-8(%ebp)
# [80] CDProbe := False;
	movb	$0,-12(%ebp)
# [81] OutB(Base + 6, Sel);
	movzwl	-4(%ebp),%eax
	leal	6(%eax),%eax
	movb	-8(%ebp),%dl
	call	CDROM_$$_OUTB$WORD$BYTE
# [82] OutB(Base + $206, $02);
	movzwl	-4(%ebp),%eax
	leal	518(%eax),%eax
	movb	$2,%dl
	call	CDROM_$$_OUTB$WORD$BYTE
# [83] OutB(Base + 7, $A1);          // IDENTIFY PACKET DEVICE
	movzwl	-4(%ebp),%eax
	leal	7(%eax),%eax
	movb	$161,%dl
	call	CDROM_$$_OUTB$WORD$BYTE
# [84] for I := 0 to 50000 do
	movl	$-1,-16(%ebp)
	.balign 8,0x90
.Lj15:
	movl	-16(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-16(%ebp)
# [86] St := InB(Base + 7);
	movzwl	-4(%ebp),%eax
	leal	7(%eax),%eax
	call	CDROM_$$_INB$WORD$$BYTE
	movb	%al,-20(%ebp)
# [87] if (St and $08) <> 0 then Break;    // DRQ -> ATAPI device
	movzbw	-20(%ebp),%ax
	andw	$8,%ax
	testw	$-1,%ax
	jne	.Lj18
	jmp	.Lj19
.Lj18:
	jmp	.Lj17
	.balign 4,0x90
.Lj19:
# [88] if (St and $01) <> 0 then Break;    // ERR -> ATA device aborted
	movzbw	-20(%ebp),%ax
	andw	$1,%ax
	testw	$-1,%ax
	jne	.Lj20
	jmp	.Lj21
.Lj20:
	jmp	.Lj17
	.balign 4,0x90
.Lj21:
# [89] if (St and $80) = 0 then
	movb	-20(%ebp),%al
	andb	$128,%al
	testb	$-1,%al
	je	.Lj22
	jmp	.Lj23
.Lj22:
# [90] if St = 0 then Break;             // no device on this slot
	cmpb	$0,-20(%ebp)
	je	.Lj24
	jmp	.Lj25
.Lj24:
	jmp	.Lj17
	.balign 4,0x90
.Lj25:
	.balign 4,0x90
.Lj23:
# [91] ATAStatusDelay;
	call	CDROM_$$_ATASTATUSDELAY
	cmpl	$50000,-16(%ebp)
	jge	.Lj17
	jmp	.Lj15
.Lj17:
# [93] if (St and $08) = 0 then Exit;
	movzbw	-20(%ebp),%ax
	andw	$8,%ax
	testw	$-1,%ax
	je	.Lj26
	jmp	.Lj27
.Lj26:
	jmp	.Lj13
	.balign 4,0x90
.Lj27:
# [94] for I := 0 to 255 do
	movl	$-1,-16(%ebp)
	.balign 8,0x90
.Lj28:
	movl	-16(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-16(%ebp)
# [95] InW(Base);                          // drain 512-byte identify block
	movw	-4(%ebp),%ax
	call	CDROM_$$_INW$WORD$$WORD
	cmpl	$255,-16(%ebp)
	jge	.Lj30
	jmp	.Lj28
.Lj30:
# [96] CDProbe := True;
	movb	$1,-12(%ebp)
.Lj13:
# [97] end;
	movb	-12(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_cdrom_$$_cdinit,"x"
	.balign 16,0x90
.globl	CDROM_$$_CDINIT
CDROM_$$_CDINIT:
# [100] begin
	pushl	%ebp
	movl	%esp,%ebp
# [101] CDBase := 0;
	movw	$0,TC_$CDROM_$$_CDBASE
# [102] if CDProbe($1F0, $A0) then begin CDBase := $1F0; CDDrive := $A0; end
	movb	$160,%dl
	movw	$496,%ax
	call	CDROM_$$_CDPROBE$WORD$BYTE$$BOOLEAN
	testb	%al,%al
	jne	.Lj33
	jmp	.Lj34
.Lj33:
	movw	$496,TC_$CDROM_$$_CDBASE
	movb	$160,TC_$CDROM_$$_CDDRIVE
	jmp	.Lj35
.Lj34:
# [103] else if CDProbe($1F0, $B0) then begin CDBase := $1F0; CDDrive := $B0; end
	movb	$176,%dl
	movw	$496,%ax
	call	CDROM_$$_CDPROBE$WORD$BYTE$$BOOLEAN
	testb	%al,%al
	jne	.Lj36
	jmp	.Lj37
.Lj36:
	movw	$496,TC_$CDROM_$$_CDBASE
	movb	$176,TC_$CDROM_$$_CDDRIVE
	jmp	.Lj38
.Lj37:
# [104] else if CDProbe($170, $A0) then begin CDBase := $170; CDDrive := $A0; end
	movb	$160,%dl
	movw	$368,%ax
	call	CDROM_$$_CDPROBE$WORD$BYTE$$BOOLEAN
	testb	%al,%al
	jne	.Lj39
	jmp	.Lj40
.Lj39:
	movw	$368,TC_$CDROM_$$_CDBASE
	movb	$160,TC_$CDROM_$$_CDDRIVE
	jmp	.Lj41
.Lj40:
# [105] else if CDProbe($170, $B0) then begin CDBase := $170; CDDrive := $B0; end;
	movb	$176,%dl
	movw	$368,%ax
	call	CDROM_$$_CDPROBE$WORD$BYTE$$BOOLEAN
	testb	%al,%al
	jne	.Lj42
	jmp	.Lj43
.Lj42:
	movw	$368,TC_$CDROM_$$_CDBASE
	movb	$176,TC_$CDROM_$$_CDDRIVE
	.balign 4,0x90
.Lj43:
.Lj41:
.Lj38:
.Lj35:
# [106] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_cdrom_$$_cdreadsector$longword$pbyte$$boolean,"x"
	.balign 16,0x90
.globl	CDROM_$$_CDREADSECTOR$LONGWORD$PBYTE$$BOOLEAN
CDROM_$$_CDREADSECTOR$LONGWORD$PBYTE$$BOOLEAN:
# [113] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-32(%esp),%esp
# Var LBA located at ebp-4, size=OS_32
# Var Buf located at ebp-8, size=OS_32
# Var $result located at ebp-12, size=OS_8
# Var I located at ebp-16, size=OS_S32
# Var St located at ebp-20, size=OS_8
# Var CDB located at ebp-32, size=OS_NO
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
# [114] CDReadSector := False;
	movb	$0,-12(%ebp)
# [115] if CDBase = 0 then Exit;
	cmpw	$0,TC_$CDROM_$$_CDBASE
	je	.Lj46
	jmp	.Lj47
.Lj46:
	jmp	.Lj44
	.balign 4,0x90
.Lj47:
# [116] OutB(CDBase + 6, CDDrive);
	movzwl	TC_$CDROM_$$_CDBASE,%eax
	leal	6(%eax),%eax
	movb	TC_$CDROM_$$_CDDRIVE,%dl
	call	CDROM_$$_OUTB$WORD$BYTE
# [117] ATAStatusDelay;
	call	CDROM_$$_ATASTATUSDELAY
# [118] for I := 0 to 100000 do
	movl	$-1,-16(%ebp)
	.balign 8,0x90
.Lj48:
	movl	-16(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-16(%ebp)
# [120] St := InB(CDBase + 7);
	movzwl	TC_$CDROM_$$_CDBASE,%eax
	leal	7(%eax),%eax
	call	CDROM_$$_INB$WORD$$BYTE
	movb	%al,-20(%ebp)
# [121] if (St and $80) = 0 then Break;     // BSY clear
	movb	-20(%ebp),%al
	andb	$128,%al
	testb	$-1,%al
	je	.Lj51
	jmp	.Lj52
.Lj51:
	jmp	.Lj50
	.balign 4,0x90
.Lj52:
# [122] ATAStatusDelay;
	call	CDROM_$$_ATASTATUSDELAY
	cmpl	$100000,-16(%ebp)
	jge	.Lj50
	jmp	.Lj48
.Lj50:
# [124] OutB(CDBase + 7, $A0);                // PACKET
	movzwl	TC_$CDROM_$$_CDBASE,%eax
	leal	7(%eax),%eax
	movb	$160,%dl
	call	CDROM_$$_OUTB$WORD$BYTE
# [125] for I := 0 to 100000 do
	movl	$-1,-16(%ebp)
	.balign 8,0x90
.Lj53:
	movl	-16(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-16(%ebp)
# [127] St := InB(CDBase + 7);
	movzwl	TC_$CDROM_$$_CDBASE,%eax
	leal	7(%eax),%eax
	call	CDROM_$$_INB$WORD$$BYTE
	movb	%al,-20(%ebp)
# [128] if (St and $08) <> 0 then Break;    // DRQ: ready for the CDB
	movzbw	-20(%ebp),%ax
	andw	$8,%ax
	testw	$-1,%ax
	jne	.Lj56
	jmp	.Lj57
.Lj56:
	jmp	.Lj55
	.balign 4,0x90
.Lj57:
# [129] if (St and $01) <> 0 then Exit;     // ERR
	movzbw	-20(%ebp),%ax
	andw	$1,%ax
	testw	$-1,%ax
	jne	.Lj58
	jmp	.Lj59
.Lj58:
	jmp	.Lj44
	.balign 4,0x90
.Lj59:
# [130] ATAStatusDelay;
	call	CDROM_$$_ATASTATUSDELAY
	cmpl	$100000,-16(%ebp)
	jge	.Lj55
	jmp	.Lj53
.Lj55:
# [132] if (St and $08) = 0 then Exit;
	movzbw	-20(%ebp),%ax
	andw	$8,%ax
	testw	$-1,%ax
	je	.Lj60
	jmp	.Lj61
.Lj60:
	jmp	.Lj44
	.balign 4,0x90
.Lj61:
# [133] CDB[0] := $28;                        // READ(10)
	movb	$40,-32(%ebp)
# [134] CDB[1] := 0;
	movb	$0,-31(%ebp)
# [135] CDB[2] := (LBA shr 24) and $FF;
	movl	-4(%ebp),%eax
	shrl	$24,%eax
	andl	$255,%eax
	movb	%al,-30(%ebp)
# [136] CDB[3] := (LBA shr 16) and $FF;
	movl	-4(%ebp),%eax
	shrl	$16,%eax
	andl	$255,%eax
	movb	%al,-29(%ebp)
# [137] CDB[4] := (LBA shr 8) and $FF;
	movl	-4(%ebp),%eax
	shrl	$8,%eax
	andl	$255,%eax
	movb	%al,-28(%ebp)
# [138] CDB[5] := LBA and $FF;
	movl	-4(%ebp),%eax
	andl	$255,%eax
	movb	%al,-27(%ebp)
# [139] CDB[6] := 0;
	movb	$0,-26(%ebp)
# [140] CDB[7] := 0;
	movb	$0,-25(%ebp)
# [141] CDB[8] := 1;                          // 1 logical sector
	movb	$1,-24(%ebp)
# [142] CDB[9] := 0;
	movb	$0,-23(%ebp)
# [143] CDB[10] := 0;
	movb	$0,-22(%ebp)
# [144] CDB[11] := 0;
	movb	$0,-21(%ebp)
# [145] for I := 0 to 5 do
	movl	$-1,-16(%ebp)
	.balign 8,0x90
.Lj62:
	movl	-16(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-16(%ebp)
# [146] OutW(CDBase, Word(CDB[I * 2]) or (Word(CDB[I * 2 + 1]) shl 8));
	movl	-16(%ebp),%eax
	shll	$1,%eax
	leal	1(%eax),%eax
	movzbw	-32(%ebp,%eax,1),%dx
	movzwl	%dx,%edx
	shll	$8,%edx
	movl	-16(%ebp),%eax
	shll	$1,%eax
	movzbw	-32(%ebp,%eax,1),%ax
	movzwl	%ax,%eax
	orl	%eax,%edx
	movw	TC_$CDROM_$$_CDBASE,%ax
	call	CDROM_$$_OUTW$WORD$WORD
	cmpl	$5,-16(%ebp)
	jge	.Lj64
	jmp	.Lj62
.Lj64:
# [147] for I := 0 to 500000 do
	movl	$-1,-16(%ebp)
	.balign 8,0x90
.Lj65:
	movl	-16(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-16(%ebp)
# [149] St := InB(CDBase + 7);
	movzwl	TC_$CDROM_$$_CDBASE,%eax
	leal	7(%eax),%eax
	call	CDROM_$$_INB$WORD$$BYTE
	movb	%al,-20(%ebp)
# [150] if (St and $08) <> 0 then Break;    // data ready
	movzbw	-20(%ebp),%ax
	andw	$8,%ax
	testw	$-1,%ax
	jne	.Lj68
	jmp	.Lj69
.Lj68:
	jmp	.Lj67
	.balign 4,0x90
.Lj69:
# [151] if (St and $01) <> 0 then Exit;     // ERR
	movzbw	-20(%ebp),%ax
	andw	$1,%ax
	testw	$-1,%ax
	jne	.Lj70
	jmp	.Lj71
.Lj70:
	jmp	.Lj44
	.balign 4,0x90
.Lj71:
# [152] ATAStatusDelay;
	call	CDROM_$$_ATASTATUSDELAY
	cmpl	$500000,-16(%ebp)
	jge	.Lj67
	jmp	.Lj65
.Lj67:
# [154] if (St and $08) = 0 then Exit;
	movzbw	-20(%ebp),%ax
	andw	$8,%ax
	testw	$-1,%ax
	je	.Lj72
	jmp	.Lj73
.Lj72:
	jmp	.Lj44
	.balign 4,0x90
.Lj73:
# [155] for I := 0 to 1023 do
	movl	$-1,-16(%ebp)
	.balign 8,0x90
.Lj74:
	movl	-16(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-16(%ebp)
# [156] PWord(PByte(Buf) + I * 2)^ := InW(CDBase);
	movw	TC_$CDROM_$$_CDBASE,%ax
	call	CDROM_$$_INW$WORD$$WORD
	movl	-16(%ebp),%edx
	shll	$1,%edx
	addl	-8(%ebp),%edx
	movw	%ax,(%edx)
	cmpl	$1023,-16(%ebp)
	jge	.Lj76
	jmp	.Lj74
.Lj76:
# [157] CDReadSector := True;
	movb	$1,-12(%ebp)
.Lj44:
# [158] end;
	movb	-12(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_cdrom_$$_nameequals$pchar$pbyte$longint$longint$$boolean,"x"
	.balign 16,0x90
CDROM_$$_NAMEEQUALS$PCHAR$PBYTE$LONGINT$LONGINT$$BOOLEAN:
# [164] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-28(%esp),%esp
# Var NamePtr located at ebp-4, size=OS_32
# Var DirBytes located at ebp-8, size=OS_32
# Var NameOffset located at ebp-12, size=OS_S32
# Var NameLen located at ebp+8, size=OS_S32
# Var $result located at ebp-16, size=OS_8
# Var I located at ebp-20, size=OS_S32
# Var Ch located at ebp-24, size=OS_8
# Var DCh located at ebp-28, size=OS_8
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [165] NameEquals := False;
	movb	$0,-16(%ebp)
# [166] I := 0;
	movl	$0,-20(%ebp)
# [167] while True do
	jmp	.Lj80
	.balign 8,0x90
.Lj79:
# [169] Ch := Byte(NamePtr[I]);
	movl	-4(%ebp),%edx
	movl	-20(%ebp),%eax
	movb	(%edx,%eax,1),%al
	movb	%al,-24(%ebp)
# [170] DCh := DirBytes[NameOffset + I];
	movl	-8(%ebp),%ecx
	movl	-12(%ebp),%edx
	movl	-20(%ebp),%eax
	leal	(%edx,%eax),%eax
	movb	(%ecx,%eax,1),%al
	movb	%al,-28(%ebp)
# [171] if (Ch = 0) or (Ch = $3B) then
	cmpb	$0,-24(%ebp)
	je	.Lj82
	jmp	.Lj83
.Lj83:
	cmpb	$59,-24(%ebp)
	je	.Lj82
	jmp	.Lj84
.Lj82:
# [173] if I >= NameLen then
	movl	-20(%ebp),%eax
	cmpl	8(%ebp),%eax
	jge	.Lj85
	jmp	.Lj86
.Lj85:
# [174] NameEquals := True
	movb	$1,-16(%ebp)
	jmp	.Lj87
.Lj86:
# [175] else if DCh = $3B then
	cmpb	$59,-28(%ebp)
	je	.Lj88
	jmp	.Lj89
.Lj88:
# [176] NameEquals := True;
	movb	$1,-16(%ebp)
	.balign 4,0x90
.Lj89:
.Lj87:
# [177] Exit;
	jmp	.Lj77
	.balign 4,0x90
.Lj84:
# [179] if I >= NameLen then Exit;
	movl	-20(%ebp),%eax
	cmpl	8(%ebp),%eax
	jge	.Lj90
	jmp	.Lj91
.Lj90:
	jmp	.Lj77
	.balign 4,0x90
.Lj91:
# [180] if Ch >= $61 then Dec(Ch, $20);
	cmpb	$97,-24(%ebp)
	jae	.Lj92
	jmp	.Lj93
.Lj92:
	subb	$32,-24(%ebp)
	.balign 4,0x90
.Lj93:
# [181] if DCh >= $61 then Dec(DCh, $20);
	cmpb	$97,-28(%ebp)
	jae	.Lj94
	jmp	.Lj95
.Lj94:
	subb	$32,-28(%ebp)
	.balign 4,0x90
.Lj95:
# [182] if Ch <> DCh then Exit;
	movb	-24(%ebp),%al
	cmpb	-28(%ebp),%al
	jne	.Lj96
	jmp	.Lj97
.Lj96:
	jmp	.Lj77
	.balign 4,0x90
.Lj97:
# [183] Inc(I);
	addl	$1,-20(%ebp)
.Lj80:
	jmp	.Lj79
.Lj77:
# [185] end;
	movb	-16(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret	$4

.section .text.n_cdrom_$$_fslookup$longword$longword$pchar$longword$longword$boolean,"x"
	.balign 16,0x90
CDROM_$$_FSLOOKUP$LONGWORD$LONGWORD$PCHAR$LONGWORD$LONGWORD$BOOLEAN:
# [193] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-32(%esp),%esp
	pushl	%ebx
# Var DirLBA located at ebp-4, size=OS_32
# Var DirSize located at ebp-8, size=OS_32
# Var Comp located at ebp-12, size=OS_32
# Var OutLBA located at ebp+16, size=OS_32
# Var OutSize located at ebp+12, size=OS_32
# Var OutIsDir located at ebp+8, size=OS_32
# Var SecCount located at ebp-16, size=OS_32
# Var S located at ebp-20, size=OS_32
# Var P located at ebp-24, size=OS_S32
# Var L located at ebp-28, size=OS_S32
# Var NameLen located at ebp-32, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [194] OutLBA := 0;
	movl	16(%ebp),%eax
	movl	$0,(%eax)
# [195] OutSize := 0;
	movl	12(%ebp),%eax
	movl	$0,(%eax)
# [196] OutIsDir := False;
	movl	8(%ebp),%eax
	movb	$0,(%eax)
# [197] SecCount := (DirSize + 2047) div 2048;
	movl	-8(%ebp),%eax
	leal	2047(%eax),%eax
	shrl	$11,%eax
	movl	%eax,-16(%ebp)
# [198] if SecCount > 16 then SecCount := 16;
	cmpl	$16,-16(%ebp)
	ja	.Lj100
	jmp	.Lj101
.Lj100:
	movl	$16,-16(%ebp)
	.balign 4,0x90
.Lj101:
# [199] for S := 0 to SecCount - 1 do
	movl	-16(%ebp),%eax
	leal	-1(%eax),%ebx
	movl	$-1,-20(%ebp)
	.balign 8,0x90
.Lj102:
	movl	-20(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-20(%ebp)
# [201] if not CDReadSector(DirLBA + S, @DirBuf[0]) then Exit;
	movl	-4(%ebp),%edx
	movl	-20(%ebp),%eax
	leal	(%edx,%eax),%eax
	movl	$U_$CDROM_$$_DIRBUF,%edx
	call	CDROM_$$_CDREADSECTOR$LONGWORD$PBYTE$$BOOLEAN
	testb	%al,%al
	je	.Lj105
	jmp	.Lj106
.Lj105:
	jmp	.Lj98
	.balign 4,0x90
.Lj106:
# [202] P := 0;
	movl	$0,-24(%ebp)
# [203] while P < 2048 do
	jmp	.Lj108
	.balign 8,0x90
.Lj107:
# [205] L := DirBuf[P];
	movl	-24(%ebp),%eax
	movzbl	U_$CDROM_$$_DIRBUF(,%eax,1),%eax
	movl	%eax,-28(%ebp)
# [206] if L = 0 then Break;
	cmpl	$0,-28(%ebp)
	je	.Lj110
	jmp	.Lj111
.Lj110:
	jmp	.Lj109
	.balign 4,0x90
.Lj111:
# [207] NameLen := DirBuf[P + 32];
	movl	-24(%ebp),%eax
	leal	32(%eax),%eax
	movzbl	U_$CDROM_$$_DIRBUF(,%eax,1),%eax
	movl	%eax,-32(%ebp)
# [208] if (NameLen > 0) and
	cmpl	$0,-32(%ebp)
	jg	.Lj112
	jmp	.Lj113
.Lj112:
# [209] NameEquals(Comp, @DirBuf[0], P + 33, NameLen) then
	pushl	-32(%ebp)
	movl	-24(%ebp),%eax
	leal	33(%eax),%ecx
	movl	$U_$CDROM_$$_DIRBUF,%edx
	movl	-12(%ebp),%eax
	call	CDROM_$$_NAMEEQUALS$PCHAR$PBYTE$LONGINT$LONGINT$$BOOLEAN
	testb	%al,%al
	jne	.Lj114
	jmp	.Lj113
.Lj114:
# [211] OutLBA := LongWord(DirBuf[P+2]) or (LongWord(DirBuf[P+3]) shl 8) or
	movl	-24(%ebp),%eax
	leal	3(%eax),%eax
	movzbl	U_$CDROM_$$_DIRBUF(,%eax,1),%eax
	shll	$8,%eax
	movl	-24(%ebp),%edx
	leal	2(%edx),%edx
	movzbl	U_$CDROM_$$_DIRBUF(,%edx,1),%edx
	orl	%edx,%eax
# [212] (LongWord(DirBuf[P+4]) shl 16) or (LongWord(DirBuf[P+5]) shl 24);
	movl	-24(%ebp),%edx
	leal	4(%edx),%edx
	movzbl	U_$CDROM_$$_DIRBUF(,%edx,1),%edx
	shll	$16,%edx
	orl	%edx,%eax
	movl	-24(%ebp),%edx
	leal	5(%edx),%edx
	movzbl	U_$CDROM_$$_DIRBUF(,%edx,1),%edx
	shll	$24,%edx
	orl	%edx,%eax
	movl	16(%ebp),%edx
	movl	%eax,(%edx)
# [213] OutSize := LongWord(DirBuf[P+10]) or (LongWord(DirBuf[P+11]) shl 8) or
	movl	-24(%ebp),%eax
	leal	11(%eax),%eax
	movzbl	U_$CDROM_$$_DIRBUF(,%eax,1),%eax
	shll	$8,%eax
	movl	-24(%ebp),%edx
	leal	10(%edx),%edx
	movzbl	U_$CDROM_$$_DIRBUF(,%edx,1),%edx
	orl	%edx,%eax
# [214] (LongWord(DirBuf[P+12]) shl 16) or (LongWord(DirBuf[P+13]) shl 24);
	movl	-24(%ebp),%edx
	leal	12(%edx),%edx
	movzbl	U_$CDROM_$$_DIRBUF(,%edx,1),%edx
	shll	$16,%edx
	orl	%edx,%eax
	movl	-24(%ebp),%edx
	leal	13(%edx),%edx
	movzbl	U_$CDROM_$$_DIRBUF(,%edx,1),%edx
	shll	$24,%edx
	orl	%edx,%eax
	movl	12(%ebp),%edx
	movl	%eax,(%edx)
# [215] OutIsDir := (DirBuf[P + 25] and 2) <> 0;
	movl	8(%ebp),%edx
	movl	-24(%ebp),%eax
	leal	25(%eax),%eax
	movzbw	U_$CDROM_$$_DIRBUF(,%eax,1),%ax
	andw	$2,%ax
	testw	$-1,%ax
	setneb	(%edx)
# [216] Exit;
	jmp	.Lj98
	.balign 4,0x90
.Lj113:
# [218] P := P + L;
	movl	-24(%ebp),%eax
	movl	-28(%ebp),%edx
	leal	(%eax,%edx),%eax
	movl	%eax,-24(%ebp)
.Lj108:
	cmpl	$2048,-24(%ebp)
	jl	.Lj107
	jmp	.Lj109
.Lj109:
	cmpl	-20(%ebp),%ebx
	jbe	.Lj104
	jmp	.Lj102
.Lj104:
.Lj98:
# [221] end;
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret	$12

.section .text.n_cdrom_$$_fsreadfile$pchar$pbyte$longword$$longint,"x"
	.balign 16,0x90
.globl	CDROM_$$_FSREADFILE$PCHAR$PBYTE$LONGWORD$$LONGINT
CDROM_$$_FSREADFILE$PCHAR$PBYTE$LONGWORD$$LONGINT:
# [233] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-164(%esp),%esp
	pushl	%ebx
	pushl	%esi
# Var Name located at ebp-4, size=OS_32
# Var Dest located at ebp-8, size=OS_32
# Var MaxSize located at ebp-12, size=OS_32
# Var $result located at ebp-16, size=OS_S32
# Var RootLBA located at ebp-20, size=OS_32
# Var RootSize located at ebp-24, size=OS_32
# Var DirLBA located at ebp-28, size=OS_32
# Var DirSize located at ebp-32, size=OS_32
# Var FileLBA located at ebp-36, size=OS_32
# Var FileSize located at ebp-40, size=OS_32
# Var IsDir located at ebp-44, size=OS_8
# Var Components located at ebp-76, size=OS_NO
# Var NumComp located at ebp-80, size=OS_S32
# Var I located at ebp-84, size=OS_S32
# Var J located at ebp-88, size=OS_S32
# Var N located at ebp-92, size=OS_S32
# Var Len located at ebp-96, size=OS_S32
# Var P located at ebp-100, size=OS_32
# Var NameBuf located at ebp-164, size=OS_NO
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [234] FSReadFile := -1;
	movl	$-1,-16(%ebp)
# [235] if CDBase = 0 then Exit;
	cmpw	$0,TC_$CDROM_$$_CDBASE
	je	.Lj117
	jmp	.Lj118
.Lj117:
	jmp	.Lj115
	.balign 4,0x90
.Lj118:
# [236] if not CDReadSector(16, @PVD[0]) then Exit;
	movl	$U_$CDROM_$$_PVD,%eax
	movl	%eax,%edx
	movl	$16,%eax
	call	CDROM_$$_CDREADSECTOR$LONGWORD$PBYTE$$BOOLEAN
	testb	%al,%al
	je	.Lj119
	jmp	.Lj120
.Lj119:
	jmp	.Lj115
	.balign 4,0x90
.Lj120:
# [237] if PVD[1] <> $43 then Exit;
	cmpb	$67,U_$CDROM_$$_PVD+1
	jne	.Lj121
	jmp	.Lj122
.Lj121:
	jmp	.Lj115
	.balign 4,0x90
.Lj122:
# [238] if PVD[2] <> $44 then Exit;
	cmpb	$68,U_$CDROM_$$_PVD+2
	jne	.Lj123
	jmp	.Lj124
.Lj123:
	jmp	.Lj115
	.balign 4,0x90
.Lj124:
# [239] if PVD[3] <> $30 then Exit;
	cmpb	$48,U_$CDROM_$$_PVD+3
	jne	.Lj125
	jmp	.Lj126
.Lj125:
	jmp	.Lj115
	.balign 4,0x90
.Lj126:
# [240] if PVD[4] <> $30 then Exit;
	cmpb	$48,U_$CDROM_$$_PVD+4
	jne	.Lj127
	jmp	.Lj128
.Lj127:
	jmp	.Lj115
	.balign 4,0x90
.Lj128:
# [241] if PVD[5] <> $31 then Exit;
	cmpb	$49,U_$CDROM_$$_PVD+5
	jne	.Lj129
	jmp	.Lj130
.Lj129:
	jmp	.Lj115
	.balign 4,0x90
.Lj130:
# [242] RootLBA := LongWord(PVD[138]) or (LongWord(PVD[139]) shl 8) or
	movzbl	U_$CDROM_$$_PVD+139,%eax
	shll	$8,%eax
	movzbl	U_$CDROM_$$_PVD+138,%edx
	orl	%edx,%eax
# [243] (LongWord(PVD[140]) shl 16) or (LongWord(PVD[141]) shl 24);
	movzbl	U_$CDROM_$$_PVD+140,%edx
	shll	$16,%edx
	orl	%edx,%eax
	movzbl	U_$CDROM_$$_PVD+141,%edx
	shll	$24,%edx
	orl	%edx,%eax
	movl	%eax,-20(%ebp)
# [244] RootSize := LongWord(PVD[146]) or (LongWord(PVD[147]) shl 8) or
	movzbl	U_$CDROM_$$_PVD+147,%eax
	shll	$8,%eax
	movzbl	U_$CDROM_$$_PVD+146,%edx
	orl	%edx,%eax
# [245] (LongWord(PVD[148]) shl 16) or (LongWord(PVD[149]) shl 24);
	movzbl	U_$CDROM_$$_PVD+148,%edx
	shll	$16,%edx
	orl	%edx,%eax
	movzbl	U_$CDROM_$$_PVD+149,%edx
	shll	$24,%edx
	orl	%edx,%eax
	movl	%eax,-24(%ebp)
# [246] Len := 0;
	movl	$0,-96(%ebp)
# [247] while (Name[Len] <> #0) and (Len < 63) do
	jmp	.Lj132
	.balign 8,0x90
.Lj131:
# [249] NameBuf[Len] := Name[Len];
	movl	-4(%ebp),%edx
	movl	-96(%ebp),%eax
	movl	-96(%ebp),%ecx
	movb	(%edx,%eax,1),%al
	movb	%al,-164(%ebp,%ecx,1)
# [250] Inc(Len);
	addl	$1,-96(%ebp)
.Lj132:
	movl	-4(%ebp),%eax
	movl	-96(%ebp),%edx
	cmpb	$0,(%eax,%edx,1)
	jne	.Lj134
	jmp	.Lj135
.Lj134:
	cmpl	$63,-96(%ebp)
	jl	.Lj136
	jmp	.Lj135
.Lj136:
	jmp	.Lj131
.Lj135:
	jmp	.Lj133
.Lj133:
# [252] NameBuf[Len] := #0;
	movl	-96(%ebp),%eax
	movb	$0,-164(%ebp,%eax,1)
# [253] NumComp := 0;
	movl	$0,-80(%ebp)
# [254] P := @NameBuf[0];
	leal	-164(%ebp),%eax
	movl	%eax,-100(%ebp)
# [255] while (P^ <> #0) and (NumComp < 8) do
	jmp	.Lj138
	.balign 8,0x90
.Lj137:
# [257] Components[NumComp] := P;
	movl	-80(%ebp),%eax
	movl	-100(%ebp),%edx
	movl	%edx,-76(%ebp,%eax,4)
# [258] Inc(NumComp);
	addl	$1,-80(%ebp)
# [259] while (P^ <> #0) and (P^ <> '\') and (P^ <> '/') do Inc(P);
	jmp	.Lj141
	.balign 8,0x90
.Lj140:
	addl	$1,-100(%ebp)
.Lj141:
	movl	-100(%ebp),%eax
	cmpb	$0,(%eax)
	jne	.Lj143
	jmp	.Lj144
.Lj143:
	movl	-100(%ebp),%eax
	cmpb	$92,(%eax)
	jne	.Lj145
	jmp	.Lj144
.Lj145:
	movl	-100(%ebp),%eax
	cmpb	$47,(%eax)
	jne	.Lj146
	jmp	.Lj144
.Lj146:
	jmp	.Lj140
.Lj144:
	jmp	.Lj142
.Lj142:
# [260] if P^ <> #0 then begin P^ := #0; Inc(P); end;
	movl	-100(%ebp),%eax
	cmpb	$0,(%eax)
	jne	.Lj147
	jmp	.Lj148
.Lj147:
	movl	-100(%ebp),%eax
	movb	$0,(%eax)
	addl	$1,-100(%ebp)
	.balign 4,0x90
.Lj148:
.Lj138:
	movl	-100(%ebp),%eax
	cmpb	$0,(%eax)
	jne	.Lj149
	jmp	.Lj150
.Lj149:
	cmpl	$8,-80(%ebp)
	jl	.Lj151
	jmp	.Lj150
.Lj151:
	jmp	.Lj137
.Lj150:
	jmp	.Lj139
.Lj139:
# [262] if NumComp = 0 then Exit;
	cmpl	$0,-80(%ebp)
	je	.Lj152
	jmp	.Lj153
.Lj152:
	jmp	.Lj115
	.balign 4,0x90
.Lj153:
# [263] DirLBA := RootLBA;
	movl	-20(%ebp),%eax
	movl	%eax,-28(%ebp)
# [264] DirSize := RootSize;
	movl	-24(%ebp),%eax
	movl	%eax,-32(%ebp)
# [265] for I := 0 to NumComp - 1 do
	movl	-80(%ebp),%eax
	leal	-1(%eax),%ebx
	cmpl	$0,%ebx
	jge	.Lj154
	jmp	.Lj155
.Lj154:
	movl	$-1,-84(%ebp)
	.balign 8,0x90
.Lj156:
	movl	-84(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-84(%ebp)
# [267] FSLookup(DirLBA, DirSize, Components[I], FileLBA, FileSize, IsDir);
	leal	-36(%ebp),%eax
	pushl	%eax
	leal	-40(%ebp),%eax
	pushl	%eax
	leal	-44(%ebp),%eax
	pushl	%eax
	movl	-84(%ebp),%eax
	movl	-76(%ebp,%eax,4),%ecx
	movl	-32(%ebp),%edx
	movl	-28(%ebp),%eax
	call	CDROM_$$_FSLOOKUP$LONGWORD$LONGWORD$PCHAR$LONGWORD$LONGWORD$BOOLEAN
# [268] if FileLBA = 0 then Exit;
	cmpl	$0,-36(%ebp)
	je	.Lj159
	jmp	.Lj160
.Lj159:
	jmp	.Lj115
	.balign 4,0x90
.Lj160:
# [269] if I < NumComp - 1 then
	movl	-80(%ebp),%eax
	leal	-1(%eax),%eax
	cmpl	-84(%ebp),%eax
	jg	.Lj161
	jmp	.Lj162
.Lj161:
# [271] if not IsDir then Exit;
	cmpb	$0,-44(%ebp)
	je	.Lj163
	jmp	.Lj164
.Lj163:
	jmp	.Lj115
	.balign 4,0x90
.Lj164:
# [272] DirLBA := FileLBA;
	movl	-36(%ebp),%eax
	movl	%eax,-28(%ebp)
# [273] DirSize := FileSize;
	movl	-40(%ebp),%eax
	movl	%eax,-32(%ebp)
	jmp	.Lj165
.Lj162:
# [277] if IsDir then Exit;
	cmpb	$0,-44(%ebp)
	jne	.Lj166
	jmp	.Lj167
.Lj166:
	jmp	.Lj115
	.balign 4,0x90
.Lj167:
# [278] N := LongInt((FileSize + 2047) div 2048);
	movl	-40(%ebp),%eax
	leal	2047(%eax),%eax
	shrl	$11,%eax
	movl	%eax,-92(%ebp)
# [279] if LongWord(N) * 2048 > MaxSize then
	movl	-92(%ebp),%eax
	shll	$11,%eax
	cmpl	-12(%ebp),%eax
	ja	.Lj168
	jmp	.Lj169
.Lj168:
# [280] N := LongInt(MaxSize div 2048);
	movl	-12(%ebp),%eax
	shrl	$11,%eax
	movl	%eax,-92(%ebp)
	.balign 4,0x90
.Lj169:
# [281] for J := 0 to N - 1 do
	movl	-92(%ebp),%eax
	leal	-1(%eax),%esi
	cmpl	$0,%esi
	jge	.Lj170
	jmp	.Lj171
.Lj170:
	movl	$-1,-88(%ebp)
	.balign 8,0x90
.Lj172:
	movl	-88(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-88(%ebp)
# [282] if not CDReadSector(FileLBA + LongWord(J), PByte(PByte(Dest) + J * 2048)) then
	movl	-88(%ebp),%edx
	shll	$11,%edx
	addl	-8(%ebp),%edx
	movl	-36(%ebp),%ecx
	movl	-88(%ebp),%eax
	leal	(%ecx,%eax),%eax
	call	CDROM_$$_CDREADSECTOR$LONGWORD$PBYTE$$BOOLEAN
	testb	%al,%al
	je	.Lj175
	jmp	.Lj176
.Lj175:
# [283] Exit;
	jmp	.Lj115
	.balign 4,0x90
.Lj176:
	cmpl	-88(%ebp),%esi
	jle	.Lj174
	jmp	.Lj172
.Lj174:
	.balign 4,0x90
.Lj171:
# [284] FSReadFile := LongInt(FileSize);
	movl	-40(%ebp),%eax
	movl	%eax,-16(%ebp)
# [285] Exit;
	jmp	.Lj115
.Lj165:
	cmpl	-84(%ebp),%ebx
	jle	.Lj158
	jmp	.Lj156
.Lj158:
	.balign 4,0x90
.Lj155:
.Lj115:
# [288] end;
	movl	-16(%ebp),%eax
	popl	%esi
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_cdrom_$$_fslistdir$pchar$pbyte$longint$$longint,"x"
	.balign 16,0x90
.globl	CDROM_$$_FSLISTDIR$PCHAR$PBYTE$LONGINT$$LONGINT
CDROM_$$_FSLISTDIR$PCHAR$PBYTE$LONGINT$$LONGINT:
# [305] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-188(%esp),%esp
	pushl	%ebx
	pushl	%esi
	pushl	%edi
# Var Name located at ebp-4, size=OS_32
# Var Dest located at ebp-8, size=OS_32
# Var MaxBytes located at ebp-12, size=OS_S32
# Var $result located at ebp-16, size=OS_S32
# Var RootLBA located at ebp-20, size=OS_32
# Var RootSize located at ebp-24, size=OS_32
# Var DirLBA located at ebp-28, size=OS_32
# Var DirSize located at ebp-32, size=OS_32
# Var FileLBA located at ebp-36, size=OS_32
# Var FileSize located at ebp-40, size=OS_32
# Var IsDir located at ebp-44, size=OS_8
# Var Components located at ebp-76, size=OS_NO
# Var NumComp located at ebp-80, size=OS_S32
# Var I located at ebp-84, size=OS_S32
# Var J located at ebp-88, size=OS_S32
# Var N located at ebp-92, size=OS_S32
# Var Len located at ebp-96, size=OS_S32
# Var P located at ebp-100, size=OS_32
# Var NameBuf located at ebp-164, size=OS_NO
# Var SecCount located at ebp-168, size=OS_32
# Var S located at ebp-172, size=OS_32
# Var OutPoz located at ebp-176, size=OS_32
# Var Count located at ebp-180, size=OS_S32
# Var ObjLen located at ebp-184, size=OS_S32
# Var NameLen located at ebp-188, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [306] FSListDir := 0;
	movl	$0,-16(%ebp)
# [307] if CDBase = 0 then Exit;
	cmpw	$0,TC_$CDROM_$$_CDBASE
	je	.Lj179
	jmp	.Lj180
.Lj179:
	jmp	.Lj177
	.balign 4,0x90
.Lj180:
# [308] if not CDReadSector(16, @PVD[0]) then Exit;
	movl	$U_$CDROM_$$_PVD,%eax
	movl	%eax,%edx
	movl	$16,%eax
	call	CDROM_$$_CDREADSECTOR$LONGWORD$PBYTE$$BOOLEAN
	testb	%al,%al
	je	.Lj181
	jmp	.Lj182
.Lj181:
	jmp	.Lj177
	.balign 4,0x90
.Lj182:
# [309] if PVD[1] <> $43 then Exit;
	cmpb	$67,U_$CDROM_$$_PVD+1
	jne	.Lj183
	jmp	.Lj184
.Lj183:
	jmp	.Lj177
	.balign 4,0x90
.Lj184:
# [310] if PVD[2] <> $44 then Exit;
	cmpb	$68,U_$CDROM_$$_PVD+2
	jne	.Lj185
	jmp	.Lj186
.Lj185:
	jmp	.Lj177
	.balign 4,0x90
.Lj186:
# [311] if PVD[3] <> $30 then Exit;
	cmpb	$48,U_$CDROM_$$_PVD+3
	jne	.Lj187
	jmp	.Lj188
.Lj187:
	jmp	.Lj177
	.balign 4,0x90
.Lj188:
# [312] if PVD[4] <> $30 then Exit;
	cmpb	$48,U_$CDROM_$$_PVD+4
	jne	.Lj189
	jmp	.Lj190
.Lj189:
	jmp	.Lj177
	.balign 4,0x90
.Lj190:
# [313] if PVD[5] <> $31 then Exit;
	cmpb	$49,U_$CDROM_$$_PVD+5
	jne	.Lj191
	jmp	.Lj192
.Lj191:
	jmp	.Lj177
	.balign 4,0x90
.Lj192:
# [314] RootLBA := LongWord(PVD[138]) or (LongWord(PVD[139]) shl 8) or
	movzbl	U_$CDROM_$$_PVD+139,%eax
	shll	$8,%eax
	movzbl	U_$CDROM_$$_PVD+138,%edx
	orl	%edx,%eax
# [315] (LongWord(PVD[140]) shl 16) or (LongWord(PVD[141]) shl 24);
	movzbl	U_$CDROM_$$_PVD+140,%edx
	shll	$16,%edx
	orl	%edx,%eax
	movzbl	U_$CDROM_$$_PVD+141,%edx
	shll	$24,%edx
	orl	%edx,%eax
	movl	%eax,-20(%ebp)
# [316] RootSize := LongWord(PVD[146]) or (LongWord(PVD[147]) shl 8) or
	movzbl	U_$CDROM_$$_PVD+147,%eax
	shll	$8,%eax
	movzbl	U_$CDROM_$$_PVD+146,%edx
	orl	%edx,%eax
# [317] (LongWord(PVD[148]) shl 16) or (LongWord(PVD[149]) shl 24);
	movzbl	U_$CDROM_$$_PVD+148,%edx
	shll	$16,%edx
	orl	%edx,%eax
	movzbl	U_$CDROM_$$_PVD+149,%edx
	shll	$24,%edx
	orl	%edx,%eax
	movl	%eax,-24(%ebp)
# [318] Len := 0;
	movl	$0,-96(%ebp)
# [319] while (Name[Len] <> #0) and (Len < 63) do
	jmp	.Lj194
	.balign 8,0x90
.Lj193:
# [321] NameBuf[Len] := Name[Len];
	movl	-4(%ebp),%eax
	movl	-96(%ebp),%edx
	movl	-96(%ebp),%ecx
	movb	(%eax,%edx,1),%al
	movb	%al,-164(%ebp,%ecx,1)
# [322] Inc(Len);
	addl	$1,-96(%ebp)
.Lj194:
	movl	-4(%ebp),%eax
	movl	-96(%ebp),%edx
	cmpb	$0,(%eax,%edx,1)
	jne	.Lj196
	jmp	.Lj197
.Lj196:
	cmpl	$63,-96(%ebp)
	jl	.Lj198
	jmp	.Lj197
.Lj198:
	jmp	.Lj193
.Lj197:
	jmp	.Lj195
.Lj195:
# [324] NameBuf[Len] := #0;
	movl	-96(%ebp),%eax
	movb	$0,-164(%ebp,%eax,1)
# [325] NumComp := 0;
	movl	$0,-80(%ebp)
# [326] P := @NameBuf[0];
	leal	-164(%ebp),%eax
	movl	%eax,-100(%ebp)
# [327] while (P^ <> #0) and (NumComp < 8) do
	jmp	.Lj200
	.balign 8,0x90
.Lj199:
# [329] Components[NumComp] := P;
	movl	-80(%ebp),%eax
	movl	-100(%ebp),%edx
	movl	%edx,-76(%ebp,%eax,4)
# [330] Inc(NumComp);
	addl	$1,-80(%ebp)
# [331] while (P^ <> #0) and (P^ <> '\') and (P^ <> '/') do Inc(P);
	jmp	.Lj203
	.balign 8,0x90
.Lj202:
	addl	$1,-100(%ebp)
.Lj203:
	movl	-100(%ebp),%eax
	cmpb	$0,(%eax)
	jne	.Lj205
	jmp	.Lj206
.Lj205:
	movl	-100(%ebp),%eax
	cmpb	$92,(%eax)
	jne	.Lj207
	jmp	.Lj206
.Lj207:
	movl	-100(%ebp),%eax
	cmpb	$47,(%eax)
	jne	.Lj208
	jmp	.Lj206
.Lj208:
	jmp	.Lj202
.Lj206:
	jmp	.Lj204
.Lj204:
# [332] if P^ <> #0 then begin P^ := #0; Inc(P); end;
	movl	-100(%ebp),%eax
	cmpb	$0,(%eax)
	jne	.Lj209
	jmp	.Lj210
.Lj209:
	movl	-100(%ebp),%eax
	movb	$0,(%eax)
	addl	$1,-100(%ebp)
	.balign 4,0x90
.Lj210:
.Lj200:
	movl	-100(%ebp),%eax
	cmpb	$0,(%eax)
	jne	.Lj211
	jmp	.Lj212
.Lj211:
	cmpl	$8,-80(%ebp)
	jl	.Lj213
	jmp	.Lj212
.Lj213:
	jmp	.Lj199
.Lj212:
	jmp	.Lj201
.Lj201:
# [334] if NumComp = 0 then Exit;
	cmpl	$0,-80(%ebp)
	je	.Lj214
	jmp	.Lj215
.Lj214:
	jmp	.Lj177
	.balign 4,0x90
.Lj215:
# [335] DirLBA := RootLBA;
	movl	-20(%ebp),%eax
	movl	%eax,-28(%ebp)
# [336] DirSize := RootSize;
	movl	-24(%ebp),%eax
	movl	%eax,-32(%ebp)
# [337] for I := 0 to NumComp - 1 do
	movl	-80(%ebp),%eax
	leal	-1(%eax),%ebx
	cmpl	$0,%ebx
	jge	.Lj216
	jmp	.Lj217
.Lj216:
	movl	$-1,-84(%ebp)
	.balign 8,0x90
.Lj218:
	movl	-84(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-84(%ebp)
# [339] FSLookup(DirLBA, DirSize, Components[I], FileLBA, FileSize, IsDir);
	leal	-36(%ebp),%eax
	pushl	%eax
	leal	-40(%ebp),%eax
	pushl	%eax
	leal	-44(%ebp),%eax
	pushl	%eax
	movl	-84(%ebp),%eax
	movl	-76(%ebp,%eax,4),%ecx
	movl	-32(%ebp),%edx
	movl	-28(%ebp),%eax
	call	CDROM_$$_FSLOOKUP$LONGWORD$LONGWORD$PCHAR$LONGWORD$LONGWORD$BOOLEAN
# [340] if FileLBA = 0 then Exit;
	cmpl	$0,-36(%ebp)
	je	.Lj221
	jmp	.Lj222
.Lj221:
	jmp	.Lj177
	.balign 4,0x90
.Lj222:
# [341] if I < NumComp - 1 then
	movl	-80(%ebp),%eax
	leal	-1(%eax),%eax
	cmpl	-84(%ebp),%eax
	jg	.Lj223
	jmp	.Lj224
.Lj223:
# [343] if not IsDir then Exit;
	cmpb	$0,-44(%ebp)
	je	.Lj225
	jmp	.Lj226
.Lj225:
	jmp	.Lj177
	.balign 4,0x90
.Lj226:
# [344] DirLBA := FileLBA;
	movl	-36(%ebp),%eax
	movl	%eax,-28(%ebp)
# [345] DirSize := FileSize;
	movl	-40(%ebp),%eax
	movl	%eax,-32(%ebp)
	jmp	.Lj227
.Lj224:
# [349] if not IsDir then Exit;
	cmpb	$0,-44(%ebp)
	je	.Lj228
	jmp	.Lj229
.Lj228:
	jmp	.Lj177
	.balign 4,0x90
.Lj229:
# [350] DirLBA := FileLBA;
	movl	-36(%ebp),%eax
	movl	%eax,-28(%ebp)
# [351] DirSize := FileSize;
	movl	-40(%ebp),%eax
	movl	%eax,-32(%ebp)
.Lj227:
	cmpl	-84(%ebp),%ebx
	jle	.Lj220
	jmp	.Lj218
.Lj220:
	.balign 4,0x90
.Lj217:
# [354] Count := 0;
	movl	$0,-180(%ebp)
# [355] OutPoz := 0;
	movl	$0,-176(%ebp)
# [356] SecCount := (DirSize + 2047) div 2048;
	movl	-32(%ebp),%eax
	leal	2047(%eax),%eax
	shrl	$11,%eax
	movl	%eax,-168(%ebp)
# [357] if SecCount > 16 then SecCount := 16;
	cmpl	$16,-168(%ebp)
	ja	.Lj230
	jmp	.Lj231
.Lj230:
	movl	$16,-168(%ebp)
	.balign 4,0x90
.Lj231:
# [358] for S := 0 to SecCount - 1 do
	movl	-168(%ebp),%eax
	leal	-1(%eax),%ebx
	movl	$-1,-172(%ebp)
	.balign 8,0x90
.Lj232:
	movl	-172(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-172(%ebp)
# [360] if not CDReadSector(DirLBA + S, @DirBuf[0]) then Exit;
	movl	-28(%ebp),%edx
	movl	-172(%ebp),%eax
	leal	(%edx,%eax),%eax
	movl	$U_$CDROM_$$_DIRBUF,%edx
	call	CDROM_$$_CDREADSECTOR$LONGWORD$PBYTE$$BOOLEAN
	testb	%al,%al
	je	.Lj235
	jmp	.Lj236
.Lj235:
	jmp	.Lj177
	.balign 4,0x90
.Lj236:
# [361] N := 0;
	movl	$0,-92(%ebp)
# [362] while N < 2048 do
	jmp	.Lj238
	.balign 8,0x90
.Lj237:
# [364] ObjLen := DirBuf[N];
	movl	-92(%ebp),%eax
	movzbl	U_$CDROM_$$_DIRBUF(,%eax,1),%eax
	movl	%eax,-184(%ebp)
# [365] if ObjLen = 0 then Break;
	cmpl	$0,-184(%ebp)
	je	.Lj240
	jmp	.Lj241
.Lj240:
	jmp	.Lj239
	.balign 4,0x90
.Lj241:
# [366] NameLen := DirBuf[N + 32];
	movl	-92(%ebp),%eax
	leal	32(%eax),%eax
	movzbl	U_$CDROM_$$_DIRBUF(,%eax,1),%eax
	movl	%eax,-188(%ebp)
# [367] IsDir := (DirBuf[N + 25] and 2) <> 0;
	movl	-92(%ebp),%eax
	leal	25(%eax),%eax
	movzbw	U_$CDROM_$$_DIRBUF(,%eax,1),%ax
	andw	$2,%ax
	testw	$-1,%ax
	setneb	-44(%ebp)
# [368] if (not IsDir) and (NameLen > 0) then
	cmpb	$0,-44(%ebp)
	je	.Lj242
	jmp	.Lj243
.Lj242:
	cmpl	$0,-188(%ebp)
	jg	.Lj244
	jmp	.Lj243
.Lj244:
# [370] if OutPoz + LongWord(NameLen) + 1 <= LongWord(MaxBytes) then
	movl	-176(%ebp),%eax
	movl	-188(%ebp),%edx
	leal	(%eax,%edx),%eax
	leal	1(%eax),%eax
	cmpl	-12(%ebp),%eax
	jbe	.Lj245
	jmp	.Lj246
.Lj245:
# [372] for J := 0 to NameLen - 1 do
	movl	-188(%ebp),%eax
	leal	-1(%eax),%eax
	cmpl	$0,%eax
	jge	.Lj247
	jmp	.Lj248
.Lj247:
	movl	$-1,-88(%ebp)
	.balign 8,0x90
.Lj249:
	movl	-88(%ebp),%edx
	leal	1(%edx),%edx
	movl	%edx,-88(%ebp)
# [373] Dest[OutPoz + LongWord(J)] := DirBuf[N + 33 + J];
	movl	-92(%ebp),%edx
	leal	33(%edx),%esi
	addl	-88(%ebp),%esi
	movl	-8(%ebp),%ecx
	movl	-176(%ebp),%edx
	movl	-88(%ebp),%edi
	leal	(%edx,%edi),%edi
	movb	U_$CDROM_$$_DIRBUF(,%esi,1),%dl
	movb	%dl,(%ecx,%edi,1)
	cmpl	-88(%ebp),%eax
	jle	.Lj251
	jmp	.Lj249
.Lj251:
	.balign 4,0x90
.Lj248:
# [374] Dest[OutPoz + LongWord(NameLen)] := 0;
	movl	-8(%ebp),%ecx
	movl	-176(%ebp),%eax
	movl	-188(%ebp),%edx
	leal	(%eax,%edx),%eax
	movb	$0,(%ecx,%eax,1)
# [375] OutPoz := OutPoz + LongWord(NameLen) + 1;
	movl	-176(%ebp),%edx
	movl	-188(%ebp),%eax
	leal	(%edx,%eax),%eax
	leal	1(%eax),%eax
	movl	%eax,-176(%ebp)
# [376] Inc(Count);
	addl	$1,-180(%ebp)
	.balign 4,0x90
.Lj246:
	.balign 4,0x90
.Lj243:
# [379] N := N + ObjLen;
	movl	-92(%ebp),%eax
	movl	-184(%ebp),%edx
	leal	(%eax,%edx),%eax
	movl	%eax,-92(%ebp)
.Lj238:
	cmpl	$2048,-92(%ebp)
	jl	.Lj237
	jmp	.Lj239
.Lj239:
	cmpl	-172(%ebp),%ebx
	jbe	.Lj234
	jmp	.Lj232
.Lj234:
# [382] FSListDir := Count;
	movl	-180(%ebp),%eax
	movl	%eax,-16(%ebp)
.Lj177:
# [383] end;
	movl	-16(%ebp),%eax
	popl	%edi
	popl	%esi
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_cdrom_$$_cdselftest,"x"
	.balign 16,0x90
.globl	CDROM_$$_CDSELFTEST
CDROM_$$_CDSELFTEST:
# [390] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-12(%esp),%esp
	pushl	%ebx
# Var N located at ebp-4, size=OS_S32
# Var I located at ebp-8, size=OS_S32
# Var Max located at ebp-12, size=OS_S32
# [391] CDInit;
	call	CDROM_$$_CDINIT
# [392] if CDBase = 0 then
	cmpw	$0,TC_$CDROM_$$_CDBASE
	je	.Lj254
	jmp	.Lj255
.Lj254:
# [394] SerialWriteString('cd=none');
	movl	$_$CDROM$_Ld1,%eax
	call	SERIAL_$$_SERIALWRITESTRING$PCHAR
# [395] SerialWriteChar(#13);
	movb	$13,%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
# [396] SerialWriteChar(#10);
	movb	$10,%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
# [397] Exit;
	jmp	.Lj252
	.balign 4,0x90
.Lj255:
# [399] N := FSReadFile('ABOUT.TXT', @FileBuf[0], SizeOf(FileBuf));
	movl	$U_$CDROM_$$_FILEBUF,%edx
	movl	$16384,%ecx
	movl	$_$CDROM$_Ld2,%eax
	call	CDROM_$$_FSREADFILE$PCHAR$PBYTE$LONGWORD$$LONGINT
	movl	%eax,-4(%ebp)
# [400] SerialWriteString('cd=ok ');
	movl	$_$CDROM$_Ld3,%eax
	call	SERIAL_$$_SERIALWRITESTRING$PCHAR
# [401] SerialWriteHex32(LongWord(CDBase));
	movzwl	TC_$CDROM_$$_CDBASE,%eax
	call	SERIAL_$$_SERIALWRITEHEX32$LONGWORD
# [402] SerialWriteChar(' ');
	movb	$32,%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
# [403] if N < 0 then
	cmpl	$0,-4(%ebp)
	jl	.Lj256
	jmp	.Lj257
.Lj256:
# [404] SerialWriteString('ABOUT.TXT:not found')
	movl	$_$CDROM$_Ld4,%eax
	call	SERIAL_$$_SERIALWRITESTRING$PCHAR
	jmp	.Lj258
.Lj257:
# [407] SerialWriteHex32(LongWord(N));
	movl	-4(%ebp),%eax
	call	SERIAL_$$_SERIALWRITEHEX32$LONGWORD
# [408] SerialWriteChar(' ');
	movb	$32,%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
# [409] Max := SizeOf(FileBuf);
	movl	$16384,-12(%ebp)
# [410] if N > Max then
	movl	-4(%ebp),%eax
	cmpl	-12(%ebp),%eax
	jg	.Lj259
	jmp	.Lj260
.Lj259:
# [411] N := Max;
	movl	-12(%ebp),%eax
	movl	%eax,-4(%ebp)
	.balign 4,0x90
.Lj260:
# [412] for I := 0 to N - 1 do
	movl	-4(%ebp),%eax
	leal	-1(%eax),%ebx
	cmpl	$0,%ebx
	jge	.Lj261
	jmp	.Lj262
.Lj261:
	movl	$-1,-8(%ebp)
	.balign 8,0x90
.Lj263:
	movl	-8(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-8(%ebp)
# [413] SerialWriteChar(Chr(FileBuf[I]));
	movl	-8(%ebp),%eax
	movb	U_$CDROM_$$_FILEBUF(,%eax,1),%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
	cmpl	-8(%ebp),%ebx
	jle	.Lj265
	jmp	.Lj263
.Lj265:
	.balign 4,0x90
.Lj262:
.Lj258:
# [415] SerialWriteChar(#13);
	movb	$13,%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
# [416] SerialWriteChar(#10);
	movb	$10,%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
.Lj252:
# [417] end;
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret
# End asmlist al_procedures
# Begin asmlist al_globals

.section .bss
# [24] PVD: array[0..2047] of Byte;
U_$CDROM_$$_PVD:
	.zero 2048

.section .bss
# [25] FileBuf: array[0..16383] of Byte;
U_$CDROM_$$_FILEBUF:
	.zero 16384

.section .bss
# [26] DirBuf: array[0..2047] of Byte;
U_$CDROM_$$_DIRBUF:
	.zero 2048
# End asmlist al_globals
# Begin asmlist al_typedconsts

.section .data.n_TC_$CDROM_$$_CDBASE,"d"
	.balign 2
TC_$CDROM_$$_CDBASE:
	.short	0
# [23] CDDrive: Byte = 0;

.section .data.n_TC_$CDROM_$$_CDDRIVE,"d"
TC_$CDROM_$$_CDDRIVE:
	.byte	0

.section .rodata.n__$CDROM$_Ld1,"d"
	.balign 4
.globl	_$CDROM$_Ld1
_$CDROM$_Ld1:
	.ascii	"cd=none\000"

.section .rodata.n__$CDROM$_Ld2,"d"
	.balign 4
.globl	_$CDROM$_Ld2
_$CDROM$_Ld2:
	.ascii	"ABOUT.TXT\000"

.section .rodata.n__$CDROM$_Ld3,"d"
	.balign 4
.globl	_$CDROM$_Ld3
_$CDROM$_Ld3:
	.ascii	"cd=ok \000"

.section .rodata.n__$CDROM$_Ld4,"d"
	.balign 4
.globl	_$CDROM$_Ld4
_$CDROM$_Ld4:
	.ascii	"ABOUT.TXT:not found\000"
# End asmlist al_typedconsts

