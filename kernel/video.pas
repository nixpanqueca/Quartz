unit Video;

{$mode objfpc}
{$H-}
{$asmmode intel}

interface

var
  RWidth, RHeight: integer;
  VPitch: integer;       // bytes por linha do framebuffer (4 por pixel)
  Framebuffer: PByte;

procedure VideoInit;
procedure PutPixel(X, Y: Integer; Color: Byte);
procedure DrawLine(X0, Y0, X1, Y1: Integer; Color: Byte);
procedure FillRect(X, Y, W, H: Integer; Color: Byte);
procedure ClearScreen(Color: Byte);
procedure FillPattern8x8(const Pattern: array of Byte; On, Off: Byte);
procedure FillPatternRect(X, Y, W, H: Integer; const Pattern: array of Byte; On, Off: Byte);
procedure DrawCursor(X, Y: Integer);
procedure SaveCursorArea(X, Y: Integer);
procedure RestoreCursorArea(X, Y: Integer);
procedure SaveScreenArea(X, Y, W, H: Integer);
procedure RestoreScreenArea(X, Y, W, H: Integer);
procedure DrawSprite(Src: PByte; SrcW, SrcH, DstX, DstY: Integer);
procedure WriteAt(X, Y: Integer; Text: PChar; Size: Integer);
procedure WriteAtCol(X, Y: Integer; Text: PChar; Size: Integer; Color: Byte);
procedure PutSymbol(X, Y: Integer; Symbol: Char; Size: Integer);
procedure DrawBMP(Name: PChar; X, Y: Integer);
procedure DrawBMPBlack(Name: PChar; X, Y: Integer);

implementation

uses CDROM, BMP;

const
  BPP = 4;   // bytes por pixel (modo 32bpp)

var
  AssetBuf: array[0..65535] of Byte;
  DrawBuf:  array[0..65535] of Byte;

  // Paleta interna: mapeia o indice de cor (Color: Byte) para RGB 24-bit.
  // Indices 0-15 = cores basicas do VGA classico; 16-231 = cubo 6x6x6
  // (usado por RGBToVGA); 232-255 = rampa de cinza.
  PalR: array[0..255] of Byte;
  PalG: array[0..255] of Byte;
  PalB: array[0..255] of Byte;

// Empacota R,G,B num dword do framebuffer (bytes: R, G, B, livre).
function PackPix(R, G, B: Byte): LongWord;
begin
  PackPix := LongWord(R) or (LongWord(G) shl 8) or (LongWord(B) shl 16);
end;

// Cor indexada -> dword do framebuffer.
function PalColor(C: Byte): LongWord;
begin
  PalColor := PackPix(PalR[C], PalG[C], PalB[C]);
end;

procedure InitPalette;
var
  i, lvl: Integer;
  BClr: array[0..14, 0..2] of Byte;
begin
  // Cores basicas do VGA classico (1..14) + branco (15).
  BClr[1][0] := 0;    BClr[1][1] := 0;    BClr[1][2] := 170;   // azul
  BClr[2][0] := 0;    BClr[2][1] := 170;  BClr[2][2] := 0;     // verde
  BClr[3][0] := 0;    BClr[3][1] := 170;  BClr[3][2] := 170;   // ciano
  BClr[4][0] := 170;  BClr[4][1] := 0;    BClr[4][2] := 0;     // vermelho
  BClr[5][0] := 170;  BClr[5][1] := 0;    BClr[5][2] := 170;   // magenta
  BClr[6][0] := 170;  BClr[6][1] := 85;   BClr[6][2] := 0;     // marrom
  BClr[7][0] := 170;  BClr[7][1] := 170;  BClr[7][2] := 170;   // cinza claro
  BClr[8][0] := 85;   BClr[8][1] := 85;   BClr[8][2] := 85;    // cinza escuro
  BClr[9][0] := 85;   BClr[9][1] := 85;   BClr[9][2] := 255;   // azul claro
  BClr[10][0] := 85;  BClr[10][1] := 255; BClr[10][2] := 85;   // verde claro
  BClr[11][0] := 85;  BClr[11][1] := 255; BClr[11][2] := 255;  // ciano claro
  BClr[12][0] := 255; BClr[12][1] := 85;  BClr[12][2] := 85;   // vermelho claro
  BClr[13][0] := 255; BClr[13][1] := 85;  BClr[13][2] := 255;  // magenta claro
  BClr[14][0] := 255; BClr[14][1] := 255; BClr[14][2] := 85;   // amarelo

  PalR[0] := 0; PalG[0] := 0; PalB[0] := 0;
  for i := 1 to 14 do
  begin
    PalR[i] := BClr[i][0];
    PalG[i] := BClr[i][1];
    PalB[i] := BClr[i][2];
  end;
  PalR[15] := 255; PalG[15] := 255; PalB[15] := 255;

  // Cubo 6x6x6 (16..231) - mesmos indices que RGBToVGA produz.
  for i := 0 to 215 do
  begin
    lvl := (i div 36) * 51;
    PalR[16 + i] := Byte(lvl);
    lvl := ((i mod 36) div 6) * 51;
    PalG[16 + i] := Byte(lvl);
    lvl := (i mod 6) * 51;
    PalB[16 + i] := Byte(lvl);
  end;

  // Rampa de cinza (232..255): 24 tons.
  for i := 0 to 23 do
  begin
    lvl := i * 11;
    if lvl > 255 then lvl := 255;
    PalR[232 + i] := Byte(lvl);
    PalG[232 + i] := Byte(lvl);
    PalB[232 + i] := Byte(lvl);
  end;
end;

procedure VideoInit;
begin
  Framebuffer := PByte(PLongWord($1000)^);
  RWidth := Integer(PWord($1004)^);
  RHeight := Integer(PWord($1006)^);
  VPitch := Integer(PWord($1008)^);
  if VPitch < RWidth * BPP then
    VPitch := RWidth * BPP;
  InitPalette;
end;

procedure PutPixel(X, Y: Integer; Color: Byte);
begin
  PLongWord(PByte(Framebuffer) + Y * VPitch + X * BPP)^ := PalColor(Color);
end;

// Desenha uma linha reta entre dois pontos (com suporte a diagonal),
// usando o algoritmo de Bresenham generalizado (todos os octantes).
procedure DrawLine(X0, Y0, X1, Y1: Integer; Color: Byte);
var
  DX, DY, SX, SY, Err, E2: Integer;
  Pix: LongWord;
begin
  DX := X1 - X0;
  if DX < 0 then DX := -DX;
  DY := Y1 - Y0;
  if DY < 0 then DY := -DY;
  if X0 < X1 then SX := 1 else SX := -1;
  if Y0 < Y1 then SY := 1 else SY := -1;
  Err := DX - DY;
  Pix := PalColor(Color);
  while True do
  begin
    if (X0 >= 0) and (X0 < RWidth) and (Y0 >= 0) and (Y0 < RHeight) then
      PLongWord(PByte(Framebuffer) + Y0 * VPitch + X0 * BPP)^ := Pix;
    if (X0 = X1) and (Y0 = Y1) then
      Break;
    E2 := 2 * Err;
    if E2 > -DY then
    begin
      Err := Err - DY;
      X0 := X0 + SX;
    end;
    if E2 < DX then
    begin
      Err := Err + DX;
      Y0 := Y0 + SY;
    end;
  end;
end;

procedure FillRect(X, Y, W, H: Integer; Color: Byte);
var
  YY, XX: Integer;
  Pix: LongWord;
begin
  Pix := PalColor(Color);
  for YY := Y to Y + H - 1 do
    if (YY >= 0) and (YY < RHeight) then
      for XX := X to X + W - 1 do
        if (XX >= 0) and (XX < RWidth) then
          PLongWord(PByte(Framebuffer) + YY * VPitch + XX * BPP)^ := Pix;
end;

procedure ClearScreen(Color: Byte);
var
  i: Integer;
  Pix: LongWord;
  P: PByte;
begin
  Pix := PalColor(Color);
  P := Framebuffer;
  for i := 0 to (RWidth * RHeight) - 1 do
  begin
    PLongWord(P)^ := Pix;
    Inc(P, BPP);
  end;
end;

procedure FillPattern8x8(const Pattern: array of Byte; On, Off: Byte);
var
  Y, X: Integer;
  P: PByte;
  Pix: LongWord;
begin
  for Y := 0 to RHeight - 1 do
  begin
    P := PByte(Framebuffer) + Y * VPitch;
    for X := 0 to RWidth - 1 do
    begin
      if (Pattern[Y and 7] and ($80 shr (X and 7))) <> 0 then
        Pix := PalColor(On)
      else
        Pix := PalColor(Off);
      PLongWord(P)^ := Pix;
      Inc(P, BPP);
    end;
  end;
end;

procedure FillPatternRect(X, Y, W, H: Integer; const Pattern: array of Byte; On, Off: Byte);
var
  YY, XX: Integer;
begin
  for YY := Y to Y + H - 1 do
    if (YY >= 0) and (YY < RHeight) then
      for XX := X to X + W - 1 do
        if (XX >= 0) and (XX < RWidth) then
          if (Pattern[YY and 7] and ($80 shr (XX and 7))) <> 0 then
            PLongWord(PByte(Framebuffer) + YY * VPitch + XX * BPP)^ := PalColor(On)
          else
            PLongWord(PByte(Framebuffer) + YY * VPitch + XX * BPP)^ := PalColor(Off);
end;

const
  CursorData: array[0..15] of Word = (
    $0000, $4000, $6000, $7000,
    $7800, $7C00, $7E00, $7F00,
    $7F80, $7C00, $6C00, $4600,
    $0600, $0300, $0300, $0000
  );
  CursorMask: array[0..15] of Word = (
    $C000, $E000, $F000, $F800,
    $FC00, $FE00, $FF00, $FF80,
    $FFC0, $FFC0, $FE00, $EF00,
    $CF00, $8780, $0780, $0380
  );

procedure DrawCursorShape(const Shape: array of Word; X, Y: Integer; Color: Byte);
var
  R, C: Integer;
  Pix: LongWord;
begin
  Pix := PalColor(Color);
  for R := 0 to 15 do
  begin
    if (Y + R < 0) or (Y + R >= RHeight) then
      Continue;
    for C := 0 to 15 do
    begin
      if (X + C < 0) or (X + C >= RWidth) then
        Continue;
      if (Shape[R] and (1 shl (15 - C))) <> 0 then
        PLongWord(PByte(Framebuffer) + (Y + R) * VPitch + (X + C) * BPP)^ := Pix;
    end;
  end;
end;

procedure DrawCursor(X, Y: Integer);
begin
  DrawCursorShape(CursorMask, X, Y, $0F);
  DrawCursorShape(CursorData, X, Y, 0);
end;

const
  CursorW = 18;
  CursorH = 18;

var
  CursorBack: array[0..(CursorW * CursorH) - 1] of LongWord;

procedure SaveCursorArea(X, Y: Integer);
var
  R, C: Integer;
begin
  for R := 0 to CursorH - 1 do
    for C := 0 to CursorW - 1 do
    begin
      if (Y - 1 + R >= 0) and (Y - 1 + R < RHeight) and
         (X - 1 + C >= 0) and (X - 1 + C < RWidth) then
        CursorBack[R * CursorW + C] := PLongWord(PByte(Framebuffer) +
          (Y - 1 + R) * VPitch + (X - 1 + C) * BPP)^
      else
        CursorBack[R * CursorW + C] := 0;
    end;
end;

procedure RestoreCursorArea(X, Y: Integer);
var
  R, C: Integer;
begin
  for R := 0 to CursorH - 1 do
    for C := 0 to CursorW - 1 do
    begin
      if (Y - 1 + R >= 0) and (Y - 1 + R < RHeight) and
         (X - 1 + C >= 0) and (X - 1 + C < RWidth) then
        PLongWord(PByte(Framebuffer) + (Y - 1 + R) * VPitch + (X - 1 + C) * BPP)^ :=
          CursorBack[R * CursorW + C];
    end;
end;

type
  TScreenArea = record
    W, H: Integer;
    Buf: PLongWord;
  end;

const
  MaxAreaW = 165;
  MaxAreaH = 250;

var
  ScreenArea: TScreenArea;
  ScreenAreaBuf: array[0..(MaxAreaW * MaxAreaH) - 1] of LongWord;

procedure SaveScreenArea(X, Y, W, H: Integer);
var
  R, C, idx: Integer;
begin
  if (W > MaxAreaW) or (H > MaxAreaH) then
    Exit;
  ScreenArea.W := W;
  ScreenArea.H := H;
  ScreenArea.Buf := @ScreenAreaBuf[0];
  idx := 0;
  for R := 0 to H - 1 do
    for C := 0 to W - 1 do
    begin
      if (Y + R >= 0) and (Y + R < RHeight) and
         (X + C >= 0) and (X + C < RWidth) then
        ScreenAreaBuf[idx] := PLongWord(PByte(Framebuffer) +
          (Y + R) * VPitch + (X + C) * BPP)^
      else
        ScreenAreaBuf[idx] := 0;
      Inc(idx);
    end;
end;

procedure RestoreScreenArea(X, Y, W, H: Integer);
var
  R, C, idx: Integer;
begin
  if (ScreenArea.Buf = nil) or (W > MaxAreaW) or (H > MaxAreaH) then
    Exit;
  idx := 0;
  for R := 0 to H - 1 do
    for C := 0 to W - 1 do
    begin
      if (Y + R >= 0) and (Y + R < RHeight) and
         (X + C >= 0) and (X + C < RWidth) then
        PLongWord(PByte(Framebuffer) + (Y + R) * VPitch + (X + C) * BPP)^ :=
          ScreenAreaBuf[idx];
      Inc(idx);
    end;
end;

const
  // 8x8 monochrome font (public domain, based on IBM VGA font),
  // characters ' '..#127, MSB-first (bit 7 = leftmost pixel).
  Font8x8: array[0..95] of array[0..7] of Byte = (
    ($00, $00, $00, $00, $00, $00, $00, $00),  // ' '
    ($18, $3C, $3C, $18, $18, $00, $18, $00),  // '!'
    ($36, $36, $00, $00, $00, $00, $00, $00),  // '"'
    ($36, $36, $7F, $36, $7F, $36, $36, $00),  // '#'
    ($0C, $3E, $03, $1E, $30, $1F, $0C, $00),  // '$'
    ($00, $63, $33, $18, $0C, $66, $63, $00),  // '%'
    ($1C, $36, $1C, $6E, $3B, $33, $6E, $00),  // '&'
    ($06, $06, $03, $00, $00, $00, $00, $00),  // '''
    ($18, $0C, $06, $06, $06, $0C, $18, $00),  // '('
    ($06, $0C, $18, $18, $18, $0C, $06, $00),  // ')'
    ($00, $66, $3C, $FF, $3C, $66, $00, $00),  // '*'
    ($00, $0C, $0C, $3F, $0C, $0C, $00, $00),  // '+'
    ($00, $00, $00, $00, $00, $0C, $0C, $06),  // ','
    ($00, $00, $00, $3F, $00, $00, $00, $00),  // '-'
    ($00, $00, $00, $00, $00, $0C, $0C, $00),  // '.'
    ($60, $30, $18, $0C, $06, $03, $01, $00),  // '/'
    ($3E, $63, $73, $7B, $6F, $67, $3E, $00),  // '0'
    ($0C, $0E, $0C, $0C, $0C, $0C, $3F, $00),  // '1'
    ($1E, $33, $30, $1C, $06, $33, $3F, $00),  // '2'
    ($1E, $33, $30, $1C, $30, $33, $1E, $00),  // '3'
    ($38, $3C, $36, $33, $7F, $30, $78, $00),  // '4'
    ($3F, $03, $1F, $30, $30, $33, $1E, $00),  // '5'
    ($1C, $06, $03, $1F, $33, $33, $1E, $00),  // '6'
    ($3F, $33, $30, $18, $0C, $0C, $0C, $00),  // '7'
    ($1E, $33, $33, $1E, $33, $33, $1E, $00),  // '8'
    ($1E, $33, $33, $3E, $30, $18, $0E, $00),  // '9'
    ($00, $0C, $0C, $00, $00, $0C, $0C, $00),  // ':'
    ($00, $0C, $0C, $00, $00, $0C, $0C, $06),  // ';'
    ($18, $0C, $06, $03, $06, $0C, $18, $00),  // '<'
    ($00, $00, $3F, $00, $00, $3F, $00, $00),  // '='
    ($06, $0C, $18, $30, $18, $0C, $06, $00),  // '>'
    ($1E, $33, $30, $18, $0C, $00, $0C, $00),  // '?'
    ($3E, $63, $7B, $7B, $7B, $03, $1E, $00),  // '@'
    ($0C, $1E, $33, $33, $3F, $33, $33, $00),  // 'A'
    ($3F, $66, $66, $3E, $66, $66, $3F, $00),  // 'B'
    ($3C, $66, $03, $03, $03, $66, $3C, $00),  // 'C'
    ($1F, $36, $66, $66, $66, $36, $1F, $00),  // 'D'
    ($7F, $46, $16, $1E, $16, $46, $7F, $00),  // 'E'
    ($7F, $46, $16, $1E, $16, $06, $0F, $00),  // 'F'
    ($3C, $66, $03, $03, $73, $66, $7C, $00),  // 'G'
    ($33, $33, $33, $3F, $33, $33, $33, $00),  // 'H'
    ($1E, $0C, $0C, $0C, $0C, $0C, $1E, $00),  // 'I'
    ($78, $30, $30, $30, $33, $33, $1E, $00),  // 'J'
    ($67, $66, $36, $1E, $36, $66, $67, $00),  // 'K'
    ($0F, $06, $06, $06, $46, $66, $7F, $00),  // 'L'
    ($63, $77, $7F, $7F, $6B, $63, $63, $00),  // 'M'
    ($63, $67, $6F, $7B, $73, $63, $63, $00),  // 'N'
    ($1C, $36, $63, $63, $63, $36, $1C, $00),  // 'O'
    ($3F, $66, $66, $3E, $06, $06, $0F, $00),  // 'P'
    ($1E, $33, $33, $33, $3B, $1E, $38, $00),  // 'Q'
    ($3F, $66, $66, $3E, $36, $66, $67, $00),  // 'R'
    ($1E, $33, $07, $0E, $38, $33, $1E, $00),  // 'S'
    ($3F, $2D, $0C, $0C, $0C, $0C, $1E, $00),  // 'T'
    ($33, $33, $33, $33, $33, $33, $3F, $00),  // 'U'
    ($33, $33, $33, $33, $33, $1E, $0C, $00),  // 'V'
    ($63, $63, $63, $6B, $7F, $77, $63, $00),  // 'W'
    ($63, $63, $36, $1C, $1C, $36, $63, $00),  // 'X'
    ($33, $33, $33, $1E, $0C, $0C, $1E, $00),  // 'Y'
    ($7F, $63, $31, $18, $4C, $66, $7F, $00),  // 'Z'
    ($1E, $06, $06, $06, $06, $06, $1E, $00),  // '['
    ($03, $06, $0C, $18, $30, $60, $40, $00),  // '\'
    ($1E, $18, $18, $18, $18, $18, $1E, $00),  // ']'
    ($08, $1C, $36, $63, $00, $00, $00, $00),  // '^'
    ($00, $00, $00, $00, $00, $00, $00, $FF),  // '_'
    ($0C, $0C, $18, $00, $00, $00, $00, $00),  // '`'
    ($00, $00, $1E, $30, $3E, $33, $6E, $00),  // 'a'
    ($07, $06, $06, $3E, $66, $66, $3B, $00),  // 'b'
    ($00, $00, $1E, $33, $03, $33, $1E, $00),  // 'c'
    ($38, $30, $30, $3E, $33, $33, $6E, $00),  // 'd'
    ($00, $00, $1E, $33, $3F, $03, $1E, $00),  // 'e'
    ($1C, $36, $06, $0F, $06, $06, $0F, $00),  // 'f'
    ($00, $00, $6E, $33, $33, $3E, $30, $1F),  // 'g'
    ($07, $06, $36, $6E, $66, $66, $67, $00),  // 'h'
    ($0C, $00, $0E, $0C, $0C, $0C, $1E, $00),  // 'i'
    ($30, $00, $30, $30, $30, $33, $33, $1E),  // 'j'
    ($07, $06, $66, $36, $1E, $36, $67, $00),  // 'k'
    ($0E, $0C, $0C, $0C, $0C, $0C, $1E, $00),  // 'l'
    ($00, $00, $33, $7F, $7F, $6B, $63, $00),  // 'm'
    ($00, $00, $1F, $33, $33, $33, $33, $00),  // 'n'
    ($00, $00, $1E, $33, $33, $33, $1E, $00),  // 'o'
    ($00, $00, $3B, $66, $66, $3E, $06, $0F),  // 'p'
    ($00, $00, $6E, $33, $33, $3E, $30, $78),  // 'q'
    ($00, $00, $3B, $6E, $66, $06, $0F, $00),  // 'r'
    ($00, $00, $3E, $03, $1E, $30, $1F, $00),  // 's'
    ($08, $0C, $3E, $0C, $0C, $2C, $18, $00),  // 't'
    ($00, $00, $33, $33, $33, $33, $6E, $00),  // 'u'
    ($00, $00, $33, $33, $33, $1E, $0C, $00),  // 'v'
    ($00, $00, $63, $6B, $7F, $7F, $36, $00),  // 'w'
    ($00, $00, $63, $36, $1C, $36, $63, $00),  // 'x'
    ($00, $00, $33, $33, $33, $3E, $30, $1F),  // 'y'
    ($00, $00, $3F, $19, $0C, $26, $3F, $00),  // 'z'
    ($38, $0C, $0C, $07, $0C, $0C, $38, $00),  // '{'
    ($18, $18, $18, $00, $18, $18, $18, $00),  // '|'
    ($07, $0C, $0C, $38, $0C, $0C, $07, $00),  // '}'
    ($6E, $3B, $00, $00, $00, $00, $00, $00),  // '~'
    ($00, $00, $00, $00, $00, $00, $00, $00)   // #127
  );

procedure WriteAtCol(X, Y: Integer; Text: PChar; Size: Integer; Color: Byte);
var
  i, R, C, G: Integer;
  Pix: LongWord;
begin
  if Text = nil then
    Exit;
  if Size < 8 then
    Size := 8;
  Pix := PalColor(Color);
  i := 0;
  while Text[i] <> #0 do
  begin
    if Text[i] = #10 then
    begin
      Y := Y + Size;
      i := i + 1;
      Continue;
    end;
    if (Ord(Text[i]) >= 32) and (Ord(Text[i]) <= 127) then
    begin
      G := Ord(Text[i]) - 32;
      for R := 0 to Size - 1 do
        for C := 0 to Size - 1 do
          if (Font8x8[G, (R * 8) div Size] and (1 shl ((C * 8) div Size))) <> 0 then
            if (X + C >= 0) and (X + C < RWidth) and
               (Y + R >= 0) and (Y + R < RHeight) then
              PLongWord(PByte(Framebuffer) + (Y + R) * VPitch + (X + C) * BPP)^ := Pix;
      X := X + Size;
    end;
      i := i + 1;
  end;
end;

procedure WriteAt(X, Y: Integer; Text: PChar; Size: Integer);
begin
  WriteAtCol(X, Y, Text, Size, 0);
end;

const
  // Fonte alternativa para simbolos customizados (8x8, MSB-first).
  // Para adicionar um novo simbolo, aumente o limite do array
  // (array[0..N]) e inclua uma entrada (Ch = caracter, G = 8 bytes do glifo).
  SymbolFont: array[0..0] of record
    Ch: Char;
    G: array[0..7] of Byte;
  end = (
    (Ch: '#'; G: ($3C, $66, $C3, $81, $81, $C3, $66, $3C))   // '#' = circulo nao preenchido
  );

procedure PutSymbol(X, Y: Integer; Symbol: Char; Size: Integer);
var
  i, R, C: Integer;
begin
  if Size < 8 then
    Size := 8;
  for i := Low(SymbolFont) to High(SymbolFont) do
    if SymbolFont[i].Ch = Symbol then
    begin
      for R := 0 to Size - 1 do
        for C := 0 to Size - 1 do
          if (SymbolFont[i].G[(R * 8) div Size] and (1 shl ((C * 8) div Size))) <> 0 then
            if (X + C >= 0) and (X + C < RWidth) and
               (Y + R >= 0) and (Y + R < RHeight) then
              PLongWord(PByte(Framebuffer) + (Y + R) * VPitch + (X + C) * BPP)^ := PalColor(0);
      Exit;
    end;
end;

// Desenha um sprite do buffer de imagem. Cada pixel e um dword com o
// formato [R][G][B][A] em memoria; A = 0 significa transparente.
procedure DrawSprite(Src: PByte; SrcW, SrcH, DstX, DstY: Integer);
var
  X, Y: Integer;
  C: LongWord;
begin
  for Y := 0 to SrcH - 1 do
    for X := 0 to SrcW - 1 do
    begin
      C := PLongWord(PByte(Src) + (Y * SrcW + X) * BPP)^;
      if (C and $FF000000) <> 0 then
        if (DstX + X >= 0) and (DstX + X < RWidth) and
           (DstY + Y >= 0) and (DstY + Y < RHeight) then
          PLongWord(PByte(Framebuffer) + (DstY + Y) * VPitch + (DstX + X) * BPP)^ :=
            C and $00FFFFFF;
    end;
end;

procedure DrawBMP(Name: PChar; X, Y: Integer);
var
  N: LongInt;
  W, H: Integer;
begin
  W := 0;
  H := 0;
  N := FSReadFile(Name, @AssetBuf[0], SizeOf(AssetBuf));
  if N < 0 then Exit;
  BMPDecode(@AssetBuf[0], LongWord(N), W, H, @DrawBuf[0], SizeOf(DrawBuf) div BPP);
  if (W = 0) or (H = 0) then Exit;
  DrawSprite(@DrawBuf[0], W, H, X, Y);
end;

// Igual a DrawSprite, mas desenha o contorno do sprite em preto
// (os pixels opacos viram cor 0 = preto).
procedure DrawSpriteBlack(Src: PByte; SrcW, SrcH, DstX, DstY: Integer);
var
  X, Y: Integer;
  C: LongWord;
begin
  for Y := 0 to SrcH - 1 do
    for X := 0 to SrcW - 1 do
    begin
      C := PLongWord(PByte(Src) + (Y * SrcW + X) * BPP)^;
      if (C and $FF000000) <> 0 then
        if (DstX + X >= 0) and (DstX + X < RWidth) and
           (DstY + Y >= 0) and (DstY + Y < RHeight) then
          PLongWord(PByte(Framebuffer) + (DstY + Y) * VPitch + (DstX + X) * BPP)^ :=
            PalColor(0);
    end;
end;

// Desenha o BMP de um atalho inteiramente em preto (estado selecionado).
procedure DrawBMPBlack(Name: PChar; X, Y: Integer);
var
  N: LongInt;
  W, H: Integer;
begin
  W := 0;
  H := 0;
  N := FSReadFile(Name, @AssetBuf[0], SizeOf(AssetBuf));
  if N < 0 then Exit;
  BMPDecode(@AssetBuf[0], LongWord(N), W, H, @DrawBuf[0], SizeOf(DrawBuf) div BPP);
  if (W = 0) or (H = 0) then Exit;
  DrawSpriteBlack(@DrawBuf[0], W, H, X, Y);
end;

end.