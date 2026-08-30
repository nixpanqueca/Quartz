	.file "mouse.pas"
# Begin asmlist al_procedures

.section .text.n_mouse_$$_outb$word$byte,"x"
	.balign 16,0x90
MOUSE_$$_OUTB$WORD$BYTE:
# [mouse.pas]
# [31] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var Addr located at ebp-4, size=OS_16
# Var Value located at ebp-8, size=OS_8
	movw	%ax,-4(%ebp)
	movb	%dl,-8(%ebp)
#  CPU PENTIUM
# [33] mov dx, Addr
	movw	-4(%ebp),%dx
# [34] mov al, Value
	movb	-8(%ebp),%al
# [35] out dx, al
	outb	%al,%dx
#  CPU PENTIUM
# [37] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_mouse_$$_inb$word$$byte,"x"
	.balign 16,0x90
MOUSE_$$_INB$WORD$$BYTE:
# [42] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-12(%esp),%esp
# Var Addr located at ebp-4, size=OS_16
# Var $result located at ebp-8, size=OS_8
# Var B located at ebp-12, size=OS_8
	movw	%ax,-4(%ebp)
#  CPU PENTIUM
# [44] mov dx, Addr
	movw	-4(%ebp),%dx
# [45] in al, dx
	inb	%dx,%al
# [46] mov B, al
	movb	%al,-12(%ebp)
#  CPU PENTIUM
# [48] InB := B;
	movb	-12(%ebp),%al
	movb	%al,-8(%ebp)
# [49] end;
	movb	-8(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_mouse_$$_waitinputempty,"x"
	.balign 16,0x90
MOUSE_$$_WAITINPUTEMPTY:
# [54] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-4(%esp),%esp
# Var i located at ebp-4, size=OS_S32
# [55] i := 0;
	movl	$0,-4(%ebp)
# [56] while ((InB(PortStatus) and $02) <> 0) and (i < 100000) do
	jmp	.Lj10
	.balign 8,0x90
.Lj9:
# [57] Inc(i);
	addl	$1,-4(%ebp)
.Lj10:
	movw	$100,%ax
	call	MOUSE_$$_INB$WORD$$BYTE
	movzbw	%al,%ax
	andw	$2,%ax
	testw	$-1,%ax
	jne	.Lj12
	jmp	.Lj13
.Lj12:
	cmpl	$100000,-4(%ebp)
	jl	.Lj14
	jmp	.Lj13
.Lj14:
	jmp	.Lj9
.Lj13:
	jmp	.Lj11
.Lj11:
# [58] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_mouse_$$_waitoutputfull,"x"
	.balign 16,0x90
MOUSE_$$_WAITOUTPUTFULL:
# [63] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-4(%esp),%esp
# Var i located at ebp-4, size=OS_S32
# [64] i := 0;
	movl	$0,-4(%ebp)
# [65] while ((InB(PortStatus) and $01) = 0) and (i < 100000) do
	jmp	.Lj18
	.balign 8,0x90
.Lj17:
# [66] Inc(i);
	addl	$1,-4(%ebp)
.Lj18:
	movw	$100,%ax
	call	MOUSE_$$_INB$WORD$$BYTE
	movzbw	%al,%ax
	andw	$1,%ax
	testw	$-1,%ax
	je	.Lj20
	jmp	.Lj21
.Lj20:
	cmpl	$100000,-4(%ebp)
	jl	.Lj22
	jmp	.Lj21
.Lj22:
	jmp	.Lj17
.Lj21:
	jmp	.Lj19
.Lj19:
# [67] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_mouse_$$_mouseinit,"x"
	.balign 16,0x90
.globl	MOUSE_$$_MOUSEINIT
MOUSE_$$_MOUSEINIT:
# [70] begin
	pushl	%ebp
	movl	%esp,%ebp
# [71] MouseX := 0;
	movl	$0,U_$MOUSE_$$_MOUSEX
# [72] MouseY := 0;
	movl	$0,U_$MOUSE_$$_MOUSEY
# [73] MouseButtons := 0;
	movb	$0,U_$MOUSE_$$_MOUSEBUTTONS
# [74] PacketPos := 0;
	movl	$0,U_$MOUSE_$$_PACKETPOS
# [76] WaitInputEmpty;
	call	MOUSE_$$_WAITINPUTEMPTY
# [77] OutB(PortStatus, $A8);        // habilita aux device (IRQ12)
	movb	$168,%dl
	movw	$100,%ax
	call	MOUSE_$$_OUTB$WORD$BYTE
# [78] WaitInputEmpty;
	call	MOUSE_$$_WAITINPUTEMPTY
# [79] OutB(PortStatus, $D4);        // proxima escrita vai para o mouse
	movb	$212,%dl
	movw	$100,%ax
	call	MOUSE_$$_OUTB$WORD$BYTE
# [80] WaitInputEmpty;
	call	MOUSE_$$_WAITINPUTEMPTY
# [81] OutB(PortData, $F4);          // habilita envio de pacotes
	movb	$244,%dl
	movw	$96,%ax
	call	MOUSE_$$_OUTB$WORD$BYTE
# [83] WaitOutputFull;
	call	MOUSE_$$_WAITOUTPUTFULL
# [84] InB(PortData);                // descarta o ACK (0xFA)
	movw	$96,%ax
	call	MOUSE_$$_INB$WORD$$BYTE
# [85] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_mouse_$$_mousedeliver$byte,"x"
	.balign 16,0x90
.globl	MOUSE_$$_MOUSEDELIVER$BYTE
MOUSE_$$_MOUSEDELIVER$BYTE:
# [88] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-4(%esp),%esp
# Var B located at ebp-4, size=OS_8
	movb	%al,-4(%ebp)
# [89] case PacketPos of
	movl	U_$MOUSE_$$_PACKETPOS,%eax
	testl	%eax,%eax
	jl	.Lj28
	testl	%eax,%eax
	je	.Lj29
	subl	$1,%eax
	je	.Lj30
	subl	$1,%eax
	je	.Lj31
	jmp	.Lj28
	.balign 4,0x90
.Lj29:
# [90] 0: Packet[0] := B;
	movb	-4(%ebp),%al
	movb	%al,U_$MOUSE_$$_PACKET
	jmp	.Lj27
	.balign 4,0x90
.Lj30:
# [91] 1: Packet[1] := B;
	movb	-4(%ebp),%al
	movb	%al,U_$MOUSE_$$_PACKET+1
	jmp	.Lj27
	.balign 4,0x90
.Lj31:
# [94] Packet[2] := B;
	movb	-4(%ebp),%al
	movb	%al,U_$MOUSE_$$_PACKET+2
# [95] if (Packet[0] and $40) = 0 then
	movzbw	U_$MOUSE_$$_PACKET,%ax
	andw	$64,%ax
	testw	$-1,%ax
	je	.Lj32
	jmp	.Lj33
.Lj32:
# [97] if (Packet[0] and $10) <> 0 then
	movzbw	U_$MOUSE_$$_PACKET,%ax
	andw	$16,%ax
	testw	$-1,%ax
	jne	.Lj34
	jmp	.Lj35
.Lj34:
# [98] MouseX := MouseX + (Packet[1] - 256)
	movzbl	U_$MOUSE_$$_PACKET+1,%eax
	subl	$256,%eax
	addl	U_$MOUSE_$$_MOUSEX,%eax
	movl	%eax,U_$MOUSE_$$_MOUSEX
	jmp	.Lj36
.Lj35:
# [100] MouseX := MouseX + Packet[1];
	movzbl	U_$MOUSE_$$_PACKET+1,%eax
	addl	U_$MOUSE_$$_MOUSEX,%eax
	movl	%eax,U_$MOUSE_$$_MOUSEX
.Lj36:
	.balign 4,0x90
.Lj33:
# [102] if (Packet[0] and $80) = 0 then
	movb	U_$MOUSE_$$_PACKET,%al
	andb	$128,%al
	testb	$-1,%al
	je	.Lj37
	jmp	.Lj38
.Lj37:
# [104] if (Packet[0] and $20) <> 0 then
	movzbw	U_$MOUSE_$$_PACKET,%ax
	andw	$32,%ax
	testw	$-1,%ax
	jne	.Lj39
	jmp	.Lj40
.Lj39:
# [105] MouseY := MouseY - (Packet[2] - 256)
	movzbl	U_$MOUSE_$$_PACKET+2,%edx
	subl	$256,%edx
	movl	U_$MOUSE_$$_MOUSEY,%eax
	subl	%edx,%eax
	movl	%eax,U_$MOUSE_$$_MOUSEY
	jmp	.Lj41
.Lj40:
# [107] MouseY := MouseY - Packet[2];
	movzbl	U_$MOUSE_$$_PACKET+2,%eax
	movl	U_$MOUSE_$$_MOUSEY,%edx
	subl	%eax,%edx
	movl	%edx,U_$MOUSE_$$_MOUSEY
.Lj41:
	.balign 4,0x90
.Lj38:
# [109] MouseButtons := Packet[0] and $03;
	movzbw	U_$MOUSE_$$_PACKET,%ax
	andw	$3,%ax
	movb	%al,U_$MOUSE_$$_MOUSEBUTTONS
# [110] if MouseX < 0 then
	cmpl	$0,U_$MOUSE_$$_MOUSEX
	jl	.Lj42
	jmp	.Lj43
.Lj42:
# [111] MouseX := 0
	movl	$0,U_$MOUSE_$$_MOUSEX
	jmp	.Lj44
.Lj43:
# [112] else if MouseX > RWidth - 16 then
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-16(%eax),%eax
	cmpl	U_$MOUSE_$$_MOUSEX,%eax
	jl	.Lj45
	jmp	.Lj46
.Lj45:
# [113] MouseX := RWidth - 16;
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-16(%eax),%eax
	movl	%eax,U_$MOUSE_$$_MOUSEX
	.balign 4,0x90
.Lj46:
.Lj44:
# [114] if MouseY < 0 then
	cmpl	$0,U_$MOUSE_$$_MOUSEY
	jl	.Lj47
	jmp	.Lj48
.Lj47:
# [115] MouseY := 0
	movl	$0,U_$MOUSE_$$_MOUSEY
	jmp	.Lj49
.Lj48:
# [116] else if MouseY > RHeight - 16 then
	movl	U_$VIDEO_$$_RHEIGHT,%eax
	leal	-16(%eax),%eax
	cmpl	U_$MOUSE_$$_MOUSEY,%eax
	jl	.Lj50
	jmp	.Lj51
.Lj50:
# [117] MouseY := RHeight - 16;
	movl	U_$VIDEO_$$_RHEIGHT,%eax
	leal	-16(%eax),%eax
	movl	%eax,U_$MOUSE_$$_MOUSEY
	.balign 4,0x90
.Lj51:
.Lj49:
	jmp	.Lj27
	.balign 4,0x90
.Lj28:
	.balign 4,0x90
.Lj27:
# [120] PacketPos := (PacketPos + 1) mod 3;
	movl	U_$MOUSE_$$_PACKETPOS,%eax
	leal	1(%eax),%eax
	cltd
	movl	$3,%ecx
	idivl	%ecx
	movl	%edx,U_$MOUSE_$$_PACKETPOS
# [121] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_mouse_$$_mousepoll,"x"
	.balign 16,0x90
.globl	MOUSE_$$_MOUSEPOLL
MOUSE_$$_MOUSEPOLL:
# [126] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var Status located at ebp-4, size=OS_8
# Var B located at ebp-8, size=OS_8
# [127] while True do
	jmp	.Lj55
	.balign 8,0x90
.Lj54:
# [129] Status := InB(PortStatus);
	movw	$100,%ax
	call	MOUSE_$$_INB$WORD$$BYTE
	movb	%al,-4(%ebp)
# [130] if (Status and $21) <> $21 then
	movzbw	-4(%ebp),%ax
	andw	$33,%ax
	cmpw	$33,%ax
	jne	.Lj57
	jmp	.Lj58
.Lj57:
# [131] Exit;
	jmp	.Lj52
	.balign 4,0x90
.Lj58:
# [132] B := InB(PortData);
	movw	$96,%ax
	call	MOUSE_$$_INB$WORD$$BYTE
	movb	%al,-8(%ebp)
# [133] MouseDeliver(B);
	movb	-8(%ebp),%al
	call	MOUSE_$$_MOUSEDELIVER$BYTE
.Lj55:
	jmp	.Lj54
.Lj52:
# [135] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_mouse_$$_getmousex$$longint,"x"
	.balign 16,0x90
.globl	MOUSE_$$_GETMOUSEX$$LONGINT
MOUSE_$$_GETMOUSEX$$LONGINT:
# [138] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-4(%esp),%esp
# Var $result located at ebp-4, size=OS_S32
# [139] GetMouseX := MouseX;
	movl	U_$MOUSE_$$_MOUSEX,%eax
	movl	%eax,-4(%ebp)
# [140] end;
	movl	-4(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_mouse_$$_getmousey$$longint,"x"
	.balign 16,0x90
.globl	MOUSE_$$_GETMOUSEY$$LONGINT
MOUSE_$$_GETMOUSEY$$LONGINT:
# [143] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-4(%esp),%esp
# Var $result located at ebp-4, size=OS_S32
# [144] GetMouseY := MouseY;
	movl	U_$MOUSE_$$_MOUSEY,%eax
	movl	%eax,-4(%ebp)
# [145] end;
	movl	-4(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_mouse_$$_getmousebuttons$$byte,"x"
	.balign 16,0x90
.globl	MOUSE_$$_GETMOUSEBUTTONS$$BYTE
MOUSE_$$_GETMOUSEBUTTONS$$BYTE:
# [148] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-4(%esp),%esp
# Var $result located at ebp-4, size=OS_8
# [149] GetMouseButtons := MouseButtons;
	movb	U_$MOUSE_$$_MOUSEBUTTONS,%al
	movb	%al,-4(%ebp)
# [150] end;
	movb	-4(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret
# End asmlist al_procedures
# Begin asmlist al_globals

.section .bss
	.balign 4
# [25] MouseX, MouseY: Integer;
U_$MOUSE_$$_MOUSEX:
	.zero 4

.section .bss
	.balign 4
U_$MOUSE_$$_MOUSEY:
	.zero 4

.section .bss
# [26] MouseButtons: Byte;
U_$MOUSE_$$_MOUSEBUTTONS:
	.zero 1

.section .bss
# [27] Packet: array[0..2] of Byte;
U_$MOUSE_$$_PACKET:
	.zero 3

.section .bss
	.balign 4
# [28] PacketPos: Integer;
U_$MOUSE_$$_PACKETPOS:
	.zero 4
# End asmlist al_globals

