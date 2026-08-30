unit CDROM;

{$mode objfpc}
{$H-}
{$N-}
{$E-}
{$asmmode intel}

interface

procedure CDInit;
function CDReadSector(LBA: LongWord; Buf: PByte): Boolean;
function FSReadFile(Name: PChar; Dest: PByte; MaxSize: LongWord): LongInt;
function FSListDir(Name: PChar; Dest: PByte; MaxBytes: Integer): Integer;
procedure CDSelfTest;

implementation

uses Serial;

var
  CDBase: Word = 0;
  CDDrive: Byte = 0;
  PVD: array[0..2047] of Byte;
  FileBuf: array[0..16383] of Byte;
  DirBuf: array[0..2047] of Byte;

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

function InW(Addr: Word): Word;
var
  W: Word;
begin
  asm
    mov dx, Addr
    in ax, dx
    mov W, ax
  end;
  InW := W;
end;

procedure OutW(Addr: Word; Value: Word);
begin
  asm
    mov dx, Addr
    mov ax, Value
    out dx, ax
  end;
end;

procedure ATAStatusDelay;
begin
  OutB(CDBase + $206, $02);   // device control register: nIEN + ~400ns delay
end;

function CDProbe(Base: Word; Sel: Byte): Boolean;
var
  I: Integer;
  St: Byte;
begin
  CDProbe := False;
  OutB(Base + 6, Sel);
  OutB(Base + $206, $02);
  OutB(Base + 7, $A1);          // IDENTIFY PACKET DEVICE
  for I := 0 to 50000 do
  begin
    St := InB(Base + 7);
    if (St and $08) <> 0 then Break;    // DRQ -> ATAPI device
    if (St and $01) <> 0 then Break;    // ERR -> ATA device aborted
    if (St and $80) = 0 then
      if St = 0 then Break;             // no device on this slot
    ATAStatusDelay;
  end;
  if (St and $08) = 0 then Exit;
  for I := 0 to 255 do
    InW(Base);                          // drain 512-byte identify block
  CDProbe := True;
end;

procedure CDInit;
begin
  CDBase := 0;
  if CDProbe($1F0, $A0) then begin CDBase := $1F0; CDDrive := $A0; end
  else if CDProbe($1F0, $B0) then begin CDBase := $1F0; CDDrive := $B0; end
  else if CDProbe($170, $A0) then begin CDBase := $170; CDDrive := $A0; end
  else if CDProbe($170, $B0) then begin CDBase := $170; CDDrive := $B0; end;
end;

function CDReadSector(LBA: LongWord; Buf: PByte): Boolean;
var
  I: Integer;
  St: Byte;
  CDB: array[0..11] of Byte;
begin
  CDReadSector := False;
  if CDBase = 0 then Exit;
  OutB(CDBase + 6, CDDrive);
  ATAStatusDelay;
  for I := 0 to 100000 do
  begin
    St := InB(CDBase + 7);
    if (St and $80) = 0 then Break;     // BSY clear
    ATAStatusDelay;
  end;
  OutB(CDBase + 7, $A0);                // PACKET
  for I := 0 to 100000 do
  begin
    St := InB(CDBase + 7);
    if (St and $08) <> 0 then Break;    // DRQ: ready for the CDB
    if (St and $01) <> 0 then Exit;     // ERR
    ATAStatusDelay;
  end;
  if (St and $08) = 0 then Exit;
  CDB[0] := $28;                        // READ(10)
  CDB[1] := 0;
  CDB[2] := (LBA shr 24) and $FF;
  CDB[3] := (LBA shr 16) and $FF;
  CDB[4] := (LBA shr 8) and $FF;
  CDB[5] := LBA and $FF;
  CDB[6] := 0;
  CDB[7] := 0;
  CDB[8] := 1;                          // 1 logical sector
  CDB[9] := 0;
  CDB[10] := 0;
  CDB[11] := 0;
  for I := 0 to 5 do
    OutW(CDBase, Word(CDB[I * 2]) or (Word(CDB[I * 2 + 1]) shl 8));
  for I := 0 to 500000 do
  begin
    St := InB(CDBase + 7);
    if (St and $08) <> 0 then Break;    // data ready
    if (St and $01) <> 0 then Exit;     // ERR
    ATAStatusDelay;
  end;
  if (St and $08) = 0 then Exit;
  for I := 0 to 1023 do
    PWord(PByte(Buf) + I * 2)^ := InW(CDBase);
  CDReadSector := True;
end;

function NameEquals(NamePtr: PChar; DirBytes: PByte; NameOffset, NameLen: Integer): Boolean;
var
  I: Integer;
  Ch, DCh: Byte;
begin
  NameEquals := False;
  I := 0;
  while True do
  begin
    Ch := Byte(NamePtr[I]);
    DCh := DirBytes[NameOffset + I];
    if (Ch = 0) or (Ch = $3B) then
    begin
      if I >= NameLen then
        NameEquals := True
      else if DCh = $3B then
        NameEquals := True;
      Exit;
    end;
    if I >= NameLen then Exit;
    if Ch >= $61 then Dec(Ch, $20);
    if DCh >= $61 then Dec(DCh, $20);
    if Ch <> DCh then Exit;
    Inc(I);
  end;
end;

procedure FSLookup(DirLBA, DirSize: LongWord; Comp: PChar;
  var OutLBA, OutSize: LongWord; var OutIsDir: Boolean);
var
  SecCount, S: LongWord;
  P, L: LongInt;
  NameLen: Integer;
begin
  OutLBA := 0;
  OutSize := 0;
  OutIsDir := False;
  SecCount := (DirSize + 2047) div 2048;
  if SecCount > 16 then SecCount := 16;
  for S := 0 to SecCount - 1 do
  begin
    if not CDReadSector(DirLBA + S, @DirBuf[0]) then Exit;
    P := 0;
    while P < 2048 do
    begin
      L := DirBuf[P];
      if L = 0 then Break;
      NameLen := DirBuf[P + 32];
      if (NameLen > 0) and
         NameEquals(Comp, @DirBuf[0], P + 33, NameLen) then
      begin
        OutLBA := LongWord(DirBuf[P+2]) or (LongWord(DirBuf[P+3]) shl 8) or
                  (LongWord(DirBuf[P+4]) shl 16) or (LongWord(DirBuf[P+5]) shl 24);
        OutSize := LongWord(DirBuf[P+10]) or (LongWord(DirBuf[P+11]) shl 8) or
                   (LongWord(DirBuf[P+12]) shl 16) or (LongWord(DirBuf[P+13]) shl 24);
        OutIsDir := (DirBuf[P + 25] and 2) <> 0;
        Exit;
      end;
      P := P + L;
    end;
  end;
end;

function FSReadFile(Name: PChar; Dest: PByte; MaxSize: LongWord): LongInt;
var
  RootLBA, RootSize: LongWord;
  DirLBA, DirSize: LongWord;
  FileLBA, FileSize: LongWord;
  IsDir: Boolean;
  Components: array[0..7] of PChar;
  NumComp, I, J, N, Len: Integer;
  P: PChar;
  NameBuf: array[0..63] of Char;
begin
  FSReadFile := -1;
  if CDBase = 0 then Exit;
  if not CDReadSector(16, @PVD[0]) then Exit;
  if PVD[1] <> $43 then Exit;
  if PVD[2] <> $44 then Exit;
  if PVD[3] <> $30 then Exit;
  if PVD[4] <> $30 then Exit;
  if PVD[5] <> $31 then Exit;
  RootLBA := LongWord(PVD[138]) or (LongWord(PVD[139]) shl 8) or
             (LongWord(PVD[140]) shl 16) or (LongWord(PVD[141]) shl 24);
  RootSize := LongWord(PVD[146]) or (LongWord(PVD[147]) shl 8) or
              (LongWord(PVD[148]) shl 16) or (LongWord(PVD[149]) shl 24);
  Len := 0;
  while (Name[Len] <> #0) and (Len < 63) do
  begin
    NameBuf[Len] := Name[Len];
    Inc(Len);
  end;
  NameBuf[Len] := #0;
  NumComp := 0;
  P := @NameBuf[0];
  while (P^ <> #0) and (NumComp < 8) do
  begin
    Components[NumComp] := P;
    Inc(NumComp);
    while (P^ <> #0) and (P^ <> '\') and (P^ <> '/') do Inc(P);
    if P^ <> #0 then begin P^ := #0; Inc(P); end;
  end;
  if NumComp = 0 then Exit;
  DirLBA := RootLBA;
  DirSize := RootSize;
  for I := 0 to NumComp - 1 do
  begin
    FSLookup(DirLBA, DirSize, Components[I], FileLBA, FileSize, IsDir);
    if FileLBA = 0 then Exit;
    if I < NumComp - 1 then
    begin
      if not IsDir then Exit;
      DirLBA := FileLBA;
      DirSize := FileSize;
    end
    else
    begin
      if IsDir then Exit;
      N := LongInt((FileSize + 2047) div 2048);
      if LongWord(N) * 2048 > MaxSize then
        N := LongInt(MaxSize div 2048);
      for J := 0 to N - 1 do
        if not CDReadSector(FileLBA + LongWord(J), PByte(PByte(Dest) + J * 2048)) then
          Exit;
      FSReadFile := LongInt(FileSize);
      Exit;
    end;
  end;
end;

// Lista os arquivos (nao-diretorios) de um diretorio. Grava em Dest os
// nomes em minusculas/como estao, um apos o outro, cada um terminado em #0.
// Retorna a quantidade de arquivos listados (0 se nao achar o diretorio).
function FSListDir(Name: PChar; Dest: PByte; MaxBytes: Integer): Integer;
var
  RootLBA, RootSize: LongWord;
  DirLBA, DirSize: LongWord;
  FileLBA, FileSize: LongWord;
  IsDir: Boolean;
  Components: array[0..7] of PChar;
  NumComp, I, J, N, Len: Integer;
  P: PChar;
  NameBuf: array[0..63] of Char;
  SecCount, S, OutPoz: LongWord;
  Count, ObjLen, NameLen: Integer;
begin
  FSListDir := 0;
  if CDBase = 0 then Exit;
  if not CDReadSector(16, @PVD[0]) then Exit;
  if PVD[1] <> $43 then Exit;
  if PVD[2] <> $44 then Exit;
  if PVD[3] <> $30 then Exit;
  if PVD[4] <> $30 then Exit;
  if PVD[5] <> $31 then Exit;
  RootLBA := LongWord(PVD[138]) or (LongWord(PVD[139]) shl 8) or
             (LongWord(PVD[140]) shl 16) or (LongWord(PVD[141]) shl 24);
  RootSize := LongWord(PVD[146]) or (LongWord(PVD[147]) shl 8) or
              (LongWord(PVD[148]) shl 16) or (LongWord(PVD[149]) shl 24);
  Len := 0;
  while (Name[Len] <> #0) and (Len < 63) do
  begin
    NameBuf[Len] := Name[Len];
    Inc(Len);
  end;
  NameBuf[Len] := #0;
  NumComp := 0;
  P := @NameBuf[0];
  while (P^ <> #0) and (NumComp < 8) do
  begin
    Components[NumComp] := P;
    Inc(NumComp);
    while (P^ <> #0) and (P^ <> '\') and (P^ <> '/') do Inc(P);
    if P^ <> #0 then begin P^ := #0; Inc(P); end;
  end;
  if NumComp = 0 then Exit;
  DirLBA := RootLBA;
  DirSize := RootSize;
  for I := 0 to NumComp - 1 do
  begin
    FSLookup(DirLBA, DirSize, Components[I], FileLBA, FileSize, IsDir);
    if FileLBA = 0 then Exit;
    if I < NumComp - 1 then
    begin
      if not IsDir then Exit;
      DirLBA := FileLBA;
      DirSize := FileSize;
    end
    else
    begin
      if not IsDir then Exit;
      DirLBA := FileLBA;
      DirSize := FileSize;
    end;
  end;
  Count := 0;
  OutPoz := 0;
  SecCount := (DirSize + 2047) div 2048;
  if SecCount > 16 then SecCount := 16;
  for S := 0 to SecCount - 1 do
  begin
    if not CDReadSector(DirLBA + S, @DirBuf[0]) then Exit;
    N := 0;
    while N < 2048 do
    begin
      ObjLen := DirBuf[N];
      if ObjLen = 0 then Break;
      NameLen := DirBuf[N + 32];
      IsDir := (DirBuf[N + 25] and 2) <> 0;
      if (not IsDir) and (NameLen > 0) then
      begin
        if OutPoz + LongWord(NameLen) + 1 <= LongWord(MaxBytes) then
        begin
          for J := 0 to NameLen - 1 do
            Dest[OutPoz + LongWord(J)] := DirBuf[N + 33 + J];
          Dest[OutPoz + LongWord(NameLen)] := 0;
          OutPoz := OutPoz + LongWord(NameLen) + 1;
          Inc(Count);
        end;
      end;
      N := N + ObjLen;
    end;
  end;
  FSListDir := Count;
end;

procedure CDSelfTest;
var
  N: LongInt;
  I: LongInt;
  Max: LongInt;
begin
  CDInit;
  if CDBase = 0 then
  begin
    SerialWriteString('cd=none');
    SerialWriteChar(#13);
    SerialWriteChar(#10);
    Exit;
  end;
  N := FSReadFile('ABOUT.TXT', @FileBuf[0], SizeOf(FileBuf));
  SerialWriteString('cd=ok ');
  SerialWriteHex32(LongWord(CDBase));
  SerialWriteChar(' ');
  if N < 0 then
    SerialWriteString('ABOUT.TXT:not found')
  else
  begin
    SerialWriteHex32(LongWord(N));
    SerialWriteChar(' ');
    Max := SizeOf(FileBuf);
    if N > Max then
      N := Max;
    for I := 0 to N - 1 do
      SerialWriteChar(Chr(FileBuf[I]));
  end;
  SerialWriteChar(#13);
  SerialWriteChar(#10);
end;

end.
