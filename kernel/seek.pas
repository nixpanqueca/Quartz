{$mode objfpc}
{$H-}
{$N-}
{$E-}
{$rtti off}
{$asmmode intel}

unit Seek; // "Finder" of this OS

interface

uses Video, Mouse, Serial, Buttons;

const
  MaxMenus = 16;

var
  ActiveWindow: PChar;
  // Menus da barra superior. Cada aplicacao define os seus (terminar com nil).
  Menus: array[0..MaxMenus - 1] of record
    Text: PChar;
    OnClick: procedure;   // funcao chamada ao clicar (passe @MinhaProc)
  end;

procedure SeekInit;
procedure UpdateMenuBar;

implementation

var
    isMenuOpen: Boolean;

const
  MacGray: array[0..7] of Byte = ($AA, $55, $AA, $55, $AA, $55, $AA, $55);

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
    DrawBMP('SPRITES\FOLDER.BMP', 6, RHeight - 20);
    // Dock separator
    FillRect(29,RHeight-25, 1, 25, 0);
end;

procedure ShowDesktop;
begin
    FillPatternRect(0,26, RWidth, RHeight - 26, MacGray,0,$0F);
    dock;
end;

procedure MainMenu;
begin
    if StrEqual(ActiveWindow, 'Seek') then
    begin
        if not isMenuOpen then
        begin
            FillRect(0, 26, 165, 250, $0F);
            isMenuOpen := true;
        end
        else
        begin
            ShowDesktop;
            isMenuOpen := false;
        end;
    end
    else
    begin
        ShowDesktop;
        isMenuOpen := false;
    end;
end;

procedure lowres; // 640x480
begin
    // MenuBar background
    FillRect(0, 0, RWidth, 25, $0F);
    FillRect(0, 25, RWidth, 1, 0);
    // MenuBar
    PutSymbol(7,7, '#', 12);
    PutPixel(13,13, 0);
    PutPixel(12,13, 0);
    PutPixel(13,12, 0);
    PutPixel(12,12, 0);
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

procedure SeekInit;
begin
    ActiveWindow := 'Seek';
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
end;

end.