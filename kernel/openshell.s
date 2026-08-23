	.file "openshell.pas"
# Begin asmlist al_procedures

.section .text.n_openshell_$$_shellinit,"x"
	.balign 16,0x90
.globl	OPENSHELL_$$_SHELLINIT
OPENSHELL_$$_SHELLINIT:
# [openshell.pas]
# [19] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var CX located at ebp-4, size=OS_S32
# Var CY located at ebp-8, size=OS_S32
# [20] ClearScreen($0F);
	movb	$15,%al
	call	VIDEO_$$_CLEARSCREEN$BYTE
# [21] WriteAt(1, 1, 'OpenShell', 16);
	pushl	$16
	movl	$_$OPENSHELL$_Ld1,%ecx
	movl	$1,%edx
	movl	$1,%eax
	call	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
# [22] end;
	movl	%ebp,%esp
	popl	%ebp
	ret
# End asmlist al_procedures
# Begin asmlist al_typedconsts

.section .rodata.n__$OPENSHELL$_Ld1,"d"
	.balign 4
.globl	_$OPENSHELL$_Ld1
_$OPENSHELL$_Ld1:
	.ascii	"OpenShell\000"
# End asmlist al_typedconsts

