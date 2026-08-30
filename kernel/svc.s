	.file "svc.pas"
# Begin asmlist al_procedures

.section .text.n_svc_$$_putsvc$longint$pointer,"x"
	.balign 16,0x90
SVC_$$_PUTSVC$LONGINT$POINTER:
# [svc.pas]
# [29] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var Index located at ebp-4, size=OS_S32
# Var P located at ebp-8, size=OS_32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
# [30] PLongWord(PByte(SERVICE_TABLE_ADDR) + Index * 4)^ := LongWord(P);
	movl	-4(%ebp),%eax
	shll	$2,%eax
	leal	393216(%eax),%edx
	movl	-8(%ebp),%eax
	movl	%eax,(%edx)
# [31] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_svc_$$_programsvcinit,"x"
	.balign 16,0x90
.globl	SVC_$$_PROGRAMSVCINIT
SVC_$$_PROGRAMSVCINIT:
# [34] begin
	pushl	%ebp
	movl	%esp,%ebp
# [35] PutSvc(SVC_MAGIC, Pointer(SERVICE_TABLE_MAGIC));
	movl	$827736915,%edx
	movl	$0,%eax
	call	SVC_$$_PUTSVC$LONGINT$POINTER
# [38] PutSvc(SVC_CLEARSCREEN, Pointer(@SvcClearScreen));
	movl	$WINDOWS_$$_SVCCLEARSCREEN$BYTE,%edx
	movl	$1,%eax
	call	SVC_$$_PUTSVC$LONGINT$POINTER
# [39] PutSvc(SVC_WRITEAT, Pointer(@SvcWriteAt));
	movl	$WINDOWS_$$_SVCWRITEAT$LONGINT$LONGINT$PCHAR$LONGINT,%edx
	movl	$2,%eax
	call	SVC_$$_PUTSVC$LONGINT$POINTER
# [40] PutSvc(SVC_WRITEATCOL, Pointer(@SvcWriteAtCol));
	movl	$WINDOWS_$$_SVCWRITEATCOL$LONGINT$LONGINT$PCHAR$LONGINT$BYTE,%edx
	movl	$3,%eax
	call	SVC_$$_PUTSVC$LONGINT$POINTER
# [41] PutSvc(SVC_FILLRECT, Pointer(@SvcFillRect));
	movl	$WINDOWS_$$_SVCFILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE,%edx
	movl	$4,%eax
	call	SVC_$$_PUTSVC$LONGINT$POINTER
# [42] PutSvc(SVC_PUTPIXEL, Pointer(@SvcPutPixel));
	movl	$WINDOWS_$$_SVCPUTPIXEL$LONGINT$LONGINT$BYTE,%edx
	movl	$5,%eax
	call	SVC_$$_PUTSVC$LONGINT$POINTER
# [43] PutSvc(SVC_DRAWLINE, Pointer(@SvcDrawLine));
	movl	$WINDOWS_$$_SVCDRAWLINE$LONGINT$LONGINT$LONGINT$LONGINT$BYTE,%edx
	movl	$6,%eax
	call	SVC_$$_PUTSVC$LONGINT$POINTER
# [44] PutSvc(SVC_DELAYMS, Pointer(@DelayMS));
	movl	$OPENFIRMWARE_$$_DELAYMS$LONGINT,%edx
	movl	$7,%eax
	call	SVC_$$_PUTSVC$LONGINT$POINTER
# [45] PutSvc(SVC_SERIALSTR, Pointer(@SerialWriteString));
	movl	$SERIAL_$$_SERIALWRITESTRING$PCHAR,%edx
	movl	$8,%eax
	call	SVC_$$_PUTSVC$LONGINT$POINTER
# [46] PutSvc(SVC_SERIALCHAR, Pointer(@SerialWriteChar));
	movl	$SERIAL_$$_SERIALWRITECHAR$CHAR,%edx
	movl	$9,%eax
	call	SVC_$$_PUTSVC$LONGINT$POINTER
# [47] PutSvc(SVC_KEYPOLL, Pointer(@KeyboardPoll));
	movl	$KEYBOARD_$$_KEYBOARDPOLL,%edx
	movl	$10,%eax
	call	SVC_$$_PUTSVC$LONGINT$POINTER
# [48] PutSvc(SVC_ANYKEY, Pointer(@AnyKeyPressed));
	movl	$KEYBOARD_$$_ANYKEYPRESSED$$BOOLEAN,%edx
	movl	$11,%eax
	call	SVC_$$_PUTSVC$LONGINT$POINTER
# [49] PutSvc(SVC_KEYPRESSED, Pointer(@KeyIsPressed));
	movl	$KEYBOARD_$$_KEYISPRESSED$CHAR$$BOOLEAN,%edx
	movl	$12,%eax
	call	SVC_$$_PUTSVC$LONGINT$POINTER
# [50] PutSvc(SVC_FSREAD, Pointer(@FSReadFile));
	movl	$CDROM_$$_FSREADFILE$PCHAR$PBYTE$LONGWORD$$LONGINT,%edx
	movl	$13,%eax
	call	SVC_$$_PUTSVC$LONGINT$POINTER
# [51] PutSvc(SVC_DRAWBMP, Pointer(@SvcDrawBMP));
	movl	$WINDOWS_$$_SVCDRAWBMP$PCHAR$LONGINT$LONGINT,%edx
	movl	$14,%eax
	call	SVC_$$_PUTSVC$LONGINT$POINTER
# [52] PutSvc(SVC_MOUSEX, Pointer(@SvcGetMouseX));
	movl	$WINDOWS_$$_SVCGETMOUSEX$$LONGINT,%edx
	movl	$15,%eax
	call	SVC_$$_PUTSVC$LONGINT$POINTER
# [53] PutSvc(SVC_MOUSEY, Pointer(@SvcGetMouseY));
	movl	$WINDOWS_$$_SVCGETMOUSEY$$LONGINT,%edx
	movl	$16,%eax
	call	SVC_$$_PUTSVC$LONGINT$POINTER
# [55] PutSvc(SVC_WINCREATE, Pointer(@WinCreate));
	movl	$WINDOWS_$$_WINCREATE$PCHAR$LONGINT$LONGINT$$LONGINT,%edx
	movl	$17,%eax
	call	SVC_$$_PUTSVC$LONGINT$POINTER
# [56] PutSvc(SVC_WINPOLL, Pointer(@WinPoll));
	movl	$WINDOWS_$$_WINPOLL$$LONGINT,%edx
	movl	$18,%eax
	call	SVC_$$_PUTSVC$LONGINT$POINTER
# [57] PutSvc(SVC_WINDESTROY, Pointer(@WinDestroy));
	movl	$WINDOWS_$$_WINDESTROY,%edx
	movl	$19,%eax
	call	SVC_$$_PUTSVC$LONGINT$POINTER
# [58] PutSvc(SVC_WINKEY, Pointer(@WinKey));
	movl	$WINDOWS_$$_WINKEY$$CHAR,%edx
	movl	$20,%eax
	call	SVC_$$_PUTSVC$LONGINT$POINTER
# [59] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_svc_$$_runprogram$pchar$$boolean,"x"
	.balign 16,0x90
.globl	SVC_$$_RUNPROGRAM$PCHAR$$BOOLEAN
SVC_$$_RUNPROGRAM$PCHAR$$BOOLEAN:
# [68] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-20(%esp),%esp
# Var Name located at ebp-4, size=OS_32
# Var $result located at ebp-8, size=OS_8
# Var P located at ebp-12, size=OS_32
# Var N located at ebp-16, size=OS_S32
# Var I located at ebp-20, size=OS_32
	movl	%eax,-4(%ebp)
# [69] RunProgram := False;
	movb	$0,-8(%ebp)
# [70] P := PByte(PROGRAM_BASE);
	movl	$1048576,-12(%ebp)
# [73] for I := 0 to PROGRAM_MAX - 1 do
	movl	$-1,-20(%ebp)
	.balign 8,0x90
.Lj9:
	movl	-20(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-20(%ebp)
# [74] P[I] := 0;
	movl	-12(%ebp),%eax
	movl	-20(%ebp),%edx
	movb	$0,(%eax,%edx,1)
	cmpl	$524287,-20(%ebp)
	jae	.Lj11
	jmp	.Lj9
.Lj11:
# [75] N := FSReadFile(Name, P, PROGRAM_MAX);
	movl	-12(%ebp),%edx
	movl	-4(%ebp),%eax
	movl	$524288,%ecx
	call	CDROM_$$_FSREADFILE$PCHAR$PBYTE$LONGWORD$$LONGINT
	movl	%eax,-16(%ebp)
# [76] SerialWriteString('prog: read ');
	movl	$_$SVC$_Ld1,%eax
	call	SERIAL_$$_SERIALWRITESTRING$PCHAR
# [77] SerialWriteHex32(LongWord(N));
	movl	-16(%ebp),%eax
	call	SERIAL_$$_SERIALWRITEHEX32$LONGWORD
# [78] SerialWriteString(' bytes ');
	movl	$_$SVC$_Ld2,%eax
	call	SERIAL_$$_SERIALWRITESTRING$PCHAR
# [79] SerialWriteString(Name);
	movl	-4(%ebp),%eax
	call	SERIAL_$$_SERIALWRITESTRING$PCHAR
# [80] SerialWriteChar(#13);
	movb	$13,%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
# [81] SerialWriteChar(#10);
	movb	$10,%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
# [82] if N <= 0 then
	cmpl	$0,-16(%ebp)
	jle	.Lj12
	jmp	.Lj13
.Lj12:
# [83] Exit;
	jmp	.Lj7
	.balign 4,0x90
.Lj13:
# [84] SerialWriteString('prog: call entry');
	movl	$_$SVC$_Ld3,%eax
	call	SERIAL_$$_SERIALWRITESTRING$PCHAR
# [85] SerialWriteChar(#13);
	movb	$13,%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
# [86] SerialWriteChar(#10);
	movb	$10,%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
# [87] TProgramProc(Pointer(P))();
	call	*-12(%ebp)
# [88] SerialWriteString('prog: returned');
	movl	$_$SVC$_Ld4,%eax
	call	SERIAL_$$_SERIALWRITESTRING$PCHAR
# [89] SerialWriteChar(#13);
	movb	$13,%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
# [90] SerialWriteChar(#10);
	movb	$10,%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
# [91] RunProgram := True;
	movb	$1,-8(%ebp)
.Lj7:
# [92] end;
	movb	-8(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret
# End asmlist al_procedures
# Begin asmlist al_typedconsts

.section .rodata.n__$SVC$_Ld1,"d"
	.balign 4
.globl	_$SVC$_Ld1
_$SVC$_Ld1:
	.ascii	"prog: read \000"

.section .rodata.n__$SVC$_Ld2,"d"
	.balign 4
.globl	_$SVC$_Ld2
_$SVC$_Ld2:
	.ascii	" bytes \000"

.section .rodata.n__$SVC$_Ld3,"d"
	.balign 4
.globl	_$SVC$_Ld3
_$SVC$_Ld3:
	.ascii	"prog: call entry\000"

.section .rodata.n__$SVC$_Ld4,"d"
	.balign 4
.globl	_$SVC$_Ld4
_$SVC$_Ld4:
	.ascii	"prog: returned\000"
# End asmlist al_typedconsts

