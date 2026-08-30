unit Keyboard;

{$mode objfpc}
{$H-}
{$asmmode intel}

interface

uses Mouse;

const
  SCAN_UP      = $48;
  SCAN_DOWN    = $50;
  SCAN_LEFT    = $4B;
  SCAN_RIGHT   = $4D;
  SCAN_HOME    = $47;
  SCAN_END     = $4F;
  SCAN_PGUP    = $49;
  SCAN_PGDN    = $51;
  SCAN_INSERT  = $52;
  SCAN_DELETE  = $53;
  SCAN_F1      = $3B;
  SCAN_F2      = $3C;
  SCAN_F3      = $3D;
  SCAN_F4      = $3E;
  SCAN_F5      = $3F;
  SCAN_F6      = $40;
  SCAN_F7      = $41;
  SCAN_F8      = $42;
  SCAN_F9      = $43;
  SCAN_F10     = $44;
  SCAN_F11     = $57;
  SCAN_F12     = $58;
  SCAN_ESC     = $01;
  SCAN_TAB     = $0F;
  SCAN_ENTER   = $1C;
  SCAN_BKSP    = $0E;
  SCAN_SPACE   = $39;
  SCAN_LCTRL   = $1D;
  SCAN_LSHIFT  = $2A;
  SCAN_RSHIFT  = $36;
  SCAN_LALT    = $38;
  SCAN_CAPS    = $3A;

procedure KeyboardInit;
procedure KeyboardPoll;
function KeyIsPressed(Ch: Char): Boolean;
function ScanIsPressed(Scan: Byte): Boolean;
function SpecialKeyIsPressed(Scan: Byte): Boolean;
function AnyKeyPressed: Boolean;

implementation

procedure OutB(Addr: Word; Value: Byte);
begin
  asm
    mov dx, Addr
    mov al, Value
    out dx, al
  end;
end;

function InB(Addr: Word): Byte;
var
  B: Byte;
begin
  asm
    mov dx, Addr
    in al, dx
    mov B, al
  end;
  InB := B;
end;

var
  KeyState: array[0..127] of Boolean;
  SpecialState: array[0..127] of Boolean;

procedure KeyboardInit;
var
  i: Integer;
begin
  for i := 0 to 127 do
  begin
    KeyState[i] := False;
    SpecialState[i] := False;
  end;
  while (InB($64) and 1) <> 0 do InB($60);
end;

procedure KeyboardPoll;
var
  Sc: Byte;
  IsBreak: Boolean;
begin
  while True do
  begin
    if (InB($64) and 1) = 0 then
      Exit;
    if (InB($64) and $20) <> 0 then
    begin
      // Byte do mouse (aux device): roteia para o parser do mouse, em vez de
      // trata-lo como tecla (evita caracteres fantasmas quando o mouse e movido).
      MouseDeliver(InB($60));
      Continue;
    end;
    Sc := InB($60);
    if Sc = $E0 then
    begin
      while (InB($64) and 1) = 0 do ;
      Sc := InB($60);
      IsBreak := (Sc and $80) <> 0;
      if IsBreak then
        Sc := Sc and $7F;
      SpecialState[Sc] := not IsBreak;
    end
    else if Sc = $E1 then
    begin
      while (InB($64) and 1) <> 0 do
        InB($60);
    end
    else
    begin
      IsBreak := (Sc and $80) <> 0;
      if IsBreak then
        Sc := Sc and $7F;
      KeyState[Sc] := not IsBreak;
    end;
  end;
end;

const
  CharToScan: array[0..36] of record
    Ch: Char;
    Scan: Byte;
  end = (
    (Ch: '1'; Scan: $02), (Ch: '2'; Scan: $03), (Ch: '3'; Scan: $04),
    (Ch: '4'; Scan: $05), (Ch: '5'; Scan: $06), (Ch: '6'; Scan: $07),
    (Ch: '7'; Scan: $08), (Ch: '8'; Scan: $09), (Ch: '9'; Scan: $0A),
    (Ch: '0'; Scan: $0B),
    (Ch: 'q'; Scan: $10), (Ch: 'w'; Scan: $11), (Ch: 'e'; Scan: $12),
    (Ch: 'r'; Scan: $13), (Ch: 't'; Scan: $14), (Ch: 'y'; Scan: $15),
    (Ch: 'u'; Scan: $16), (Ch: 'i'; Scan: $17), (Ch: 'o'; Scan: $18),
    (Ch: 'p'; Scan: $19),
    (Ch: 'a'; Scan: $1E), (Ch: 's'; Scan: $1F), (Ch: 'd'; Scan: $20),
    (Ch: 'f'; Scan: $21), (Ch: 'g'; Scan: $22), (Ch: 'h'; Scan: $23),
    (Ch: 'j'; Scan: $24), (Ch: 'k'; Scan: $25), (Ch: 'l'; Scan: $26),
    (Ch: 'z'; Scan: $2C), (Ch: 'x'; Scan: $2D), (Ch: 'c'; Scan: $2E),
    (Ch: 'v'; Scan: $2F), (Ch: 'b'; Scan: $30), (Ch: 'n'; Scan: $31),
    (Ch: 'm'; Scan: $32),
    (Ch: ' '; Scan: $39)
  );

function KeyIsPressed(Ch: Char): Boolean;
var
  i: Integer;
  L: Char;
begin
  KeyIsPressed := False;
  L := Ch;
  if (L >= 'A') and (L <= 'Z') then
    L := Char(Ord(L) + 32);
  for i := 0 to High(CharToScan) do
  begin
    if CharToScan[i].Ch = L then
    begin
      KeyIsPressed := KeyState[CharToScan[i].Scan];
      Exit;
    end;
  end;
end;

function SpecialKeyIsPressed(Scan: Byte): Boolean;
begin
  SpecialKeyIsPressed := SpecialState[Scan];
end;

function ScanIsPressed(Scan: Byte): Boolean;
begin
  ScanIsPressed := KeyState[Scan] or SpecialState[Scan];
end;

function AnyKeyPressed: Boolean;
var
  i: Integer;
begin
  AnyKeyPressed := False;
  for i := 0 to 127 do
    if KeyState[i] or SpecialState[i] then
    begin
      AnyKeyPressed := True;
      Exit;
    end;
end;

end.
