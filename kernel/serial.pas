unit Serial;

{$mode objfpc}
{$H-}
{$asmmode intel}

interface

procedure SerialInit;
procedure SerialWriteChar(C: Char);
procedure SerialWriteString(S: PChar);
procedure SerialWriteHex32(V: LongWord);

implementation

const
  COM1 = $3F8;

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

procedure SerialInit;
begin
  OutB(COM1 + 1, $00);    // sem interrupcoes
  OutB(COM1 + 3, $80);    // DLAB = 1
  OutB(COM1,     $03);    // divisor baixo (38400 baud)
  OutB(COM1 + 1, $00);    // divisor alto
  OutB(COM1 + 3, $03);    // 8N1, DLAB = 0
  OutB(COM1 + 2, $C7);    // FIFO enable, clear, 14 bytes
end;

procedure SerialWriteChar(C: Char);
var
  i: Integer;
begin
  i := 0;
  while ((InB(COM1 + 5) and $20) = 0) and (i < 100000) do
    Inc(i);
  OutB(COM1, Ord(C));
end;

procedure SerialWriteString(S: PChar);
begin
  while S^ <> #0 do
  begin
    SerialWriteChar(S^);
    Inc(S);
  end;
end;

procedure SerialWriteHex32(V: LongWord);
var
  i: Integer;
  Digit: Char;
begin
  for i := 7 downto 0 do
  begin
    Digit := Chr($30 + ((V shr (i * 4)) and $F));
    if Digit > '9' then
      Digit := Chr(Ord(Digit) + 7);
    SerialWriteChar(Digit);
  end;
end;

end.
