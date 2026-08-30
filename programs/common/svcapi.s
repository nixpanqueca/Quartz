	.file "svcapi.pas"
# Begin asmlist al_procedures

.section .text.n_svcapi_$$_svcproc$longint$$pointer,"x"
	.balign 16,0x90
SVCAPI_$$_SVCPROC$LONGINT$$POINTER:
# [svcapi.pas]
# [36] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var Index located at ebp-4, size=OS_S32
# Var $result located at ebp-8, size=OS_32
	movl	%eax,-4(%ebp)
# [37] SvcProc := Pointer(PLongWord(PByte(SERVICE_TABLE_ADDR) + Index * 4)^);
	movl	-4(%ebp),%eax
	shll	$2,%eax
	leal	393216(%eax),%eax
	movl	(%eax),%eax
	movl	%eax,-8(%ebp)
# [38] end;
	movl	-8(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_svcapi_$$_clearscreen$byte,"x"
	.balign 16,0x90
.globl	SVCAPI_$$_CLEARSCREEN$BYTE
SVCAPI_$$_CLEARSCREEN$BYTE:
# [59] begin P := TProcClear(SvcProc(SVC_CLEARSCREEN)); P(Color); end;
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var Color located at ebp-4, size=OS_8
# Var P located at ebp-8, size=OS_32
	movb	%al,-4(%ebp)
	movl	$1,%eax
	call	SVCAPI_$$_SVCPROC$LONGINT$$POINTER
	movl	%eax,-8(%ebp)
	movb	-4(%ebp),%al
	call	*-8(%ebp)
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_svcapi_$$_writeat$longint$longint$pchar$longint,"x"
	.balign 16,0x90
.globl	SVCAPI_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
SVCAPI_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT:
# [63] begin P := TProcWrite(SvcProc(SVC_WRITEAT)); P(X, Y, Text, Size); end;
	pushl	%ebp
	movl	%esp,%ebp
	leal	-16(%esp),%esp
# Var X located at ebp-4, size=OS_S32
# Var Y located at ebp-8, size=OS_S32
# Var Text located at ebp-12, size=OS_32
# Var Size located at ebp+8, size=OS_S32
# Var P located at ebp-16, size=OS_32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
	movl	$2,%eax
	call	SVCAPI_$$_SVCPROC$LONGINT$$POINTER
	movl	%eax,-16(%ebp)
	pushl	8(%ebp)
	movl	-12(%ebp),%ecx
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	call	*-16(%ebp)
	movl	%ebp,%esp
	popl	%ebp
	ret	$4

.section .text.n_svcapi_$$_writeatcol$longint$longint$pchar$longint$byte,"x"
	.balign 16,0x90
.globl	SVCAPI_$$_WRITEATCOL$LONGINT$LONGINT$PCHAR$LONGINT$BYTE
SVCAPI_$$_WRITEATCOL$LONGINT$LONGINT$PCHAR$LONGINT$BYTE:
# [67] begin P := TProcWriteC(SvcProc(SVC_WRITEATCOL)); P(X, Y, Text, Size, Color); end;
	pushl	%ebp
	movl	%esp,%ebp
	leal	-16(%esp),%esp
# Var X located at ebp-4, size=OS_S32
# Var Y located at ebp-8, size=OS_S32
# Var Text located at ebp-12, size=OS_32
# Var Size located at ebp+12, size=OS_S32
# Var Color located at ebp+8, size=OS_8
# Var P located at ebp-16, size=OS_32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
	movl	$3,%eax
	call	SVCAPI_$$_SVCPROC$LONGINT$$POINTER
	movl	%eax,-16(%ebp)
	pushl	12(%ebp)
	movzbl	8(%ebp),%eax
	pushl	%eax
	movl	-12(%ebp),%ecx
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	call	*-16(%ebp)
	movl	%ebp,%esp
	popl	%ebp
	ret	$8

.section .text.n_svcapi_$$_fillrect$longint$longint$longint$longint$byte,"x"
	.balign 16,0x90
.globl	SVCAPI_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
SVCAPI_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE:
# [71] begin P := TProcFill(SvcProc(SVC_FILLRECT)); P(X, Y, W, H, Color); end;
	pushl	%ebp
	movl	%esp,%ebp
	leal	-16(%esp),%esp
# Var X located at ebp-4, size=OS_S32
# Var Y located at ebp-8, size=OS_S32
# Var W located at ebp-12, size=OS_S32
# Var H located at ebp+12, size=OS_S32
# Var Color located at ebp+8, size=OS_8
# Var P located at ebp-16, size=OS_32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
	movl	$4,%eax
	call	SVCAPI_$$_SVCPROC$LONGINT$$POINTER
	movl	%eax,-16(%ebp)
	pushl	12(%ebp)
	movzbl	8(%ebp),%eax
	pushl	%eax
	movl	-12(%ebp),%ecx
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	call	*-16(%ebp)
	movl	%ebp,%esp
	popl	%ebp
	ret	$8

.section .text.n_svcapi_$$_putpixel$longint$longint$byte,"x"
	.balign 16,0x90
.globl	SVCAPI_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
SVCAPI_$$_PUTPIXEL$LONGINT$LONGINT$BYTE:
# [75] begin P := TProcPix(SvcProc(SVC_PUTPIXEL)); P(X, Y, Color); end;
	pushl	%ebp
	movl	%esp,%ebp
	leal	-16(%esp),%esp
# Var X located at ebp-4, size=OS_S32
# Var Y located at ebp-8, size=OS_S32
# Var Color located at ebp-12, size=OS_8
# Var P located at ebp-16, size=OS_32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movb	%cl,-12(%ebp)
	movl	$5,%eax
	call	SVCAPI_$$_SVCPROC$LONGINT$$POINTER
	movl	%eax,-16(%ebp)
	movb	-12(%ebp),%cl
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	call	*-16(%ebp)
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_svcapi_$$_drawline$longint$longint$longint$longint$byte,"x"
	.balign 16,0x90
.globl	SVCAPI_$$_DRAWLINE$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
SVCAPI_$$_DRAWLINE$LONGINT$LONGINT$LONGINT$LONGINT$BYTE:
# [79] begin P := TProcLine(SvcProc(SVC_DRAWLINE)); P(X0, Y0, X1, Y1, Color); end;
	pushl	%ebp
	movl	%esp,%ebp
	leal	-16(%esp),%esp
# Var X0 located at ebp-4, size=OS_S32
# Var Y0 located at ebp-8, size=OS_S32
# Var X1 located at ebp-12, size=OS_S32
# Var Y1 located at ebp+12, size=OS_S32
# Var Color located at ebp+8, size=OS_8
# Var P located at ebp-16, size=OS_32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
	movl	$6,%eax
	call	SVCAPI_$$_SVCPROC$LONGINT$$POINTER
	movl	%eax,-16(%ebp)
	pushl	12(%ebp)
	movzbl	8(%ebp),%eax
	pushl	%eax
	movl	-12(%ebp),%ecx
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	call	*-16(%ebp)
	movl	%ebp,%esp
	popl	%ebp
	ret	$8

.section .text.n_svcapi_$$_delayms$longint,"x"
	.balign 16,0x90
.globl	SVCAPI_$$_DELAYMS$LONGINT
SVCAPI_$$_DELAYMS$LONGINT:
# [83] begin P := TProcDelay(SvcProc(SVC_DELAYMS)); P(Millis); end;
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var Millis located at ebp-4, size=OS_S32
# Var P located at ebp-8, size=OS_32
	movl	%eax,-4(%ebp)
	movl	$7,%eax
	call	SVCAPI_$$_SVCPROC$LONGINT$$POINTER
	movl	%eax,-8(%ebp)
	movl	-4(%ebp),%eax
	call	*-8(%ebp)
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_svcapi_$$_serialwritestring$pchar,"x"
	.balign 16,0x90
.globl	SVCAPI_$$_SERIALWRITESTRING$PCHAR
SVCAPI_$$_SERIALWRITESTRING$PCHAR:
# [87] begin P := TProcSStr(SvcProc(SVC_SERIALSTR)); P(S); end;
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var S located at ebp-4, size=OS_32
# Var P located at ebp-8, size=OS_32
	movl	%eax,-4(%ebp)
	movl	$8,%eax
	call	SVCAPI_$$_SVCPROC$LONGINT$$POINTER
	movl	%eax,-8(%ebp)
	movl	-4(%ebp),%eax
	call	*-8(%ebp)
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_svcapi_$$_serialwritechar$char,"x"
	.balign 16,0x90
.globl	SVCAPI_$$_SERIALWRITECHAR$CHAR
SVCAPI_$$_SERIALWRITECHAR$CHAR:
# [91] begin P := TProcSChar(SvcProc(SVC_SERIALCHAR)); P(C); end;
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var C located at ebp-4, size=OS_8
# Var P located at ebp-8, size=OS_32
	movb	%al,-4(%ebp)
	movl	$9,%eax
	call	SVCAPI_$$_SVCPROC$LONGINT$$POINTER
	movl	%eax,-8(%ebp)
	movb	-4(%ebp),%al
	call	*-8(%ebp)
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_svcapi_$$_keyboardpoll,"x"
	.balign 16,0x90
.globl	SVCAPI_$$_KEYBOARDPOLL
SVCAPI_$$_KEYBOARDPOLL:
# [95] begin P := TProcKPoll(SvcProc(SVC_KEYPOLL)); P; end;
	pushl	%ebp
	movl	%esp,%ebp
	leal	-4(%esp),%esp
# Var P located at ebp-4, size=OS_32
	movl	$10,%eax
	call	SVCAPI_$$_SVCPROC$LONGINT$$POINTER
	movl	%eax,-4(%ebp)
	call	*-4(%ebp)
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_svcapi_$$_anykeypressed$$boolean,"x"
	.balign 16,0x90
.globl	SVCAPI_$$_ANYKEYPRESSED$$BOOLEAN
SVCAPI_$$_ANYKEYPRESSED$$BOOLEAN:
# [99] begin P := TFuncBool0(SvcProc(SVC_ANYKEY)); AnyKeyPressed := P(); end;
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var $result located at ebp-4, size=OS_8
# Var P located at ebp-8, size=OS_32
	movl	$11,%eax
	call	SVCAPI_$$_SVCPROC$LONGINT$$POINTER
	movl	%eax,-8(%ebp)
	call	*-8(%ebp)
	movb	%al,-4(%ebp)
	movb	-4(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_svcapi_$$_keyispressed$char$$boolean,"x"
	.balign 16,0x90
.globl	SVCAPI_$$_KEYISPRESSED$CHAR$$BOOLEAN
SVCAPI_$$_KEYISPRESSED$CHAR$$BOOLEAN:
# [103] begin P := TFuncBool1(SvcProc(SVC_KEYPRESSED)); KeyIsPressed := P(Ch); end;
	pushl	%ebp
	movl	%esp,%ebp
	leal	-12(%esp),%esp
# Var Ch located at ebp-4, size=OS_8
# Var $result located at ebp-8, size=OS_8
# Var P located at ebp-12, size=OS_32
	movb	%al,-4(%ebp)
	movl	$12,%eax
	call	SVCAPI_$$_SVCPROC$LONGINT$$POINTER
	movl	%eax,-12(%ebp)
	movb	-4(%ebp),%al
	call	*-12(%ebp)
	movb	%al,-8(%ebp)
	movb	-8(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_svcapi_$$_fsreadfile$pchar$pbyte$longword$$longint,"x"
	.balign 16,0x90
.globl	SVCAPI_$$_FSREADFILE$PCHAR$PBYTE$LONGWORD$$LONGINT
SVCAPI_$$_FSREADFILE$PCHAR$PBYTE$LONGWORD$$LONGINT:
# [107] begin P := TFuncFS(SvcProc(SVC_FSREAD)); FSReadFile := P(Name, Dest, MaxSize); end;
	pushl	%ebp
	movl	%esp,%ebp
	leal	-20(%esp),%esp
# Var Name located at ebp-4, size=OS_32
# Var Dest located at ebp-8, size=OS_32
# Var MaxSize located at ebp-12, size=OS_32
# Var $result located at ebp-16, size=OS_S32
# Var P located at ebp-20, size=OS_32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
	movl	$13,%eax
	call	SVCAPI_$$_SVCPROC$LONGINT$$POINTER
	movl	%eax,-20(%ebp)
	movl	-12(%ebp),%ecx
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	call	*-20(%ebp)
	movl	%eax,-16(%ebp)
	movl	-16(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_svcapi_$$_drawbmp$pchar$longint$longint,"x"
	.balign 16,0x90
.globl	SVCAPI_$$_DRAWBMP$PCHAR$LONGINT$LONGINT
SVCAPI_$$_DRAWBMP$PCHAR$LONGINT$LONGINT:
# [111] begin P := TProcBMP(SvcProc(SVC_DRAWBMP)); P(Name, X, Y); end;
	pushl	%ebp
	movl	%esp,%ebp
	leal	-16(%esp),%esp
# Var Name located at ebp-4, size=OS_32
# Var X located at ebp-8, size=OS_S32
# Var Y located at ebp-12, size=OS_S32
# Var P located at ebp-16, size=OS_32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
	movl	$14,%eax
	call	SVCAPI_$$_SVCPROC$LONGINT$$POINTER
	movl	%eax,-16(%ebp)
	movl	-12(%ebp),%ecx
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	call	*-16(%ebp)
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_svcapi_$$_getmousex$$longint,"x"
	.balign 16,0x90
.globl	SVCAPI_$$_GETMOUSEX$$LONGINT
SVCAPI_$$_GETMOUSEX$$LONGINT:
# [115] begin P := TFuncInt0(SvcProc(SVC_MOUSEX)); GetMouseX := P(); end;
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var $result located at ebp-4, size=OS_S32
# Var P located at ebp-8, size=OS_32
	movl	$15,%eax
	call	SVCAPI_$$_SVCPROC$LONGINT$$POINTER
	movl	%eax,-8(%ebp)
	call	*-8(%ebp)
	movl	%eax,-4(%ebp)
	movl	-4(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_svcapi_$$_getmousey$$longint,"x"
	.balign 16,0x90
.globl	SVCAPI_$$_GETMOUSEY$$LONGINT
SVCAPI_$$_GETMOUSEY$$LONGINT:
# [119] begin P := TFuncInt0(SvcProc(SVC_MOUSEY)); GetMouseY := P(); end;
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var $result located at ebp-4, size=OS_S32
# Var P located at ebp-8, size=OS_32
	movl	$16,%eax
	call	SVCAPI_$$_SVCPROC$LONGINT$$POINTER
	movl	%eax,-8(%ebp)
	call	*-8(%ebp)
	movl	%eax,-4(%ebp)
	movl	-4(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret
# End asmlist al_procedures

