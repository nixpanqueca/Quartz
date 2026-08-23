	.file "seek.pas"
# Begin asmlist al_procedures

.section .text.n_seek_$$_strlen$pchar$$longint,"x"
	.balign 16,0x90
SEEK_$$_STRLEN$PCHAR$$LONGINT:
# [seek.pas]
# [37] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-8(%esp),%esp
# Var S located at ebp-4, size=OS_32
# Var $result located at ebp-8, size=OS_S32
	movl	%eax,-4(%ebp)
# [38] Result := 0;
	movl	$0,-8(%ebp)
# [39] if S = nil then
	cmpl	$0,-4(%ebp)
	je	.Lj5
	jmp	.Lj6
.Lj5:
# [40] Exit;
	jmp	.Lj3
	.balign 4,0x90
.Lj6:
# [41] while S[Result] <> #0 do
	jmp	.Lj8
	.balign 8,0x90
.Lj7:
# [42] Result := Result + 1;
	movl	-8(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-8(%ebp)
.Lj8:
	movl	-4(%ebp),%eax
	movl	-8(%ebp),%edx
	cmpb	$0,(%eax,%edx,1)
	jne	.Lj7
	jmp	.Lj9
.Lj9:
.Lj3:
# [43] end;
	movl	-8(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_seek_$$_menubarheight$$longint,"x"
	.balign 16,0x90
SEEK_$$_MENUBARHEIGHT$$LONGINT:
# [46] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-4(%esp),%esp
# Var $result located at ebp-4, size=OS_S32
# [47] if RHeight = 720 then
	cmpl	$720,U_$VIDEO_$$_RHEIGHT
	je	.Lj12
	jmp	.Lj13
.Lj12:
# [48] Result := 21
	movl	$21,-4(%ebp)
	jmp	.Lj14
.Lj13:
# [50] Result := 25;
	movl	$25,-4(%ebp)
.Lj14:
# [51] end;
	movl	-4(%ebp),%eax
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_seek_$$_removemenubuttons,"x"
	.balign 16,0x90
SEEK_$$_REMOVEMENUBUTTONS:
# [60] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-4(%esp),%esp
# Var i located at ebp-4, size=OS_S32
# [61] for i := MenuButtonCount - 1 downto 0 do
	movl	U_$SEEK_$$_MENUBUTTONCOUNT,%eax
	leal	-1(%eax),%eax
	cmpl	$0,%eax
	jge	.Lj17
	jmp	.Lj18
.Lj17:
	movl	%eax,-4(%ebp)
	movl	-4(%ebp),%eax
	leal	1(%eax),%eax
	movl	%eax,-4(%ebp)
	.balign 8,0x90
.Lj19:
	movl	-4(%ebp),%eax
	leal	-1(%eax),%eax
	movl	%eax,-4(%ebp)
# [62] RemoveButton(MenuButtons[i]);
	movl	-4(%ebp),%eax
	movl	U_$SEEK_$$_MENUBUTTONS(,%eax,4),%eax
	call	BUTTONS_$$_REMOVEBUTTON$LONGINT
	cmpl	$0,-4(%ebp)
	jle	.Lj21
	jmp	.Lj19
.Lj21:
	.balign 4,0x90
.Lj18:
# [63] MenuButtonCount := 0;
	movl	$0,U_$SEEK_$$_MENUBUTTONCOUNT
# [64] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_seek_$$_drawmenubar,"x"
	.balign 16,0x90
SEEK_$$_DRAWMENUBAR:
# [69] begin
	pushl	%ebp
	movl	%esp,%ebp
	leal	-12(%esp),%esp
# Var i located at ebp-4, size=OS_S32
# Var X located at ebp-8, size=OS_S32
# Var W located at ebp-12, size=OS_S32
# [71] FillRect(28, 0, RWidth - 35, MenuBarHeight, $0F);
	call	SEEK_$$_MENUBARHEIGHT$$LONGINT
	pushl	%eax
	pushl	$15
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-35(%eax),%ecx
	movl	$0,%edx
	movl	$28,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [72] RemoveMenuButtons;
	call	SEEK_$$_REMOVEMENUBUTTONS
# [74] X := 30;
	movl	$30,-8(%ebp)
# [75] i := 0;
	movl	$0,-4(%ebp)
# [76] while Menus[i].Text <> nil do
	jmp	.Lj25
	.balign 8,0x90
.Lj24:
# [78] W := StrLen(Menus[i].Text) * 12;
	movl	-4(%ebp),%eax
	movl	U_$SEEK_$$_MENUS(,%eax,8),%eax
	call	SEEK_$$_STRLEN$PCHAR$$LONGINT
	imull	$12,%eax
	movl	%eax,-12(%ebp)
# [79] WriteAt(X, 7, Menus[i].Text, 12);
	pushl	$12
	movl	-4(%ebp),%eax
	movl	U_$SEEK_$$_MENUS(,%eax,8),%ecx
	movl	-8(%ebp),%eax
	movl	$7,%edx
	call	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
# [80] MenuButtons[MenuButtonCount] := AddButton(X, 0, W, MenuBarHeight, Pointer(Menus[i].OnClick));
	call	SEEK_$$_MENUBARHEIGHT$$LONGINT
	pushl	%eax
	movl	-4(%ebp),%eax
	pushl	U_$SEEK_$$_MENUS+4(,%eax,8)
	movl	-12(%ebp),%ecx
	movl	-8(%ebp),%eax
	movl	$0,%edx
	call	BUTTONS_$$_ADDBUTTON$LONGINT$LONGINT$LONGINT$LONGINT$POINTER$$LONGINT
	movl	U_$SEEK_$$_MENUBUTTONCOUNT,%edx
	movl	%eax,U_$SEEK_$$_MENUBUTTONS(,%edx,4)
# [81] Inc(MenuButtonCount);
	addl	$1,U_$SEEK_$$_MENUBUTTONCOUNT
# [82] X := X + W + 14;
	movl	-8(%ebp),%edx
	movl	-12(%ebp),%eax
	leal	(%edx,%eax),%eax
	leal	14(%eax),%eax
	movl	%eax,-8(%ebp)
# [83] Inc(i);
	addl	$1,-4(%ebp)
.Lj25:
	movl	-4(%ebp),%eax
	cmpl	$0,U_$SEEK_$$_MENUS(,%eax,8)
	jne	.Lj24
	jmp	.Lj26
.Lj26:
# [86] X := StrLen(ActiveWindow) * 12;
	movl	U_$SEEK_$$_ACTIVEWINDOW,%eax
	call	SEEK_$$_STRLEN$PCHAR$$LONGINT
	imull	$12,%eax
	movl	%eax,-8(%ebp)
# [87] WriteAt(RWidth - 8 - X, 7, ActiveWindow, 12);
	pushl	$12
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-8(%eax),%eax
	subl	-8(%ebp),%eax
	movl	U_$SEEK_$$_ACTIVEWINDOW,%ecx
	movl	$7,%edx
	call	VIDEO_$$_WRITEAT$LONGINT$LONGINT$PCHAR$LONGINT
# [88] FillRect(RWidth-8-X-8,0, 1, 25, 0);
	pushl	$25
	pushl	$0
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-8(%eax),%eax
	subl	-8(%ebp),%eax
	subl	$8,%eax
	movl	$1,%ecx
	movl	$0,%edx
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [89] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_seek_$$_updatemenubar,"x"
	.balign 16,0x90
.globl	SEEK_$$_UPDATEMENUBAR
SEEK_$$_UPDATEMENUBAR:
# [92] begin
	pushl	%ebp
	movl	%esp,%ebp
# [93] DrawMenuBar;
	call	SEEK_$$_DRAWMENUBAR
# [94] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_seek_$$_dock,"x"
	.balign 16,0x90
SEEK_$$_DOCK:
# [97] begin
	pushl	%ebp
	movl	%esp,%ebp
# [99] FillRect(0, RHeight - 25, RWidth div 2 + 15, 25, $0F);
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
# [101] FillRect(0, RHeight - 26, RWidth div 2 + 15, 1, 0);
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
# [102] FillRect(RWidth div 2 + 15, RHeight - 26, 1, 25, 0);
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
# [103] PutPixel(RWidth div 2 + 15, RHeight - 26, $0F);
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
# [106] FillRect(6, RHeight - 20, 15, 15, 0);
	pushl	$15
	pushl	$0
	movl	U_$VIDEO_$$_RHEIGHT,%eax
	leal	-20(%eax),%edx
	movl	$15,%ecx
	movl	$6,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [107] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_seek_$$_showdesktop,"x"
	.balign 16,0x90
SEEK_$$_SHOWDESKTOP:
# [110] begin
	pushl	%ebp
	movl	%esp,%ebp
# [111] FillPatternRect(0,26, RWidth, RHeight - 26, MacGray,0,$0F);
	movl	U_$VIDEO_$$_RHEIGHT,%eax
	leal	-26(%eax),%eax
	pushl	%eax
	pushl	$TC_$SEEK_$$_MACGRAY
	pushl	$7
	pushl	$0
	pushl	$15
	movl	U_$VIDEO_$$_RWIDTH,%ecx
	movl	$26,%edx
	movl	$0,%eax
	call	VIDEO_$$_FILLPATTERNRECT$LONGINT$LONGINT$LONGINT$LONGINT$array_of_BYTE$BYTE$BYTE
# [112] dock;
	call	SEEK_$$_DOCK
# [113] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_seek_$$_mainmenu,"x"
	.balign 16,0x90
SEEK_$$_MAINMENU:
# [116] begin
	pushl	%ebp
	movl	%esp,%ebp
# [117] if StrEqual(ActiveWindow, 'Seek') then
	movl	U_$SEEK_$$_ACTIVEWINDOW,%eax
	movl	$_$SEEK$_Ld1,%edx
	call	BUTTONS_$$_STREQUAL$PCHAR$PCHAR$$BOOLEAN
	testb	%al,%al
	jne	.Lj35
	jmp	.Lj36
.Lj35:
# [119] if not isMenuOpen then
	cmpb	$0,U_$SEEK_$$_ISMENUOPEN
	je	.Lj37
	jmp	.Lj38
.Lj37:
# [121] FillRect(0, 26, 165, 250, $0F);
	pushl	$250
	pushl	$15
	movl	$165,%ecx
	movl	$26,%edx
	movl	$0,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [122] isMenuOpen := true;
	movb	$1,U_$SEEK_$$_ISMENUOPEN
	jmp	.Lj39
.Lj38:
# [126] ShowDesktop;
	call	SEEK_$$_SHOWDESKTOP
# [127] isMenuOpen := false;
	movb	$0,U_$SEEK_$$_ISMENUOPEN
.Lj39:
	jmp	.Lj40
.Lj36:
# [132] ShowDesktop;
	call	SEEK_$$_SHOWDESKTOP
# [133] isMenuOpen := false;
	movb	$0,U_$SEEK_$$_ISMENUOPEN
.Lj40:
# [135] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_seek_$$_lowres,"x"
	.balign 16,0x90
SEEK_$$_LOWRES:
# [138] begin
	pushl	%ebp
	movl	%esp,%ebp
# [140] FillRect(0, 0, RWidth, 25, $0F);
	pushl	$25
	pushl	$15
	movl	U_$VIDEO_$$_RWIDTH,%ecx
	movl	$0,%edx
	movl	$0,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [141] FillRect(0, 25, RWidth, 1, 0);
	pushl	$1
	pushl	$0
	movl	U_$VIDEO_$$_RWIDTH,%ecx
	movl	$25,%edx
	movl	$0,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [143] PutSymbol(7,7, '#', 12);
	pushl	$12
	movb	$35,%cl
	movl	$7,%edx
	movl	$7,%eax
	call	VIDEO_$$_PUTSYMBOL$LONGINT$LONGINT$CHAR$LONGINT
# [144] PutPixel(13,13, 0);
	movb	$0,%cl
	movl	$13,%edx
	movl	$13,%eax
	call	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
# [145] PutPixel(12,13, 0);
	movb	$0,%cl
	movl	$13,%edx
	movl	$12,%eax
	call	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
# [146] PutPixel(13,12, 0);
	movb	$0,%cl
	movl	$12,%edx
	movl	$13,%eax
	call	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
# [147] PutPixel(12,12, 0);
	movb	$0,%cl
	movl	$12,%edx
	movl	$12,%eax
	call	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
# [148] AddButton(7,7, 12, 12, @MainMenu);
	pushl	$12
	movl	$SEEK_$$_MAINMENU,%eax
	pushl	%eax
	movl	$12,%ecx
	movl	$7,%edx
	movl	$7,%eax
	call	BUTTONS_$$_ADDBUTTON$LONGINT$LONGINT$LONGINT$LONGINT$POINTER$$LONGINT
# [149] DrawMenuBar;
	call	SEEK_$$_DRAWMENUBAR
# [152] FillRect(0,0, 5, 1, 0);
	pushl	$1
	pushl	$0
	movl	$5,%ecx
	movl	$0,%edx
	movl	$0,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [153] FillRect(0,1, 3, 1, 0);
	pushl	$1
	pushl	$0
	movl	$3,%ecx
	movl	$1,%edx
	movl	$0,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [154] FillRect(0,2, 2, 1, 0);
	pushl	$1
	pushl	$0
	movl	$2,%ecx
	movl	$2,%edx
	movl	$0,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [155] PutPixel(0,3, 0);
	movb	$0,%cl
	movl	$3,%edx
	movl	$0,%eax
	call	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
# [156] PutPixel(0,4, 0);
	movb	$0,%cl
	movl	$4,%edx
	movl	$0,%eax
	call	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
# [158] FillRect(RWidth - 5,0, 5, 1, 0);
	pushl	$1
	pushl	$0
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-5(%eax),%eax
	movl	$5,%ecx
	movl	$0,%edx
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [159] FillRect(RWidth - 3,1, 3, 1, 0);
	pushl	$1
	pushl	$0
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-3(%eax),%eax
	movl	$3,%ecx
	movl	$1,%edx
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [160] FillRect(RWidth - 2,2, 2, 1, 0);
	pushl	$1
	pushl	$0
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-2(%eax),%eax
	movl	$2,%ecx
	movl	$2,%edx
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [161] PutPixel(RWidth - 1,3, 0);
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-1(%eax),%eax
	movb	$0,%cl
	movl	$3,%edx
	call	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
# [162] PutPixel(RWidth - 1,4, 0);
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-1(%eax),%eax
	movb	$0,%cl
	movl	$4,%edx
	call	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
# [163] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_seek_$$_highres,"x"
	.balign 16,0x90
SEEK_$$_HIGHRES:
# [166] begin // for now this will be the same as 480p
	pushl	%ebp
	movl	%esp,%ebp
# [168] FillRect(0, 0, RWidth, 25, $0F);
	pushl	$25
	pushl	$15
	movl	U_$VIDEO_$$_RWIDTH,%ecx
	movl	$0,%edx
	movl	$0,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [169] FillRect(0, 26, RWidth, 1, 0);
	pushl	$1
	pushl	$0
	movl	U_$VIDEO_$$_RWIDTH,%ecx
	movl	$26,%edx
	movl	$0,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [171] PutSymbol(7,7, '#', 12);
	pushl	$12
	movb	$35,%cl
	movl	$7,%edx
	movl	$7,%eax
	call	VIDEO_$$_PUTSYMBOL$LONGINT$LONGINT$CHAR$LONGINT
# [172] PutPixel(13,13, 0);
	movb	$0,%cl
	movl	$13,%edx
	movl	$13,%eax
	call	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
# [173] PutPixel(12,13, 0);
	movb	$0,%cl
	movl	$13,%edx
	movl	$12,%eax
	call	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
# [174] PutPixel(13,12, 0);
	movb	$0,%cl
	movl	$12,%edx
	movl	$13,%eax
	call	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
# [175] PutPixel(12,12, 0);
	movb	$0,%cl
	movl	$12,%edx
	movl	$12,%eax
	call	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
# [176] DrawMenuBar;
	call	SEEK_$$_DRAWMENUBAR
# [179] FillRect(0,0, 5, 1, 0);
	pushl	$1
	pushl	$0
	movl	$5,%ecx
	movl	$0,%edx
	movl	$0,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [180] FillRect(0,1, 3, 1, 0);
	pushl	$1
	pushl	$0
	movl	$3,%ecx
	movl	$1,%edx
	movl	$0,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [181] FillRect(0,2, 2, 1, 0);
	pushl	$1
	pushl	$0
	movl	$2,%ecx
	movl	$2,%edx
	movl	$0,%eax
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [182] PutPixel(0,3, 0);
	movb	$0,%cl
	movl	$3,%edx
	movl	$0,%eax
	call	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
# [183] PutPixel(0,4, 0);
	movb	$0,%cl
	movl	$4,%edx
	movl	$0,%eax
	call	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
# [185] FillRect(RWidth - 5,0, 5, 1, 0);
	pushl	$1
	pushl	$0
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-5(%eax),%eax
	movl	$5,%ecx
	movl	$0,%edx
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [186] FillRect(RWidth - 3,1, 3, 1, 0);
	pushl	$1
	pushl	$0
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-3(%eax),%eax
	movl	$3,%ecx
	movl	$1,%edx
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [187] FillRect(RWidth - 2,2, 2, 1, 0);
	pushl	$1
	pushl	$0
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-2(%eax),%eax
	movl	$2,%ecx
	movl	$2,%edx
	call	VIDEO_$$_FILLRECT$LONGINT$LONGINT$LONGINT$LONGINT$BYTE
# [188] PutPixel(RWidth - 1,3, 0);
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-1(%eax),%eax
	movb	$0,%cl
	movl	$3,%edx
	call	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
# [189] PutPixel(RWidth - 1,4, 0);
	movl	U_$VIDEO_$$_RWIDTH,%eax
	leal	-1(%eax),%eax
	movb	$0,%cl
	movl	$4,%edx
	call	VIDEO_$$_PUTPIXEL$LONGINT$LONGINT$BYTE
# [190] end;
	movl	%ebp,%esp
	popl	%ebp
	ret

.section .text.n_seek_$$_seekinit,"x"
	.balign 16,0x90
.globl	SEEK_$$_SEEKINIT
SEEK_$$_SEEKINIT:
# [193] begin
	pushl	%ebp
	movl	%esp,%ebp
# [194] ActiveWindow := 'Seek';
	movl	$_$SEEK$_Ld1,%eax
	movl	%eax,U_$SEEK_$$_ACTIVEWINDOW
# [196] Menus[0].Text := 'File';   Menus[0].OnClick := nil;
	movl	$_$SEEK$_Ld2,%eax
	movl	%eax,U_$SEEK_$$_MENUS
	movl	$0,U_$SEEK_$$_MENUS+4
# [197] Menus[1].Text := 'Edit';   Menus[1].OnClick := nil;
	movl	$_$SEEK$_Ld3,%eax
	movl	%eax,U_$SEEK_$$_MENUS+8
	movl	$0,U_$SEEK_$$_MENUS+12
# [198] Menus[2].Text := 'View';   Menus[2].OnClick := nil;
	movl	$_$SEEK$_Ld4,%eax
	movl	%eax,U_$SEEK_$$_MENUS+16
	movl	$0,U_$SEEK_$$_MENUS+20
# [199] Menus[3].Text := 'Special';   Menus[3].OnClick := nil;
	movl	$_$SEEK$_Ld5,%eax
	movl	%eax,U_$SEEK_$$_MENUS+24
	movl	$0,U_$SEEK_$$_MENUS+28
# [200] Menus[4].Text := nil;
	movl	$0,U_$SEEK_$$_MENUS+32
# [202] ClearScreen($0F);
	movb	$15,%al
	call	VIDEO_$$_CLEARSCREEN$BYTE
# [203] FillPattern8x8(MacGray, 0, $0F);
	pushl	$15
	movl	$TC_$SEEK_$$_MACGRAY,%eax
	movb	$0,%cl
	movl	$7,%edx
	call	VIDEO_$$_FILLPATTERN8X8$array_of_BYTE$BYTE$BYTE
# [205] if RHeight = 480 then
	cmpl	$480,U_$VIDEO_$$_RHEIGHT
	je	.Lj47
	jmp	.Lj48
.Lj47:
# [207] lowres;
	call	SEEK_$$_LOWRES
	.balign 4,0x90
.Lj48:
# [209] if RHeight = 720 then
	cmpl	$720,U_$VIDEO_$$_RHEIGHT
	je	.Lj49
	jmp	.Lj50
.Lj49:
# [211] highres;
	call	SEEK_$$_HIGHRES
	.balign 4,0x90
.Lj50:
# [213] isMenuOpen := false;
	movb	$0,U_$SEEK_$$_ISMENUOPEN
# [214] dock;
	call	SEEK_$$_DOCK
# [215] end;
	movl	%ebp,%esp
	popl	%ebp
	ret
# End asmlist al_procedures
# Begin asmlist al_globals

.section .bss
	.balign 4
# [18] ActiveWindow: PChar;
	.globl U_$SEEK_$$_ACTIVEWINDOW
U_$SEEK_$$_ACTIVEWINDOW:
	.zero 4

.section .bss
	.balign 4
# [20] Menus: array[0..MaxMenus - 1] of record
	.globl U_$SEEK_$$_MENUS
U_$SEEK_$$_MENUS:
	.zero 128

.section .bss
# [31] isMenuOpen: Boolean;
U_$SEEK_$$_ISMENUOPEN:
	.zero 1

.section .bss
	.balign 4
# [54] MenuButtons: array[0..MaxMenus - 1] of Integer;
U_$SEEK_$$_MENUBUTTONS:
	.zero 64

.section .bss
	.balign 4
# [55] MenuButtonCount: Integer;
U_$SEEK_$$_MENUBUTTONCOUNT:
	.zero 4
# End asmlist al_globals
# Begin asmlist al_typedconsts

.section .data.n_TC_$SEEK_$$_MACGRAY,"d"
TC_$SEEK_$$_MACGRAY:
	.byte	170,85,170,85,170,85,170,85
# [36] function StrLen(S: PChar): Integer;

.section .rodata.n__$SEEK$_Ld1,"d"
	.balign 4
.globl	_$SEEK$_Ld1
_$SEEK$_Ld1:
	.ascii	"Seek\000"

.section .rodata.n__$SEEK$_Ld2,"d"
	.balign 4
.globl	_$SEEK$_Ld2
_$SEEK$_Ld2:
	.ascii	"File\000"

.section .rodata.n__$SEEK$_Ld3,"d"
	.balign 4
.globl	_$SEEK$_Ld3
_$SEEK$_Ld3:
	.ascii	"Edit\000"

.section .rodata.n__$SEEK$_Ld4,"d"
	.balign 4
.globl	_$SEEK$_Ld4
_$SEEK$_Ld4:
	.ascii	"View\000"

.section .rodata.n__$SEEK$_Ld5,"d"
	.balign 4
.globl	_$SEEK$_Ld5
_$SEEK$_Ld5:
	.ascii	"Special\000"
# End asmlist al_typedconsts

