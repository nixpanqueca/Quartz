	.file "prism.pas"
# Begin asmlist al_procedures

.section .text.n_prism_$$_mapbuttontoshortcut$longint$$longint,"x"
	.balign 16,0x90
PRISM_$$_MAPBUTTONTOSHORTCUT$LONGINT$$LONGINT:
# [prism.pas]
# [77] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var ButtonIdx located at ebp-4, size=OS_S32
# Var $result located at ebp-8, size=OS_S32
	movl	%eax,-4(%ebp)
# [78] Result := -1;
	movl	$-1,-8(%ebp)
# [79] if (ButtonIdx >= 0) and (ButtonIdx <= 63) then
	cmpl	$0,-4(%ebp)
	jge	.Lj5
	jmp	.Lj6
.Lj5:
	cmpl	$63,-4(%ebp)
	jle	.Lj7
	jmp	.Lj6
.Lj7:
# [80] Result := ShortcutOfButton[ButtonIdx];
	movl	-4(%ebp),%eax
	movl	U_$PRISM_$$_SHORTCUTOFBUTTON(,%eax,4),%eax
	movl	%eax,-8(%ebp)
	.balign 4,0x90
.Lj6:
# [81] end;
	movl	-8(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_prism_$$_drawshortcutlabel$longint$boolean,"x"
	.balign 16,0x90
PRISM_$$_DRAWSHORTCUTLABEL$LONGINT$BOOLEAN:
# [84] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var S located at ebp-4, size=OS_S32
# Var Selected located at ebp-8, size=OS_8
	movl	%eax,-4(%ebp)
	movb	%dl,-8(%ebp)
# [85] if Selected then
	cmpb	$0,-8(%ebp)
	jne	.Lj10
	jmp	.Lj11
.Lj10:
# [88] FillRect(Shortcuts[S].LabelX - 2, Shortcuts[S].LabelY - 2,
	pushl	$14
	pushl	$0
# [89] Shortcuts[S].TW + 4, LabelSize + 4, 0);
	movl	-4(%ebp),%eax
	imull	$48,%eax,%eax
	movl	U_$PRISM_$$_SHORTCUTS+28(,%eax),%eax
	leal	4(%eax),%ecx
	movl	-4(%ebp),%eax
	imull	$48,%eax,%eax
	movl	U_$PRISM_$$_SHORTCUTS+24(,%eax),%eax
	leal	-2(%eax),%edx
	movl	-4(%ebp),%eax
	imull	$48,%eax,%eax
	movl	U_$PRISM_$$_SHORTCUTS+20(,%eax),%eax
	leal	-2(%eax),%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [90] WriteAtCol(Shortcuts[S].LabelX, Shortcuts[S].LabelY,
	pushl	$10
	pushl	$15
# [91] Shortcuts[S].LabelText, LabelSize, 15);
	movl	-4(%ebp),%eax
	imull	$48,%eax,%eax
	movl	U_$PRISM_$$_SHORTCUTS+44(,%eax),%ecx
	movl	-4(%ebp),%eax
	imull	$48,%eax,%eax
	movl	U_$PRISM_$$_SHORTCUTS+24(,%eax),%edx
	movl	-4(%ebp),%eax
	imull	$48,%eax,%eax
	movl	U_$PRISM_$$_SHORTCUTS+20(,%eax),%eax
	call	VIDEO_$$_WRITEATCOL$LONGINT$LONGINT$PCHAR$LONGINT$BYTE
	jmp	.Lj12
.Lj11:
# [95] FillRect(Shortcuts[S].LabelX - 2, Shortcuts[S].LabelY - 2,
	pushl	$14
	pushl	$15
# [96] Shortcuts[S].TW + 4, LabelSize + 4, 15);
	movl	-4(%ebp),%eax
	imull	$48,%eax,%eax
	movl	U_$PRISM_$$_SHORTCUTS+28(,%eax),%eax
	leal	4(%eax),%ecx
	movl	-4(%ebp),%eax
	imull	$48,%eax,%eax
	movl	U_$PRISM_$$_SHORTCUTS+24(,%eax),%eax
	leal	-2(%eax),%edx
	movl	-4(%ebp),%eax
	imull	$48,%eax,%eax
	movl	U_$PRISM_$$_SHORTCUTS+20(,%eax),%eax
	leal	-2(%eax),%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [97] WriteAt(Shortcuts[S].LabelX, Shortcuts[S].LabelY,
	pushl	$10
# [98] Shortcuts[S].LabelText, LabelSize);
	movl	-4(%ebp),%eax
	imull	$48,%eax,%eax
	movl	U_$PRISM_$$_SHORTCUTS+44(,%eax),%ecx
	movl	-4(%ebp),%eax
	imull	$48,%eax,%eax
	movl	U_$PRISM_$$_SHORTCUTS+24(,%eax),%edx
	movl	-4(%ebp),%eax
	imull	$48,%eax,%eax
	movl	U_$PRISM_$$_SHORTCUTS+20(,%eax),%eax
	call	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
.Lj12:
# [100] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_prism_$$_redrawshortcut$longint$boolean,"x"
	.balign 16,0x90
PRISM_$$_REDRAWSHORTCUT$LONGINT$BOOLEAN:
# [104] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var S located at ebp-4, size=OS_S32
# Var Selected located at ebp-8, size=OS_8
	movl	%eax,-4(%ebp)
	movb	%dl,-8(%ebp)
# [105] FillPatternRect(Shortcuts[S].CellX, Shortcuts[S].CellY,
	pushl	$92
	pushl	$TC_$PRISM_$$_MACGRAY
	pushl	$7
	pushl	$0
	pushl	$15
	movl	-4(%ebp),%eax
	imull	$48,%eax,%eax
	movl	U_$PRISM_$$_SHORTCUTS+8(,%eax),%edx
	movl	-4(%ebp),%eax
	imull	$48,%eax,%eax
	movl	U_$PRISM_$$_SHORTCUTS+4(,%eax),%eax
	movl	$96,%ecx
	call	VIDEO_$$_FILLPATTERNRECT$LONGINT$LONGINT$LONGINT$LONGINT$array_of_BYTE$BYTE$BYTE
# [107] if Selected then
	cmpb	$0,-8(%ebp)
	jne	.Lj15
	jmp	.Lj16
.Lj15:
# [108] DrawBMPBlack(Shortcuts[S].Icon, Shortcuts[S].IconX, Shortcuts[S].IconY)
	movl	-4(%ebp),%eax
	imull	$48,%eax,%eax
	movl	U_$PRISM_$$_SHORTCUTS+16(,%eax),%ecx
	movl	-4(%ebp),%eax
	imull	$48,%eax,%eax
	movl	U_$PRISM_$$_SHORTCUTS+12(,%eax),%edx
	movl	-4(%ebp),%eax
	imull	$48,%eax,%eax
	movl	U_$PRISM_$$_SHORTCUTS+40(,%eax),%eax
	call	VIDEO_$$_DRAWBMPBLACK$PCHAR$LONGINT$LONGINT
	jmp	.Lj17
.Lj16:
# [110] DrawBMP(Shortcuts[S].Icon, Shortcuts[S].IconX, Shortcuts[S].IconY);
	movl	-4(%ebp),%eax
	imull	$48,%eax,%eax
	movl	U_$PRISM_$$_SHORTCUTS+16(,%eax),%ecx
	movl	-4(%ebp),%eax
	imull	$48,%eax,%eax
	movl	U_$PRISM_$$_SHORTCUTS+12(,%eax),%edx
	movl	-4(%ebp),%eax
	imull	$48,%eax,%eax
	movl	U_$PRISM_$$_SHORTCUTS+40(,%eax),%eax
	call	VIDEO_$$_DRAWBMP$PCHAR$LONGINT$LONGINT
.Lj17:
# [111] DrawShortcutLabel(S, Selected);
	movb	-8(%ebp),%dl
	movl	-4(%ebp),%eax
	call	PRISM_$$_DRAWSHORTCUTLABEL$LONGINT$BOOLEAN
# [112] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_prism_$$_selectshortcut$longint,"x"
	.balign 16,0x90
PRISM_$$_SELECTSHORTCUT$LONGINT:
# [117] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var S located at ebp-4, size=OS_S32
# Var Old located at ebp-8, size=OS_S32
	movl	%eax,-4(%ebp)
# [118] if (S < 0) or (S >= ShortcutCount) then
	cmpl	$0,-4(%ebp)
	jl	.Lj20
	jmp	.Lj21
.Lj21:
	movl	-4(%ebp),%eax
	cmpl	U_$PRISM_$$_SHORTCUTCOUNT,%eax
	jge	.Lj20
	jmp	.Lj22
.Lj20:
# [119] Exit;
	jmp	.Lj18
	.balign 4,0x90
.Lj22:
# [120] Old := SelectedShortcut;
	movl	U_$PRISM_$$_SELECTEDSHORTCUT,%eax
	movl	%eax,-8(%ebp)
# [121] if Old = S then
	movl	-8(%ebp),%eax
	cmpl	-4(%ebp),%eax
	je	.Lj23
	jmp	.Lj24
.Lj23:
# [122] Exit;
	jmp	.Lj18
	.balign 4,0x90
.Lj24:
# [123] if (Old >= 0) and (Old < ShortcutCount) then
	cmpl	$0,-8(%ebp)
	jge	.Lj25
	jmp	.Lj26
.Lj25:
	movl	-8(%ebp),%eax
	cmpl	U_$PRISM_$$_SHORTCUTCOUNT,%eax
	jl	.Lj27
	jmp	.Lj26
.Lj27:
# [124] RedrawShortcut(Old, False);
	movl	-8(%ebp),%eax
	movb	$0,%dl
	call	PRISM_$$_REDRAWSHORTCUT$LONGINT$BOOLEAN
	.balign 4,0x90
.Lj26:
# [125] SelectedShortcut := S;
	movl	-4(%ebp),%eax
	movl	%eax,U_$PRISM_$$_SELECTEDSHORTCUT
# [126] RedrawShortcut(S, True);
	movl	-4(%ebp),%eax
	movb	$1,%dl
	call	PRISM_$$_REDRAWSHORTCUT$LONGINT$BOOLEAN
.Lj18:
# [127] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_prism_$$_clearshortcutselection,"x"
	.balign 16,0x90
.globl	PRISM_$$_CLEARSHORTCUTSELECTION
PRISM_$$_CLEARSHORTCUTSELECTION:
# [130] begin
	pushl	%ebp
	movl	%esp,%ebp
# [131] if (SelectedShortcut >= 0) and (SelectedShortcut < ShortcutCount) then
	cmpl	$0,U_$PRISM_$$_SELECTEDSHORTCUT
	jge	.Lj30
	jmp	.Lj31
.Lj30:
	movl	U_$PRISM_$$_SELECTEDSHORTCUT,%eax
	cmpl	U_$PRISM_$$_SHORTCUTCOUNT,%eax
	jl	.Lj32
	jmp	.Lj31
.Lj32:
# [132] RedrawShortcut(SelectedShortcut, False);
	movl	U_$PRISM_$$_SELECTEDSHORTCUT,%eax
	movb	$0,%dl
	call	PRISM_$$_REDRAWSHORTCUT$LONGINT$BOOLEAN
	.balign 4,0x90
.Lj31:
# [133] SelectedShortcut := -1;
	movl	$-1,U_$PRISM_$$_SELECTEDSHORTCUT
# [134] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_prism_$$_desktopshortcutclick,"x"
	.balign 16,0x90
PRISM_$$_DESKTOPSHORTCUTCLICK:
# [140] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-4(%esp),%esp
# Var S located at ebp-4, size=OS_S32
# [141] S := MapButtonToShortcut(GetLastHit);
	call	BUTTONS_$$_GETLASTHIT$$LONGINT
	call	PRISM_$$_MAPBUTTONTOSHORTCUT$LONGINT$$LONGINT
	movl	%eax,-4(%ebp)
# [142] if S >= 0 then
	cmpl	$0,-4(%ebp)
	jge	.Lj35
	jmp	.Lj36
.Lj35:
# [143] SelectShortcut(S);
	movl	-4(%ebp),%eax
	call	PRISM_$$_SELECTSHORTCUT$LONGINT
	.balign 4,0x90
.Lj36:
# [144] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_prism_$$_isbinpath$pchar$$boolean,"x"
	.balign 16,0x90
PRISM_$$_ISBINPATH$PCHAR$$BOOLEAN:
# [151] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-12(%esp),%esp
# Var P located at ebp-4, size=OS_32
# Var $result located at ebp-8, size=OS_8
# Var L located at ebp-12, size=OS_S32
	movl	%eax,-4(%ebp)
# [152] IsBinPath := False;
	movb	$0,-8(%ebp)
# [153] L := 0;
	movl	$0,-12(%ebp)
# [154] while P[L] <> #0 do
	jmp	.Lj40
	.balign 8,0x90
.Lj39:
# [155] Inc(L);
	addl	$1,-12(%ebp)
.Lj40:
	movl	-4(%ebp),%edx
	movl	-12(%ebp),%eax
	cmpb	$0,(%edx,%eax,1)
	jne	.Lj39
	jmp	.Lj41
.Lj41:
# [156] if L < 4 then
	cmpl	$4,-12(%ebp)
	jl	.Lj42
	jmp	.Lj43
.Lj42:
# [157] Exit;
	jmp	.Lj37
	.balign 4,0x90
.Lj43:
# [158] if (P[L - 4] = '.') and (P[L - 3] = 'B') and (P[L - 2] = 'I') and
	movl	-4(%ebp),%edx
	movl	-12(%ebp),%eax
	leal	-4(%eax),%eax
	cmpb	$46,(%edx,%eax,1)
	je	.Lj44
	jmp	.Lj45
.Lj44:
	movl	-4(%ebp),%edx
	movl	-12(%ebp),%eax
	leal	-3(%eax),%eax
	cmpb	$66,(%edx,%eax,1)
	je	.Lj46
	jmp	.Lj45
.Lj46:
	movl	-4(%ebp),%edx
	movl	-12(%ebp),%eax
	leal	-2(%eax),%eax
	cmpb	$73,(%edx,%eax,1)
	je	.Lj47
	jmp	.Lj45
.Lj47:
# [159] (P[L - 1] = 'N') then
	movl	-4(%ebp),%edx
	movl	-12(%ebp),%eax
	leal	-1(%eax),%eax
	cmpb	$78,(%edx,%eax,1)
	je	.Lj48
	jmp	.Lj45
.Lj48:
# [160] IsBinPath := True;
	movb	$1,-8(%ebp)
	.balign 4,0x90
.Lj45:
.Lj37:
# [161] end;
	movb	-8(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_prism_$$_desktopshortcutdblclick,"x"
	.balign 16,0x90
PRISM_$$_DESKTOPSHORTCUTDBLCLICK:
# [166] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-4(%esp),%esp
# Var S located at ebp-4, size=OS_S32
# [167] S := MapButtonToShortcut(GetLastHit);
	call	BUTTONS_$$_GETLASTHIT$$LONGINT
	call	PRISM_$$_MAPBUTTONTOSHORTCUT$LONGINT$$LONGINT
	movl	%eax,-4(%ebp)
# [168] if S < 0 then
	cmpl	$0,-4(%ebp)
	jl	.Lj51
	jmp	.Lj52
.Lj51:
# [169] Exit;
	jmp	.Lj49
	.balign 4,0x90
.Lj52:
# [170] SelectShortcut(S);
	movl	-4(%ebp),%eax
	call	PRISM_$$_SELECTSHORTCUT$LONGINT
# [171] if Shortcuts[S].RunPath <> nil then
	movl	-4(%ebp),%eax
	imull	$48,%eax,%eax
	cmpl	$0,U_$PRISM_$$_SHORTCUTS+36(,%eax)
	jne	.Lj53
	jmp	.Lj54
.Lj53:
# [173] if IsBinPath(Shortcuts[S].RunPath) then
	movl	-4(%ebp),%eax
	imull	$48,%eax,%eax
	movl	U_$PRISM_$$_SHORTCUTS+36(,%eax),%eax
	call	PRISM_$$_ISBINPATH$PCHAR$$BOOLEAN
	testb	%al,%al
	jne	.Lj55
	jmp	.Lj56
.Lj55:
# [174] RunProgram(Shortcuts[S].RunPath)
	movl	-4(%ebp),%eax
	imull	$48,%eax,%eax
	movl	U_$PRISM_$$_SHORTCUTS+36(,%eax),%eax
	call	SVC_$$_RUNPROGRAM$PCHAR$$BOOLEAN
	jmp	.Lj57
.Lj56:
# [176] ShellRunFile(Shortcuts[S].RunPath, True);
	movl	-4(%ebp),%eax
	imull	$48,%eax,%eax
	movl	U_$PRISM_$$_SHORTCUTS+36(,%eax),%eax
	movb	$1,%dl
	call	OPENSHELL_$$_SHELLRUNFILE$PCHAR$BOOLEAN$$LONGINT
.Lj57:
	jmp	.Lj58
.Lj54:
# [178] else if Shortcuts[S].OpenProc <> nil then
	movl	-4(%ebp),%eax
	imull	$48,%eax,%eax
	cmpl	$0,U_$PRISM_$$_SHORTCUTS+32(,%eax)
	jne	.Lj59
	jmp	.Lj60
.Lj59:
# [179] TShortcutProc(Shortcuts[S].OpenProc);
	movl	-4(%ebp),%eax
	imull	$48,%eax,%eax
	call	*U_$PRISM_$$_SHORTCUTS+32(,%eax)
	.balign 4,0x90
.Lj60:
.Lj58:
.Lj49:
# [180] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_prism_$$_strlen$pchar$$longint,"x"
	.balign 16,0x90
PRISM_$$_STRLEN$PCHAR$$LONGINT:
# [183] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var S located at ebp-4, size=OS_32
# Var $result located at ebp-8, size=OS_S32
	movl	%eax,-4(%ebp)
# [184] Result := 0;
	movl	$0,-8(%ebp)
# [185] if S = nil then
	cmpl	$0,-4(%ebp)
	je	.Lj63
	jmp	.Lj64
.Lj63:
# [186] Exit;
	jmp	.Lj61
	.balign 4,0x90
.Lj64:
# [187] while S[Result] <> #0 do
	jmp	.Lj66
	.balign 8,0x90
.Lj65:
# [188] Result := Result + 1;
	movl	-8(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-8(%ebp)
.Lj66:
	movl	-4(%ebp),%eax
	movl	-8(%ebp),%edx
	cmpb	$0,(%eax,%edx,1)
	jne	.Lj65
	jmp	.Lj67
.Lj67:
.Lj61:
# [189] end;
	movl	-8(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_prism_$$_menubarheight$$longint,"x"
	.balign 16,0x90
PRISM_$$_MENUBARHEIGHT$$LONGINT:
# [192] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-4(%esp),%esp
# Var $result located at ebp-4, size=OS_S32
# [193] if RHeight = 720 then
	cmpl	$720,U_$VIDEO_$$_RHEIGHT
	je	.Lj70
	jmp	.Lj71
.Lj70:
# [194] Result := 21
	movl	$21,-4(%ebp)
	jmp	.Lj72
.Lj71:
# [196] Result := 25;
	movl	$25,-4(%ebp)
.Lj72:
# [197] end;
	movl	-4(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_prism_$$_removemenubuttons,"x"
	.balign 16,0x90
PRISM_$$_REMOVEMENUBUTTONS:
# [206] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-4(%esp),%esp
# Var i located at ebp-4, size=OS_S32
# [207] for i := MenuButtonCount - 1 downto 0 do
	movl	U_$PRISM_$$_MENUBUTTONCOUNT,%eax
	leal	-1(%eax),%eax
	cmpl	$0,%eax
	jge	.Lj75
	jmp	.Lj76
.Lj75:
	movl	%eax,-4(%ebp)
	movl	-4(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-4(%ebp)
	.balign 8,0x90
.Lj77:
	movl	-4(%ebp),%eax
	leal	-1(%eax),%eax
	movl	%eax,-4(%ebp)
# [208] RemoveButton(MenuButtons[i]);
	movl	-4(%ebp),%eax
	movl	U_$PRISM_$$_MENUBUTTONS(,%eax,4),%eax
	call	BUTTONS_$$_REMOVEBUTTON$LONGINT
	cmpl	$0,-4(%ebp)
	jle	.Lj79
	jmp	.Lj77
.Lj79:
	.balign 4,0x90
.Lj76:
# [209] MenuButtonCount := 0;
	movl	$0,U_$PRISM_$$_MENUBUTTONCOUNT
# [210] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_prism_$$_drawmenubar,"x"
	.balign 16,0x90
PRISM_$$_DRAWMENUBAR:
# [215] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-12(%esp),%esp
# Var i located at ebp-4, size=OS_S32
# Var X located at ebp-8, size=OS_S32
# Var W located at ebp-12, size=OS_S32
# [217] FillRect(28, 0, RWidth - 35, MenuBarHeight, $0F);
	call	PRISM_$$_MENUBARHEIGHT$$LONGINT
	pushl	%eax
	pushl	$15
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-35(%eax),%ecx
	movl	$0,%edx
	movl	$28,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [218] RemoveMenuButtons;
	call	PRISM_$$_REMOVEMENUBUTTONS
# [220] X := 30;
	movl	$30,-8(%ebp)
# [221] i := 0;
	movl	$0,-4(%ebp)
# [222] while Menus[i].Text <> nil do
	jmp	.Lj83
	.balign 8,0x90
.Lj82:
# [224] W := StrLen(Menus[i].Text) * 12;
	movl	-4(%ebp),%eax
	movl	U_$PRISM_$$_MENUS(,%eax,8),%eax
	call	PRISM_$$_STRLEN$PCHAR$$LONGINT
	imull	$12,%eax
	movl	%eax,-12(%ebp)
# [225] WriteAt(X, 7, Menus[i].Text, 12);
	pushl	$12
	movl	-4(%ebp),%eax
	movl	U_$PRISM_$$_MENUS(,%eax,8),%ecx
	movl	-8(%ebp),%eax
	movl	$7,%edx
	call	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
# [226] MenuButtons[MenuButtonCount] := AddButton(X, 0, W, MenuBarHeight, Pointer(Menus[i].OnClick));
	call	PRISM_$$_MENUBARHEIGHT$$LONGINT
	pushl	%eax
	movl	-4(%ebp),%eax
	pushl	U_$PRISM_$$_MENUS+4(,%eax,8)
	movl	-12(%ebp),%ecx
	movl	-8(%ebp),%eax
	movl	$0,%edx
	call	BUTTONS_$$_ADDBUTTON$LONGINT$LONGINT$LONGINT$LONGINT$POINTER$$LONGINT
	movl	U_$PRISM_$$_MENUBUTTONCOUNT,%edx
	movl	%eax,U_$PRISM_$$_MENUBUTTONS(,%edx,4)
# [227] Inc(MenuButtonCount);
	addl	$1,U_$PRISM_$$_MENUBUTTONCOUNT
# [228] X := X + W + 14;
	movl	-8(%ebp),%edx
	movl	-12(%ebp),%eax
	leal	(%edx,%eax),%eax
	leal	14(%eax),%eax
	movl	%eax,-8(%ebp)
# [229] Inc(i);
	addl	$1,-4(%ebp)
.Lj83:
	movl	-4(%ebp),%eax
	cmpl	$0,U_$PRISM_$$_MENUS(,%eax,8)
	jne	.Lj82
	jmp	.Lj84
.Lj84:
# [232] X := StrLen(ActiveWindow) * 12;
	movl	U_$PRISM_$$_ACTIVEWINDOW,%eax
	call	PRISM_$$_STRLEN$PCHAR$$LONGINT
	imull	$12,%eax
	movl	%eax,-8(%ebp)
# [233] WriteAt(RWidth - 8 - X, 7, ActiveWindow, 12);
	pushl	$12
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-8(%eax),%eax
	subl	-8(%ebp),%eax
	movl	U_$PRISM_$$_ACTIVEWINDOW,%ecx
	movl	$7,%edx
	call	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
# [234] FillRect(RWidth-8-X-8,0, 1, 25, 0);
	pushl	$25
	pushl	$0
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-8(%eax),%eax
	subl	-8(%ebp),%eax
	subl	$8,%eax
	movl	$1,%ecx
	movl	$0,%edx
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [235] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_prism_$$_updatemenubar,"x"
	.balign 16,0x90
.globl	PRISM_$$_UPDATEMENUBAR
PRISM_$$_UPDATEMENUBAR:
# [238] begin
	pushl	%ebp
	movl	%esp,%ebp
# [239] DrawMenuBar;
	call	PRISM_$$_DRAWMENUBAR
# [240] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_prism_$$_dock,"x"
	.balign 16,0x90
PRISM_$$_DOCK:
# [243] begin
	pushl	%ebp
	movl	%esp,%ebp
# [245] FillRect(0, RHeight - 25, RWidth div 2 + 15, 25, $0F);
	pushl	$25
	pushl	$15
	movl	U_$VIDEO_$$_RWIDTH,%edx
	movl	%edx,%eax
	shrl	$31,%eax
	addl	%eax,%edx
	sarl	$1,%edx
	leal	15(%edx),%ecx
	movl	U_$VIDEO_$$_RHEIGHT,%eax
	leal	-25(%eax),%edx
	movl	$0,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [247] FillRect(0, RHeight - 26, RWidth div 2 + 15, 1, 0);
	pushl	$1
	pushl	$0
	movl	U_$VIDEO_$$_RWIDTH,%edx
	movl	%edx,%eax
	shrl	$31,%eax
	addl	%eax,%edx
	sarl	$1,%edx
	leal	15(%edx),%ecx
	movl	U_$VIDEO_$$_RHEIGHT,%eax
	leal	-26(%eax),%edx
	movl	$0,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [248] FillRect(RWidth div 2 + 15, RHeight - 26, 1, 25, 0);
	pushl	$25
	pushl	$0
	movl	U_$VIDEO_$$_RWIDTH,%edx
	movl	%edx,%eax
	shrl	$31,%eax
	addl	%eax,%edx
	sarl	$1,%edx
	leal	15(%edx),%eax
	movl	U_$VIDEO_$$_RHEIGHT,%edx
	leal	-26(%edx),%edx
	movl	$1,%ecx
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [249] PutPixel(RWidth div 2 + 15, RHeight - 26, $0F);
	movl	U_$VIDEO_$$_RWIDTH,%edx
	movl	%edx,%eax
	shrl	$31,%eax
	addl	%eax,%edx
	sarl	$1,%edx
	leal	15(%edx),%eax
	movl	U_$VIDEO_$$_RHEIGHT,%edx
	leal	-26(%edx),%edx
	movb	$15,%cl
	call	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
# [250] PutPixel(RWidth div 2 + 14, RHeight - 25, 0);
	movl	U_$VIDEO_$$_RWIDTH,%edx
	movl	%edx,%eax
	shrl	$31,%eax
	addl	%eax,%edx
	sarl	$1,%edx
	leal	14(%edx),%eax
	movl	U_$VIDEO_$$_RHEIGHT,%edx
	leal	-25(%edx),%edx
	movb	$0,%cl
	call	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
# [253] DrawBMP('SYSTEM\COMPILED\PRISM\BITMAP\FOLDER.BMP', 6, RHeight - 20);
	movl	U_$VIDEO_$$_RHEIGHT,%eax
	leal	-20(%eax),%ecx
	movl	$6,%edx
	movl	$_$PRISM$_Ld1,%eax
	call	VIDEO_$$_DRAWBMP$PCHAR$LONGINT$LONGINT
# [255] FillRect(29,RHeight-25, 1, 25, 0);
	pushl	$25
	pushl	$0
	movl	U_$VIDEO_$$_RHEIGHT,%eax
	leal	-25(%eax),%edx
	movl	$1,%ecx
	movl	$29,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [256] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_prism_$$_showdesktop,"x"
	.balign 16,0x90
.globl	PRISM_$$_SHOWDESKTOP
PRISM_$$_SHOWDESKTOP:
# [259] begin
	pushl	%ebp
	movl	%esp,%ebp
# [260] FillPatternRect(0,26, RWidth, RHeight - 26, MacGray,0,$0F);
	movl	U_$VIDEO_$$_RHEIGHT,%eax
	leal	-26(%eax),%eax
	pushl	%eax
	pushl	$TC_$PRISM_$$_MACGRAY
	pushl	$7
	pushl	$0
	pushl	$15
	movl	U_$VIDEO_$$_RWIDTH,%ecx
	movl	$26,%edx
	movl	$0,%eax
	call	VIDEO_$$_FILLPATTERNRECT$LONGINT$LONGINT$LONGINT$LONGINT$array_of_BYTE$BYTE$BYTE
# [261] dock;
	call	PRISM_$$_DOCK
# [262] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_prism_$$_desktopshortcut$longint$pchar$pchar,"x"
	.balign 16,0x90
.globl	PRISM_$$_DESKTOPSHORTCUT$LONGINT$PCHAR$PCHAR
PRISM_$$_DESKTOPSHORTCUT$LONGINT$PCHAR$PCHAR:
# [274] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-64(%esp),%esp
# Var Pos located at ebp-4, size=OS_S32
# Var Icon located at ebp-8, size=OS_32
# Var LabelText located at ebp-12, size=OS_32
# Var Index located at ebp-16, size=OS_S32
# Var Rows located at ebp-20, size=OS_S32
# Var Cols located at ebp-24, size=OS_S32
# Var MainRows located at ebp-28, size=OS_S32
# Var ColOffset located at ebp-32, size=OS_S32
# Var Row located at ebp-36, size=OS_S32
# Var StartY located at ebp-40, size=OS_S32
# Var EndY located at ebp-44, size=OS_S32
# Var CellX located at ebp-48, size=OS_S32
# Var CellY located at ebp-52, size=OS_S32
# Var IconX located at ebp-56, size=OS_S32
# Var IconY located at ebp-60, size=OS_S32
# Var TW located at ebp-64, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [275] if Pos = 0 then
	cmpl	$0,-4(%ebp)
	je	.Lj93
	jmp	.Lj94
.Lj93:
# [276] Index := ShortcutCount
	movl	U_$PRISM_$$_SHORTCUTCOUNT,%eax
	movl	%eax,-16(%ebp)
	jmp	.Lj95
.Lj94:
# [278] Index := Pos - 1;
	movl	-4(%ebp),%eax
	leal	-1(%eax),%eax
	movl	%eax,-16(%ebp)
.Lj95:
# [279] if Index < 0 then
	cmpl	$0,-16(%ebp)
	jl	.Lj96
	jmp	.Lj97
.Lj96:
# [280] Exit;
	jmp	.Lj91
	.balign 4,0x90
.Lj97:
# [283] StartY := MenuBarHeight + 1;
	call	PRISM_$$_MENUBARHEIGHT$$LONGINT
	leal	1(%eax),%eax
	movl	%eax,-40(%ebp)
# [284] EndY := RHeight - 25;
	movl	U_$VIDEO_$$_RHEIGHT,%eax
	leal	-25(%eax),%eax
	movl	%eax,-44(%ebp)
# [285] Rows := (EndY - StartY) div IconCellH;
	movl	-44(%ebp),%ecx
	movl	-40(%ebp),%eax
	subl	%eax,%ecx
	movl	$-1307163959,%eax
	imull	%ecx
	addl	%ecx,%edx
	sarl	$6,%edx
	shrl	$31,%ecx
	addl	%ecx,%edx
	movl	%edx,-20(%ebp)
# [286] if Rows < 1 then
	cmpl	$1,-20(%ebp)
	jl	.Lj98
	jmp	.Lj99
.Lj98:
# [287] Rows := 1;
	movl	$1,-20(%ebp)
	.balign 4,0x90
.Lj99:
# [288] Cols := RWidth div IconCellW;
	movl	U_$VIDEO_$$_RWIDTH,%ecx
	movl	$715827883,%eax
	imull	%ecx
	sarl	$4,%edx
	shrl	$31,%ecx
	addl	%ecx,%edx
	movl	%edx,-24(%ebp)
# [289] if Cols < 1 then
	cmpl	$1,-24(%ebp)
	jl	.Lj100
	jmp	.Lj101
.Lj100:
# [290] Cols := 1;
	movl	$1,-24(%ebp)
	.balign 4,0x90
.Lj101:
# [292] if Index >= Rows * Cols then
	movl	-20(%ebp),%edx
	movl	-24(%ebp),%eax
	imull	%edx,%eax
	cmpl	-16(%ebp),%eax
	jle	.Lj102
	jmp	.Lj103
.Lj102:
# [293] Exit;
	jmp	.Lj91
	.balign 4,0x90
.Lj103:
# [298] if Index = TrashIndex then
	cmpl	$4,-16(%ebp)
	je	.Lj104
	jmp	.Lj105
.Lj104:
# [300] Row := Rows - 1;
	movl	-20(%ebp),%eax
	leal	-1(%eax),%eax
	movl	%eax,-36(%ebp)
# [301] MainRows := 1;   // lixeira: unica na linha de baixo
	movl	$1,-28(%ebp)
# [302] ColOffset := 0;  // alinhada a direita
	movl	$0,-32(%ebp)
	jmp	.Lj106
.Lj105:
# [306] MainRows := Rows - 1;
	movl	-20(%ebp),%eax
	leal	-1(%eax),%eax
	movl	%eax,-28(%ebp)
# [307] if MainRows < 1 then
	cmpl	$1,-28(%ebp)
	jl	.Lj107
	jmp	.Lj108
.Lj107:
# [308] MainRows := 1;
	movl	$1,-28(%ebp)
	.balign 4,0x90
.Lj108:
# [309] Row := Index mod MainRows;
	movl	-16(%ebp),%eax
	cltd
	idivl	-28(%ebp)
	movl	%edx,-36(%ebp)
# [310] ColOffset := Index div MainRows;
	movl	-16(%ebp),%eax
	cltd
	idivl	-28(%ebp)
	movl	%eax,-32(%ebp)
.Lj106:
# [314] CellX := RWidth - IconRightMargin - IconCellW - ColOffset * IconCellW;
	movl	-32(%ebp),%eax
	imull	$96,%eax,%edx
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-8(%eax),%eax
	subl	$96,%eax
	subl	%edx,%eax
	movl	%eax,-48(%ebp)
# [315] CellY := StartY + Row * IconCellH;
	movl	-36(%ebp),%eax
	imull	$92,%eax,%eax
	addl	-40(%ebp),%eax
	movl	%eax,-52(%ebp)
# [319] IconX := CellX + (IconCellW - IconSizeW) div 2;
	movl	-48(%ebp),%eax
	leal	26(%eax),%eax
	movl	%eax,-56(%ebp)
# [320] IconY := CellY + IconTopOffset;
	movl	-52(%ebp),%eax
	leal	16(%eax),%eax
	movl	%eax,-60(%ebp)
# [321] DrawBMP(Icon, IconX, IconY);
	movl	-60(%ebp),%ecx
	movl	-56(%ebp),%edx
	movl	-8(%ebp),%eax
	call	VIDEO_$$_DRAWBMP$PCHAR$LONGINT$LONGINT
# [322] Shortcuts[ShortcutCount].IconX := IconX;
	movl	U_$PRISM_$$_SHORTCUTCOUNT,%eax
	imull	$48,%eax,%eax
	movl	-56(%ebp),%edx
	movl	%edx,U_$PRISM_$$_SHORTCUTS+12(,%eax)
# [323] Shortcuts[ShortcutCount].IconY := IconY;
	movl	U_$PRISM_$$_SHORTCUTCOUNT,%eax
	imull	$48,%eax,%edx
	movl	-60(%ebp),%eax
	movl	%eax,U_$PRISM_$$_SHORTCUTS+16(,%edx)
# [327] TW := StrLen(LabelText) * LabelSize;
	movl	-12(%ebp),%eax
	call	PRISM_$$_STRLEN$PCHAR$$LONGINT
	imull	$10,%eax
	movl	%eax,-64(%ebp)
# [328] IconY := CellY + IconTopOffset + IconSizeH + 6;
	movl	-52(%ebp),%eax
	leal	16(%eax),%eax
	leal	44(%eax),%eax
	leal	6(%eax),%eax
	movl	%eax,-60(%ebp)
# [329] FillRect(CellX + (IconCellW - TW) div 2 - 2, IconY - 2,
	pushl	$14
	pushl	$15
	movl	-64(%ebp),%edx
	movl	$96,%eax
	subl	%edx,%eax
	movl	%eax,%edx
	shrl	$31,%edx
	addl	%edx,%eax
	sarl	$1,%eax
	addl	-48(%ebp),%eax
	subl	$2,%eax
# [330] TW + 4, LabelSize + 4, 15);
	movl	-64(%ebp),%edx
	leal	4(%edx),%ecx
	movl	-60(%ebp),%edx
	leal	-2(%edx),%edx
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [331] WriteAt(CellX + (IconCellW - TW) div 2, IconY, LabelText, LabelSize);
	pushl	$10
	movl	-64(%ebp),%edx
	movl	$96,%eax
	subl	%edx,%eax
	movl	%eax,%edx
	shrl	$31,%edx
	addl	%edx,%eax
	sarl	$1,%eax
	addl	-48(%ebp),%eax
	movl	-12(%ebp),%ecx
	movl	-60(%ebp),%edx
	call	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
# [334] Shortcuts[ShortcutCount].Active := True;
	movl	U_$PRISM_$$_SHORTCUTCOUNT,%eax
	imull	$48,%eax,%eax
	movb	$1,U_$PRISM_$$_SHORTCUTS(,%eax)
# [335] Shortcuts[ShortcutCount].CellX := CellX;
	movl	U_$PRISM_$$_SHORTCUTCOUNT,%eax
	imull	$48,%eax,%eax
	movl	-48(%ebp),%edx
	movl	%edx,U_$PRISM_$$_SHORTCUTS+4(,%eax)
# [336] Shortcuts[ShortcutCount].CellY := CellY;
	movl	U_$PRISM_$$_SHORTCUTCOUNT,%eax
	imull	$48,%eax,%eax
	movl	-52(%ebp),%edx
	movl	%edx,U_$PRISM_$$_SHORTCUTS+8(,%eax)
# [337] Shortcuts[ShortcutCount].LabelX := CellX + (IconCellW - TW) div 2;
	movl	-64(%ebp),%edx
	movl	$96,%eax
	subl	%edx,%eax
	movl	%eax,%edx
	shrl	$31,%edx
	addl	%edx,%eax
	sarl	$1,%eax
	addl	-48(%ebp),%eax
	movl	U_$PRISM_$$_SHORTCUTCOUNT,%edx
	imull	$48,%edx,%edx
	movl	%eax,U_$PRISM_$$_SHORTCUTS+20(,%edx)
# [338] Shortcuts[ShortcutCount].LabelY := IconY;
	movl	U_$PRISM_$$_SHORTCUTCOUNT,%eax
	imull	$48,%eax,%eax
	movl	-60(%ebp),%edx
	movl	%edx,U_$PRISM_$$_SHORTCUTS+24(,%eax)
# [339] Shortcuts[ShortcutCount].TW := TW;
	movl	U_$PRISM_$$_SHORTCUTCOUNT,%eax
	imull	$48,%eax,%eax
	movl	-64(%ebp),%edx
	movl	%edx,U_$PRISM_$$_SHORTCUTS+28(,%eax)
# [340] Shortcuts[ShortcutCount].OpenProc := nil;
	movl	U_$PRISM_$$_SHORTCUTCOUNT,%eax
	imull	$48,%eax,%eax
	movl	$0,U_$PRISM_$$_SHORTCUTS+32(,%eax)
# [341] Shortcuts[ShortcutCount].RunPath := nil;
	movl	U_$PRISM_$$_SHORTCUTCOUNT,%eax
	imull	$48,%eax,%eax
	movl	$0,U_$PRISM_$$_SHORTCUTS+36(,%eax)
# [342] Shortcuts[ShortcutCount].Icon := Icon;
	movl	U_$PRISM_$$_SHORTCUTCOUNT,%eax
	imull	$48,%eax,%eax
	movl	-8(%ebp),%edx
	movl	%edx,U_$PRISM_$$_SHORTCUTS+40(,%eax)
# [343] Shortcuts[ShortcutCount].LabelText := LabelText;
	movl	U_$PRISM_$$_SHORTCUTCOUNT,%eax
	imull	$48,%eax,%eax
	movl	-12(%ebp),%edx
	movl	%edx,U_$PRISM_$$_SHORTCUTS+44(,%eax)
# [344] ShortcutOfButton[AddButtonEx(CellX, CellY, IconCellW, IconCellH,
	pushl	$92
# [345] @DesktopShortcutClick, @DesktopShortcutDblClick)] :=
	movl	$PRISM_$$_DESKTOPSHORTCUTCLICK,%eax
	pushl	%eax
	movl	$PRISM_$$_DESKTOPSHORTCUTDBLCLICK,%eax
	pushl	%eax
	movl	-52(%ebp),%edx
	movl	-48(%ebp),%eax
	movl	$96,%ecx
	call	BUTTONS_$$_ADDBUTTONEX$LONGINT$LONGINT$LONGINT$LONGINT$POINTER$POINTER$$LONGINT
	movl	U_$PRISM_$$_SHORTCUTCOUNT,%edx
	movl	%edx,U_$PRISM_$$_SHORTCUTOFBUTTON(,%eax,4)
# [347] Inc(ShortcutCount);
	addl	$1,U_$PRISM_$$_SHORTCUTCOUNT
.Lj91:
# [348] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_prism_$$_upch$char$$char,"x"
	.balign 16,0x90
PRISM_$$_UPCH$CHAR$$CHAR:
# [351] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var C located at ebp-4, size=OS_8
# Var $result located at ebp-8, size=OS_8
	movb	%al,-4(%ebp)
# [352] if (C >= 'a') and (C <= 'z') then
	cmpb	$97,-4(%ebp)
	jae	.Lj111
	jmp	.Lj112
.Lj111:
	cmpb	$122,-4(%ebp)
	jbe	.Lj113
	jmp	.Lj112
.Lj113:
# [353] UpCh := Char(Ord(C) - 32)
	movzbl	-4(%ebp),%eax
	subl	$32,%eax
	movb	%al,-8(%ebp)
	jmp	.Lj114
.Lj112:
# [355] UpCh := C;
	movb	-4(%ebp),%al
	movb	%al,-8(%ebp)
.Lj114:
# [356] end;
	movb	-8(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_prism_$$_copycleanname$pchar$longint$pchar$$longint,"x"
	.balign 16,0x90
PRISM_$$_COPYCLEANNAME$PCHAR$LONGINT$PCHAR$$LONGINT:
# [364] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-28(%esp),%esp
	pushl	%ebx
# Var List located at ebp-4, size=OS_32
# Var Idx located at ebp-8, size=OS_S32
# Var Dest located at ebp-12, size=OS_32
# Var $result located at ebp-16, size=OS_S32
# Var I located at ebp-20, size=OS_S32
# Var J located at ebp-24, size=OS_S32
# Var L located at ebp-28, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
	movl	%ecx,-12(%ebp)
# [365] J := 0;
	movl	$0,-24(%ebp)
# [366] for I := 0 to Idx - 1 do
	movl	-8(%ebp),%eax
	leal	-1(%eax),%eax
	cmpl	$0,%eax
	jge	.Lj117
	jmp	.Lj118
.Lj117:
	movl	$-1,-20(%ebp)
	.balign 8,0x90
.Lj119:
	movl	-20(%ebp),%edx
	leal	1(%edx),%edx
	movl	%edx,-20(%ebp)
# [368] while List[J] <> #0 do
	jmp	.Lj123
	.balign 8,0x90
.Lj122:
# [369] Inc(J);
	addl	$1,-24(%ebp)
.Lj123:
	movl	-4(%ebp),%edx
	movl	-24(%ebp),%ecx
	cmpb	$0,(%edx,%ecx,1)
	jne	.Lj122
	jmp	.Lj124
.Lj124:
# [370] Inc(J);   // pula o #0
	addl	$1,-24(%ebp)
	cmpl	-20(%ebp),%eax
	jle	.Lj121
	jmp	.Lj119
.Lj121:
	.balign 4,0x90
.Lj118:
# [372] L := 0;
	movl	$0,-28(%ebp)
# [373] while List[J] <> #0 do
	jmp	.Lj126
	.balign 8,0x90
.Lj125:
# [375] Dest[L] := List[J];
	movl	-12(%ebp),%ecx
	movl	-28(%ebp),%ebx
	movl	-4(%ebp),%eax
	movl	-24(%ebp),%edx
	movb	(%eax,%edx,1),%al
	movb	%al,(%ecx,%ebx,1)
# [376] Inc(L);
	addl	$1,-28(%ebp)
# [377] Inc(J);
	addl	$1,-24(%ebp)
.Lj126:
	movl	-4(%ebp),%edx
	movl	-24(%ebp),%eax
	cmpb	$0,(%edx,%eax,1)
	jne	.Lj125
	jmp	.Lj127
.Lj127:
# [380] if (L >= 2) and (Dest[L - 2] = ';') and (Dest[L - 1] = '1') then
	cmpl	$2,-28(%ebp)
	jge	.Lj128
	jmp	.Lj129
.Lj128:
	movl	-12(%ebp),%edx
	movl	-28(%ebp),%eax
	leal	-2(%eax),%eax
	cmpb	$59,(%edx,%eax,1)
	je	.Lj130
	jmp	.Lj129
.Lj130:
	movl	-12(%ebp),%edx
	movl	-28(%ebp),%eax
	leal	-1(%eax),%eax
	cmpb	$49,(%edx,%eax,1)
	je	.Lj131
	jmp	.Lj129
.Lj131:
# [381] L := L - 2;
	movl	-28(%ebp),%eax
	leal	-2(%eax),%eax
	movl	%eax,-28(%ebp)
	.balign 4,0x90
.Lj129:
# [382] Dest[L] := #0;
	movl	-12(%ebp),%edx
	movl	-28(%ebp),%eax
	movb	$0,(%edx,%eax,1)
# [383] Result := L;
	movl	-28(%ebp),%eax
	movl	%eax,-16(%ebp)
# [384] end;
	movl	-16(%ebp),%eax
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_prism_$$_endswithbmp$pchar$$boolean,"x"
	.balign 16,0x90
PRISM_$$_ENDSWITHBMP$PCHAR$$BOOLEAN:
# [391] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-16(%esp),%esp
# Var N located at ebp-4, size=OS_32
# Var $result located at ebp-8, size=OS_8
# Var L located at ebp-12, size=OS_S32
# Var E located at ebp-16, size=OS_32
	movl	%eax,-4(%ebp)
# [392] L := 0;
	movl	$0,-12(%ebp)
# [393] while (N[L] <> #0) and (L < 63) do
	jmp	.Lj135
	.balign 8,0x90
.Lj134:
# [394] Inc(L);
	addl	$1,-12(%ebp)
.Lj135:
	movl	-4(%ebp),%edx
	movl	-12(%ebp),%eax
	cmpb	$0,(%edx,%eax,1)
	jne	.Lj137
	jmp	.Lj138
.Lj137:
	cmpl	$63,-12(%ebp)
	jl	.Lj139
	jmp	.Lj138
.Lj139:
	jmp	.Lj134
.Lj138:
	jmp	.Lj136
.Lj136:
# [395] if L < 4 then
	cmpl	$4,-12(%ebp)
	jl	.Lj140
	jmp	.Lj141
.Lj140:
# [396] Exit(False);
	movb	$0,-8(%ebp)
	jmp	.Lj132
	.balign 4,0x90
.Lj141:
# [397] E[0] := UpCh(N[L - 4]);
	movl	-4(%ebp),%edx
	movl	-12(%ebp),%eax
	leal	-4(%eax),%eax
	movb	(%edx,%eax,1),%al
	call	PRISM_$$_UPCH$CHAR$$CHAR
	movb	%al,-16(%ebp)
# [398] E[1] := UpCh(N[L - 3]);
	movl	-4(%ebp),%edx
	movl	-12(%ebp),%eax
	leal	-3(%eax),%eax
	movb	(%edx,%eax,1),%al
	call	PRISM_$$_UPCH$CHAR$$CHAR
	movb	%al,-15(%ebp)
# [399] E[2] := UpCh(N[L - 2]);
	movl	-4(%ebp),%edx
	movl	-12(%ebp),%eax
	leal	-2(%eax),%eax
	movb	(%edx,%eax,1),%al
	call	PRISM_$$_UPCH$CHAR$$CHAR
	movb	%al,-14(%ebp)
# [400] E[3] := UpCh(N[L - 1]);
	movl	-4(%ebp),%edx
	movl	-12(%ebp),%eax
	leal	-1(%eax),%eax
	movb	(%edx,%eax,1),%al
	call	PRISM_$$_UPCH$CHAR$$CHAR
	movb	%al,-13(%ebp)
# [401] Result := (E[0] = '.') and (E[1] = 'B') and (E[2] = 'M') and (E[3] = 'P');
	cmpb	$46,-16(%ebp)
	je	.Lj142
	jmp	.Lj143
.Lj142:
	cmpb	$66,-15(%ebp)
	je	.Lj144
	jmp	.Lj143
.Lj144:
	cmpb	$77,-14(%ebp)
	je	.Lj145
	jmp	.Lj143
.Lj145:
	cmpb	$80,-13(%ebp)
	je	.Lj146
	jmp	.Lj143
.Lj146:
	movb	$1,-8(%ebp)
	jmp	.Lj147
.Lj143:
	movb	$0,-8(%ebp)
.Lj147:
.Lj132:
# [402] end;
	movb	-8(%ebp),%al
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_prism_$$_copybasename$pchar$pchar,"x"
	.balign 16,0x90
PRISM_$$_COPYBASENAME$PCHAR$PCHAR:
# [408] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-12(%esp),%esp
	pushl	%ebx
# Var N located at ebp-4, size=OS_32
# Var Dest located at ebp-8, size=OS_32
# Var I located at ebp-12, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
# [409] I := 0;
	movl	$0,-12(%ebp)
# [410] while (N[I] <> #0) and (N[I] <> '.') and (I < 31) do
	jmp	.Lj151
	.balign 8,0x90
.Lj150:
# [412] Dest[I] := N[I];
	movl	-8(%ebp),%ecx
	movl	-12(%ebp),%ebx
	movl	-4(%ebp),%eax
	movl	-12(%ebp),%edx
	movb	(%eax,%edx,1),%al
	movb	%al,(%ecx,%ebx,1)
# [413] Inc(I);
	addl	$1,-12(%ebp)
.Lj151:
	movl	-4(%ebp),%edx
	movl	-12(%ebp),%eax
	cmpb	$0,(%edx,%eax,1)
	jne	.Lj153
	jmp	.Lj154
.Lj153:
	movl	-4(%ebp),%eax
	movl	-12(%ebp),%edx
	cmpb	$46,(%eax,%edx,1)
	jne	.Lj155
	jmp	.Lj154
.Lj155:
	cmpl	$31,-12(%ebp)
	jl	.Lj156
	jmp	.Lj154
.Lj156:
	jmp	.Lj150
.Lj154:
	jmp	.Lj152
.Lj152:
# [415] Dest[I] := #0;
	movl	-8(%ebp),%eax
	movl	-12(%ebp),%edx
	movb	$0,(%eax,%edx,1)
# [416] end;
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_prism_$$_builddesktoppath$pchar$pchar$$longint,"x"
	.balign 16,0x90
PRISM_$$_BUILDDESKTOPPATH$PCHAR$PCHAR$$LONGINT:
# [425] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-16(%esp),%esp
# Var N located at ebp-4, size=OS_32
# Var Dest located at ebp-8, size=OS_32
# Var $result located at ebp-12, size=OS_S32
# Var I located at ebp-16, size=OS_S32
	movl	%eax,-4(%ebp)
	movl	%edx,-8(%ebp)
# [426] for I := 0 to 12 do
	movl	$-1,-16(%ebp)
	.balign 8,0x90
.Lj159:
	movl	-16(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-16(%ebp)
# [427] Dest[I] := Prefix[I];
	movl	-8(%ebp),%ecx
	movl	-16(%ebp),%edx
	movl	-16(%ebp),%eax
	movb	TC_$PRISM$_$BUILDDESKTOPPATH$PCHAR$PCHAR$$LONGINT_$$_PREFIX(,%eax,1),%al
	movb	%al,(%ecx,%edx,1)
	cmpl	$12,-16(%ebp)
	jge	.Lj161
	jmp	.Lj159
.Lj161:
# [428] I := 13;
	movl	$13,-16(%ebp)
# [429] while N^ <> #0 do
	jmp	.Lj163
	.balign 8,0x90
.Lj162:
# [431] Dest[I] := N^;
	movl	-8(%ebp),%ecx
	movl	-16(%ebp),%edx
	movl	-4(%ebp),%eax
	movb	(%eax),%al
	movb	%al,(%ecx,%edx,1)
# [432] Inc(I);
	addl	$1,-16(%ebp)
# [433] Inc(N);
	addl	$1,-4(%ebp)
.Lj163:
	movl	-4(%ebp),%eax
	cmpb	$0,(%eax)
	jne	.Lj162
	jmp	.Lj164
.Lj164:
# [435] Dest[I] := #0;
	movl	-8(%ebp),%edx
	movl	-16(%ebp),%eax
	movb	$0,(%edx,%eax,1)
# [436] Result := I;
	movl	-16(%ebp),%eax
	movl	%eax,-12(%ebp)
# [437] end;
	movl	-12(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_prism_$$_loaddesktopshortcuts,"x"
	.balign 16,0x90
PRISM_$$_LOADDESKTOPSHORTCUTS:
# [451] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-1192(%esp),%esp
	pushl	%ebx
# Var List located at ebp-1024, size=OS_NO
# Var CleanName located at ebp-1088, size=OS_NO
# Var Scratch located at ebp-1168, size=OS_NO
# Var Count located at ebp-1172, size=OS_S32
# Var I located at ebp-1176, size=OS_S32
# Var Idx located at ebp-1180, size=OS_S32
# Var NameLen located at ebp-1184, size=OS_S32
# Var PathLen located at ebp-1188, size=OS_S32
# Var HasBmp located at ebp-1192, size=OS_8
# [452] Count := FSListDir('USER\DESKTOP', @List[0], SizeOf(List));
	leal	-1024(%ebp),%eax
	movl	%eax,%edx
	movl	$1024,%ecx
	movl	$_$PRISM$_Ld2,%eax
	call	CDROM_$$_FSLISTDIR$PCHAR$PBYTE$LONGINT$$LONGINT
	movl	%eax,-1172(%ebp)
# [453] Idx := -1;
	movl	$-1,-1180(%ebp)
# [454] for I := 0 to Count - 1 do
	movl	-1172(%ebp),%eax
	leal	-1(%eax),%ebx
	cmpl	$0,%ebx
	jge	.Lj167
	jmp	.Lj168
.Lj167:
	movl	$-1,-1176(%ebp)
	.balign 8,0x90
.Lj169:
	movl	-1176(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-1176(%ebp)
# [456] NameLen := CopyCleanName(@List[0], I, @CleanName[0]);
	leal	-1088(%ebp),%ecx
	leal	-1024(%ebp),%eax
	movl	-1176(%ebp),%edx
	call	PRISM_$$_COPYCLEANNAME$PCHAR$LONGINT$PCHAR$$LONGINT
	movl	%eax,-1184(%ebp)
# [457] if (NameLen > 0) and not EndsWithBMP(@CleanName[0]) then
	cmpl	$0,-1184(%ebp)
	jg	.Lj172
	jmp	.Lj173
.Lj172:
	leal	-1088(%ebp),%eax
	call	PRISM_$$_ENDSWITHBMP$PCHAR$$BOOLEAN
	testb	%al,%al
	je	.Lj174
	jmp	.Lj173
.Lj174:
# [459] Inc(Idx);
	addl	$1,-1180(%ebp)
# [460] if Idx >= MaxShortcuts then
	cmpl	$16,-1180(%ebp)
	jge	.Lj175
	jmp	.Lj176
.Lj175:
# [461] Break;
	jmp	.Lj171
	.balign 4,0x90
.Lj176:
# [463] CopyBaseName(@CleanName[0], @ShortcutLabels[Idx][0]);
	movl	-1180(%ebp),%eax
	shll	$5,%eax
	leal	U_$PRISM_$$_SHORTCUTLABELS(,%eax),%edx
	leal	-1088(%ebp),%eax
	call	PRISM_$$_COPYBASENAME$PCHAR$PCHAR
# [465] BuildDesktopPath(@CleanName[0], @ShortcutRunPaths[Idx][0]);
	movl	-1180(%ebp),%eax
	imull	$80,%eax,%eax
	leal	U_$PRISM_$$_SHORTCUTRUNPATHS(,%eax),%edx
	leal	-1088(%ebp),%eax
	call	PRISM_$$_BUILDDESKTOPPATH$PCHAR$PCHAR$$LONGINT
# [468] PathLen := BuildDesktopPath(@CleanName[0], @ShortcutIconPaths[Idx][0]);
	movl	-1180(%ebp),%eax
	imull	$80,%eax,%eax
	leal	U_$PRISM_$$_SHORTCUTICONPATHS(,%eax),%edx
	leal	-1088(%ebp),%eax
	call	PRISM_$$_BUILDDESKTOPPATH$PCHAR$PCHAR$$LONGINT
	movl	%eax,-1188(%ebp)
# [469] if PathLen >= 4 then
	cmpl	$4,-1188(%ebp)
	jge	.Lj177
	jmp	.Lj178
.Lj177:
# [471] ShortcutIconPaths[Idx][PathLen - 3] := 'B';
	movl	-1180(%ebp),%eax
	imull	$80,%eax,%edx
	movl	-1188(%ebp),%eax
	leal	-3(%eax),%eax
	movb	$66,U_$PRISM_$$_SHORTCUTICONPATHS(%edx,%eax,1)
# [472] ShortcutIconPaths[Idx][PathLen - 2] := 'M';
	movl	-1180(%ebp),%eax
	imull	$80,%eax,%edx
	movl	-1188(%ebp),%eax
	leal	-2(%eax),%eax
	movb	$77,U_$PRISM_$$_SHORTCUTICONPATHS(%edx,%eax,1)
# [473] ShortcutIconPaths[Idx][PathLen - 1] := 'P';
	movl	-1180(%ebp),%eax
	imull	$80,%eax,%edx
	movl	-1188(%ebp),%eax
	leal	-1(%eax),%eax
	movb	$80,U_$PRISM_$$_SHORTCUTICONPATHS(%edx,%eax,1)
	.balign 4,0x90
.Lj178:
# [476] HasBmp := FSReadFile(@ShortcutIconPaths[Idx][0], @Scratch[0], SizeOf(Scratch)) > 0;
	movl	-1180(%ebp),%eax
	imull	$80,%eax,%eax
	leal	U_$PRISM_$$_SHORTCUTICONPATHS(,%eax),%eax
	leal	-1168(%ebp),%edx
	movl	$80,%ecx
	call	CDROM_$$_FSREADFILE$PCHAR$PBYTE$LONGWORD$$LONGINT
	cmpl	$0,%eax
	setgb	-1192(%ebp)
# [477] if HasBmp then
	cmpb	$0,-1192(%ebp)
	jne	.Lj179
	jmp	.Lj180
.Lj179:
# [478] DesktopShortcut(0, @ShortcutIconPaths[Idx][0], @ShortcutLabels[Idx][0])
	movl	-1180(%ebp),%eax
	shll	$5,%eax
	leal	U_$PRISM_$$_SHORTCUTLABELS(,%eax),%ecx
	movl	-1180(%ebp),%eax
	imull	$80,%eax,%eax
	leal	U_$PRISM_$$_SHORTCUTICONPATHS(,%eax),%edx
	movl	$0,%eax
	call	PRISM_$$_DESKTOPSHORTCUT$LONGINT$PCHAR$PCHAR
	jmp	.Lj181
.Lj180:
# [480] DesktopShortcut(0, DefaultIcon, @ShortcutLabels[Idx][0]);
	movl	-1180(%ebp),%eax
	shll	$5,%eax
	leal	U_$PRISM_$$_SHORTCUTLABELS(,%eax),%ecx
	movl	$_$PRISM$_Ld3,%edx
	movl	$0,%eax
	call	PRISM_$$_DESKTOPSHORTCUT$LONGINT$PCHAR$PCHAR
.Lj181:
# [481] Shortcuts[ShortcutCount - 1].RunPath := @ShortcutRunPaths[Idx][0];
	movl	U_$PRISM_$$_SHORTCUTCOUNT,%eax
	leal	-1(%eax),%eax
	imull	$48,%eax,%edx
	movl	-1180(%ebp),%eax
	imull	$80,%eax,%eax
	leal	U_$PRISM_$$_SHORTCUTRUNPATHS(,%eax),%eax
	movl	%eax,U_$PRISM_$$_SHORTCUTS+36(,%edx)
	.balign 4,0x90
.Lj173:
	cmpl	-1176(%ebp),%ebx
	jle	.Lj171
	jmp	.Lj169
.Lj171:
	.balign 4,0x90
.Lj168:
# [484] end;
	popl	%ebx
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_prism_$$_mainmenu,"x"
	.balign 16,0x90
PRISM_$$_MAINMENU:
# [492] begin
	pushl	%ebp
	movl	%esp,%ebp
# [493] if not isMenuOpen then
	cmpb	$0,U_$PRISM_$$_ISMENUOPEN
	je	.Lj184
	jmp	.Lj185
.Lj184:
# [497] SaveScreenArea(MenuX, MenuY, MenuW, MenuH);
	pushl	$250
	movl	$165,%ecx
	movl	$25,%edx
	movl	$0,%eax
	call	VIDEO_$$_SAVESCREENAREA$LONGINT$LONGINT$LONGINT$LONGINT
# [498] FillRect(MenuX, MenuY, MenuW, MenuH, $0F);
	pushl	$250
	pushl	$15
	movl	$165,%ecx
	movl	$25,%edx
	movl	$0,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [499] FillRect(MenuX, MenuY, MenuW, 1, 0);
	pushl	$1
	pushl	$0
	movl	$165,%ecx
	movl	$25,%edx
	movl	$0,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [500] FillRect(MenuX, MenuY + MenuH - 1, MenuW, 1, 0);
	pushl	$1
	pushl	$0
	movl	$165,%ecx
	movl	$274,%edx
	movl	$0,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [501] FillRect(MenuX, MenuY, 1, MenuH, 0);
	pushl	$250
	pushl	$0
	movl	$1,%ecx
	movl	$25,%edx
	movl	$0,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [502] FillRect(MenuX + MenuW - 1, MenuY, 1, MenuH, 0);
	pushl	$250
	pushl	$0
	movl	$1,%ecx
	movl	$25,%edx
	movl	$164,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [503] isMenuOpen := true;
	movb	$1,U_$PRISM_$$_ISMENUOPEN
	jmp	.Lj186
.Lj185:
# [507] RestoreScreenArea(MenuX, MenuY, MenuW, MenuH);
	pushl	$250
	movl	$165,%ecx
	movl	$25,%edx
	movl	$0,%eax
	call	VIDEO_$$_RESTORESCREENAREA$LONGINT$LONGINT$LONGINT$LONGINT
# [508] isMenuOpen := false;
	movb	$0,U_$PRISM_$$_ISMENUOPEN
.Lj186:
# [510] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_prism_$$_lowres,"x"
	.balign 16,0x90
PRISM_$$_LOWRES:
# [513] begin
	pushl	%ebp
	movl	%esp,%ebp
# [515] FillRect(0, 0, RWidth, 25, $0F);
	pushl	$25
	pushl	$15
	movl	U_$VIDEO_$$_RWIDTH,%ecx
	movl	$0,%edx
	movl	$0,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [516] FillRect(0, 25, RWidth, 1, 0);
	pushl	$1
	pushl	$0
	movl	U_$VIDEO_$$_RWIDTH,%ecx
	movl	$25,%edx
	movl	$0,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [523] DrawBMP('SYSTEM\COMPILED\PRISM\BITMAP\ICON.BMP', 7,5);
	movl	$5,%ecx
	movl	$7,%edx
	movl	$_$PRISM$_Ld4,%eax
	call	VIDEO_$$_DRAWBMP$PCHAR$LONGINT$LONGINT
# [524] AddButton(7,7, 12, 12, @MainMenu);
	pushl	$12
	movl	$PRISM_$$_MAINMENU,%eax
	pushl	%eax
	movl	$12,%ecx
	movl	$7,%edx
	movl	$7,%eax
	call	BUTTONS_$$_ADDBUTTON$LONGINT$LONGINT$LONGINT$LONGINT$POINTER$$LONGINT
# [525] DrawMenuBar;
	call	PRISM_$$_DRAWMENUBAR
# [528] FillRect(0,0, 5, 1, 0);
	pushl	$1
	pushl	$0
	movl	$5,%ecx
	movl	$0,%edx
	movl	$0,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [529] FillRect(0,1, 3, 1, 0);
	pushl	$1
	pushl	$0
	movl	$3,%ecx
	movl	$1,%edx
	movl	$0,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [530] FillRect(0,2, 2, 1, 0);
	pushl	$1
	pushl	$0
	movl	$2,%ecx
	movl	$2,%edx
	movl	$0,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [531] PutPixel(0,3, 0);
	movb	$0,%cl
	movl	$3,%edx
	movl	$0,%eax
	call	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
# [532] PutPixel(0,4, 0);
	movb	$0,%cl
	movl	$4,%edx
	movl	$0,%eax
	call	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
# [534] FillRect(RWidth - 5,0, 5, 1, 0);
	pushl	$1
	pushl	$0
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-5(%eax),%eax
	movl	$5,%ecx
	movl	$0,%edx
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [535] FillRect(RWidth - 3,1, 3, 1, 0);
	pushl	$1
	pushl	$0
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-3(%eax),%eax
	movl	$3,%ecx
	movl	$1,%edx
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [536] FillRect(RWidth - 2,2, 2, 1, 0);
	pushl	$1
	pushl	$0
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-2(%eax),%eax
	movl	$2,%ecx
	movl	$2,%edx
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [537] PutPixel(RWidth - 1,3, 0);
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-1(%eax),%eax
	movb	$0,%cl
	movl	$3,%edx
	call	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
# [538] PutPixel(RWidth - 1,4, 0);
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-1(%eax),%eax
	movb	$0,%cl
	movl	$4,%edx
	call	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
# [539] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_prism_$$_highres,"x"
	.balign 16,0x90
PRISM_$$_HIGHRES:
# [542] begin // for now this will be the same as 480p
	pushl	%ebp
	movl	%esp,%ebp
# [544] FillRect(0, 0, RWidth, 25, $0F);
	pushl	$25
	pushl	$15
	movl	U_$VIDEO_$$_RWIDTH,%ecx
	movl	$0,%edx
	movl	$0,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [545] FillRect(0, 26, RWidth, 1, 0);
	pushl	$1
	pushl	$0
	movl	U_$VIDEO_$$_RWIDTH,%ecx
	movl	$26,%edx
	movl	$0,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [547] PutSymbol(7,7, '#', 12);
	pushl	$12
	movb	$35,%cl
	movl	$7,%edx
	movl	$7,%eax
	call	VIDEO_$$_PUTSYMBOL$LONGINT$LONGINT$CHAR$LONGINT
# [548] PutPixel(13,13, 0);
	movb	$0,%cl
	movl	$13,%edx
	movl	$13,%eax
	call	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
# [549] PutPixel(12,13, 0);
	movb	$0,%cl
	movl	$13,%edx
	movl	$12,%eax
	call	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
# [550] PutPixel(13,12, 0);
	movb	$0,%cl
	movl	$12,%edx
	movl	$13,%eax
	call	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
# [551] PutPixel(12,12, 0);
	movb	$0,%cl
	movl	$12,%edx
	movl	$12,%eax
	call	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
# [552] DrawMenuBar;
	call	PRISM_$$_DRAWMENUBAR
# [555] FillRect(0,0, 5, 1, 0);
	pushl	$1
	pushl	$0
	movl	$5,%ecx
	movl	$0,%edx
	movl	$0,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [556] FillRect(0,1, 3, 1, 0);
	pushl	$1
	pushl	$0
	movl	$3,%ecx
	movl	$1,%edx
	movl	$0,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [557] FillRect(0,2, 2, 1, 0);
	pushl	$1
	pushl	$0
	movl	$2,%ecx
	movl	$2,%edx
	movl	$0,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [558] PutPixel(0,3, 0);
	movb	$0,%cl
	movl	$3,%edx
	movl	$0,%eax
	call	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
# [559] PutPixel(0,4, 0);
	movb	$0,%cl
	movl	$4,%edx
	movl	$0,%eax
	call	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
# [561] FillRect(RWidth - 5,0, 5, 1, 0);
	pushl	$1
	pushl	$0
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-5(%eax),%eax
	movl	$5,%ecx
	movl	$0,%edx
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [562] FillRect(RWidth - 3,1, 3, 1, 0);
	pushl	$1
	pushl	$0
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-3(%eax),%eax
	movl	$3,%ecx
	movl	$1,%edx
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [563] FillRect(RWidth - 2,2, 2, 1, 0);
	pushl	$1
	pushl	$0
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-2(%eax),%eax
	movl	$2,%ecx
	movl	$2,%edx
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [564] PutPixel(RWidth - 1,3, 0);
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-1(%eax),%eax
	movb	$0,%cl
	movl	$3,%edx
	call	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
# [565] PutPixel(RWidth - 1,4, 0);
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-1(%eax),%eax
	movb	$0,%cl
	movl	$4,%edx
	call	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
# [566] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_prism_$$_openaetherhd,"x"
	.balign 16,0x90
PRISM_$$_OPENAETHERHD:
# [569] begin
	pushl	%ebp
	movl	%esp,%ebp
# [571] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_prism_$$_prisminit,"x"
	.balign 16,0x90
.globl	PRISM_$$_PRISMINIT
PRISM_$$_PRISMINIT:
# [576] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-4(%esp),%esp
# Var i located at ebp-4, size=OS_S32
# [577] ActiveWindow := 'Prism';
	movl	$_$PRISM$_Ld5,%eax
	movl	%eax,U_$PRISM_$$_ACTIVEWINDOW
# [578] for i := 0 to 63 do
	movl	$-1,-4(%ebp)
	.balign 8,0x90
.Lj195:
	movl	-4(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-4(%ebp)
# [579] ShortcutOfButton[i] := -1;
	movl	-4(%ebp),%eax
	movl	$-1,U_$PRISM_$$_SHORTCUTOFBUTTON(,%eax,4)
	cmpl	$63,-4(%ebp)
	jge	.Lj197
	jmp	.Lj195
.Lj197:
# [580] ShortcutCount := 0;
	movl	$0,U_$PRISM_$$_SHORTCUTCOUNT
# [581] SelectedShortcut := -1;
	movl	$-1,U_$PRISM_$$_SELECTEDSHORTCUT
# [583] Menus[0].Text := 'File';   Menus[0].OnClick := nil;
	movl	$_$PRISM$_Ld6,%eax
	movl	%eax,U_$PRISM_$$_MENUS
	movl	$0,U_$PRISM_$$_MENUS+4
# [584] Menus[1].Text := 'Edit';   Menus[1].OnClick := nil;
	movl	$_$PRISM$_Ld7,%eax
	movl	%eax,U_$PRISM_$$_MENUS+8
	movl	$0,U_$PRISM_$$_MENUS+12
# [585] Menus[2].Text := 'View';   Menus[2].OnClick := nil;
	movl	$_$PRISM$_Ld8,%eax
	movl	%eax,U_$PRISM_$$_MENUS+16
	movl	$0,U_$PRISM_$$_MENUS+20
# [586] Menus[3].Text := 'Special';   Menus[3].OnClick := nil;
	movl	$_$PRISM$_Ld9,%eax
	movl	%eax,U_$PRISM_$$_MENUS+24
	movl	$0,U_$PRISM_$$_MENUS+28
# [587] Menus[4].Text := nil;
	movl	$0,U_$PRISM_$$_MENUS+32
# [589] ClearScreen($0F);
	movb	$15,%al
	call	VIDEO_$$_CLEARSCREEN$BYTE
# [590] FillPattern8x8(MacGray, 0, $0F);
	pushl	$15
	movl	$TC_$PRISM_$$_MACGRAY,%eax
	movb	$0,%cl
	movl	$7,%edx
	call	VIDEO_$$_FILLPATTERN8X8$array_of_BYTE$BYTE$BYTE
# [592] if RHeight = 480 then
	cmpl	$480,U_$VIDEO_$$_RHEIGHT
	je	.Lj198
	jmp	.Lj199
.Lj198:
# [594] lowres;
	call	PRISM_$$_LOWRES
	.balign 4,0x90
.Lj199:
# [596] if RHeight = 720 then
	cmpl	$720,U_$VIDEO_$$_RHEIGHT
	je	.Lj200
	jmp	.Lj201
.Lj200:
# [598] highres;
	call	PRISM_$$_HIGHRES
	.balign 4,0x90
.Lj201:
# [600] isMenuOpen := false;
	movb	$0,U_$PRISM_$$_ISMENUOPEN
# [601] dock;
	call	PRISM_$$_DOCK
# [604] LoadDesktopShortcuts;
	call	PRISM_$$_LOADDESKTOPSHORTCUTS
# [605] end;
	movl	%ebp,%esp
	popl	%ebp
	ret
# End asmlist al_procedures
# Begin asmlist al_globals

.section .bss
	.balign 4
# [18] ActiveWindow: PChar;
	.globl U_$PRISM_$$_ACTIVEWINDOW
U_$PRISM_$$_ACTIVEWINDOW:
	.zero 4

.section .bss
	.balign 4
# [20] Menus: array[0..MaxMenus - 1] of record
	.globl U_$PRISM_$$_MENUS
U_$PRISM_$$_MENUS:
	.zero 128

.section .bss
# [34] isMenuOpen: Boolean;
U_$PRISM_$$_ISMENUOPEN:
	.zero 1

.section .bss
	.balign 4
# [48] ShortcutCount: Integer;
U_$PRISM_$$_SHORTCUTCOUNT:
	.zero 4

.section .bss
	.balign 4
# [69] Shortcuts: array[0..MaxShortcuts - 1] of TShortcut;
U_$PRISM_$$_SHORTCUTS:
	.zero 768

.section .bss
	.balign 4
# [70] SelectedShortcut: Integer;
U_$PRISM_$$_SELECTEDSHORTCUT:
	.zero 4

.section .bss
	.balign 4
# [71] ShortcutOfButton: array[0..63] of Integer;
U_$PRISM_$$_SHORTCUTOFBUTTON:
	.zero 256

.section .bss
# [72] ShortcutLabels: array[0..MaxShortcuts - 1, 0..31] of Char;
U_$PRISM_$$_SHORTCUTLABELS:
	.zero 512

.section .bss
# [73] ShortcutIconPaths: array[0..MaxShortcuts - 1, 0..79] of Char;
U_$PRISM_$$_SHORTCUTICONPATHS:
	.zero 1280

.section .bss
# [74] ShortcutRunPaths: array[0..MaxShortcuts - 1, 0..79] of Char;
U_$PRISM_$$_SHORTCUTRUNPATHS:
	.zero 1280

.section .bss
	.balign 4
# [200] MenuButtons: array[0..MaxMenus - 1] of Integer;
U_$PRISM_$$_MENUBUTTONS:
	.zero 64

.section .bss
	.balign 4
# [201] MenuButtonCount: Integer;
U_$PRISM_$$_MENUBUTTONCOUNT:
	.zero 4
# End asmlist al_globals
# Begin asmlist al_typedconsts

.section .data.n_TC_$PRISM_$$_MACGRAY,"d"
TC_$PRISM_$$_MACGRAY:
	.byte	170,85,170,85,170,85,170,85
# [38] IconCellW = 96;

.section .rodata.n__$PRISM$_Ld1,"d"
	.balign 4
.globl	_$PRISM$_Ld1
_$PRISM$_Ld1:
	.ascii	"SYSTEM\\COMPILED\\PRISM\\BITMAP\\FOLDER.BMP\000"

.section .data.n_TC_$PRISM$_$BUILDDESKTOPPATH$PCHAR$PCHAR$$LONGINT_$$_PREFIX,"d"
TC_$PRISM$_$BUILDDESKTOPPATH$PCHAR$PCHAR$$LONGINT_$$_PREFIX:
	.byte	85,83,69,82,92,68,69,83,75,84,79,80,92
# [423] var

.section .rodata.n__$PRISM$_Ld2,"d"
	.balign 4
.globl	_$PRISM$_Ld2
_$PRISM$_Ld2:
	.ascii	"USER\\DESKTOP\000"

.section .rodata.n__$PRISM$_Ld3,"d"
	.balign 4
.globl	_$PRISM$_Ld3
_$PRISM$_Ld3:
	.ascii	"SYSTEM\\COMPILED\\PRISM\\BITMAP\\FLOPPY@2.BMP\000"

.section .rodata.n__$PRISM$_Ld4,"d"
	.balign 4
.globl	_$PRISM$_Ld4
_$PRISM$_Ld4:
	.ascii	"SYSTEM\\COMPILED\\PRISM\\BITMAP\\ICON.BMP\000"

.section .rodata.n__$PRISM$_Ld5,"d"
	.balign 4
.globl	_$PRISM$_Ld5
_$PRISM$_Ld5:
	.ascii	"Prism\000"

.section .rodata.n__$PRISM$_Ld6,"d"
	.balign 4
.globl	_$PRISM$_Ld6
_$PRISM$_Ld6:
	.ascii	"File\000"

.section .rodata.n__$PRISM$_Ld7,"d"
	.balign 4
.globl	_$PRISM$_Ld7
_$PRISM$_Ld7:
	.ascii	"Edit\000"

.section .rodata.n__$PRISM$_Ld8,"d"
	.balign 4
.globl	_$PRISM$_Ld8
_$PRISM$_Ld8:
	.ascii	"View\000"

.section .rodata.n__$PRISM$_Ld9,"d"
	.balign 4
.globl	_$PRISM$_Ld9
_$PRISM$_Ld9:
	.ascii	"Special\000"
# End asmlist al_typedconsts

