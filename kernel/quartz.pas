{$mode objfpc}
{$H-}
{$N-}
{$E-}
{$asmmode intel}

unit Quartz;

interface

procedure Kernel; cdecl; public;
procedure Print(Text: PChar);

implementation

uses Serial, Video, Mouse, Prism, Buttons, CDROM, Keyboard, OpenFirmware, Svc, OpenShell;

var
  VideoMemory: PByte = Pointer($B8000);
  Cursor: Integer = 0;

const
  MacGray: array[0..7] of Byte = ($AA, $55, $AA, $55, $AA, $55, $AA, $55);

const
  MacLogo: array[0..31] of LongWord = (
    $57FFFFD5, $FFFFFFFF, $F800003F, $E1FFFF0F,
    $E3FFFF8F, $E000000F, $E000000F, $E011100F,
    $E011100F, $E001000F, $E001000F, $E003000F,
    $E000000F, $E008400F, $E007800F, $E000000F,
    $E000000F, $E3FFFF8F, $E1FFFF0F, $E000000F,
    $E000000F, $E000000F, $E3003F0F, $E3003F0F,
    $E000000F, $E000000F, $E000000F, $FFFFFFFF,
    $F7FFFFDF, $F000001F, $F000001F, $F7FFFFDF
  );

procedure DrawMacLogo(X, Y: Integer);
var
  R, C: Integer;
begin
  for R := 0 to 31 do
    for C := 0 to 31 do
      if (MacLogo[R] and (LongWord(1) shl (31 - C))) <> 0 then
        PutPixel(X + C, Y + R, 0);
end;

procedure Print(Text: PChar);
var
  i: Integer;
begin
  i := 0;

  while Text[i] <> #0 do
  begin
    VideoMemory[Cursor] := Ord(Text[i]);
    VideoMemory[Cursor + 1] := $07;

    Cursor := Cursor + 2;
    i := i + 1;
  end;
end;

procedure Kernel; cdecl;
var
  CursorX, CursorY: Integer;
  WinX, WinY, WinW, WinH: Integer;
begin
    VideoInit;

    FillPattern8x8(MacGray, 0, $0F);

    CDSelfTest;

    MouseInit;
    KeyboardInit;
    SerialInit;
    SerialWriteString('fb=');
    SerialWriteHex32(LongWord(Framebuffer));
    SerialWriteString(' w=');
    SerialWriteHex32(LongWord(RWidth));
    SerialWriteString(' h=');
    SerialWriteHex32(LongWord(RHeight));
    SerialWriteChar(#13);
    SerialWriteChar(#10);

    ProgramSvcInit;

    OFinit;

    ClearScreen($0F);
    FillPattern8x8(MacGray, 0, $0F);
    WinW := RWidth div 5 * 4;
    WinH := RHeight div 4 * 2;
    WinX := (RWidth - WinW) div 2;
    WinY := (RHeight - WinH) div 2 - 20;
    FillRect(WinX, WinY, WinW, WinH, $0F);
    FillRect(WinX+4, WinY+4, WinW-8, WinH-8, 0);
    FillRect(WinX+6, WinY+6, WinW-12, WinH-12, $0F);
    WriteAt(WinX + (WinW - Length('Welcome to Aether') * 12) div 2,
            WinY + (WinH - 16) div 3,
            'Welcome to Aether', 16);
    DrawBMP('SYSTEM\COMPILED\PRISM\BITMAP\FACE@2X.BMP', WinX + 35, WinY + 35);
    DelayMS(2000);

    ClearScreen($0F);
    FillPattern8x8(MacGray, 0, $0F);
    DelayMS(100);
    PrismInit;
    CursorX := GetMouseX;
    CursorY := GetMouseY;
    SaveCursorArea(CursorX, CursorY);
    DrawCursor(CursorX, CursorY);

    while True do
    begin
        MousePoll;
        KeyboardPoll;
        if (GetMouseX <> CursorX) or (GetMouseY <> CursorY) then
        begin
            RestoreCursorArea(CursorX, CursorY);
            CursorX := GetMouseX;
            CursorY := GetMouseY;
            SaveCursorArea(CursorX, CursorY);
            DrawCursor(CursorX, CursorY);
        end;
        CheckButtons;
        if GetOutsideClick then
            ClearShortcutSelection;
    end;
end;

end.
