	.file "winapi.pas"
# Begin asmlist al_procedures

.section .text.n_winapi_$$_svcproc$longint$$pointer,"x"
	.balign 16,0x90
WINAPI_$$_SVCPROC$LONGINT$$POINTER:
# [winapi.pas]
# [28] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var Index located at ebp-4, size=OS_S32
# Var $result located at ebp-8, size=OS_32
	movl	%eax,-4(%ebp)
# [29] SvcProc := Pointer(PLongWord(PByte(SERVICE_TABLE_ADDR) + Index * 4)^);
	movl	-4(%ebp),%eax
	shll	$2,%eax
	leal	393216(%eax),%eax
	movl	(%eax),%eax
	movl	%eax,-8(%ebp)
# [30] end;
	movl	-8(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_winapi_$$_wincreate$pchar$longint$longint,"x"
	.balign 16,0x90
.globl	WINAPI_$$_WINCREATE$PCHAR$LONGINT$LONGINT
WINAPI_$$_WINCREATE$PCHAR$LONGINT$LONGINT:
# [40] begin P := TProcWinCreate(SvcProc(SVC_WINCREATE)); P(Title, W, H); end;
	pushl	%ebp
	movl	%esp,%ebp
	leal	-16(%esp),%esp
# Var Title located at ebp-4, size=OS_32
# Var W located at ebp-8, size=OS_S32
# Var H located at ebp-12, size=OS_S32
# Var P located at ebp-16, size=OS_32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
	movl	$17,%eax
	call	WINAPI_$$_SVCPROC$LONGINT$$POINTER
	movl	%eax,-16(%ebp)
	movl	-12(%ebp),%ecx
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	call	*-16(%ebp)
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_winapi_$$_windestroy,"x"
	.balign 16,0x90
.globl	WINAPI_$$_WINDESTROY
WINAPI_$$_WINDESTROY:
# [44] begin P := TProcWinDestroy(SvcProc(SVC_WINDESTROY)); P; end;
	pushl	%ebp
	movl	%esp,%ebp
	leal	-4(%esp),%esp
# Var P located at ebp-4, size=OS_32
	movl	$19,%eax
	call	WINAPI_$$_SVCPROC$LONGINT$$POINTER
	movl	%eax,-4(%ebp)
	call	*-4(%ebp)
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_winapi_$$_winpoll$$longint,"x"
	.balign 16,0x90
.globl	WINAPI_$$_WINPOLL$$LONGINT
WINAPI_$$_WINPOLL$$LONGINT:
# [48] begin P := TFuncWinPoll(SvcProc(SVC_WINPOLL)); WinPoll := P(); end;
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var $result located at ebp-4, size=OS_S32
# Var P located at ebp-8, size=OS_32
	movl	$18,%eax
	call	WINAPI_$$_SVCPROC$LONGINT$$POINTER
	movl	%eax,-8(%ebp)
	call	*-8(%ebp)
	movl	%eax,-4(%ebp)
	movl	-4(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_winapi_$$_winkey$$char,"x"
	.balign 16,0x90
.globl	WINAPI_$$_WINKEY$$CHAR
WINAPI_$$_WINKEY$$CHAR:
# [52] begin P := TFuncWinKey(SvcProc(SVC_WINKEY)); WinKey := P(); end;
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var $result located at ebp-4, size=OS_8
# Var P located at ebp-8, size=OS_32
	movl	$20,%eax
	call	WINAPI_$$_SVCPROC$LONGINT$$POINTER
	movl	%eax,-8(%ebp)
	call	*-8(%ebp)
	movb	%al,-4(%ebp)
	movb	-4(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret
# End asmlist al_procedures

