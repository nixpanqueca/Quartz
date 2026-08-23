unit OpenFirmware;

{$mode objfpc}
{$H-}
{$asmmode intel}

interface

procedure OutB(Addr: Word; Value: Byte);
function InB(Addr: Word): Byte;
procedure DelayMS(Millis: LongInt);
procedure OFinit;

var
  Placeholder: Integer;

implementation

uses
  Video, Keyboard, bmp, Serial, Seek, OpenShell;

const
  MacGray: array[0..7] of Byte = ($AA, $55, $AA, $55, $AA, $55, $AA, $55);

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

procedure DelayMS(Millis: LongInt);
var
  Rounds, R: LongInt;
  L, H: Byte;
begin
  Rounds := (Millis + 54) div 55;
  if Rounds < 1 then
    Rounds := 1;
  for R := 0 to Rounds - 1 do
  begin
    OutB($43, $30);
    OutB($40, $FF);
    OutB($40, $FF);
    repeat
      OutB($43, $00);
      L := InB($40);
      H := InB($40);
    until (H = 0) and (L = 0);
  end;
end;

procedure OFinit;
var
  CX, CY: Integer;
begin
  CX := (RWidth - 32) div 2;
  CY := (RHeight - 32) div 2;
  DrawBMP('SPRITES\FLOPPY.BMP', CX, CY);
  DelayMS(400);
  DrawBMP('SPRITES\FLOPPY@2.BMP', CX, CY);
  DelayMS(400);
  DrawBMP('SPRITES\FLOPPY.BMP', CX, CY);
  DelayMS(400);
  DrawBMP('SPRITES\FLOPPY@2.BMP', CX, CY);
  DelayMS(400);
  DrawBMP('SPRITES\FLOPPY.BMP', CX, CY);
  DelayMS(400);
  DrawBMP('SPRITES\FLOPPY@2.BMP', CX, CY);
  DelayMS(400);
  DrawBMP('SPRITES\FLOPPY.BMP', CX, CY);
  DelayMS(400);
  DrawBMP('SPRITES\FLOPPY@2.BMP', CX, CY);
  DelayMS(400);
  KeyboardPoll;
  if ScanIsPressed(SCAN_LALT) and KeyIsPressed('o') and KeyIsPressed('f') then
  begin
    ClearScreen($0F);
  end;
end;

end.
