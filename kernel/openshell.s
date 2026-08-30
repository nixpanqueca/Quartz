	.file "openshell.pas"
# Begin asmlist al_procedures

.section .text.n_openshell_$$_scantochar$byte$$char,"x"
	.balign 16,0x90
OPENSHELL_$$_SCANTOCHAR$BYTE$$CHAR:
# [openshell.pas]
# [37] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var Sc located at ebp-4, size=OS_8
# Var $result located at ebp-8, size=OS_8
	movb	%al,-4(%ebp)
# [38] case Sc of
	movb	-4(%ebp),%al
	cmpb	$2,%al
	jb	.Lj6
	subb	$2,%al
	je	.Lj7
	subb	$1,%al
	je	.Lj8
	subb	$1,%al
	je	.Lj9
	subb	$1,%al
	je	.Lj10
	subb	$1,%al
	je	.Lj11
	subb	$1,%al
	je	.Lj12
	subb	$1,%al
	je	.Lj13
	subb	$1,%al
	je	.Lj14
	subb	$1,%al
	je	.Lj15
	subb	$1,%al
	je	.Lj16
	subb	$1,%al
	je	.Lj44
	subb	$1,%al
	je	.Lj54
	subb	$3,%al
	je	.Lj17
	subb	$1,%al
	je	.Lj18
	subb	$1,%al
	je	.Lj19
	subb	$1,%al
	je	.Lj20
	subb	$1,%al
	je	.Lj21
	subb	$1,%al
	je	.Lj22
	subb	$1,%al
	je	.Lj23
	subb	$1,%al
	je	.Lj24
	subb	$1,%al
	je	.Lj25
	subb	$1,%al
	je	.Lj26
	subb	$1,%al
	je	.Lj45
	subb	$1,%al
	je	.Lj46
	subb	$3,%al
	je	.Lj27
	subb	$1,%al
	je	.Lj28
	subb	$1,%al
	je	.Lj29
	subb	$1,%al
	je	.Lj30
	subb	$1,%al
	je	.Lj31
	subb	$1,%al
	je	.Lj32
	subb	$1,%al
	je	.Lj33
	subb	$1,%al
	je	.Lj34
	subb	$1,%al
	je	.Lj35
	subb	$1,%al
	je	.Lj47
	subb	$1,%al
	je	.Lj48
	subb	$1,%al
	je	.Lj49
	subb	$2,%al
	je	.Lj50
	subb	$1,%al
	je	.Lj36
	subb	$1,%al
	je	.Lj37
	subb	$1,%al
	je	.Lj38
	subb	$1,%al
	je	.Lj39
	subb	$1,%al
	je	.Lj40
	subb	$1,%al
	je	.Lj41
	subb	$1,%al
	je	.Lj42
	subb	$1,%al
	je	.Lj51
	subb	$1,%al
	je	.Lj52
	subb	$1,%al
	je	.Lj53
	subb	$4,%al
	je	.Lj43
	jmp	.Lj6
	.balign 4,0x90
.Lj7:
# [39] $02: ScanToChar := '1'; $03: ScanToChar := '2'; $04: ScanToChar := '3';
	movb	$49,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj8:
	movb	$50,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj9:
	movb	$51,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj10:
# [40] $05: ScanToChar := '4'; $06: ScanToChar := '5'; $07: ScanToChar := '6';
	movb	$52,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj11:
	movb	$53,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj12:
	movb	$54,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj13:
# [41] $08: ScanToChar := '7'; $09: ScanToChar := '8'; $0A: ScanToChar := '9';
	movb	$55,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj14:
	movb	$56,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj15:
	movb	$57,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj16:
# [42] $0B: ScanToChar := '0';
	movb	$48,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj17:
# [43] $10: ScanToChar := 'q'; $11: ScanToChar := 'w'; $12: ScanToChar := 'e';
	movb	$113,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj18:
	movb	$119,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj19:
	movb	$101,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj20:
# [44] $13: ScanToChar := 'r'; $14: ScanToChar := 't'; $15: ScanToChar := 'y';
	movb	$114,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj21:
	movb	$116,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj22:
	movb	$121,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj23:
# [45] $16: ScanToChar := 'u'; $17: ScanToChar := 'i'; $18: ScanToChar := 'o';
	movb	$117,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj24:
	movb	$105,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj25:
	movb	$111,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj26:
# [46] $19: ScanToChar := 'p';
	movb	$112,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj27:
# [47] $1E: ScanToChar := 'a'; $1F: ScanToChar := 's'; $20: ScanToChar := 'd';
	movb	$97,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj28:
	movb	$115,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj29:
	movb	$100,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj30:
# [48] $21: ScanToChar := 'f'; $22: ScanToChar := 'g'; $23: ScanToChar := 'h';
	movb	$102,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj31:
	movb	$103,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj32:
	movb	$104,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj33:
# [49] $24: ScanToChar := 'j'; $25: ScanToChar := 'k'; $26: ScanToChar := 'l';
	movb	$106,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj34:
	movb	$107,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj35:
	movb	$108,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj36:
# [50] $2C: ScanToChar := 'z'; $2D: ScanToChar := 'x'; $2E: ScanToChar := 'c';
	movb	$122,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj37:
	movb	$120,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj38:
	movb	$99,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj39:
# [51] $2F: ScanToChar := 'v'; $30: ScanToChar := 'b'; $31: ScanToChar := 'n';
	movb	$118,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj40:
	movb	$98,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj41:
	movb	$110,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj42:
# [52] $32: ScanToChar := 'm';
	movb	$109,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj43:
# [53] $39: ScanToChar := ' ';
	movb	$32,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj44:
# [54] $0C: ScanToChar := '-'; $1A: ScanToChar := '['; $1B: ScanToChar := ']';
	movb	$45,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj45:
	movb	$91,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj46:
	movb	$93,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj47:
# [55] $27: ScanToChar := ';'; $28: ScanToChar := ''''; $29: ScanToChar := '`';
	movb	$59,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj48:
	movb	$39,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj49:
	movb	$96,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj50:
# [56] $2B: ScanToChar := '\'; $33: ScanToChar := ','; $34: ScanToChar := '.';
	movb	$92,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj51:
	movb	$44,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj52:
	movb	$46,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj53:
# [57] $35: ScanToChar := '/'; $0D: ScanToChar := '=';
	movb	$47,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj54:
	movb	$61,-8(%ebp)
	jmp	.Lj5
	.balign 4,0x90
.Lj6:
# [59] ScanToChar := #0;
	movb	$0,-8(%ebp)
	.balign 4,0x90
.Lj5:
# [61] end;
	movb	-8(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_openshell_$$_upperchar$char$$char,"x"
	.balign 16,0x90
OPENSHELL_$$_UPPERCHAR$CHAR$$CHAR:
# [64] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var C located at ebp-4, size=OS_8
# Var $result located at ebp-8, size=OS_8
	movb	%al,-4(%ebp)
# [65] if (C >= 'a') and (C <= 'z') then
	cmpb	$97,-4(%ebp)
	jae	.Lj57
	jmp	.Lj58
.Lj57:
	cmpb	$122,-4(%ebp)
	jbe	.Lj59
	jmp	.Lj58
.Lj59:
# [66] UpperChar := Char(Ord(C) - 32)
	movzbl	-4(%ebp),%eax
	subl	$32,%eax
	movb	%al,-8(%ebp)
	jmp	.Lj60
.Lj58:
# [68] UpperChar := C;
	movb	-4(%ebp),%al
	movb	%al,-8(%ebp)
.Lj60:
# [69] end;
	movb	-8(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_openshell_$$_startswith$pchar$longint$pchar$$boolean,"x"
	.balign 16,0x90
OPENSHELL_$$_STARTSWITH$PCHAR$LONGINT$PCHAR$$BOOLEAN:
# [74] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-20(%esp),%esp
	pushl	%ebx
# Var Line located at ebp-4, size=OS_32
# Var Len located at ebp-8, size=OS_S32
# Var Prefix located at ebp-12, size=OS_32
# Var $result located at ebp-16, size=OS_8
# Var I located at ebp-20, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [75] StartsWith := False;
	movb	$0,-16(%ebp)
# [76] I := 0;
	movl	$0,-20(%ebp)
# [77] while (Prefix[I] <> #0) and (I < Len) do
	jmp	.Lj64
	.balign 8,0x90
.Lj63:
# [79] if UpperChar(Line[I]) <> UpperChar(Prefix[I]) then
	movl	-4(%ebp),%edx
	movl	-20(%ebp),%eax
	movb	(%edx,%eax,1),%al
	call	OPENSHELL_$$_UPPERCHAR$CHAR$$CHAR
	movb	%al,%bl
	movl	-12(%ebp),%edx
	movl	-20(%ebp),%eax
	movb	(%edx,%eax,1),%al
	call	OPENSHELL_$$_UPPERCHAR$CHAR$$CHAR
	cmpb	%al,%bl
	jne	.Lj66
	jmp	.Lj67
.Lj66:
# [80] Exit;
	jmp	.Lj61
	.balign 4,0x90
.Lj67:
# [81] Inc(I);
	addl	$1,-20(%ebp)
.Lj64:
	movl	-12(%ebp),%eax
	movl	-20(%ebp),%edx
	cmpb	$0,(%eax,%edx,1)
	jne	.Lj68
	jmp	.Lj69
.Lj68:
	movl	-20(%ebp),%eax
	cmpl	-8(%ebp),%eax
	jl	.Lj70
	jmp	.Lj69
.Lj70:
	jmp	.Lj63
.Lj69:
	jmp	.Lj65
.Lj65:
# [83] if Prefix[I] = #0 then
	movl	-12(%ebp),%eax
	movl	-20(%ebp),%edx
	cmpb	$0,(%eax,%edx,1)
	je	.Lj71
	jmp	.Lj72
.Lj71:
# [84] StartsWith := True;
	movb	$1,-16(%ebp)
	.balign 4,0x90
.Lj72:
.Lj61:
# [85] end;
	movb	-16(%ebp),%al
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_openshell_$$_extractarg$pchar$longint$pchar$longint,"x"
	.balign 16,0x90
OPENSHELL_$$_EXTRACTARG$PCHAR$LONGINT$PCHAR$LONGINT:
# [90] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-20(%esp),%esp
	pushl	%ebx
# Var Line located at ebp-4, size=OS_32
# Var Len located at ebp-8, size=OS_S32
# Var Arg located at ebp-12, size=OS_32
# Var ArgLen located at ebp+8, size=OS_32
# Var I located at ebp-16, size=OS_S32
# Var K located at ebp-20, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [91] I := 0;
	movl	$0,-16(%ebp)
# [92] while (I < Len) and (Line[I] <> ' ') do Inc(I);
	jmp	.Lj76
	.balign 8,0x90
.Lj75:
	addl	$1,-16(%ebp)
.Lj76:
	movl	-16(%ebp),%eax
	cmpl	-8(%ebp),%eax
	jl	.Lj78
	jmp	.Lj79
.Lj78:
	movl	-4(%ebp),%edx
	movl	-16(%ebp),%eax
	cmpb	$32,(%edx,%eax,1)
	jne	.Lj80
	jmp	.Lj79
.Lj80:
	jmp	.Lj75
.Lj79:
	jmp	.Lj77
.Lj77:
# [93] while (I < Len) and (Line[I] = ' ') do Inc(I);
	jmp	.Lj82
	.balign 8,0x90
.Lj81:
	addl	$1,-16(%ebp)
.Lj82:
	movl	-16(%ebp),%eax
	cmpl	-8(%ebp),%eax
	jl	.Lj84
	jmp	.Lj85
.Lj84:
	movl	-4(%ebp),%eax
	movl	-16(%ebp),%edx
	cmpb	$32,(%eax,%edx,1)
	je	.Lj86
	jmp	.Lj85
.Lj86:
	jmp	.Lj81
.Lj85:
	jmp	.Lj83
.Lj83:
# [94] K := 0;
	movl	$0,-20(%ebp)
# [95] while (I < Len) and (K < 63) do
	jmp	.Lj88
	.balign 8,0x90
.Lj87:
# [97] Arg[K] := Line[I];
	movl	-12(%ebp),%ecx
	movl	-20(%ebp),%ebx
	movl	-4(%ebp),%eax
	movl	-16(%ebp),%edx
	movb	(%eax,%edx,1),%al
	movb	%al,(%ecx,%ebx,1)
# [98] Inc(K);
	addl	$1,-20(%ebp)
# [99] Inc(I);
	addl	$1,-16(%ebp)
.Lj88:
	movl	-16(%ebp),%eax
	cmpl	-8(%ebp),%eax
	jl	.Lj90
	jmp	.Lj91
.Lj90:
	cmpl	$63,-20(%ebp)
	jl	.Lj92
	jmp	.Lj91
.Lj92:
	jmp	.Lj87
.Lj91:
	jmp	.Lj89
.Lj89:
# [101] Arg[K] := #0;
	movl	-12(%ebp),%eax
	movl	-20(%ebp),%edx
	movb	$0,(%eax,%edx,1)
# [102] ArgLen := K;
	movl	8(%ebp),%eax
	movl	-20(%ebp),%edx
	movl	%edx,(%eax)
# [103] end;
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret	$4

.section .text.n_openshell_$$_upstr$char$$char,"x"
	.balign 16,0x90
OPENSHELL_$$_UPSTR$CHAR$$CHAR:
# [106] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var C located at ebp-4, size=OS_8
# Var $result located at ebp-8, size=OS_8
	movb	%al,-4(%ebp)
# [107] if (C >= 'a') and (C <= 'z') then
	cmpb	$97,-4(%ebp)
	jae	.Lj95
	jmp	.Lj96
.Lj95:
	cmpb	$122,-4(%ebp)
	jbe	.Lj97
	jmp	.Lj96
.Lj97:
# [108] UpStr := Char(Ord(C) - 32)
	movzbl	-4(%ebp),%eax
	subl	$32,%eax
	movb	%al,-8(%ebp)
	jmp	.Lj98
.Lj96:
# [110] UpStr := C;
	movb	-4(%ebp),%al
	movb	%al,-8(%ebp)
.Lj98:
# [111] end;
	movb	-8(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_openshell_$$_runscript$pchar$longint$longint$boolean$$longint,"x"
	.balign 16,0x90
OPENSHELL_$$_RUNSCRIPT$PCHAR$LONGINT$LONGINT$BOOLEAN$$LONGINT:
# [128] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-160(%esp),%esp
# Var Data located at ebp-4, size=OS_32
# Var Size located at ebp-8, size=OS_S32
# Var CY located at ebp-12, size=OS_32
# Var Silent located at ebp+8, size=OS_8
# Var $result located at ebp-16, size=OS_S32
# Var P located at ebp-20, size=OS_S32
# Var Line located at ebp-148, size=OS_NO
# Var LLen located at ebp-152, size=OS_S32
# Var Res located at ebp-156, size=OS_S32
# Var Visible located at ebp-160, size=OS_8
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [129] Visible := not Silent;
	cmpb	$0,8(%ebp)
	seteb	-160(%ebp)
# [130] P := 0;
	movl	$0,-20(%ebp)
# [131] while P < Size do
	jmp	.Lj102
	.balign 8,0x90
.Lj101:
# [133] LLen := 0;
	movl	$0,-152(%ebp)
# [134] while (P < Size) and (Data[P] <> #10) and (Data[P] <> #13) and (LLen < MAXLINE - 1) do
	jmp	.Lj105
	.balign 8,0x90
.Lj104:
# [136] Line[LLen] := Data[P];
	movl	-4(%ebp),%eax
	movl	-20(%ebp),%edx
	movl	-152(%ebp),%ecx
	movb	(%eax,%edx,1),%al
	movb	%al,-148(%ebp,%ecx,1)
# [137] Inc(LLen);
	addl	$1,-152(%ebp)
# [138] Inc(P);
	addl	$1,-20(%ebp)
.Lj105:
	movl	-20(%ebp),%eax
	cmpl	-8(%ebp),%eax
	jl	.Lj107
	jmp	.Lj108
.Lj107:
	movl	-4(%ebp),%edx
	movl	-20(%ebp),%eax
	cmpb	$10,(%edx,%eax,1)
	jne	.Lj109
	jmp	.Lj108
.Lj109:
	movl	-4(%ebp),%edx
	movl	-20(%ebp),%eax
	cmpb	$13,(%edx,%eax,1)
	jne	.Lj110
	jmp	.Lj108
.Lj110:
	cmpl	$127,-152(%ebp)
	jl	.Lj111
	jmp	.Lj108
.Lj111:
	jmp	.Lj104
.Lj108:
	jmp	.Lj106
.Lj106:
# [140] if (P < Size) and (Data[P] = #13) then Inc(P);
	movl	-20(%ebp),%eax
	cmpl	-8(%ebp),%eax
	jl	.Lj112
	jmp	.Lj113
.Lj112:
	movl	-4(%ebp),%eax
	movl	-20(%ebp),%edx
	cmpb	$13,(%eax,%edx,1)
	je	.Lj114
	jmp	.Lj113
.Lj114:
	addl	$1,-20(%ebp)
	.balign 4,0x90
.Lj113:
# [141] if (P < Size) and (Data[P] = #10) then Inc(P);
	movl	-20(%ebp),%eax
	cmpl	-8(%ebp),%eax
	jl	.Lj115
	jmp	.Lj116
.Lj115:
	movl	-4(%ebp),%edx
	movl	-20(%ebp),%eax
	cmpb	$10,(%edx,%eax,1)
	je	.Lj117
	jmp	.Lj116
.Lj117:
	addl	$1,-20(%ebp)
	.balign 4,0x90
.Lj116:
# [142] Line[LLen] := #0;
	movl	-152(%ebp),%eax
	movb	$0,-148(%ebp,%eax,1)
# [143] if LLen > 0 then
	cmpl	$0,-152(%ebp)
	jg	.Lj118
	jmp	.Lj119
.Lj118:
# [145] Res := ProcCommand(@Line[0], LLen, CY, not Visible);
	cmpb	$0,-160(%ebp)
	seteb	%al
	pushl	%eax
	movl	-12(%ebp),%ecx
	leal	-148(%ebp),%eax
	movl	-152(%ebp),%edx
	call	OPENSHELL_$$_PROCCOMMAND$PCHAR$LONGINT$LONGINT$BOOLEAN$$LONGINT
	movl	%eax,-156(%ebp)
# [146] if Res = CMD_OPEN then
	cmpl	$2,-156(%ebp)
	je	.Lj120
	jmp	.Lj121
.Lj120:
# [147] Visible := True;
	movb	$1,-160(%ebp)
	.balign 4,0x90
.Lj121:
# [148] if Res = CMD_EXIT then
	cmpl	$1,-156(%ebp)
	je	.Lj122
	jmp	.Lj123
.Lj122:
# [150] RunScript := CMD_CLOSE;
	movl	$3,-16(%ebp)
# [151] Exit;
	jmp	.Lj99
	.balign 4,0x90
.Lj123:
	.balign 4,0x90
.Lj119:
.Lj102:
	movl	-20(%ebp),%eax
	cmpl	-8(%ebp),%eax
	jl	.Lj101
	jmp	.Lj103
.Lj103:
# [155] if Visible then
	cmpb	$0,-160(%ebp)
	jne	.Lj124
	jmp	.Lj125
.Lj124:
# [156] RunScript := CMD_OPEN
	movl	$2,-16(%ebp)
	jmp	.Lj126
.Lj125:
# [158] RunScript := CMD_CLOSE;
	movl	$3,-16(%ebp)
.Lj126:
.Lj99:
# [159] end;
	movl	-16(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret	$4

.section .text.n_openshell_$$_shellrunfile$pchar$boolean$$longint,"x"
	.balign 16,0x90
.globl	OPENSHELL_$$_SHELLRUNFILE$PCHAR$BOOLEAN$$LONGINT
OPENSHELL_$$_SHELLRUNFILE$PCHAR$BOOLEAN$$LONGINT:
# [167] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-20(%esp),%esp
# Var Path located at ebp-4, size=OS_32
# Var Silent located at ebp-8, size=OS_8
# Var $result located at ebp-12, size=OS_S32
# Var N located at ebp-16, size=OS_S32
# Var CY located at ebp-20, size=OS_S32
	movl	%eax,-4(%ebp)
	movb	%dl,-8(%ebp)
# [168] N := FSReadFile(Path, @ScriptBuf[0], SCRIPT_MAX);
	movl	$U_$OPENSHELL_$$_SCRIPTBUF,%eax
	movl	%eax,%edx
	movl	-4(%ebp),%eax
	movl	$8192,%ecx
	call	CDROM_$$_FSREADFILE$PCHAR$PBYTE$LONGWORD$$LONGINT
	movl	%eax,-16(%ebp)
# [169] if N <= 0 then
	cmpl	$0,-16(%ebp)
	jle	.Lj129
	jmp	.Lj130
.Lj129:
# [171] SerialWriteString('runfile: nao encontrado ');
	movl	$_$OPENSHELL$_Ld1,%eax
	call	SERIAL_$$_SERIALWRITESTRING$PCHAR
# [172] SerialWriteString(Path);
	movl	-4(%ebp),%eax
	call	SERIAL_$$_SERIALWRITESTRING$PCHAR
# [173] SerialWriteChar(#13);
	movb	$13,%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
# [174] SerialWriteChar(#10);
	movb	$10,%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
# [175] ShellRunFile := CMD_CLOSE;
	movl	$3,-12(%ebp)
# [176] Exit;
	jmp	.Lj127
	.balign 4,0x90
.Lj130:
# [178] SerialWriteString('runfile: executando ');
	movl	$_$OPENSHELL$_Ld2,%eax
	call	SERIAL_$$_SERIALWRITESTRING$PCHAR
# [179] SerialWriteString(Path);
	movl	-4(%ebp),%eax
	call	SERIAL_$$_SERIALWRITESTRING$PCHAR
# [180] SerialWriteChar(#13);
	movb	$13,%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
# [181] SerialWriteChar(#10);
	movb	$10,%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
# [182] CY := 60;
	movl	$60,-20(%ebp)
# [183] ShellRunFile := RunScript(@ScriptBuf[0], N, CY, Silent);
	movzbl	-8(%ebp),%eax
	pushl	%eax
	movl	$U_$OPENSHELL_$$_SCRIPTBUF,%eax
	leal	-20(%ebp),%ecx
	movl	-16(%ebp),%edx
	call	OPENSHELL_$$_RUNSCRIPT$PCHAR$LONGINT$LONGINT$BOOLEAN$$LONGINT
	movl	%eax,-12(%ebp)
.Lj127:
# [184] end;
	movl	-12(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_openshell_$$_proccommand$pchar$longint$longint$boolean$$longint,"x"
	.balign 16,0x90
OPENSHELL_$$_PROCCOMMAND$PCHAR$LONGINT$LONGINT$BOOLEAN$$LONGINT:
# [195] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-208(%esp),%esp
	pushl	%ebx
# Var Line located at ebp-4, size=OS_32
# Var Len located at ebp-8, size=OS_S32
# Var CY located at ebp-12, size=OS_32
# Var Silent located at ebp+8, size=OS_8
# Var $result located at ebp-16, size=OS_S32
# Var Arg located at ebp-80, size=OS_NO
# Var Path located at ebp-176, size=OS_NO
# Var ArgLen located at ebp-180, size=OS_S32
# Var I located at ebp-184, size=OS_S32
# Var J located at ebp-188, size=OS_S32
# Var K located at ebp-192, size=OS_S32
# Var N located at ebp-196, size=OS_S32
# Var Ok located at ebp-200, size=OS_8
# Var HasExt located at ebp-204, size=OS_8
# Var HasPath located at ebp-208, size=OS_8
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [196] ProcCommand := CMD_CONTINUE;
	movl	$0,-16(%ebp)
# [197] if Len >= 64 then Len := 64;
	cmpl	$64,-8(%ebp)
	jge	.Lj133
	jmp	.Lj134
.Lj133:
	movl	$64,-8(%ebp)
	.balign 4,0x90
.Lj134:
# [198] if StartsWith(Line, Len, 'help') then
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	movl	$_$OPENSHELL$_Ld3,%ecx
	call	OPENSHELL_$$_STARTSWITH$PCHAR$LONGINT$PCHAR$$BOOLEAN
	testb	%al,%al
	jne	.Lj135
	jmp	.Lj136
.Lj135:
# [200] if not Silent then
	cmpb	$0,8(%ebp)
	je	.Lj137
	jmp	.Lj138
.Lj137:
# [202] CY := CY + 16;
	movl	-12(%ebp),%eax
	movl	(%eax),%eax
	leal	16(%eax),%edx
	movl	-12(%ebp),%eax
	movl	%edx,(%eax)
# [203] WriteAt(3, CY, 'Comandos: run <NOME>, file <ARQ.RUN>, cls, help, exit', 12);
	pushl	$12
	movl	-12(%ebp),%eax
	movl	(%eax),%edx
	movl	$_$OPENSHELL$_Ld4,%ecx
	movl	$3,%eax
	call	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
	.balign 4,0x90
.Lj138:
	jmp	.Lj139
.Lj136:
# [206] else if StartsWith(Line, Len, 'cls') and (Len = 3) then
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	movl	$_$OPENSHELL$_Ld5,%ecx
	call	OPENSHELL_$$_STARTSWITH$PCHAR$LONGINT$PCHAR$$BOOLEAN
	testb	%al,%al
	jne	.Lj140
	jmp	.Lj141
.Lj140:
	cmpl	$3,-8(%ebp)
	je	.Lj142
	jmp	.Lj141
.Lj142:
# [208] if Silent then
	cmpb	$0,8(%ebp)
	jne	.Lj143
	jmp	.Lj144
.Lj143:
# [211] ClearScreen($0F);
	movb	$15,%al
	call	VIDEO_$$_CLEARSCREEN$BYTE
# [212] WriteAt(3, 3, 'Aether OpenShell', 16);
	pushl	$16
	movl	$_$OPENSHELL$_Ld6,%ecx
	movl	$3,%edx
	movl	$3,%eax
	call	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
# [213] WriteAt(3, 24, 'boas-vindas. digite help', 12);
	pushl	$12
	movl	$_$OPENSHELL$_Ld7,%ecx
	movl	$24,%edx
	movl	$3,%eax
	call	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
# [214] CY := 56;
	movl	-12(%ebp),%eax
	movl	$56,(%eax)
# [215] ProcCommand := CMD_OPEN;
	movl	$2,-16(%ebp)
	jmp	.Lj145
.Lj144:
# [219] ClearScreen($0F);
	movb	$15,%al
	call	VIDEO_$$_CLEARSCREEN$BYTE
# [220] WriteAt(3, 3, 'Aether OpenShell', 16);
	pushl	$16
	movl	$_$OPENSHELL$_Ld6,%ecx
	movl	$3,%edx
	movl	$3,%eax
	call	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
# [221] WriteAt(3, 24, 'boas-vindas. digite help', 12);
	pushl	$12
	movl	$_$OPENSHELL$_Ld7,%ecx
	movl	$24,%edx
	movl	$3,%eax
	call	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
# [222] CY := 56;
	movl	-12(%ebp),%eax
	movl	$56,(%eax)
.Lj145:
	jmp	.Lj146
.Lj141:
# [225] else if StartsWith(Line, Len, 'exit') and (Len = 4) then
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	movl	$_$OPENSHELL$_Ld8,%ecx
	call	OPENSHELL_$$_STARTSWITH$PCHAR$LONGINT$PCHAR$$BOOLEAN
	testb	%al,%al
	jne	.Lj147
	jmp	.Lj148
.Lj147:
	cmpl	$4,-8(%ebp)
	je	.Lj149
	jmp	.Lj148
.Lj149:
# [227] if not Silent then
	cmpb	$0,8(%ebp)
	je	.Lj150
	jmp	.Lj151
.Lj150:
# [229] CY := CY + 16;
	movl	-12(%ebp),%eax
	movl	(%eax),%eax
	leal	16(%eax),%edx
	movl	-12(%ebp),%eax
	movl	%edx,(%eax)
# [230] WriteAt(3, CY, 'Voltando ao desktop...', 16);
	pushl	$16
	movl	-12(%ebp),%eax
	movl	(%eax),%edx
	movl	$_$OPENSHELL$_Ld9,%ecx
	movl	$3,%eax
	call	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
	.balign 4,0x90
.Lj151:
# [232] ProcCommand := CMD_EXIT;
	movl	$1,-16(%ebp)
	jmp	.Lj152
.Lj148:
# [234] else if StartsWith(Line, Len, 'run') then
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	movl	$_$OPENSHELL$_Ld10,%ecx
	call	OPENSHELL_$$_STARTSWITH$PCHAR$LONGINT$PCHAR$$BOOLEAN
	testb	%al,%al
	jne	.Lj153
	jmp	.Lj154
.Lj153:
# [236] ExtractArg(Line, Len, @Arg[0], ArgLen);
	leal	-180(%ebp),%eax
	pushl	%eax
	leal	-80(%ebp),%ecx
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	call	OPENSHELL_$$_EXTRACTARG$PCHAR$LONGINT$PCHAR$LONGINT
# [237] if ArgLen = 0 then
	cmpl	$0,-180(%ebp)
	je	.Lj155
	jmp	.Lj156
.Lj155:
# [239] if not Silent then
	cmpb	$0,8(%ebp)
	je	.Lj157
	jmp	.Lj158
.Lj157:
# [241] CY := CY + 16;
	movl	-12(%ebp),%eax
	movl	(%eax),%eax
	leal	16(%eax),%eax
	movl	-12(%ebp),%edx
	movl	%eax,(%edx)
# [242] WriteAt(3, CY, 'uso: run <NOME DO PROGRAMA>', 12);
	pushl	$12
	movl	-12(%ebp),%eax
	movl	(%eax),%edx
	movl	$_$OPENSHELL$_Ld11,%ecx
	movl	$3,%eax
	call	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
	.balign 4,0x90
.Lj158:
	jmp	.Lj159
.Lj156:
# [248] HasExt := False;
	movb	$0,-204(%ebp)
# [249] for I := 0 to ArgLen - 1 do
	movl	-180(%ebp),%eax
	leal	-1(%eax),%eax
	cmpl	$0,%eax
	jge	.Lj160
	jmp	.Lj161
.Lj160:
	movl	$-1,-184(%ebp)
	.balign 8,0x90
.Lj162:
	movl	-184(%ebp),%edx
	leal	1(%edx),%edx
	movl	%edx,-184(%ebp)
# [250] if (Arg[I] = '.') or (Arg[I] = '\') or (Arg[I] = '/') then
	movl	-184(%ebp),%edx
	cmpb	$46,-80(%ebp,%edx,1)
	je	.Lj165
	jmp	.Lj166
.Lj166:
	movl	-184(%ebp),%edx
	cmpb	$92,-80(%ebp,%edx,1)
	je	.Lj165
	jmp	.Lj167
.Lj167:
	movl	-184(%ebp),%edx
	cmpb	$47,-80(%ebp,%edx,1)
	je	.Lj165
	jmp	.Lj168
.Lj165:
# [251] HasExt := True;
	movb	$1,-204(%ebp)
	.balign 4,0x90
.Lj168:
	cmpl	-184(%ebp),%eax
	jle	.Lj164
	jmp	.Lj162
.Lj164:
	.balign 4,0x90
.Lj161:
# [254] Ok := RunProgram(@Arg[0]);
	leal	-80(%ebp),%eax
	call	SVC_$$_RUNPROGRAM$PCHAR$$BOOLEAN
	movb	%al,-200(%ebp)
# [257] if not Ok and not HasExt then
	cmpb	$0,-200(%ebp)
	je	.Lj169
	jmp	.Lj170
.Lj169:
	cmpb	$0,-204(%ebp)
	je	.Lj171
	jmp	.Lj170
.Lj171:
# [259] for I := 0 to ArgLen - 1 do
	movl	-180(%ebp),%eax
	leal	-1(%eax),%eax
	cmpl	$0,%eax
	jge	.Lj172
	jmp	.Lj173
.Lj172:
	movl	$-1,-184(%ebp)
	.balign 8,0x90
.Lj174:
	movl	-184(%ebp),%edx
	leal	1(%edx),%edx
	movl	%edx,-184(%ebp)
# [260] Path[I] := Arg[I];
	movl	-184(%ebp),%ecx
	movl	-184(%ebp),%edx
	movb	-80(%ebp,%edx,1),%dl
	movb	%dl,-176(%ebp,%ecx,1)
	cmpl	-184(%ebp),%eax
	jle	.Lj176
	jmp	.Lj174
.Lj176:
	.balign 4,0x90
.Lj173:
# [261] Path[ArgLen] := '.';
	movl	-180(%ebp),%eax
	movb	$46,-176(%ebp,%eax,1)
# [262] Path[ArgLen + 1] := 'B';
	movl	-180(%ebp),%eax
	leal	1(%eax),%eax
	movb	$66,-176(%ebp,%eax,1)
# [263] Path[ArgLen + 2] := 'I';
	movl	-180(%ebp),%eax
	leal	2(%eax),%eax
	movb	$73,-176(%ebp,%eax,1)
# [264] Path[ArgLen + 3] := 'N';
	movl	-180(%ebp),%eax
	leal	3(%eax),%eax
	movb	$78,-176(%ebp,%eax,1)
# [265] Path[ArgLen + 4] := #0;
	movl	-180(%ebp),%eax
	leal	4(%eax),%eax
	movb	$0,-176(%ebp,%eax,1)
# [266] Ok := RunProgram(@Path[0]);
	leal	-176(%ebp),%eax
	call	SVC_$$_RUNPROGRAM$PCHAR$$BOOLEAN
	movb	%al,-200(%ebp)
	.balign 4,0x90
.Lj170:
# [270] if not Ok then
	cmpb	$0,-200(%ebp)
	je	.Lj177
	jmp	.Lj178
.Lj177:
# [272] I := 0;
	movl	$0,-184(%ebp)
# [273] while I < 16 do
	jmp	.Lj180
	.balign 8,0x90
.Lj179:
# [275] Path[I] := 'SYSTEM\COMPILED\'[I + 1];
	movl	-184(%ebp),%eax
	leal	1(%eax),%eax
	movzbl	%al,%eax
	movl	-184(%ebp),%edx
	movb	_$OPENSHELL$_Ld12(,%eax,1),%al
	movb	%al,-176(%ebp,%edx,1)
# [276] Inc(I);
	addl	$1,-184(%ebp)
.Lj180:
	cmpl	$16,-184(%ebp)
	jl	.Lj179
	jmp	.Lj181
.Lj181:
# [278] for I := 0 to ArgLen - 1 do
	movl	-180(%ebp),%eax
	leal	-1(%eax),%ebx
	cmpl	$0,%ebx
	jge	.Lj182
	jmp	.Lj183
.Lj182:
	movl	$-1,-184(%ebp)
	.balign 8,0x90
.Lj184:
	movl	-184(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-184(%ebp)
# [279] Path[16 + I] := UpStr(Arg[I]);
	movl	-184(%ebp),%eax
	movb	-80(%ebp,%eax,1),%al
	call	OPENSHELL_$$_UPSTR$CHAR$$CHAR
	movl	-184(%ebp),%edx
	leal	16(%edx),%edx
	movb	%al,-176(%ebp,%edx,1)
	cmpl	-184(%ebp),%ebx
	jle	.Lj186
	jmp	.Lj184
.Lj186:
	.balign 4,0x90
.Lj183:
# [280] J := 16 + ArgLen;
	movl	-180(%ebp),%eax
	leal	16(%eax),%eax
	movl	%eax,-188(%ebp)
# [281] for I := 0 to 3 do
	movl	$-1,-184(%ebp)
	.balign 8,0x90
.Lj187:
	movl	-184(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-184(%ebp)
# [283] Path[J + I] := '.BIN'[I + 1];
	movl	-188(%ebp),%edx
	movl	-184(%ebp),%eax
	leal	(%edx,%eax),%edx
	movl	-184(%ebp),%eax
	leal	1(%eax),%eax
	movzbl	%al,%eax
	movb	_$OPENSHELL$_Ld13(,%eax,1),%al
	movb	%al,-176(%ebp,%edx,1)
	cmpl	$3,-184(%ebp)
	jge	.Lj189
	jmp	.Lj187
.Lj189:
# [285] Path[J + 4] := #0;
	movl	-188(%ebp),%eax
	leal	4(%eax),%eax
	movb	$0,-176(%ebp,%eax,1)
# [286] Ok := RunProgram(@Path[0]);
	leal	-176(%ebp),%eax
	call	SVC_$$_RUNPROGRAM$PCHAR$$BOOLEAN
	movb	%al,-200(%ebp)
	.balign 4,0x90
.Lj178:
# [289] if not Silent then
	cmpb	$0,8(%ebp)
	je	.Lj190
	jmp	.Lj191
.Lj190:
# [291] CY := CY + 16;
	movl	-12(%ebp),%eax
	movl	(%eax),%eax
	leal	16(%eax),%eax
	movl	-12(%ebp),%edx
	movl	%eax,(%edx)
# [292] WriteAt(3, CY, 'Executando ', 12);
	pushl	$12
	movl	-12(%ebp),%eax
	movl	(%eax),%edx
	movl	$_$OPENSHELL$_Ld14,%ecx
	movl	$3,%eax
	call	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
# [293] WriteAt(105, CY, @Arg[0], 12);
	pushl	$12
	leal	-80(%ebp),%ecx
	movl	-12(%ebp),%eax
	movl	(%eax),%edx
	movl	$105,%eax
	call	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
# [294] if Ok then
	cmpb	$0,-200(%ebp)
	jne	.Lj192
	jmp	.Lj193
.Lj192:
# [295] WriteAt(320, CY, '[ok]', 12)
	pushl	$12
	movl	-12(%ebp),%eax
	movl	(%eax),%edx
	movl	$_$OPENSHELL$_Ld15,%ecx
	movl	$320,%eax
	call	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
	jmp	.Lj194
.Lj193:
# [297] WriteAt(320, CY, '[nao encontrado]', 12);
	pushl	$12
	movl	-12(%ebp),%eax
	movl	(%eax),%edx
	movl	$_$OPENSHELL$_Ld16,%ecx
	movl	$320,%eax
	call	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
.Lj194:
	.balign 4,0x90
.Lj191:
# [299] SerialWriteString('shell: run ');
	movl	$_$OPENSHELL$_Ld17,%eax
	call	SERIAL_$$_SERIALWRITESTRING$PCHAR
# [300] SerialWriteString(@Arg[0]);
	leal	-80(%ebp),%eax
	call	SERIAL_$$_SERIALWRITESTRING$PCHAR
# [301] SerialWriteChar(#13);
	movb	$13,%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
# [302] SerialWriteChar(#10);
	movb	$10,%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
.Lj159:
	jmp	.Lj195
.Lj154:
# [305] else if StartsWith(Line, Len, 'file') then
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	movl	$_$OPENSHELL$_Ld18,%ecx
	call	OPENSHELL_$$_STARTSWITH$PCHAR$LONGINT$PCHAR$$BOOLEAN
	testb	%al,%al
	jne	.Lj196
	jmp	.Lj197
.Lj196:
# [307] ExtractArg(Line, Len, @Arg[0], ArgLen);
	leal	-180(%ebp),%eax
	pushl	%eax
	leal	-80(%ebp),%ecx
	movl	-8(%ebp),%edx
	movl	-4(%ebp),%eax
	call	OPENSHELL_$$_EXTRACTARG$PCHAR$LONGINT$PCHAR$LONGINT
# [308] if ArgLen = 0 then
	cmpl	$0,-180(%ebp)
	je	.Lj198
	jmp	.Lj199
.Lj198:
# [310] if not Silent then
	cmpb	$0,8(%ebp)
	je	.Lj200
	jmp	.Lj201
.Lj200:
# [312] CY := CY + 16;
	movl	-12(%ebp),%eax
	movl	(%eax),%eax
	leal	16(%eax),%edx
	movl	-12(%ebp),%eax
	movl	%edx,(%eax)
# [313] WriteAt(3, CY, 'uso: file <ARQUIVO.RUN>', 12);
	pushl	$12
	movl	-12(%ebp),%eax
	movl	(%eax),%edx
	movl	$_$OPENSHELL$_Ld19,%ecx
	movl	$3,%eax
	call	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
	.balign 4,0x90
.Lj201:
	jmp	.Lj202
.Lj199:
# [321] HasExt := False;
	movb	$0,-204(%ebp)
# [322] HasPath := False;
	movb	$0,-208(%ebp)
# [323] for I := 0 to ArgLen - 1 do
	movl	-180(%ebp),%eax
	leal	-1(%eax),%eax
	cmpl	$0,%eax
	jge	.Lj203
	jmp	.Lj204
.Lj203:
	movl	$-1,-184(%ebp)
	.balign 8,0x90
.Lj205:
	movl	-184(%ebp),%edx
	leal	1(%edx),%edx
	movl	%edx,-184(%ebp)
# [325] if (Arg[I] = '.') or (Arg[I] = '\') or (Arg[I] = '/') then
	movl	-184(%ebp),%edx
	cmpb	$46,-80(%ebp,%edx,1)
	je	.Lj208
	jmp	.Lj209
.Lj209:
	movl	-184(%ebp),%edx
	cmpb	$92,-80(%ebp,%edx,1)
	je	.Lj208
	jmp	.Lj210
.Lj210:
	movl	-184(%ebp),%edx
	cmpb	$47,-80(%ebp,%edx,1)
	je	.Lj208
	jmp	.Lj211
.Lj208:
# [326] HasExt := True;
	movb	$1,-204(%ebp)
	.balign 4,0x90
.Lj211:
# [327] if (Arg[I] = '\') or (Arg[I] = '/') then
	movl	-184(%ebp),%edx
	cmpb	$92,-80(%ebp,%edx,1)
	je	.Lj212
	jmp	.Lj213
.Lj213:
	movl	-184(%ebp),%edx
	cmpb	$47,-80(%ebp,%edx,1)
	je	.Lj212
	jmp	.Lj214
.Lj212:
# [328] HasPath := True;
	movb	$1,-208(%ebp)
	.balign 4,0x90
.Lj214:
	cmpl	-184(%ebp),%eax
	jle	.Lj207
	jmp	.Lj205
.Lj207:
	.balign 4,0x90
.Lj204:
# [331] N := 0;
	movl	$0,-196(%ebp)
# [332] K := 0;
	movl	$0,-192(%ebp)
# [334] for I := 0 to ArgLen - 1 do
	movl	-180(%ebp),%eax
	leal	-1(%eax),%ebx
	cmpl	$0,%ebx
	jge	.Lj215
	jmp	.Lj216
.Lj215:
	movl	$-1,-184(%ebp)
	.balign 8,0x90
.Lj217:
	movl	-184(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-184(%ebp)
# [335] Path[I] := UpStr(Arg[I]);
	movl	-184(%ebp),%eax
	movb	-80(%ebp,%eax,1),%al
	call	OPENSHELL_$$_UPSTR$CHAR$$CHAR
	movl	-184(%ebp),%edx
	movb	%al,-176(%ebp,%edx,1)
	cmpl	-184(%ebp),%ebx
	jle	.Lj219
	jmp	.Lj217
.Lj219:
	.balign 4,0x90
.Lj216:
# [336] K := ArgLen;
	movl	-180(%ebp),%eax
	movl	%eax,-192(%ebp)
# [337] if not HasExt then
	cmpb	$0,-204(%ebp)
	je	.Lj220
	jmp	.Lj221
.Lj220:
# [339] Path[K] := '.';
	movl	-192(%ebp),%eax
	movb	$46,-176(%ebp,%eax,1)
# [340] Path[K + 1] := 'R';
	movl	-192(%ebp),%eax
	leal	1(%eax),%eax
	movb	$82,-176(%ebp,%eax,1)
# [341] Path[K + 2] := 'U';
	movl	-192(%ebp),%eax
	leal	2(%eax),%eax
	movb	$85,-176(%ebp,%eax,1)
# [342] Path[K + 3] := 'N';
	movl	-192(%ebp),%eax
	leal	3(%eax),%eax
	movb	$78,-176(%ebp,%eax,1)
# [343] K := K + 4;
	movl	-192(%ebp),%eax
	leal	4(%eax),%eax
	movl	%eax,-192(%ebp)
	.balign 4,0x90
.Lj221:
# [345] Path[K] := #0;
	movl	-192(%ebp),%eax
	movb	$0,-176(%ebp,%eax,1)
# [346] N := FSReadFile(@Path[0], @ScriptBuf[0], SCRIPT_MAX);
	movl	$U_$OPENSHELL_$$_SCRIPTBUF,%edx
	leal	-176(%ebp),%eax
	movl	$8192,%ecx
	call	CDROM_$$_FSREADFILE$PCHAR$PBYTE$LONGWORD$$LONGINT
	movl	%eax,-196(%ebp)
# [349] if (N <= 0) and not HasPath then
	cmpl	$0,-196(%ebp)
	jle	.Lj222
	jmp	.Lj223
.Lj222:
	cmpb	$0,-208(%ebp)
	je	.Lj224
	jmp	.Lj223
.Lj224:
# [351] I := 0;
	movl	$0,-184(%ebp)
# [352] while I < 8 do
	jmp	.Lj226
	.balign 8,0x90
.Lj225:
# [354] Path[I] := 'SCRIPTS\'[I + 1];
	movl	-184(%ebp),%eax
	leal	1(%eax),%eax
	movzbl	%al,%eax
	movl	-184(%ebp),%edx
	movb	_$OPENSHELL$_Ld20(,%eax,1),%al
	movb	%al,-176(%ebp,%edx,1)
# [355] Inc(I);
	addl	$1,-184(%ebp)
.Lj226:
	cmpl	$8,-184(%ebp)
	jl	.Lj225
	jmp	.Lj227
.Lj227:
# [357] for I := 0 to ArgLen - 1 do
	movl	-180(%ebp),%eax
	leal	-1(%eax),%ebx
	cmpl	$0,%ebx
	jge	.Lj228
	jmp	.Lj229
.Lj228:
	movl	$-1,-184(%ebp)
	.balign 8,0x90
.Lj230:
	movl	-184(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-184(%ebp)
# [358] Path[8 + I] := UpStr(Arg[I]);
	movl	-184(%ebp),%eax
	movb	-80(%ebp,%eax,1),%al
	call	OPENSHELL_$$_UPSTR$CHAR$$CHAR
	movl	-184(%ebp),%edx
	leal	8(%edx),%edx
	movb	%al,-176(%ebp,%edx,1)
	cmpl	-184(%ebp),%ebx
	jle	.Lj232
	jmp	.Lj230
.Lj232:
	.balign 4,0x90
.Lj229:
# [359] K := 8 + ArgLen;
	movl	-180(%ebp),%eax
	leal	8(%eax),%eax
	movl	%eax,-192(%ebp)
# [360] if not HasExt then
	cmpb	$0,-204(%ebp)
	je	.Lj233
	jmp	.Lj234
.Lj233:
# [362] Path[K] := '.';
	movl	-192(%ebp),%eax
	movb	$46,-176(%ebp,%eax,1)
# [363] Path[K + 1] := 'R';
	movl	-192(%ebp),%eax
	leal	1(%eax),%eax
	movb	$82,-176(%ebp,%eax,1)
# [364] Path[K + 2] := 'U';
	movl	-192(%ebp),%eax
	leal	2(%eax),%eax
	movb	$85,-176(%ebp,%eax,1)
# [365] Path[K + 3] := 'N';
	movl	-192(%ebp),%eax
	leal	3(%eax),%eax
	movb	$78,-176(%ebp,%eax,1)
# [366] K := K + 4;
	movl	-192(%ebp),%eax
	leal	4(%eax),%eax
	movl	%eax,-192(%ebp)
	.balign 4,0x90
.Lj234:
# [368] Path[K] := #0;
	movl	-192(%ebp),%eax
	movb	$0,-176(%ebp,%eax,1)
# [369] N := FSReadFile(@Path[0], @ScriptBuf[0], SCRIPT_MAX);
	movl	$U_$OPENSHELL_$$_SCRIPTBUF,%edx
	leal	-176(%ebp),%eax
	movl	$8192,%ecx
	call	CDROM_$$_FSREADFILE$PCHAR$PBYTE$LONGWORD$$LONGINT
	movl	%eax,-196(%ebp)
	.balign 4,0x90
.Lj223:
# [372] if N <= 0 then
	cmpl	$0,-196(%ebp)
	jle	.Lj235
	jmp	.Lj236
.Lj235:
# [374] if not Silent then
	cmpb	$0,8(%ebp)
	je	.Lj237
	jmp	.Lj238
.Lj237:
# [376] CY := CY + 16;
	movl	-12(%ebp),%eax
	movl	(%eax),%eax
	leal	16(%eax),%eax
	movl	-12(%ebp),%edx
	movl	%eax,(%edx)
# [377] WriteAt(3, CY, 'script nao encontrado', 12);
	pushl	$12
	movl	-12(%ebp),%eax
	movl	(%eax),%edx
	movl	$_$OPENSHELL$_Ld21,%ecx
	movl	$3,%eax
	call	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
	.balign 4,0x90
.Lj238:
# [379] SerialWriteString('file: nao encontrado ');
	movl	$_$OPENSHELL$_Ld22,%eax
	call	SERIAL_$$_SERIALWRITESTRING$PCHAR
# [380] SerialWriteString(@Path[0]);
	leal	-176(%ebp),%eax
	call	SERIAL_$$_SERIALWRITESTRING$PCHAR
# [381] SerialWriteChar(#13);
	movb	$13,%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
# [382] SerialWriteChar(#10);
	movb	$10,%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
	jmp	.Lj239
.Lj236:
# [386] SerialWriteString('file: executando ');
	movl	$_$OPENSHELL$_Ld23,%eax
	call	SERIAL_$$_SERIALWRITESTRING$PCHAR
# [387] SerialWriteString(@Path[0]);
	leal	-176(%ebp),%eax
	call	SERIAL_$$_SERIALWRITESTRING$PCHAR
# [388] SerialWriteChar(#13);
	movb	$13,%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
# [389] SerialWriteChar(#10);
	movb	$10,%al
	call	SERIAL_$$_SERIALWRITECHAR$CHAR
# [390] ProcCommand := RunScript(@ScriptBuf[0], N, CY, Silent);
	movzbl	8(%ebp),%eax
	pushl	%eax
	movl	-12(%ebp),%ecx
	movl	$U_$OPENSHELL_$$_SCRIPTBUF,%eax
	movl	-196(%ebp),%edx
	call	OPENSHELL_$$_RUNSCRIPT$PCHAR$LONGINT$LONGINT$BOOLEAN$$LONGINT
	movl	%eax,-16(%ebp)
.Lj239:
.Lj202:
	jmp	.Lj240
.Lj197:
# [396] if not Silent then
	cmpb	$0,8(%ebp)
	je	.Lj241
	jmp	.Lj242
.Lj241:
# [398] CY := CY + 16;
	movl	-12(%ebp),%eax
	movl	(%eax),%eax
	leal	16(%eax),%eax
	movl	-12(%ebp),%edx
	movl	%eax,(%edx)
# [399] WriteAt(3, CY, 'comando desconhecido', 12);
	pushl	$12
	movl	-12(%ebp),%eax
	movl	(%eax),%edx
	movl	$_$OPENSHELL$_Ld24,%ecx
	movl	$3,%eax
	call	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
	.balign 4,0x90
.Lj242:
.Lj240:
.Lj195:
.Lj152:
.Lj146:
.Lj139:
# [402] if ProcCommand = CMD_CONTINUE then
	cmpl	$0,-16(%ebp)
	je	.Lj243
	jmp	.Lj244
.Lj243:
# [403] CY := CY + 16;   // linha em branco antes do proximo prompt
	movl	-12(%ebp),%eax
	movl	(%eax),%eax
	leal	16(%eax),%eax
	movl	-12(%ebp),%edx
	movl	%eax,(%edx)
	.balign 4,0x90
.Lj244:
# [404] end;
	movl	-16(%ebp),%eax
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret	$4

.section .text.n_openshell_$$_shellloop,"x"
	.balign 16,0x90
.globl	OPENSHELL_$$_SHELLLOOP
OPENSHELL_$$_SHELLLOOP:
# [411] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-152(%esp),%esp
# Var Line located at ebp-128, size=OS_NO
# Var Len located at ebp-132, size=OS_S32
# Var CX located at ebp-136, size=OS_S32
# Var CY located at ebp-140, size=OS_S32
# Var I located at ebp-144, size=OS_S32
# Var Sc located at ebp-148, size=OS_S32
# Var Ch located at ebp-152, size=OS_8
# [414] KeyboardPoll;
	call	KEYBOARD_$$_KEYBOARDPOLL
# [415] for I := 0 to 127 do
	movl	$-1,-144(%ebp)
	.balign 8,0x90
.Lj247:
	movl	-144(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-144(%ebp)
# [416] LastScan[I] := ScanIsPressed(I);
	movb	-144(%ebp),%al
	call	KEYBOARD_$$_SCANISPRESSED$BYTE$$BOOLEAN
	movl	-144(%ebp),%edx
	movb	%al,U_$OPENSHELL_$$_LASTSCAN(,%edx,1)
	cmpl	$127,-144(%ebp)
	jge	.Lj249
	jmp	.Lj247
.Lj249:
# [417] Len := 0;
	movl	$0,-132(%ebp)
# [418] ClearScreen($0F);
	movb	$15,%al
	call	VIDEO_$$_CLEARSCREEN$BYTE
# [419] WriteAt(20, 20, 'Aether OpenShell', 24);
	pushl	$24
	movl	$_$OPENSHELL$_Ld6,%ecx
	movl	$20,%edx
	movl	$20,%eax
	call	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
# [420] WriteAt(20, 60, 'digite help para ver os comandos', 12);
	pushl	$12
	movl	$_$OPENSHELL$_Ld25,%ecx
	movl	$60,%edx
	movl	$20,%eax
	call	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
# [422] CY := 90;
	movl	$90,-140(%ebp)
# [423] CX := 3;
	movl	$3,-136(%ebp)
# [424] WriteAt(CX, CY, '> ', 12);
	pushl	$12
	movl	-140(%ebp),%edx
	movl	-136(%ebp),%eax
	movl	$_$OPENSHELL$_Ld26,%ecx
	call	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
# [425] CX := CX + 20;
	movl	-136(%ebp),%eax
	leal	20(%eax),%eax
	movl	%eax,-136(%ebp)
# [426] while True do
	jmp	.Lj251
	.balign 8,0x90
.Lj250:
# [428] KeyboardPoll;
	call	KEYBOARD_$$_KEYBOARDPOLL
# [429] for Sc := 1 to 127 do
	movl	$0,-148(%ebp)
	.balign 8,0x90
.Lj253:
	movl	-148(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-148(%ebp)
# [431] if ScanIsPressed(Sc) and not LastScan[Sc] then
	movb	-148(%ebp),%al
	call	KEYBOARD_$$_SCANISPRESSED$BYTE$$BOOLEAN
	testb	%al,%al
	jne	.Lj256
	jmp	.Lj257
.Lj256:
	movl	-148(%ebp),%eax
	cmpb	$0,U_$OPENSHELL_$$_LASTSCAN(,%eax,1)
	je	.Lj258
	jmp	.Lj257
.Lj258:
# [433] if Sc = SCAN_ENTER then
	cmpl	$28,-148(%ebp)
	je	.Lj259
	jmp	.Lj260
.Lj259:
# [435] Line[Len] := #0;
	movl	-132(%ebp),%eax
	movb	$0,-128(%ebp,%eax,1)
# [437] if ProcCommand(@Line[0], Len, CY, False) in [CMD_EXIT, CMD_CLOSE] then
	pushl	$0
	leal	-128(%ebp),%eax
	leal	-140(%ebp),%ecx
	movl	-132(%ebp),%edx
	call	OPENSHELL_$$_PROCCOMMAND$PCHAR$LONGINT$LONGINT$BOOLEAN$$LONGINT
	cmpl	$1,%eax
	je	.Lj261
	cmpl	$3,%eax
	je	.Lj261
.Lj261:
	je	.Lj262
	jmp	.Lj263
.Lj262:
# [438] Exit;   // volta ao desktop
	jmp	.Lj245
	.balign 4,0x90
.Lj263:
# [439] if CY > (RHeight - 56) then
	movl	U_$VIDEO_$$_RHEIGHT,%eax
	leal	-56(%eax),%eax
	cmpl	-140(%ebp),%eax
	jl	.Lj264
	jmp	.Lj265
.Lj264:
# [441] ClearScreen($0F);
	movb	$15,%al
	call	VIDEO_$$_CLEARSCREEN$BYTE
# [442] WriteAt(20, 20, 'Aether OpenShell', 24);
	pushl	$24
	movl	$_$OPENSHELL$_Ld6,%ecx
	movl	$20,%edx
	movl	$20,%eax
	call	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
# [443] WriteAt(20, 60, 'digite help para ver os comandos', 12);
	pushl	$12
	movl	$_$OPENSHELL$_Ld25,%ecx
	movl	$60,%edx
	movl	$20,%eax
	call	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
# [444] CY := 90;
	movl	$90,-140(%ebp)
	.balign 4,0x90
.Lj265:
# [446] CX := 3;
	movl	$3,-136(%ebp)
# [447] WriteAt(CX, CY, '> ', 12);
	pushl	$12
	movl	-140(%ebp),%edx
	movl	-136(%ebp),%eax
	movl	$_$OPENSHELL$_Ld26,%ecx
	call	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
# [448] CX := CX + 20;
	movl	-136(%ebp),%eax
	leal	20(%eax),%eax
	movl	%eax,-136(%ebp)
# [449] Len := 0;
	movl	$0,-132(%ebp)
	jmp	.Lj266
.Lj260:
# [451] else if Sc = SCAN_BKSP then
	cmpl	$14,-148(%ebp)
	je	.Lj267
	jmp	.Lj268
.Lj267:
# [453] if Len > 0 then
	cmpl	$0,-132(%ebp)
	jg	.Lj269
	jmp	.Lj270
.Lj269:
# [455] Dec(Len);
	subl	$1,-132(%ebp)
# [456] Line[Len] := #0;
	movl	-132(%ebp),%eax
	movb	$0,-128(%ebp,%eax,1)
# [457] CX := CX - 12;
	movl	-136(%ebp),%eax
	leal	-12(%eax),%eax
	movl	%eax,-136(%ebp)
# [460] FillRect(CX, CY, 12, 16, $0F);
	pushl	$16
	pushl	$15
	movl	-140(%ebp),%edx
	movl	-136(%ebp),%eax
	movl	$12,%ecx
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
	.balign 4,0x90
.Lj270:
	jmp	.Lj271
.Lj268:
# [465] Ch := ScanToChar(Sc);
	movb	-148(%ebp),%al
	call	OPENSHELL_$$_SCANTOCHAR$BYTE$$CHAR
	movb	%al,-152(%ebp)
# [466] if (Ch <> #0) and (Len < MAXLINE - 1) then
	cmpb	$0,-152(%ebp)
	jne	.Lj272
	jmp	.Lj273
.Lj272:
	cmpl	$127,-132(%ebp)
	jl	.Lj274
	jmp	.Lj273
.Lj274:
# [468] if ScanIsPressed(SCAN_LSHIFT) or ScanIsPressed(SCAN_RSHIFT) then
	movb	$42,%al
	call	KEYBOARD_$$_SCANISPRESSED$BYTE$$BOOLEAN
	testb	%al,%al
	jne	.Lj275
	jmp	.Lj276
.Lj276:
	movb	$54,%al
	call	KEYBOARD_$$_SCANISPRESSED$BYTE$$BOOLEAN
	testb	%al,%al
	jne	.Lj275
	jmp	.Lj277
.Lj275:
# [469] if (Ch >= 'a') and (Ch <= 'z') then
	cmpb	$97,-152(%ebp)
	jae	.Lj278
	jmp	.Lj279
.Lj278:
	cmpb	$122,-152(%ebp)
	jbe	.Lj280
	jmp	.Lj279
.Lj280:
# [470] Ch := Char(Ord(Ch) - 32);
	movzbl	-152(%ebp),%eax
	subl	$32,%eax
	movb	%al,-152(%ebp)
	.balign 4,0x90
.Lj279:
	.balign 4,0x90
.Lj277:
# [471] if (Len = 0) and (CX < 3) then
	cmpl	$0,-132(%ebp)
	je	.Lj281
	jmp	.Lj282
.Lj281:
	cmpl	$3,-136(%ebp)
	jl	.Lj283
	jmp	.Lj282
.Lj283:
# [472] CX := 3;
	movl	$3,-136(%ebp)
	.balign 4,0x90
.Lj282:
# [473] Line[Len] := Ch;
	movl	-132(%ebp),%eax
	movb	-152(%ebp),%dl
	movb	%dl,-128(%ebp,%eax,1)
# [474] Inc(Len);
	addl	$1,-132(%ebp)
# [475] Line[Len] := #0;
	movl	-132(%ebp),%eax
	movb	$0,-128(%ebp,%eax,1)
# [478] WriteAt(CX, CY, @Line[Len - 1], 12);
	pushl	$12
	movl	-132(%ebp),%eax
	leal	-1(%eax),%eax
	leal	-128(%ebp,%eax,1),%ecx
	movl	-140(%ebp),%edx
	movl	-136(%ebp),%eax
	call	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
# [479] CX := CX + 12;
	movl	-136(%ebp),%eax
	leal	12(%eax),%eax
	movl	%eax,-136(%ebp)
	.balign 4,0x90
.Lj273:
.Lj271:
.Lj266:
	.balign 4,0x90
.Lj257:
	cmpl	$127,-148(%ebp)
	jge	.Lj255
	jmp	.Lj253
.Lj255:
# [484] for Sc := 1 to 127 do
	movl	$0,-148(%ebp)
	.balign 8,0x90
.Lj284:
	movl	-148(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-148(%ebp)
# [485] LastScan[Sc] := ScanIsPressed(Sc);
	movb	-148(%ebp),%al
	call	KEYBOARD_$$_SCANISPRESSED$BYTE$$BOOLEAN
	movl	-148(%ebp),%edx
	movb	%al,U_$OPENSHELL_$$_LASTSCAN(,%edx,1)
	cmpl	$127,-148(%ebp)
	jge	.Lj286
	jmp	.Lj284
.Lj286:
.Lj251:
	jmp	.Lj250
.Lj245:
# [487] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_openshell_$$_shellinit,"x"
	.balign 16,0x90
.globl	OPENSHELL_$$_SHELLINIT
OPENSHELL_$$_SHELLINIT:
# [490] begin
	pushl	%ebp
	movl	%esp,%ebp
# [491] end;
	movl	%ebp,%esp
	popl	%ebp
	ret
# End asmlist al_procedures
# Begin asmlist al_globals

.section .bss
# [33] LastScan: array[0..127] of Boolean;
U_$OPENSHELL_$$_LASTSCAN:
	.zero 128

.section .bss
# [34] ScriptBuf: array[0..SCRIPT_MAX - 1] of Byte;
U_$OPENSHELL_$$_SCRIPTBUF:
	.zero 8192
# End asmlist al_globals
# Begin asmlist al_typedconsts

.section .rodata.n__$OPENSHELL$_Ld1,"d"
	.balign 4
.globl	_$OPENSHELL$_Ld1
_$OPENSHELL$_Ld1:
	.ascii	"runfile: nao encontrado \000"

.section .rodata.n__$OPENSHELL$_Ld2,"d"
	.balign 4
.globl	_$OPENSHELL$_Ld2
_$OPENSHELL$_Ld2:
	.ascii	"runfile: executando \000"

.section .rodata.n__$OPENSHELL$_Ld3,"d"
	.balign 4
.globl	_$OPENSHELL$_Ld3
_$OPENSHELL$_Ld3:
	.ascii	"help\000"

.section .rodata.n__$OPENSHELL$_Ld4,"d"
	.balign 4
.globl	_$OPENSHELL$_Ld4
_$OPENSHELL$_Ld4:
	.ascii	"Comandos: run <NOME>, file <ARQ.RUN>, cls, help, ex"
	.ascii	"it\000"

.section .rodata.n__$OPENSHELL$_Ld5,"d"
	.balign 4
.globl	_$OPENSHELL$_Ld5
_$OPENSHELL$_Ld5:
	.ascii	"cls\000"

.section .rodata.n__$OPENSHELL$_Ld6,"d"
	.balign 4
.globl	_$OPENSHELL$_Ld6
_$OPENSHELL$_Ld6:
	.ascii	"Aether OpenShell\000"

.section .rodata.n__$OPENSHELL$_Ld7,"d"
	.balign 4
.globl	_$OPENSHELL$_Ld7
_$OPENSHELL$_Ld7:
	.ascii	"boas-vindas. digite help\000"

.section .rodata.n__$OPENSHELL$_Ld8,"d"
	.balign 4
.globl	_$OPENSHELL$_Ld8
_$OPENSHELL$_Ld8:
	.ascii	"exit\000"

.section .rodata.n__$OPENSHELL$_Ld9,"d"
	.balign 4
.globl	_$OPENSHELL$_Ld9
_$OPENSHELL$_Ld9:
	.ascii	"Voltando ao desktop...\000"

.section .rodata.n__$OPENSHELL$_Ld10,"d"
	.balign 4
.globl	_$OPENSHELL$_Ld10
_$OPENSHELL$_Ld10:
	.ascii	"run\000"

.section .rodata.n__$OPENSHELL$_Ld11,"d"
	.balign 4
.globl	_$OPENSHELL$_Ld11
_$OPENSHELL$_Ld11:
	.ascii	"uso: run <NOME DO PROGRAMA>\000"

.section .rodata.n__$OPENSHELL$_Ld12,"d"
	.balign 4
.globl	_$OPENSHELL$_Ld12
_$OPENSHELL$_Ld12:
	.ascii	"\020SYSTEM\\COMPILED\\\000"

.section .rodata.n__$OPENSHELL$_Ld13,"d"
	.balign 4
.globl	_$OPENSHELL$_Ld13
_$OPENSHELL$_Ld13:
	.ascii	"\004.BIN\000"

.section .rodata.n__$OPENSHELL$_Ld14,"d"
	.balign 4
.globl	_$OPENSHELL$_Ld14
_$OPENSHELL$_Ld14:
	.ascii	"Executando \000"

.section .rodata.n__$OPENSHELL$_Ld15,"d"
	.balign 4
.globl	_$OPENSHELL$_Ld15
_$OPENSHELL$_Ld15:
	.ascii	"[ok]\000"

.section .rodata.n__$OPENSHELL$_Ld16,"d"
	.balign 4
.globl	_$OPENSHELL$_Ld16
_$OPENSHELL$_Ld16:
	.ascii	"[nao encontrado]\000"

.section .rodata.n__$OPENSHELL$_Ld17,"d"
	.balign 4
.globl	_$OPENSHELL$_Ld17
_$OPENSHELL$_Ld17:
	.ascii	"shell: run \000"

.section .rodata.n__$OPENSHELL$_Ld18,"d"
	.balign 4
.globl	_$OPENSHELL$_Ld18
_$OPENSHELL$_Ld18:
	.ascii	"file\000"

.section .rodata.n__$OPENSHELL$_Ld19,"d"
	.balign 4
.globl	_$OPENSHELL$_Ld19
_$OPENSHELL$_Ld19:
	.ascii	"uso: file <ARQUIVO.RUN>\000"

.section .rodata.n__$OPENSHELL$_Ld20,"d"
	.balign 4
.globl	_$OPENSHELL$_Ld20
_$OPENSHELL$_Ld20:
	.ascii	"\010SCRIPTS\\\000"

.section .rodata.n__$OPENSHELL$_Ld21,"d"
	.balign 4
.globl	_$OPENSHELL$_Ld21
_$OPENSHELL$_Ld21:
	.ascii	"script nao encontrado\000"

.section .rodata.n__$OPENSHELL$_Ld22,"d"
	.balign 4
.globl	_$OPENSHELL$_Ld22
_$OPENSHELL$_Ld22:
	.ascii	"file: nao encontrado \000"

.section .rodata.n__$OPENSHELL$_Ld23,"d"
	.balign 4
.globl	_$OPENSHELL$_Ld23
_$OPENSHELL$_Ld23:
	.ascii	"file: executando \000"

.section .rodata.n__$OPENSHELL$_Ld24,"d"
	.balign 4
.globl	_$OPENSHELL$_Ld24
_$OPENSHELL$_Ld24:
	.ascii	"comando desconhecido\000"

.section .rodata.n__$OPENSHELL$_Ld25,"d"
	.balign 4
.globl	_$OPENSHELL$_Ld25
_$OPENSHELL$_Ld25:
	.ascii	"digite help para ver os comandos\000"

.section .rodata.n__$OPENSHELL$_Ld26,"d"
	.balign 4
.globl	_$OPENSHELL$_Ld26
_$OPENSHELL$_Ld26:
	.ascii	"> \000"
# End asmlist al_typedconsts

