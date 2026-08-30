{$mode objfpc}
{$H-}
{$N-}
{$E-}
{$rtti off}
{$asmmode intel}

unit Prism; // "Finder" of this OS

interface

uses Video, Mouse, Serial, Buttons, CDROM, OpenShell, Svc;

const
  MaxMenus = 16;

var
  ActiveWindow: PChar;
  // Menus da barra superior. Cada aplicacao define os seus (terminar com nil).
  Menus: array[0..MaxMenus - 1] of record
    Text: PChar;
    OnClick: procedure;   // funcao chamada ao clicar (passe @MinhaProc)
  end;

procedure PrismInit;
procedure UpdateMenuBar;
procedure DesktopShortcut(Pos: Integer; Icon: PChar; LabelText: PChar);
procedure ShowDesktop;
procedure ClearShortcutSelection;

implementation

var
    isMenuOpen: Boolean;

const
  MacGray: array[0..7] of Byte = ($AA, $55, $AA, $55, $AA, $55, $AA, $55);
  IconCellW = 96;
  IconCellH = 92;
  IconSizeW = 44;
  IconSizeH = 44;
  IconRightMargin = 8;
  LabelSize = 10;
  IconTopOffset = 16;
  TrashIndex = 4;   // 5o atalho -> linha inferior dedicada (lixeira)

var
  ShortcutCount: Integer;

const
  MaxShortcuts = 16;

type
  TShortcutProc = procedure;

  TShortcut = record
    Active: Boolean;
    CellX, CellY: Integer;
    IconX, IconY: Integer;
    LabelX, LabelY: Integer;
    TW: Integer;
    OpenProc: Pointer;
    RunPath: PChar;
    Icon: PChar;
    LabelText: PChar;
  end;

var
  Shortcuts: array[0..MaxShortcuts - 1] of TShortcut;
  SelectedShortcut: Integer;
  ShortcutOfButton: array[0..63] of Integer;
  ShortcutLabels: array[0..MaxShortcuts - 1, 0..31] of Char;
  ShortcutIconPaths: array[0..MaxShortcuts - 1, 0..79] of Char;
  ShortcutRunPaths: array[0..MaxShortcuts - 1, 0..79] of Char;

function MapButtonToShortcut(ButtonIdx: Integer): Integer;
begin
  Result := -1;
  if (ButtonIdx >= 0) and (ButtonIdx <= 63) then
    Result := ShortcutOfButton[ButtonIdx];
end;

procedure DrawShortcutLabel(S: Integer; Selected: Boolean);
begin
  if Selected then
  begin
    // Invertido: quadrado preto atras e texto branco.
    FillRect(Shortcuts[S].LabelX - 2, Shortcuts[S].LabelY - 2,
             Shortcuts[S].TW + 4, LabelSize + 4, 0);
    WriteAtCol(Shortcuts[S].LabelX, Shortcuts[S].LabelY,
               Shortcuts[S].LabelText, LabelSize, 15);
  end
  else
  begin
    FillRect(Shortcuts[S].LabelX - 2, Shortcuts[S].LabelY - 2,
             Shortcuts[S].TW + 4, LabelSize + 4, 15);
    WriteAt(Shortcuts[S].LabelX, Shortcuts[S].LabelY,
            Shortcuts[S].LabelText, LabelSize);
  end;
end;

// Redesenha um atalho sobre o fundo. Selected = true desenha o destaque.
procedure RedrawShortcut(S: Integer; Selected: Boolean);
begin
  FillPatternRect(Shortcuts[S].CellX, Shortcuts[S].CellY,
                  IconCellW, IconCellH, MacGray, 0, $0F);
  if Selected then
    DrawBMPBlack(Shortcuts[S].Icon, Shortcuts[S].IconX, Shortcuts[S].IconY)
  else
    DrawBMP(Shortcuts[S].Icon, Shortcuts[S].IconX, Shortcuts[S].IconY);
  DrawShortcutLabel(S, Selected);
end;

procedure SelectShortcut(S: Integer);
var
  Old: Integer;
begin
  if (S < 0) or (S >= ShortcutCount) then
    Exit;
  Old := SelectedShortcut;
  if Old = S then
    Exit;
  if (Old >= 0) and (Old < ShortcutCount) then
    RedrawShortcut(Old, False);
  SelectedShortcut := S;
  RedrawShortcut(S, True);
end;

procedure ClearShortcutSelection;
begin
  if (SelectedShortcut >= 0) and (SelectedShortcut < ShortcutCount) then
    RedrawShortcut(SelectedShortcut, False);
  SelectedShortcut := -1;
end;

// Clique simples num atalho -> seleciona.
procedure DesktopShortcutClick;
var
  S: Integer;
begin
  S := MapButtonToShortcut(GetLastHit);
  if S >= 0 then
    SelectShortcut(S);
end;

// Double-click num atalho -> seleciona e executa (arquivo .run/.bin ou
// procedimento de abertura).
function IsBinPath(P: PChar): Boolean;
var
  L: Integer;
begin
  IsBinPath := False;
  L := 0;
  while P[L] <> #0 do
    Inc(L);
  if L < 4 then
    Exit;
  if (P[L - 4] = '.') and (P[L - 3] = 'B') and (P[L - 2] = 'I') and
     (P[L - 1] = 'N') then
    IsBinPath := True;
end;

procedure DesktopShortcutDblClick;
var
  S: Integer;
begin
  S := MapButtonToShortcut(GetLastHit);
  if S < 0 then
    Exit;
  SelectShortcut(S);
  if Shortcuts[S].RunPath <> nil then
  begin
    if IsBinPath(Shortcuts[S].RunPath) then
      RunProgram(Shortcuts[S].RunPath)
    else
      ShellRunFile(Shortcuts[S].RunPath, True);
  end
  else if Shortcuts[S].OpenProc <> nil then
    TShortcutProc(Shortcuts[S].OpenProc);
end;

function StrLen(S: PChar): Integer;
begin
  Result := 0;
  if S = nil then
    Exit;
  while S[Result] <> #0 do
    Result := Result + 1;
end;

function MenuBarHeight: Integer;
begin
  if RHeight = 720 then
    Result := 21
  else
    Result := 25;
end;

var
  MenuButtons: array[0..MaxMenus - 1] of Integer;
  MenuButtonCount: Integer;

procedure RemoveMenuButtons;
var
  i: Integer;
begin
  for i := MenuButtonCount - 1 downto 0 do
    RemoveButton(MenuButtons[i]);
  MenuButtonCount := 0;
end;

procedure DrawMenuBar;
var
  i, X, W: Integer;
begin
  // Limpa a area de menus e titulo (mantem icone e bordas)
  FillRect(28, 0, RWidth - 35, MenuBarHeight, $0F);
  RemoveMenuButtons;
  // Menus (esquerda, apos o icone). Cada menu e um botao clicavel.
  X := 30;
  i := 0;
  while Menus[i].Text <> nil do
  begin
    W := StrLen(Menus[i].Text) * 12;
    WriteAt(X, 7, Menus[i].Text, 12);
    MenuButtons[MenuButtonCount] := AddButton(X, 0, W, MenuBarHeight, Pointer(Menus[i].OnClick));
    Inc(MenuButtonCount);
    X := X + W + 14;
    Inc(i);
  end;
  // Titulo da janela ativa (direita, separado dos menus)
  X := StrLen(ActiveWindow) * 12;
  WriteAt(RWidth - 8 - X, 7, ActiveWindow, 12);
  FillRect(RWidth-8-X-8,0, 1, 25, 0);
end;

procedure UpdateMenuBar;
begin
  DrawMenuBar;
end;

procedure dock;
begin
    // Dock background
    FillRect(0, RHeight - 25, RWidth div 2 + 15, 25, $0F);
    // Dock lines
    FillRect(0, RHeight - 26, RWidth div 2 + 15, 1, 0);
    FillRect(RWidth div 2 + 15, RHeight - 26, 1, 25, 0);
    PutPixel(RWidth div 2 + 15, RHeight - 26, $0F);
    PutPixel(RWidth div 2 + 14, RHeight - 25, 0);

    // Dock icon1
    DrawBMP('SYSTEM\COMPILED\PRISM\BITMAP\FOLDER.BMP', 6, RHeight - 20);
    // Dock separator
    FillRect(29,RHeight-25, 1, 25, 0);
end;

procedure ShowDesktop;
begin
    FillPatternRect(0,26, RWidth, RHeight - 26, MacGray,0,$0F);
    dock;
end;

// Desenha um atalho na area de trabalho em layout de grade.
// Posicao e por indices de grade (0 = primeiro), organizado de cima para
// baixo e da direita para a esquerda. Posicao 0 = proxima disponivel.
// Icon = caminho do BMP (ex: 'SYSTEM\COMPILED\PRISM\BITMAP\APP.BMP'), LabelText = texto do atalho.
procedure DesktopShortcut(Pos: Integer; Icon: PChar; LabelText: PChar);
var
  Index, Rows, Cols, MainRows, ColOffset, Row: Integer;
  StartY, EndY: Integer;
  CellX, CellY, IconX, IconY: Integer;
  TW: Integer;
begin
  if Pos = 0 then
    Index := ShortcutCount
  else
    Index := Pos - 1;
  if Index < 0 then
    Exit;

  // Grade: icones a partir de baixo da dep, acima do dock (RHeight - 25).
  StartY := MenuBarHeight + 1;
  EndY := RHeight - 25;
  Rows := (EndY - StartY) div IconCellH;
  if Rows < 1 then
    Rows := 1;
  Cols := RWidth div IconCellW;
  if Cols < 1 then
    Cols := 1;

  if Index >= Rows * Cols then
    Exit;

  // organizacao: cima para baixo e da direita para a esquerda
  // (coluna 0 = mais a direita). A linha inferior fica reservada para a
  // lixeira (TrashIndex), que fica abaixo de todos os outros.
  if Index = TrashIndex then
  begin
    Row := Rows - 1;
    MainRows := 1;   // lixeira: unica na linha de baixo
    ColOffset := 0;  // alinhada a direita
  end
  else
  begin
    MainRows := Rows - 1;
    if MainRows < 1 then
      MainRows := 1;
    Row := Index mod MainRows;
    ColOffset := Index div MainRows;
  end;

  // Grade alinhada a direita: a coluna da direita fica proxima a margem.
  CellX := RWidth - IconRightMargin - IconCellW - ColOffset * IconCellW;
  CellY := StartY + Row * IconCellH;

  // Desenha o icone centralizado horizontalmente, um pouco abaixo do topo
  // da celula para nao colar na barra superior.
  IconX := CellX + (IconCellW - IconSizeW) div 2;
  IconY := CellY + IconTopOffset;
  DrawBMP(Icon, IconX, IconY);
  Shortcuts[ShortcutCount].IconX := IconX;
  Shortcuts[ShortcutCount].IconY := IconY;

  // Label centralizado sob o icone, com um quadrado branco atras do texto
  // (2px de padding em cada lado).
  TW := StrLen(LabelText) * LabelSize;
  IconY := CellY + IconTopOffset + IconSizeH + 6;
  FillRect(CellX + (IconCellW - TW) div 2 - 2, IconY - 2,
           TW + 4, LabelSize + 4, 15);
  WriteAt(CellX + (IconCellW - TW) div 2, IconY, LabelText, LabelSize);

  // Registra o atalho para selecao/double-click.
  Shortcuts[ShortcutCount].Active := True;
  Shortcuts[ShortcutCount].CellX := CellX;
  Shortcuts[ShortcutCount].CellY := CellY;
  Shortcuts[ShortcutCount].LabelX := CellX + (IconCellW - TW) div 2;
  Shortcuts[ShortcutCount].LabelY := IconY;
  Shortcuts[ShortcutCount].TW := TW;
  Shortcuts[ShortcutCount].OpenProc := nil;
  Shortcuts[ShortcutCount].RunPath := nil;
  Shortcuts[ShortcutCount].Icon := Icon;
  Shortcuts[ShortcutCount].LabelText := LabelText;
  ShortcutOfButton[AddButtonEx(CellX, CellY, IconCellW, IconCellH,
                               @DesktopShortcutClick, @DesktopShortcutDblClick)] :=
    ShortcutCount;
  Inc(ShortcutCount);
end;

function UpCh(C: Char): Char;
begin
  if (C >= 'a') and (C <= 'z') then
    UpCh := Char(Ord(C) - 32)
  else
    UpCh := C;
end;

// Copia o nome de indice Idx da lista List (nomes terminados em #0) para
// Dest, removendo o sufixo ';1' que o ISO 9660 grava nos arquivos.
// Retorna o comprimento do nome limpo.
function CopyCleanName(List: PChar; Idx: Integer; Dest: PChar): Integer;
var
  I, J, L: Integer;
begin
  J := 0;
  for I := 0 to Idx - 1 do
  begin
    while List[J] <> #0 do
      Inc(J);
    Inc(J);   // pula o #0
  end;
  L := 0;
  while List[J] <> #0 do
  begin
    Dest[L] := List[J];
    Inc(L);
    Inc(J);
  end;
  // remove sufixo ';1' (extensao + versao ISO) se presente
  if (L >= 2) and (Dest[L - 2] = ';') and (Dest[L - 1] = '1') then
    L := L - 2;
  Dest[L] := #0;
  Result := L;
end;

// Verifica se o nome (ja sem ';1') termina com '.BMP' (sem caixa).
function EndsWithBMP(N: PChar): Boolean;
var
  L: Integer;
  E: array[0..3] of Char;
begin
  L := 0;
  while (N[L] <> #0) and (L < 63) do
    Inc(L);
  if L < 4 then
    Exit(False);
  E[0] := UpCh(N[L - 4]);
  E[1] := UpCh(N[L - 3]);
  E[2] := UpCh(N[L - 2]);
  E[3] := UpCh(N[L - 1]);
  Result := (E[0] = '.') and (E[1] = 'B') and (E[2] = 'M') and (E[3] = 'P');
end;

// Copia o nome ate o ponto (extensao) para Dest. Ex.: 'ABOUT.RUN' -> 'ABOUT'.
procedure CopyBaseName(N: PChar; Dest: PChar);
var
  I: Integer;
begin
  I := 0;
  while (N[I] <> #0) and (N[I] <> '.') and (I < 31) do
  begin
    Dest[I] := N[I];
    Inc(I);
  end;
  Dest[I] := #0;
end;

// Monta em Dest o caminho 'USER\DESKTOP\NOME' a partir de um nome limpo.
// Retorna o comprimento do caminho montado.
function BuildDesktopPath(N: PChar; Dest: PChar): Integer;
const
  Prefix: array[0..12] of Char = 'USER\DESKTOP\';
var
  I: Integer;
begin
  for I := 0 to 12 do
    Dest[I] := Prefix[I];
  I := 13;
  while N^ <> #0 do
  begin
    Dest[I] := N^;
    Inc(I);
    Inc(N);
  end;
  Dest[I] := #0;
  Result := I;
end;

// Carrega os itens de USER\DESKTOP como atalhos da area de trabalho.
// Ignora arquivos .BMP (que servem de icone) e diretorios. Cada atalho usa
// o .BMP de mesmo nome como icone (se existir) e e executado no double-click.
procedure LoadDesktopShortcuts;
const
  DefaultIcon = 'SYSTEM\COMPILED\PRISM\BITMAP\FLOPPY@2.BMP';
var
  List: array[0..1023] of Char;
  CleanName: array[0..63] of Char;
  Scratch: array[0..79] of Byte;
  Count, I, Idx, NameLen, PathLen: Integer;
  HasBmp: Boolean;
begin
  Count := FSListDir('USER\DESKTOP', @List[0], SizeOf(List));
  Idx := -1;
  for I := 0 to Count - 1 do
  begin
    NameLen := CopyCleanName(@List[0], I, @CleanName[0]);
    if (NameLen > 0) and not EndsWithBMP(@CleanName[0]) then
    begin
      Inc(Idx);
      if Idx >= MaxShortcuts then
        Break;
      // label = nome base (sem extensao)
      CopyBaseName(@CleanName[0], @ShortcutLabels[Idx][0]);
      // run path = USER\DESKTOP\<nome limpo>
      BuildDesktopPath(@CleanName[0], @ShortcutRunPaths[Idx][0]);
      // monta caminho do icone: USER\DESKTOP\<nome limpo> e troca a
      // extensao por .BMP
      PathLen := BuildDesktopPath(@CleanName[0], @ShortcutIconPaths[Idx][0]);
      if PathLen >= 4 then
      begin
        ShortcutIconPaths[Idx][PathLen - 3] := 'B';
        ShortcutIconPaths[Idx][PathLen - 2] := 'M';
        ShortcutIconPaths[Idx][PathLen - 1] := 'P';
      end;
      // verifica se o icone existe
      HasBmp := FSReadFile(@ShortcutIconPaths[Idx][0], @Scratch[0], SizeOf(Scratch)) > 0;
      if HasBmp then
        DesktopShortcut(0, @ShortcutIconPaths[Idx][0], @ShortcutLabels[Idx][0])
      else
        DesktopShortcut(0, DefaultIcon, @ShortcutLabels[Idx][0]);
      Shortcuts[ShortcutCount - 1].RunPath := @ShortcutRunPaths[Idx][0];
    end;
  end;
end;

procedure MainMenu;
const
  MenuX = 0;
  MenuY = 25;
  MenuW = 165;
  MenuH = 250;
begin
    if not isMenuOpen then
    begin
        // Guarda o fundo sob o menu para poder restaurar sem redesenhar
        // o desktop inteiro, depois desenha o painel.
        SaveScreenArea(MenuX, MenuY, MenuW, MenuH);
        FillRect(MenuX, MenuY, MenuW, MenuH, $0F);
        FillRect(MenuX, MenuY, MenuW, 1, 0);
        FillRect(MenuX, MenuY + MenuH - 1, MenuW, 1, 0);
        FillRect(MenuX, MenuY, 1, MenuH, 0);
        FillRect(MenuX + MenuW - 1, MenuY, 1, MenuH, 0);
        isMenuOpen := true;
    end
    else
    begin
        RestoreScreenArea(MenuX, MenuY, MenuW, MenuH);
        isMenuOpen := false;
    end;
end;

procedure lowres; // 640x480
begin
    // MenuBar background
    FillRect(0, 0, RWidth, 25, $0F);
    FillRect(0, 25, RWidth, 1, 0);
    // MenuBar
    { PutSymbol(7,7, '#', 12);
    PutPixel(13,13, 0);
    PutPixel(12,13, 0);
    PutPixel(13,12, 0);
    PutPixel(12,12, 0); }
    DrawBMP('SYSTEM\COMPILED\PRISM\BITMAP\ICON.BMP', 7,5);
    AddButton(7,7, 12, 12, @MainMenu);
    DrawMenuBar;

    // Rounded border left
    FillRect(0,0, 5, 1, 0);
    FillRect(0,1, 3, 1, 0);
    FillRect(0,2, 2, 1, 0);
    PutPixel(0,3, 0);
    PutPixel(0,4, 0);
    // Rounded border right
    FillRect(RWidth - 5,0, 5, 1, 0);
    FillRect(RWidth - 3,1, 3, 1, 0);
    FillRect(RWidth - 2,2, 2, 1, 0);
    PutPixel(RWidth - 1,3, 0);
    PutPixel(RWidth - 1,4, 0);
end;

procedure highres; // 1280x720
begin // for now this will be the same as 480p
    // MenuBar background
    FillRect(0, 0, RWidth, 25, $0F);
    FillRect(0, 26, RWidth, 1, 0);
    // MenuBar
    PutSymbol(7,7, '#', 12);
    PutPixel(13,13, 0);
    PutPixel(12,13, 0);
    PutPixel(13,12, 0);
    PutPixel(12,12, 0);
    DrawMenuBar;

    // Rounded border left
    FillRect(0,0, 5, 1, 0);
    FillRect(0,1, 3, 1, 0);
    FillRect(0,2, 2, 1, 0);
    PutPixel(0,3, 0);
    PutPixel(0,4, 0);
    // Rounded border right
    FillRect(RWidth - 5,0, 5, 1, 0);
    FillRect(RWidth - 3,1, 3, 1, 0);
    FillRect(RWidth - 2,2, 2, 1, 0);
    PutPixel(RWidth - 1,3, 0);
    PutPixel(RWidth - 1,4, 0);
end;

procedure OpenAetherHD;
begin
  // Placeholder: aqui entrara o sistema de abertura de programas.
end;

procedure PrismInit;
var
  i: Integer;
begin
    ActiveWindow := 'Prism';
    for i := 0 to 63 do
      ShortcutOfButton[i] := -1;
    ShortcutCount := 0;
    SelectedShortcut := -1;
    // Menus padrao do Finder (cada aplicacao pode trocar depois)
    Menus[0].Text := 'File';   Menus[0].OnClick := nil;
    Menus[1].Text := 'Edit';   Menus[1].OnClick := nil;
    Menus[2].Text := 'View';   Menus[2].OnClick := nil;
    Menus[3].Text := 'Special';   Menus[3].OnClick := nil;
    Menus[4].Text := nil;
    // System wallpaper
    ClearScreen($0F);
    FillPattern8x8(MacGray, 0, $0F);
    // the system know that if the Height is 480, the Width will be 640. the same happens to 720
    if RHeight = 480 then
    begin
        lowres;
    end;
    if RHeight = 720 then
    begin
        highres;
    end;
    isMenuOpen := false;
    dock;

    // Desktop shortcuts (itens de USER\DESKTOP)
    LoadDesktopShortcuts;
end;

end.