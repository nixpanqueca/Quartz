	.file "teste.pas"
# Begin asmlist al_procedures

.section .text.n_teste_$$_main,"x"
	.balign 16,0x90
.globl	TESTE_$$_MAIN
TESTE_$$_MAIN:
.globl	_Main
_Main:
# [teste.pas]
# [24] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-4(%esp),%esp
# Var ev located at ebp-4, size=OS_S32
# [26] WinCreate('Teste de Janela', 320, 220);
	movl	$220,%ecx
	movl	$320,%edx
	movl	$_$TESTE$_Ld1,%eax
	call	WINAPI_$$_WINCREATE$PCHAR$LONGINT$LONGINT
# [29] FillRect(0, 0, 320, 220, 16 + 1 * 36 + 2 * 6 + 4);
	pushl	$220
	pushl	$68
	movl	$320,%ecx
	movl	$0,%edx
	movl	$0,%eax
	call	SVCAPI_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [31] FillRect(0, 0, 320, 24, 16 + 2 * 36);
	pushl	$24
	pushl	$88
	movl	$320,%ecx
	movl	$0,%edx
	movl	$0,%eax
	call	SVCAPI_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [32] WriteAt(10, 8, 'Pyramid Toolkit', 14);
	pushl	$14
	movl	$_$TESTE$_Ld2,%ecx
	movl	$8,%edx
	movl	$10,%eax
	call	SVCAPI_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
# [34] WriteAt(10, 40, 'Ola! Sua janela esta funcionando.', 12);
	pushl	$12
	movl	$_$TESTE$_Ld3,%ecx
	movl	$40,%edx
	movl	$10,%eax
	call	SVCAPI_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
# [35] WriteAt(10, 62, 'Este texto usa coordenadas locais da janela.', 12);
	pushl	$12
	movl	$_$TESTE$_Ld4,%ecx
	movl	$62,%edx
	movl	$10,%eax
	call	SVCAPI_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
# [36] WriteAt(10, 84, 'O kernel aplicou o offset automaticamente.', 12);
	pushl	$12
	movl	$_$TESTE$_Ld5,%ecx
	movl	$84,%edx
	movl	$10,%eax
	call	SVCAPI_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
# [39] FillRect(10, 110, 120, 60, 16 + 4 * 36 + 3 * 6 + 5);
	pushl	$60
	pushl	$183
	movl	$120,%ecx
	movl	$110,%edx
	movl	$10,%eax
	call	SVCAPI_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [40] FillRect(18, 118, 24, 44, 16 + 0 * 36 + 5 * 6 + 4);
	pushl	$44
	pushl	$50
	movl	$24,%ecx
	movl	$118,%edx
	movl	$18,%eax
	call	SVCAPI_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [41] FillRect(34, 118, 24, 44, 16 + 4 * 36 + 0 * 6 + 4);
	pushl	$44
	pushl	$164
	movl	$24,%ecx
	movl	$118,%edx
	movl	$34,%eax
	call	SVCAPI_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [43] WriteAt(10, 188, 'Clique no X (canto) para fechar.', 12);
	pushl	$12
	movl	$_$TESTE$_Ld6,%ecx
	movl	$188,%edx
	movl	$10,%eax
	call	SVCAPI_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
	.balign 8,0x90
.Lj5:
# [47] ev := WinPoll;
	call	WINAPI_$$_WINPOLL$$LONGINT
	movl	%eax,-4(%ebp)
# [48] until ev = WINEV_CLOSE;
	cmpl	$1,-4(%ebp)
	je	.Lj7
	jmp	.Lj5
.Lj7:
# [51] WinDestroy;
	call	WINAPI_$$_WINDESTROY
# [52] end;
	movl	%ebp,%esp
	popl	%ebp
	ret
# End asmlist al_procedures
# Begin asmlist al_typedconsts

.section .rodata.n__$TESTE$_Ld1,"d"
	.balign 4
.globl	_$TESTE$_Ld1
_$TESTE$_Ld1:
	.ascii	"Teste de Janela\000"

.section .rodata.n__$TESTE$_Ld2,"d"
	.balign 4
.globl	_$TESTE$_Ld2
_$TESTE$_Ld2:
	.ascii	"Pyramid Toolkit\000"

.section .rodata.n__$TESTE$_Ld3,"d"
	.balign 4
.globl	_$TESTE$_Ld3
_$TESTE$_Ld3:
	.ascii	"Ola! Sua janela esta funcionando.\000"

.section .rodata.n__$TESTE$_Ld4,"d"
	.balign 4
.globl	_$TESTE$_Ld4
_$TESTE$_Ld4:
	.ascii	"Este texto usa coordenadas locais da janela.\000"

.section .rodata.n__$TESTE$_Ld5,"d"
	.balign 4
.globl	_$TESTE$_Ld5
_$TESTE$_Ld5:
	.ascii	"O kernel aplicou o offset automaticamente.\000"

.section .rodata.n__$TESTE$_Ld6,"d"
	.balign 4
.globl	_$TESTE$_Ld6
_$TESTE$_Ld6:
	.ascii	"Clique no X (canto) para fechar.\000"
# End asmlist al_typedconsts

