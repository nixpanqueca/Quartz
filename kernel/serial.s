	.file "serial.pas"
# Begin asmlist al_procedures

.section .text.n_serial_$$_outb$word$byte,"x"
	.balign 16,0x90
SERIAL_$$_OUTB$WORD$BYTE:
# [serial.pas]
# [20] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var Addr located at ebp-4, size=OS_16
# Var Value located at ebp-8, size=OS_8
	movw	%ax,-4(%ebp)
	movb	%dl,-8(%ebp)
#  CPU PENTIUM
# [22] mov dx, Addr
	movw	-4(%ebp),%dx
# [23] mov al, Value
	movb	-8(%ebp),%al
# [24] out dx, al
	outb	%al,%dx
#  CPU PENTIUM
# [26] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_serial_$$_inb$word$$byte,"x"
	.balign 16,0x90
SERIAL_$$_INB$WORD$$BYTE:
# [31] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-12(%esp),%esp
# Var Addr located at ebp-4, size=OS_16
# Var $result located at ebp-8, size=OS_8
# Var B located at ebp-12, size=OS_8
	movw	%ax,-4(%ebp)
#  CPU PENTIUM
# [33] mov dx, Addr
	movw	-4(%ebp),%dx
# [34] in al, dx
	inb	%dx,%al
# [35] mov B, al
	movb	%al,-12(%ebp)
#  CPU PENTIUM
# [37] InB := B;
	movb	-12(%ebp),%al
	movb	%al,-8(%ebp)
# [38] end;
	movb	-8(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_serial_$$_serialinit,"x"
	.balign 16,0x90
.globl	SERIAL_$$_SERIALINIT
SERIAL_$$_SERIALINIT:
# [41] begin
	pushl	%ebp
	movl	%esp,%ebp
# [42] OutB(COM1 + 1, $00);    // sem interrupcoes
	movb	$0,%dl
	movw	$1017,%ax
	call	SERIAL_$$_OUTB$WORD$BYTE
# [43] OutB(COM1 + 3, $80);    // DLAB = 1
	movb	$128,%dl
	movw	$1019,%ax
	call	SERIAL_$$_OUTB$WORD$BYTE
# [44] OutB(COM1,     $03);    // divisor baixo (38400 baud)
	movb	$3,%dl
	movw	$1016,%ax
	call	SERIAL_$$_OUTB$WORD$BYTE
# [45] OutB(COM1 + 1, $00);    // divisor alto
	movb	$0,%dl
	movw	$1017,%ax
	call	SERIAL_$$_OUTB$WORD$BYTE
# [46] OutB(COM1 + 3, $03);    // 8N1, DLAB = 0
	movb	$3,%dl
	movw	$1019,%ax
	call	SERIAL_$$_OUTB$WORD$BYTE
# [47] OutB(COM1 + 2, $C7);    // FIFO enable, clear, 14 bytes
	movb	$199,%dl
	movw	$1018,%ax
	call	SERIAL_$$_OUTB$WORD$BYTE
# [48] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_serial_$$_serialwritechar$char,"x"
	.balign 16,0x90
.globl	SERIAL_$$_SERIALWRITECHAR$CHAR
SERIAL_$$_SERIALWRITECHAR$CHAR:
# [53] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var C located at ebp-4, size=OS_8
# Var i located at ebp-8, size=OS_S32
	movb	%al,-4(%ebp)
# [54] i := 0;
	movl	$0,-8(%ebp)
# [55] while ((InB(COM1 + 5) and $20) = 0) and (i < 100000) do
	jmp	.Lj12
	.balign 8,0x90
.Lj11:
# [56] Inc(i);
	addl	$1,-8(%ebp)
.Lj12:
	movw	$1021,%ax
	call	SERIAL_$$_INB$WORD$$BYTE
	movzbw	%al,%ax
	andw	$32,%ax
	testw	$-1,%ax
	je	.Lj14
	jmp	.Lj15
.Lj14:
	cmpl	$100000,-8(%ebp)
	jl	.Lj16
	jmp	.Lj15
.Lj16:
	jmp	.Lj11
.Lj15:
	jmp	.Lj13
.Lj13:
# [57] OutB(COM1, Ord(C));
	movb	-4(%ebp),%dl
	movw	$1016,%ax
	call	SERIAL_$$_OUTB$WORD$BYTE
# [58] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_serial_$$_serialwritestring$pchar,"x"
	.balign 16,0x90
.globl	SERIAL_$$_SERIALWRITESTRING$PCHAR
SERIAL_$$_SERIALWRITESTRING$PCHAR:
# [61] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-4(%esp),%esp
# Var S located at ebp-4, size=OS_32
	movl	%eax,-4(%ebp)
# [62] while S^ <> #0 do
	jmp	.Lj20
	.balign 8,0x90
.Lj19:
# [64] SerialWriteChar(S^);
	movl	-4(%ebp),%eax
	movb	(%eax),%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
# [65] Inc(S);
	addl	$1,-4(%ebp)
.Lj20:
	movl	-4(%ebp),%eax
	cmpb	$0,(%eax)
	jne	.Lj19
	jmp	.Lj21
.Lj21:
# [67] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_serial_$$_serialwritehex32$longword,"x"
	.balign 16,0x90
.globl	SERIAL_$$_SERIALWRITEHEX32$LONGWORD
SERIAL_$$_SERIALWRITEHEX32$LONGWORD:
# [73] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-12(%esp),%esp
# Var V located at ebp-4, size=OS_32
# Var i located at ebp-8, size=OS_S32
# Var Digit located at ebp-12, size=OS_8
	movl	%eax,-4(%ebp)
# [74] for i := 7 downto 0 do
	movl	$8,-8(%ebp)
	.balign 8,0x90
.Lj24:
	movl	-8(%ebp),%eax
	leal	-1(%eax),%eax
	movl	%eax,-8(%ebp)
# [76] Digit := Chr($30 + ((V shr (i * 4)) and $F));
	movl	-8(%ebp),%ecx
	shll	$2,%ecx
	movl	-4(%ebp),%eax
	shrl	%cl,%eax
	andl	$15,%eax
	leal	48(%eax),%eax
	movb	%al,-12(%ebp)
# [77] if Digit > '9' then
	cmpb	$57,-12(%ebp)
	ja	.Lj27
	jmp	.Lj28
.Lj27:
# [78] Digit := Chr(Ord(Digit) + 7);
	movzbl	-12(%ebp),%eax
	leal	7(%eax),%eax
	movb	%al,-12(%ebp)
	.balign 4,0x90
.Lj28:
# [79] SerialWriteChar(Digit);
	movb	-12(%ebp),%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
	cmpl	$0,-8(%ebp)
	jle	.Lj26
	jmp	.Lj24
.Lj26:
# [81] end;
	movl	%ebp,%esp
	popl	%ebp
	ret
# End asmlist al_procedures

