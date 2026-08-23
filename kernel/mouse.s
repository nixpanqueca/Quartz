	.file "mouse.pas"
# Begin asmlist al_procedures

.section .text.n_mouse_$$_outb$word$byte,"x"
	.balign 16,0x90
MOUSE_$$_OUTB$WORD$BYTE:
# [mouse.pas]
# [30] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var Addr located at ebp-4, size=OS_16
# Var Value located at ebp-8, size=OS_8
	movw	%ax,-4(%ebp)
	movb	%dl,-8(%ebp)
#  CPU PENTIUM
# [32] mov dx, Addr
	movw	-4(%ebp),%dx
# [33] mov al, Value
	movb	-8(%ebp),%al
# [34] out dx, al
	outb	%al,%dx
#  CPU PENTIUM
# [36] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_mouse_$$_inb$word$$byte,"x"
	.balign 16,0x90
MOUSE_$$_INB$WORD$$BYTE:
# [41] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-12(%esp),%esp
# Var Addr located at ebp-4, size=OS_16
# Var $result located at ebp-8, size=OS_8
# Var B located at ebp-12, size=OS_8
	movw	%ax,-4(%ebp)
#  CPU PENTIUM
# [43] mov dx, Addr
	movw	-4(%ebp),%dx
# [44] in al, dx
	inb	%dx,%al
# [45] mov B, al
	movb	%al,-12(%ebp)
#  CPU PENTIUM
# [47] InB := B;
	movb	-12(%ebp),%al
	movb	%al,-8(%ebp)
# [48] end;
	movb	-8(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_mouse_$$_waitinputempty,"x"
	.balign 16,0x90
MOUSE_$$_WAITINPUTEMPTY:
# [53] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-4(%esp),%esp
# Var i located at ebp-4, size=OS_S32
# [54] i := 0;
	movl	$0,-4(%ebp)
# [55] while ((InB(PortStatus) and $02) <> 0) and (i < 100000) do
	jmp	.Lj10
	.balign 8,0x90
.Lj9:
# [56] Inc(i);
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
# [57] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_mouse_$$_waitoutputfull,"x"
	.balign 16,0x90
MOUSE_$$_WAITOUTPUTFULL:
# [62] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-4(%esp),%esp
# Var i located at ebp-4, size=OS_S32
# [63] i := 0;
	movl	$0,-4(%ebp)
# [64] while ((InB(PortStatus) and $01) = 0) and (i < 100000) do
	jmp	.Lj18
	.balign 8,0x90
.Lj17:
# [65] Inc(i);
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
# [66] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_mouse_$$_mouseinit,"x"
	.balign 16,0x90
.globl	MOUSE_$$_MOUSEINIT
MOUSE_$$_MOUSEINIT:
# [69] begin
	pushl	%ebp
	movl	%esp,%ebp
# [70] MouseX := 0;
	movl	$0,U_$MOUSE_$$_MOUSEX
# [71] MouseY := 0;
	movl	$0,U_$MOUSE_$$_MOUSEY
# [72] MouseButtons := 0;
	movb	$0,U_$MOUSE_$$_MOUSEBUTTONS
# [73] PacketPos := 0;
	movl	$0,U_$MOUSE_$$_PACKETPOS
# [75] WaitInputEmpty;
	call	MOUSE_$$_WAITINPUTEMPTY
# [76] OutB(PortStatus, $A8);        // habilita aux device (IRQ12)
	movb	$168,%dl
	movw	$100,%ax
	call	MOUSE_$$_OUTB$WORD$BYTE
# [77] WaitInputEmpty;
	call	MOUSE_$$_WAITINPUTEMPTY
# [78] OutB(PortStatus, $D4);        // proxima escrita vai para o mouse
	movb	$212,%dl
	movw	$100,%ax
	call	MOUSE_$$_OUTB$WORD$BYTE
# [79] WaitInputEmpty;
	call	MOUSE_$$_WAITINPUTEMPTY
# [80] OutB(PortData, $F4);          // habilita envio de pacotes
	movb	$244,%dl
	movw	$96,%ax
	call	MOUSE_$$_OUTB$WORD$BYTE
# [82] WaitOutputFull;
	call	MOUSE_$$_WAITOUTPUTFULL
# [83] InB(PortData);                // descarta o ACK (0xFA)
	movw	$96,%ax
	call	MOUSE_$$_INB$WORD$$BYTE
# [84] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_mouse_$$_mousepoll,"x"
	.balign 16,0x90
.globl	MOUSE_$$_MOUSEPOLL
MOUSE_$$_MOUSEPOLL:
# [89] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var Status located at ebp-4, size=OS_8
# Var B located at ebp-8, size=OS_8
# [90] while True do
	jmp	.Lj28
	.balign 8,0x90
.Lj27:
# [92] Status := InB(PortStatus);
	movw	$100,%ax
	call	MOUSE_$$_INB$WORD$$BYTE
	movb	%al,-4(%ebp)
# [93] if (Status and $21) <> $21 then
	movzbw	-4(%ebp),%ax
	andw	$33,%ax
	cmpw	$33,%ax
	jne	.Lj30
	jmp	.Lj31
.Lj30:
# [94] Exit;
	jmp	.Lj25
	.balign 4,0x90
.Lj31:
# [95] B := InB(PortData);
	movw	$96,%ax
	call	MOUSE_$$_INB$WORD$$BYTE
	movb	%al,-8(%ebp)
# [96] case PacketPos of
	movl	U_$MOUSE_$$_PACKETPOS,%eax
	testl	%eax,%eax
	jl	.Lj33
	testl	%eax,%eax
	je	.Lj34
	subl	$1,%eax
	je	.Lj35
	subl	$1,%eax
	je	.Lj36
	jmp	.Lj33
	.balign 4,0x90
.Lj34:
# [97] 0: Packet[0] := B;
	movb	-8(%ebp),%al
	movb	%al,U_$MOUSE_$$_PACKET
	jmp	.Lj32
	.balign 4,0x90
.Lj35:
# [98] 1: Packet[1] := B;
	movb	-8(%ebp),%al
	movb	%al,U_$MOUSE_$$_PACKET+1
	jmp	.Lj32
	.balign 4,0x90
.Lj36:
# [101] Packet[2] := B;
	movb	-8(%ebp),%al
	movb	%al,U_$MOUSE_$$_PACKET+2
# [102] if (Packet[0] and $40) = 0 then
	movzbw	U_$MOUSE_$$_PACKET,%ax
	andw	$64,%ax
	testw	$-1,%ax
	je	.Lj37
	jmp	.Lj38
.Lj37:
# [104] if (Packet[0] and $10) <> 0 then
	movzbw	U_$MOUSE_$$_PACKET,%ax
	andw	$16,%ax
	testw	$-1,%ax
	jne	.Lj39
	jmp	.Lj40
.Lj39:
# [105] MouseX := MouseX + (Packet[1] - 256)
	movzbl	U_$MOUSE_$$_PACKET+1,%eax
	subl	$256,%eax
	addl	U_$MOUSE_$$_MOUSEX,%eax
	movl	%eax,U_$MOUSE_$$_MOUSEX
	jmp	.Lj41
.Lj40:
# [107] MouseX := MouseX + Packet[1];
	movzbl	U_$MOUSE_$$_PACKET+1,%eax
	addl	U_$MOUSE_$$_MOUSEX,%eax
	movl	%eax,U_$MOUSE_$$_MOUSEX
.Lj41:
	.balign 4,0x90
.Lj38:
# [109] if (Packet[0] and $80) = 0 then
	movb	U_$MOUSE_$$_PACKET,%al
	andb	$128,%al
	testb	$-1,%al
	je	.Lj42
	jmp	.Lj43
.Lj42:
# [111] if (Packet[0] and $20) <> 0 then
	movzbw	U_$MOUSE_$$_PACKET,%ax
	andw	$32,%ax
	testw	$-1,%ax
	jne	.Lj44
	jmp	.Lj45
.Lj44:
# [112] MouseY := MouseY - (Packet[2] - 256)
	movzbl	U_$MOUSE_$$_PACKET+2,%edx
	subl	$256,%edx
	movl	U_$MOUSE_$$_MOUSEY,%eax
	subl	%edx,%eax
	movl	%eax,U_$MOUSE_$$_MOUSEY
	jmp	.Lj46
.Lj45:
# [114] MouseY := MouseY - Packet[2];
	movzbl	U_$MOUSE_$$_PACKET+2,%eax
	movl	U_$MOUSE_$$_MOUSEY,%edx
	subl	%eax,%edx
	movl	%edx,U_$MOUSE_$$_MOUSEY
.Lj46:
	.balign 4,0x90
.Lj43:
# [116] MouseButtons := Packet[0] and $03;
	movzbw	U_$MOUSE_$$_PACKET,%ax
	andw	$3,%ax
	movb	%al,U_$MOUSE_$$_MOUSEBUTTONS
# [117] if MouseX < 0 then
	cmpl	$0,U_$MOUSE_$$_MOUSEX
	jl	.Lj47
	jmp	.Lj48
.Lj47:
# [118] MouseX := 0
	movl	$0,U_$MOUSE_$$_MOUSEX
	jmp	.Lj49
.Lj48:
# [119] else if MouseX > RWidth - 16 then
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-16(%eax),%eax
	cmpl	U_$MOUSE_$$_MOUSEX,%eax
	jl	.Lj50
	jmp	.Lj51
.Lj50:
# [120] MouseX := RWidth - 16;
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-16(%eax),%eax
	movl	%eax,U_$MOUSE_$$_MOUSEX
	.balign 4,0x90
.Lj51:
.Lj49:
# [121] if MouseY < 0 then
	cmpl	$0,U_$MOUSE_$$_MOUSEY
	jl	.Lj52
	jmp	.Lj53
.Lj52:
# [122] MouseY := 0
	movl	$0,U_$MOUSE_$$_MOUSEY
	jmp	.Lj54
.Lj53:
# [123] else if MouseY > RHeight - 16 then
	movl	U_$VIDEO_$$_RHEIGHT,%eax
	leal	-16(%eax),%eax
	cmpl	U_$MOUSE_$$_MOUSEY,%eax
	jl	.Lj55
	jmp	.Lj56
.Lj55:
# [124] MouseY := RHeight - 16;
	movl	U_$VIDEO_$$_RHEIGHT,%eax
	leal	-16(%eax),%eax
	movl	%eax,U_$MOUSE_$$_MOUSEY
	.balign 4,0x90
.Lj56:
.Lj54:
	jmp	.Lj32
	.balign 4,0x90
.Lj33:
	.balign 4,0x90
.Lj32:
# [127] PacketPos := (PacketPos + 1) mod 3;
	movl	U_$MOUSE_$$_PACKETPOS,%eax
	leal	1(%eax),%eax
	cltd
	movl	$3,%ecx
	idivl	%ecx
	movl	%edx,U_$MOUSE_$$_PACKETPOS
.Lj28:
	jmp	.Lj27
.Lj25:
# [129] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_mouse_$$_getmousex$$longint,"x"
	.balign 16,0x90
.globl	MOUSE_$$_GETMOUSEX$$LONGINT
MOUSE_$$_GETMOUSEX$$LONGINT:
# [132] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-4(%esp),%esp
# Var $result located at ebp-4, size=OS_S32
# [133] GetMouseX := MouseX;
	movl	U_$MOUSE_$$_MOUSEX,%eax
	movl	%eax,-4(%ebp)
# [134] end;
	movl	-4(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_mouse_$$_getmousey$$longint,"x"
	.balign 16,0x90
.globl	MOUSE_$$_GETMOUSEY$$LONGINT
MOUSE_$$_GETMOUSEY$$LONGINT:
# [137] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-4(%esp),%esp
# Var $result located at ebp-4, size=OS_S32
# [138] GetMouseY := MouseY;
	movl	U_$MOUSE_$$_MOUSEY,%eax
	movl	%eax,-4(%ebp)
# [139] end;
	movl	-4(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_mouse_$$_getmousebuttons$$byte,"x"
	.balign 16,0x90
.globl	MOUSE_$$_GETMOUSEBUTTONS$$BYTE
MOUSE_$$_GETMOUSEBUTTONS$$BYTE:
# [142] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-4(%esp),%esp
# Var $result located at ebp-4, size=OS_8
# [143] GetMouseButtons := MouseButtons;
	movb	U_$MOUSE_$$_MOUSEBUTTONS,%al
	movb	%al,-4(%ebp)
# [144] end;
	movb	-4(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret
# End asmlist al_procedures
# Begin asmlist al_globals

.section .bss
	.balign 4
# [24] MouseX, MouseY: Integer;
U_$MOUSE_$$_MOUSEX:
	.zero 4

.section .bss
	.balign 4
U_$MOUSE_$$_MOUSEY:
	.zero 4

.section .bss
# [25] MouseButtons: Byte;
U_$MOUSE_$$_MOUSEBUTTONS:
	.zero 1

.section .bss
# [26] Packet: array[0..2] of Byte;
U_$MOUSE_$$_PACKET:
	.zero 3

.section .bss
	.balign 4
# [27] PacketPos: Integer;
U_$MOUSE_$$_PACKETPOS:
	.zero 4
# End asmlist al_globals

