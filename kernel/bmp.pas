unit BMP;

{$mode objfpc}
{$H-}
{$N-}
{$E-}

interface

function RGBToVGA(R, G, B: Byte): Byte;
function BMPDecode(Src: PByte; SrcSize: LongWord;
  var W, H: Integer; Dst: PByte; MaxPixels: LongWord): Boolean;

implementation

uses Serial;

function RGBToVGA(R, G, B: Byte): Byte;
var
  ri, gi, bi: Integer;
begin
  ri := R * 6 div 256;
  gi := G * 6 div 256;
  bi := B * 6 div 256;
  RGBToVGA := 16 + Byte(ri) * 36 + Byte(gi) * 6 + Byte(bi);
end;

function ReadLE16(P: PByte): Word;
begin
  ReadLE16 := Word(P^) or (Word((P + 1)^) shl 8);
end;

function ReadLE32(P: PByte): LongWord;
begin
  ReadLE32 := LongWord(P^) or (LongWord((P + 1)^) shl 8) or
              (LongWord((P + 2)^) shl 16) or (LongWord((P + 3)^) shl 24);
end;

// Decodifica um arquivo BMP (8/24/32 bpp, sem compressao) para um buffer
// de pixels true color. Cada pixel no Dst ocupa 4 bytes no formato
// [R][G][B][A] (bytes na ordem do framebuffer); A = 0 significa
// transparente (pixel vermelho puro 255,0,0 na origem).
function BMPDecode(Src: PByte; SrcSize: LongWord;
  var W, H: Integer; Dst: PByte; MaxPixels: LongWord): Boolean;
var
  HdrSize, ImgOff: LongWord;
  Bpp, Planes, Comp: Word;
  RowBytes, Y, X, DstRow: Integer;
  DstPtr, SrcPtr: PByte;
  Pad: Integer;
  PixIdx: LongWord;
  R, G, B: Byte;
  IsTopDown: Boolean;
  PaletteBase: Integer;
  PalEntry: PByte;
begin
  BMPDecode := False;
  W := 0;
  H := 0;
  if SrcSize < 54 then Exit;
  if Src[0] <> $42 then Exit;
  if Src[1] <> $4D then Exit;
  ImgOff := ReadLE32(Src + 10);
  HdrSize := ReadLE32(Src + 14);
  W := LongInt(ReadLE32(Src + 18));
  H := LongInt(ReadLE32(Src + 22));
  Planes := ReadLE16(Src + 26);
  Bpp := ReadLE16(Src + 28);
  Comp := ReadLE32(Src + 30);
  IsTopDown := H < 0;
  if IsTopDown then H := -H;
  if Planes <> 1 then begin W := 0; H := 0; Exit; end;
  if (Bpp <> 24) and (Bpp <> 32) and (Bpp <> 8) then
  begin
    SerialWriteString('bmp: unsupported bpp=');
    SerialWriteHex32(Bpp);
    SerialWriteChar(#13);
    SerialWriteChar(#10);
    W := 0;
    H := 0;
    Exit;
  end;
  if Comp <> 0 then
  begin
    SerialWriteString('bmp: compressed');
    SerialWriteChar(#13);
    SerialWriteChar(#10);
    W := 0;
    H := 0;
    Exit;
  end;
  if (W <= 0) or (H <= 0) then Exit;
  if MaxPixels < LongWord(W * H) then
  begin
    SerialWriteString('bmp: too large');
    SerialWriteChar(#13);
    SerialWriteChar(#10);
    W := 0;
    H := 0;
    Exit;
  end;
  RowBytes := (W * Bpp + 31) div 32 * 4;
  Pad := RowBytes - (W * Bpp div 8);
  PaletteBase := 14 + Integer(HdrSize);
  PixIdx := 0;
  for Y := 0 to H - 1 do
  begin
    if IsTopDown then DstRow := Y
    else DstRow := H - 1 - Y;
    DstPtr := Dst;
    Inc(DstPtr, DstRow * W * 4);
    SrcPtr := PByte(PByte(Src) + ImgOff + LongWord(Y) * LongWord(RowBytes));
    for X := 0 to W - 1 do
    begin
      if Bpp = 8 then
      begin
        PalEntry := PByte(PByte(Src) + PaletteBase + Integer(SrcPtr^) * 4);
        B := PalEntry^; Inc(PalEntry);
        G := PalEntry^; Inc(PalEntry);
        R := PalEntry^;
        Inc(SrcPtr);
      end
      else if Bpp = 24 then
      begin
        B := SrcPtr^; Inc(SrcPtr);
        G := SrcPtr^; Inc(SrcPtr);
        R := SrcPtr^; Inc(SrcPtr);
      end
      else
      begin
        B := SrcPtr^; Inc(SrcPtr);
        G := SrcPtr^; Inc(SrcPtr);
        R := SrcPtr^; Inc(SrcPtr);
        Inc(SrcPtr);
      end;
      if (R = 255) and (G = 0) and (B = 0) then
        PLongWord(DstPtr)^ := $00000000   // transparente
      else
        PLongWord(DstPtr)^ := $FF000000 or LongWord(R) or
                              (LongWord(G) shl 8) or (LongWord(B) shl 16);
      Inc(DstPtr, 4);
      Inc(PixIdx);
    end;
    Inc(SrcPtr, Pad);
  end;
  BMPDecode := True;
end;

end.