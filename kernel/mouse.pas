unit Mouse;

{$mode objfpc}
{$H-}
{$asmmode intel}

interface

uses Video;

procedure MouseInit;
procedure MousePoll;
procedure MouseDeliver(B: Byte);
function GetMouseX: Integer;
function GetMouseY: Integer;
function GetMouseButtons: Byte;

implementation

const
  PortStatus = $64;
  PortData   = $60;

var
  MouseX, MouseY: Integer;
  MouseButtons: Byte;
  Packet: array[0..2] of Byte;
  PacketPos: Integer;

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

procedure WaitInputEmpty;
var
  i: Integer;
begin
  i := 0;
  while ((InB(PortStatus) and $02) <> 0) and (i < 100000) do
    Inc(i);
end;

procedure WaitOutputFull;
var
  i: Integer;
begin
  i := 0;
  while ((InB(PortStatus) and $01) = 0) and (i < 100000) do
    Inc(i);
end;

procedure MouseInit;
begin
  MouseX := 0;
  MouseY := 0;
  MouseButtons := 0;
  PacketPos := 0;

  WaitInputEmpty;
  OutB(PortStatus, $A8);        // habilita aux device (IRQ12)
  WaitInputEmpty;
  OutB(PortStatus, $D4);        // proxima escrita vai para o mouse
  WaitInputEmpty;
  OutB(PortData, $F4);          // habilita envio de pacotes

  WaitOutputFull;
  InB(PortData);                // descarta o ACK (0xFA)
end;

procedure MouseDeliver(B: Byte);
begin
  case PacketPos of
    0: Packet[0] := B;
    1: Packet[1] := B;
    2:
    begin
      Packet[2] := B;
      if (Packet[0] and $40) = 0 then
      begin
        if (Packet[0] and $10) <> 0 then
          MouseX := MouseX + (Packet[1] - 256)
        else
          MouseX := MouseX + Packet[1];
      end;
      if (Packet[0] and $80) = 0 then
      begin
        if (Packet[0] and $20) <> 0 then
          MouseY := MouseY - (Packet[2] - 256)
        else
          MouseY := MouseY - Packet[2];
      end;
      MouseButtons := Packet[0] and $03;
      if MouseX < 0 then
        MouseX := 0
      else if MouseX > RWidth - 16 then
        MouseX := RWidth - 16;
      if MouseY < 0 then
        MouseY := 0
      else if MouseY > RHeight - 16 then
        MouseY := RHeight - 16;
    end;
  end;
  PacketPos := (PacketPos + 1) mod 3;
end;

procedure MousePoll;
var
  Status, B: Byte;
begin
  while True do
  begin
    Status := InB(PortStatus);
    if (Status and $21) <> $21 then
      Exit;
    B := InB(PortData);
    MouseDeliver(B);
  end;
end;

function GetMouseX: Integer;
begin
  GetMouseX := MouseX;
end;

function GetMouseY: Integer;
begin
  GetMouseY := MouseY;
end;

function GetMouseButtons: Byte;
begin
  GetMouseButtons := MouseButtons;
end;

end.
