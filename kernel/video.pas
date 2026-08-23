unit Video;

{$mode objfpc}
{$H-}
{$asmmode intel}

interface

var
  RWidth, RHeight: integer;
  Framebuffer: PByte;

procedure VideoInit;
procedure PutPixel(X, Y: Integer; Color: Byte);
procedure FillRect(X, Y, W, H: Integer; Color: Byte);
procedure ClearScreen(Color: Byte);
procedure FillPattern8x8(const Pattern: array of Byte; On, Off: Byte);
procedure FillPatternRect(X, Y, W, H: Integer; const Pattern: array of Byte; On, Off: Byte);
procedure DrawCursor(X, Y: Integer);
procedure SaveCursorArea(X, Y: Integer);
procedure RestoreCursorArea(X, Y: Integer);
procedure DrawSprite(Src: PByte; SrcW, SrcH, DstX, DstY: Integer);
procedure WriteAt(X, Y: Integer; Text: PChar; Size: Integer);
procedure PutSymbol(X, Y: Integer; Symbol: Char; Size: Integer);
procedure DrawBMP(Name: PChar; X, Y: Integer);

implementation

uses CDROM, BMP;

var
  AssetBuf: array[0..16383] of Byte;
  DrawBuf:  array[0..16383] of Byte;

procedure OutB(Addr: Word; Value: Byte);
begin
  asm
    mov dx, Addr
    mov al, Value
    out dx, al
  end;
end;

procedure VideoInit;
var
  i: Integer;
  r, g, b: Byte;
begin
  Framebuffer := PByte(PLongWord($1000)^);
  RWidth := Integer(PWord($1004)^);
  RHeight := Integer(PWord($1006)^);
  OutB($3C8, 0);
  for i := 0 to 15 do
  begin
    case i of
      0:  begin r := 0;  g := 0;  b := 0;  end;
      15: begin r := 63; g := 63; b := 63; end;
    else
      begin r := 0; g := 0; b := 0; end;
    end;
    OutB($3C9, r);
    OutB($3C9, g);
    OutB($3C9, b);
  end;
  for i := 0 to 215 do
  begin
    r := (i div 36) * 51 div 4;
    g := ((i mod 36) div 6) * 51 div 4;
    b := (i mod 6) * 51 div 4;
    OutB($3C9, r);
    OutB($3C9, g);
    OutB($3C9, b);
  end;
end;

procedure PutPixel(X, Y: Integer; Color: Byte);
begin
  Framebuffer[(Y * RWidth) + X] := Color;
end;

procedure FillRect(X, Y, W, H: Integer; Color: Byte);
var
  YY, XX: Integer;
begin
  for YY := Y to Y + H - 1 do
    if (YY >= 0) and (YY < RHeight) then
      for XX := X to X + W - 1 do
        if (XX >= 0) and (XX < RWidth) then
          Framebuffer[YY * RWidth + XX] := Color;
end;

procedure ClearScreen(Color: Byte);
var
  i: Integer;
begin
  for i := 0 to (RWidth * RHeight) - 1 do
  begin
    Framebuffer[i] := Color;
  end;
end;

procedure FillPattern8x8(const Pattern: array of Byte; On, Off: Byte);
var
  Y, X: Integer;
begin
  for Y := 0 to RHeight - 1 do
  begin
    for X := 0 to RWidth - 1 do
    begin
      if (Pattern[Y and 7] and ($80 shr (X and 7))) <> 0 then
        Framebuffer[Y * RWidth + X] := On
      else
        Framebuffer[Y * RWidth + X] := Off;
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
            Framebuffer[YY * RWidth + XX] := On
          else
            Framebuffer[YY * RWidth + XX] := Off;
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
begin
  for R := 0 to 15 do
  begin
    if (Y + R < 0) or (Y + R >= RHeight) then
      Continue;
    for C := 0 to 15 do
    begin
      if (X + C < 0) or (X + C >= RWidth) then
        Continue;
      if (Shape[R] and (1 shl (15 - C))) <> 0 then
        Framebuffer[(Y + R) * RWidth + X + C] := Color;
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
  CursorBack: array[0..(CursorW * CursorH) - 1] of Byte;

procedure SaveCursorArea(X, Y: Integer);
var
  R, C: Integer;
begin
  for R := 0 to CursorH - 1 do
    for C := 0 to CursorW - 1 do
    begin
      if (Y - 1 + R >= 0) and (Y - 1 + R < RHeight) and
         (X - 1 + C >= 0) and (X - 1 + C < RWidth) then
        CursorBack[R * CursorW + C] := Framebuffer[(Y - 1 + R) * RWidth + (X - 1 + C)]
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
        Framebuffer[(Y - 1 + R) * RWidth + (X - 1 + C)] := CursorBack[R * CursorW + C];
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

procedure WriteAt(X, Y: Integer; Text: PChar; Size: Integer);
var
  i, R, C, G: Integer;
begin
  if Text = nil then
    Exit;
  if Size < 8 then
    Size := 8;
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
              Framebuffer[(Y + R) * RWidth + X + C] := 0;
      X := X + Size;
    end;
      i := i + 1;
  end;
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
              Framebuffer[(Y + R) * RWidth + X + C] := 0;
      Exit;
    end;
end;

procedure DrawSprite(Src: PByte; SrcW, SrcH, DstX, DstY: Integer);
var
  X, Y: Integer;
  C: Byte;
begin
  for Y := 0 to SrcH - 1 do
    for X := 0 to SrcW - 1 do
    begin
      C := PByte(PByte(Src) + Y * SrcW + X)^;
      if C <> 0 then
        if (DstX + X >= 0) and (DstX + X < RWidth) and
           (DstY + Y >= 0) and (DstY + Y < RHeight) then
          Framebuffer[(DstY + Y) * RWidth + DstX + X] := C;
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
  BMPDecode(@AssetBuf[0], LongWord(N), W, H, @DrawBuf[0], SizeOf(DrawBuf));
  if (W = 0) or (H = 0) then Exit;
  DrawSprite(@DrawBuf[0], W, H, X, Y);
end;

end.