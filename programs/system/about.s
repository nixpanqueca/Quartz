	.file "about.pas"
# Begin asmlist al_procedures

.section .text.n_about_$$_main,"x"
	.balign 16,0x90
.globl	ABOUT_$$_MAIN
ABOUT_$$_MAIN:
.globl	_Main
_Main:
# [about.pas]
# [20] begin
	pushl	%ebp
	movl	%esp,%ebp
# [21] ClearScreen($0F);
	movb	$15,%al
	call	SVCAPI_$$_CLEARSCREEN$BYTE
# [22] WriteAt(30, 30, 'Aether System Software', 24);
	pushl	$24
	movl	$_$ABOUT$_Ld1,%ecx
	movl	$30,%edx
	movl	$30,%eax
	call	SVCAPI_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
# [23] WriteAt(30, 70, 'Kernel: Quartz - OpenShell', 16);
	pushl	$16
	movl	$_$ABOUT$_Ld2,%ecx
	movl	$70,%edx
	movl	$30,%eax
	call	SVCAPI_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
# [24] WriteAt(30, 100, 'Seu programa foi carregado e executado.', 12);
	pushl	$12
	movl	$_$ABOUT$_Ld3,%ecx
	movl	$100,%edx
	movl	$30,%eax
	call	SVCAPI_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
# [25] WriteAt(30, 120, 'Este e um programa de SISTEMA.', 12);
	pushl	$12
	movl	$_$ABOUT$_Ld4,%ecx
	movl	$120,%edx
	movl	$30,%eax
	call	SVCAPI_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
# [26] DelayMS(3000);
	movl	$3000,%eax
	call	SVCAPI_$$_DELAYMS$LONGINT
# [27] end;
	movl	%ebp,%esp
	popl	%ebp
	ret
# End asmlist al_procedures
# Begin asmlist al_typedconsts

.section .rodata.n__$ABOUT$_Ld1,"d"
	.balign 4
.globl	_$ABOUT$_Ld1
_$ABOUT$_Ld1:
	.ascii	"Aether System Software\000"

.section .rodata.n__$ABOUT$_Ld2,"d"
	.balign 4
.globl	_$ABOUT$_Ld2
_$ABOUT$_Ld2:
	.ascii	"Kernel: Quartz - OpenShell\000"

.section .rodata.n__$ABOUT$_Ld3,"d"
	.balign 4
.globl	_$ABOUT$_Ld3
_$ABOUT$_Ld3:
	.ascii	"Seu programa foi carregado e executado.\000"

.section .rodata.n__$ABOUT$_Ld4,"d"
	.balign 4
.globl	_$ABOUT$_Ld4
_$ABOUT$_Ld4:
	.ascii	"Este e um programa de SISTEMA.\000"
# End asmlist al_typedconsts

