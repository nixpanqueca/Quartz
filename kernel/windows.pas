unit Windows;

{$mode objfpc}
{$H-}
{$N-}
{$E-}
{$asmmode intel}

interface

uses Video;

// ============================================================================
//  WindowManager do Prism.
//
//  Permite que um programa (.bin) rode dentro de uma janela desenhada pelo
//  kernel, com desenho em coordenadas LOCAIS da janela (o kernel aplica o
//  offset automaticamente). O programa roda de forma bloqueante (uma janela
//  ativa por vez) e usa a tabela de servicos para desenhar/interagir.
//
//  Recursos:
//    - moldura com barra de titulo e botao fechar (icone na esquerda).
//    - arrastar a janela segurando o botao esquerdo na barra de titulo.
//    - servicos de desenho com offset automatico para a area client.
// ============================================================================

// Wrappers de desenho usados pela tabela de servicos.
procedure SvcClearScreen(Color: Byte);
procedure SvcWriteAt(X, Y: Integer; Text: PChar; Size: Integer);
procedure SvcWriteAtCol(X, Y: Integer; Text: PChar; Size: Integer; Color: Byte);
procedure SvcFillRect(X, Y, W, H: Integer; Color: Byte);
procedure SvcPutPixel(X, Y: Integer; Color: Byte);
procedure SvcDrawLine(X0, Y0, X1, Y1: Integer; Color: Byte);
procedure SvcDrawBMP(Name: PChar; X, Y: Integer);
procedure SvcDrawBMPBlack(Name: PChar; X, Y: Integer);

// Coordenadas de mouse relativas a janela (enquanto aberta).
function SvcGetMouseX: Integer;
function SvcGetMouseY: Integer;

// Gerenciamento de janela.
function WinCreate(Title: PChar; W, H: Integer): Integer;
procedure WinDestroy;
function WinPoll: Integer;    // WINEV_NONE / WINEV_CLOSE (ver svc.inc)
function WinKey: Char;        // ultima tecla digitada pelo usuario

implementation

uses Mouse, Keyboard, CDROM, BMP;

const
  Border = 1;    // borda preta ao redor da janela
  TitleH = 20;   // altura da barra de titulo (inclui borda superior)

  CloseIconPath  = 'SYSTEM\COMPILED\PRISM\WINDOWMANAGER\CLOSE.BMP';
  CloseIconPath2 = 'SYSTEM\COMPILED\PRISM\WINDOWMANAGER\CLOSE@2.BMP';
  CloseIconW = 8;   // tamanho do bitmap do icone
  CloseIconH = 8;
  CloseW = 12;      // area clicavel (um pouco maior que o icone)
  CloseH = 12;

type
  // Scancode -> caractere (mesmo mapeamento do teclado).
  TScanMap = record
    Scan: Byte;
    Ch: Char;
  end;

const
  ScanToCharMap: array[0..37] of TScanMap = (
    (Scan: $02; Ch: '1'), (Scan: $03; Ch: '2'), (Scan: $04; Ch: '3'),
    (Scan: $05; Ch: '4'), (Scan: $06; Ch: '5'), (Scan: $07; Ch: '6'),
    (Scan: $08; Ch: '7'), (Scan: $09; Ch: '8'), (Scan: $0A; Ch: '9'),
    (Scan: $0B; Ch: '0'),
    (Scan: $10; Ch: 'q'), (Scan: $11; Ch: 'w'), (Scan: $12; Ch: 'e'),
    (Scan: $13; Ch: 'r'), (Scan: $14; Ch: 't'), (Scan: $15; Ch: 'y'),
    (Scan: $16; Ch: 'u'), (Scan: $17; Ch: 'i'), (Scan: $18; Ch: 'o'),
    (Scan: $19; Ch: 'p'),
    (Scan: $1E; Ch: 'a'), (Scan: $1F; Ch: 's'), (Scan: $20; Ch: 'd'),
    (Scan: $21; Ch: 'f'), (Scan: $22; Ch: 'g'), (Scan: $23; Ch: 'h'),
    (Scan: $24; Ch: 'j'), (Scan: $25; Ch: 'k'), (Scan: $26; Ch: 'l'),
    (Scan: $2C; Ch: 'z'), (Scan: $2D; Ch: 'x'), (Scan: $2E; Ch: 'c'),
    (Scan: $2F; Ch: 'v'), (Scan: $30; Ch: 'b'), (Scan: $31; Ch: 'n'),
    (Scan: $32; Ch: 'm'),
    (Scan: $39; Ch: ' '), (Scan: $1C; Ch: #13)
  );

const
  // Tamanho maximo da area de janela com que os buffers (fundo + arrasto)
  // conseguem trabalhar.
  MaxWinW = 640;
  MaxWinH = 480;

var
  WOpen: Boolean;
  FrameX, FrameY, FrameW, FrameH: Integer;       // moldura total
  ClientX, ClientY, ClientW, ClientH: Integer;   // area de desenho do programa
  CloseX, CloseY: Integer;                       // canto sup. esquerdo do icone
  WinLastKey: Char;
  PrevScan: array[0..127] of Boolean;
  PrevBtnDown: Boolean;
  CurX, CurY: Integer;

  // Arrasto pelo titulo.
  Dragging: Boolean;
  DragDX, DragDY: Integer;
  CloseHover: Boolean;

  // Buffer do fundo (restaurado ao fechar) e buffer do arrasto (pixels da
  // propria janela, para move-la sem pedir o conteudo ao programa).
  // Sao dwords (4 bytes por pixel, formato do framebuffer).
  WinBuf: array[0 .. MaxWinW * MaxWinH - 1] of LongWord;
  DragBuf: array[0 .. MaxWinW * MaxWinH - 1] of LongWord;
  WinSavedValid: Boolean;

procedure SaveBg; forward;
procedure RestoreBg; forward;
procedure DrawFrame(Title: PChar); forward;
procedure DrawCloseIcon(Hovered: Boolean); forward;

// ---- helpers de offset -----------------------------------------------------

function OffX(X: Integer): Integer;
begin
  if WOpen then OffX := X + ClientX else OffX := X;
end;

function OffY(Y: Integer): Integer;
begin
  if WOpen then OffY := Y + ClientY else OffY := Y;
end;

procedure SvcClearScreen(Color: Byte);
begin
  if WOpen then
    FillRect(ClientX, ClientY, ClientW, ClientH, Color)
  else
    ClearScreen(Color);
end;

procedure SvcWriteAt(X, Y: Integer; Text: PChar; Size: Integer);
begin
  WriteAt(OffX(X), OffY(Y), Text, Size);
end;

procedure SvcWriteAtCol(X, Y: Integer; Text: PChar; Size: Integer; Color: Byte);
begin
  WriteAtCol(OffX(X), OffY(Y), Text, Size, Color);
end;

procedure SvcFillRect(X, Y, W, H: Integer; Color: Byte);
begin
  FillRect(OffX(X), OffY(Y), W, H, Color);
end;

procedure SvcPutPixel(X, Y: Integer; Color: Byte);
begin
  PutPixel(OffX(X), OffY(Y), Color);
end;

procedure SvcDrawLine(X0, Y0, X1, Y1: Integer; Color: Byte);
begin
  DrawLine(OffX(X0), OffY(Y0), OffX(X1), OffY(Y1), Color);
end;

procedure SvcDrawBMP(Name: PChar; X, Y: Integer);
begin
  DrawBMP(Name, OffX(X), OffY(Y));
end;

procedure SvcDrawBMPBlack(Name: PChar; X, Y: Integer);
begin
  DrawBMPBlack(Name, OffX(X), OffY(Y));
end;

function SvcGetMouseX: Integer;
begin
  if WOpen then SvcGetMouseX := GetMouseX - ClientX
  else SvcGetMouseX := GetMouseX;
end;

function SvcGetMouseY: Integer;
begin
  if WOpen then SvcGetMouseY := GetMouseY - ClientY
  else SvcGetMouseY := GetMouseY;
end;

// ---- copiar retangulos framebuffer <-> buffer ------------------------------

// Copia a area (X, Y, W, H) da tela para Buf (dwords, 1 por pixel). Pixels
// fora da tela viram 0.
procedure CaptureRect(Buf: PLongWord; X, Y, W, H: Integer);
var
  R, C, idx: Integer;
begin
  if (W <= 0) or (H <= 0) then
    Exit;
  idx := 0;
  for R := 0 to H - 1 do
    for C := 0 to W - 1 do
    begin
      if (Y + R >= 0) and (Y + R < RHeight) and
         (X + C >= 0) and (X + C < RWidth) then
        Buf[idx] := PLongWord(PByte(Framebuffer) + (Y + R) * VPitch + (X + C) * 4)^
      else
        Buf[idx] := 0;
      Inc(idx);
    end;
end;

// Copia Buf (dwords, 1 por pixel) para a area (X, Y, W, H) da tela.
procedure BlitRect(Buf: PLongWord; X, Y, W, H: Integer);
var
  R, C, idx: Integer;
begin
  if (W <= 0) or (H <= 0) then
    Exit;
  idx := 0;
  for R := 0 to H - 1 do
    for C := 0 to W - 1 do
    begin
      if (Y + R >= 0) and (Y + R < RHeight) and
         (X + C >= 0) and (X + C < RWidth) then
        PLongWord(PByte(Framebuffer) + (Y + R) * VPitch + (X + C) * 4)^ := Buf[idx];
      Inc(idx);
    end;
end;

// ---- salvar/restaurar fundo ------------------------------------------------

procedure SaveBg;
begin
  WinSavedValid := (FrameW <= MaxWinW) and (FrameH <= MaxWinH) and
                   (FrameW > 0) and (FrameH > 0);
  if not WinSavedValid then
    Exit;
  CaptureRect(@WinBuf[0], FrameX, FrameY, FrameW, FrameH);
end;

procedure RestoreBg;
begin
  if not WinSavedValid then
    Exit;
  BlitRect(@WinBuf[0], FrameX, FrameY, FrameW, FrameH);
end;

// ---- moldura ---------------------------------------------------------------

procedure UpdateClosePos;
begin
  CloseX := FrameX + Border + 3;
  CloseY := FrameY + Border + (TitleH - Border - CloseIconH) div 2;
end;

// Desenha somente o icone do botao fechar no estado atual.
procedure DrawCloseIcon(Hovered: Boolean);
begin
  if Hovered then
    DrawBMP(CloseIconPath2, CloseX, CloseY)
  else
    DrawBMP(CloseIconPath, CloseX, CloseY);
end;

procedure DrawFrame(Title: PChar);
var
  TX, TY: Integer;
  TW: Integer;
begin
  // Borda externa preta.
  FillRect(FrameX, FrameY, FrameW, FrameH, 0);
  // Barra de titulo (branca, com borda interna nao preciso: base preta).
  FillRect(FrameX + Border, FrameY + Border, FrameW - 2 * Border, TitleH - Border, $0F);
  // Area client (conteudo do programa) - preta por padrao.
  FillRect(ClientX, ClientY, ClientW, ClientH, 0);

  // Titulo centralizado na barra.
  TW := 0;
  if Title <> nil then
    while Title[TW] <> #0 do
      Inc(TW);
  TX := FrameX + (FrameW - TW * 8) div 2;
  TY := FrameY + Border + (TitleH - Border - 8) div 2;
  if TX < FrameX + Border then
    TX := FrameX + Border;
  if Title <> nil then
    WriteAtCol(TX, TY, Title, 8, 0);

  // Botao fechar (icone) no canto superior esquerdo da barra.
  UpdateClosePos;
  CloseHover := False;
  DrawCloseIcon(False);
end;

// ---- arrasto ---------------------------------------------------------------

function PtInRect(PX, PY, RX, RY, RW, RH: Integer): Boolean;
begin
  PtInRect := (PX >= RX) and (PX < RX + RW) and
              (PY >= RY) and (PY < RY + RH);
end;

// Mantem a janela visivel na tela.
procedure ClampFrame(var NFX, NFY: Integer);
begin
  if NFX < 2 then NFX := 2;
  if NFX + FrameW > RWidth - 2 then NFX := RWidth - 2 - FrameW;
  if NFX < 2 then NFX := 2;
  if NFY < 2 then NFY := 2;
  if NFY + FrameH > RHeight - 2 then NFY := RHeight - 2 - FrameH;
  if NFY < 2 then NFY := 2;
end;

procedure StartDrag(MX, MY: Integer);
begin
  // Remove o cursor antes de capturar, para o sprite nao virar parte da janela.
  if (CurX >= 0) and (CurY >= 0) then
  begin
    RestoreCursorArea(CurX, CurY);
    CurX := -1;
    CurY := -1;
  end;
  CaptureRect(@DragBuf[0], FrameX, FrameY, FrameW, FrameH);
  Dragging := True;
  DragDX := MX - FrameX;
  DragDY := MY - FrameY;
end;

// Move a moldura para a nova posicao, preservando o conteudo desenhado.
procedure MoveWindowTo(NFX, NFY: Integer);
begin
  if not WinSavedValid then
    Exit;
  // Restaura o fundo onde a janela estava.
  RestoreBg;
  // Atualiza a geometria.
  FrameX := NFX;
  FrameY := NFY;
  ClientX := FrameX + Border;
  ClientY := FrameY + Border + TitleH;
  UpdateClosePos;
  // Captura o fundo (desktop) que fica atras da nova posicao.
  CaptureRect(@WinBuf[0], FrameX, FrameY, FrameW, FrameH);
  // Desenha os pixels da janela na nova posicao.
  BlitRect(@DragBuf[0], FrameX, FrameY, FrameW, FrameH);
end;

// ---- gerenciamento ---------------------------------------------------------

function WinCreate(Title: PChar; W, H: Integer): Integer;
var
  s: Integer;
begin
  if WOpen then
  begin
    WinCreate := 0;
    Exit;
  end;
  if (W <= 0) or (H <= 0) then
  begin
    WinCreate := 0;
    Exit;
  end;

  // Centraliza a area client e monta a moldura.
  ClientW := W;
  ClientH := H;
  ClientX := (RWidth - W) div 2;
  ClientY := (RHeight - H) div 2;
  FrameX := ClientX - Border;
  FrameY := ClientY - Border - TitleH;
  FrameW := W + 2 * Border;
  FrameH := TitleH + H + Border;

  // Guarda o fundo antes de desenhar.
  SaveBg;

  // Estado inicial.
  WOpen := True;
  WinLastKey := #0;
  PrevBtnDown := False;
  for s := 0 to 127 do
    PrevScan[s] := False;
  CurX := -1;
  CurY := -1;
  Dragging := False;
  CloseHover := False;

  DrawFrame(Title);

  // Limpa a area client.
  FillRect(ClientX, ClientY, ClientW, ClientH, 0);

  WinCreate := 1;
end;

procedure WinDestroy;
begin
  if not WOpen then
    Exit;
  Dragging := False;
  // Remove qualquer cursor desenhado dentro da janela.
  if (CurX >= 0) and (CurY >= 0) then
  begin
    RestoreCursorArea(CurX, CurY);
    CurX := -1;
    CurY := -1;
  end;
  RestoreBg;
  WOpen := False;
  WinSavedValid := False;
end;

function ScanChar(Sc: Byte): Char;
var
  i: Integer;
begin
  ScanChar := #0;
  for i := Low(ScanToCharMap) to High(ScanToCharMap) do
    if ScanToCharMap[i].Scan = Sc then
    begin
      ScanChar := ScanToCharMap[i].Ch;
      Exit;
    end;
end;

function WinPoll: Integer;
var
  s, MX, MY, NFX, NFY: Integer;
  B: Byte;
  LeftDown, Hov: Boolean;
  ch: Char;
begin
  if not WOpen then
  begin
    WinPoll := 0;
    Exit;
  end;

  KeyboardPoll;
  MousePoll;

  // Detecta novas teclas (borda de pressionar) e guarda o caractere.
  for s := 0 to 127 do
  begin
    if ScanIsPressed(s) and (not PrevScan[s]) then
    begin
      ch := ScanChar(s);
      if ch <> #0 then
        WinLastKey := ch;
    end;
    PrevScan[s] := ScanIsPressed(s);
  end;

  MX := GetMouseX;
  MY := GetMouseY;
  B := GetMouseButtons;
  LeftDown := (B and 1) <> 0;

  // Arrasto da janela pela barra de titulo.
  if Dragging then
  begin
    if not LeftDown then
      Dragging := False
    else
    begin
      NFX := MX - DragDX;
      NFY := MY - DragDY;
      ClampFrame(NFX, NFY);
      if (NFX <> FrameX) or (NFY <> FrameY) then
        MoveWindowTo(NFX, NFY);
    end;
  end
  else if LeftDown and (not PrevBtnDown) then
  begin
    // Clique na borda de subida do botao esquerdo.
    if PtInRect(MX, MY, CloseX, CloseY, CloseW, CloseH) then
    begin
      WinPoll := 1;   // WINEV_CLOSE
      Exit;
    end
    else if PtInRect(MX, MY, FrameX, FrameY, FrameW, ClientY - FrameY) then
      if (FrameW <= MaxWinW) and (FrameH <= MaxWinH) then
        StartDrag(MX, MY);
  end;

  PrevBtnDown := LeftDown;

  // Feedback visual (hover) do icone de fechar.
  Hov := PtInRect(MX, MY, CloseX, CloseY, CloseW, CloseH) and (not Dragging);
  if Hov <> CloseHover then
  begin
    CloseHover := Hov;
    DrawCloseIcon(Hov);
  end;

  // Redesenha o cursor somente se o mouse se moveu (padrao do desktop:
  // evita piscar). Desenhado em qualquer posicao da tela, mesmo fora da
  // janela, para o cursor nunca sumir durante o programa.
  if (MX <> CurX) or (MY <> CurY) then
  begin
    if (CurX >= 0) and (CurY >= 0) then
      RestoreCursorArea(CurX, CurY);
    SaveCursorArea(MX, MY);
    DrawCursor(MX, MY);
    CurX := MX;
    CurY := MY;
  end;

  WinPoll := 0;
end;

function WinKey: Char;
begin
  WinKey := WinLastKey;
end;

end.