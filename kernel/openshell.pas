unit OpenShell;

{$mode objfpc}
{$H-}
{$N-}
{$E-}
{$asmmode intel}

interface

procedure ShellInit;
procedure ShellLoop;
// Carrega e executa um arquivo .run (caminho completo do disco) em modo
// headless (Silent=True, sem desenhar a tela) e retorna o CMD_* resultante.
function ShellRunFile(Path: PChar; Silent: Boolean): Integer;

implementation

uses
  Video, Keyboard, Serial, Svc, CDROM;

const
  MAXLINE = 128;
  SCRIPT_MAX = 8192;

  // Resultado do despacho de um comando:
  CMD_CONTINUE = 0;   // segue normalmente
  CMD_EXIT     = 1;   // comando 'exit'
  CMD_OPEN     = 2;   // forcou abertura do shell (cls dentro de um script)
  CMD_CLOSE    = 3;   // fechar o shell ao fim de um script (headless)

var
  LastScan: array[0..127] of Boolean;
  ScriptBuf: array[0..SCRIPT_MAX - 1] of Byte;

function ScanToChar(Sc: Byte): Char;
begin
  case Sc of
    $02: ScanToChar := '1'; $03: ScanToChar := '2'; $04: ScanToChar := '3';
    $05: ScanToChar := '4'; $06: ScanToChar := '5'; $07: ScanToChar := '6';
    $08: ScanToChar := '7'; $09: ScanToChar := '8'; $0A: ScanToChar := '9';
    $0B: ScanToChar := '0';
    $10: ScanToChar := 'q'; $11: ScanToChar := 'w'; $12: ScanToChar := 'e';
    $13: ScanToChar := 'r'; $14: ScanToChar := 't'; $15: ScanToChar := 'y';
    $16: ScanToChar := 'u'; $17: ScanToChar := 'i'; $18: ScanToChar := 'o';
    $19: ScanToChar := 'p';
    $1E: ScanToChar := 'a'; $1F: ScanToChar := 's'; $20: ScanToChar := 'd';
    $21: ScanToChar := 'f'; $22: ScanToChar := 'g'; $23: ScanToChar := 'h';
    $24: ScanToChar := 'j'; $25: ScanToChar := 'k'; $26: ScanToChar := 'l';
    $2C: ScanToChar := 'z'; $2D: ScanToChar := 'x'; $2E: ScanToChar := 'c';
    $2F: ScanToChar := 'v'; $30: ScanToChar := 'b'; $31: ScanToChar := 'n';
    $32: ScanToChar := 'm';
    $39: ScanToChar := ' ';
    $0C: ScanToChar := '-'; $1A: ScanToChar := '['; $1B: ScanToChar := ']';
    $27: ScanToChar := ';'; $28: ScanToChar := ''''; $29: ScanToChar := '`';
    $2B: ScanToChar := '\'; $33: ScanToChar := ','; $34: ScanToChar := '.';
    $35: ScanToChar := '/'; $0D: ScanToChar := '=';
  else
    ScanToChar := #0;
  end;
end;

function UpperChar(C: Char): Char;
begin
  if (C >= 'a') and (C <= 'z') then
    UpperChar := Char(Ord(C) - 32)
  else
    UpperChar := C;
end;

function StartsWith(Line: PChar; Len: Integer; Prefix: PChar): Boolean;
var
  I: Integer;
begin
  StartsWith := False;
  I := 0;
  while (Prefix[I] <> #0) and (I < Len) do
  begin
    if UpperChar(Line[I]) <> UpperChar(Prefix[I]) then
      Exit;
    Inc(I);
  end;
  if Prefix[I] = #0 then
    StartsWith := True;
end;

procedure ExtractArg(Line: PChar; Len: Integer; Arg: PChar; var ArgLen: Integer);
var
  I, K: Integer;
begin
  I := 0;
  while (I < Len) and (Line[I] <> ' ') do Inc(I);
  while (I < Len) and (Line[I] = ' ') do Inc(I);
  K := 0;
  while (I < Len) and (K < 63) do
  begin
    Arg[K] := Line[I];
    Inc(K);
    Inc(I);
  end;
  Arg[K] := #0;
  ArgLen := K;
end;

function UpStr(C: Char): Char;
begin
  if (C >= 'a') and (C <= 'z') then
    UpStr := Char(Ord(C) - 32)
  else
    UpStr := C;
end;

// Despacha um comando (definida abaixo; forward para RunScript usa-la).
function ProcCommand(Line: PChar; Len: Integer; var CY: Integer; Silent: Boolean): Integer; forward;

// Executa as linhas de um script (arquivo .run) ja carregado em ScriptBuf.
// Silent = True: processa em modo headless, sem desenhar texto na tela.
// Se uma linha for 'cls', abre o shell (desenha a tela) e o resto passa a
// ser desenhado normalmente. Retorna CMD_CLOSE se nada forcou o shell
// (volta ao desktop ao terminar) ou CMD_OPEN se o shell foi aberto.
function RunScript(Data: PChar; Size: Integer; var CY: Integer; Silent: Boolean): Integer;
var
  P: Integer;
  Line: array[0..MAXLINE - 1] of Char;
  LLen: Integer;
  Res: Integer;
  Visible: Boolean;
begin
  Visible := not Silent;
  P := 0;
  while P < Size do
  begin
    LLen := 0;
    while (P < Size) and (Data[P] <> #10) and (Data[P] <> #13) and (LLen < MAXLINE - 1) do
    begin
      Line[LLen] := Data[P];
      Inc(LLen);
      Inc(P);
    end;
    if (P < Size) and (Data[P] = #13) then Inc(P);
    if (P < Size) and (Data[P] = #10) then Inc(P);
    Line[LLen] := #0;
    if LLen > 0 then
    begin
      Res := ProcCommand(@Line[0], LLen, CY, not Visible);
      if Res = CMD_OPEN then
        Visible := True;
      if Res = CMD_EXIT then
      begin
        RunScript := CMD_CLOSE;
        Exit;
      end;
    end;
  end;
  if Visible then
    RunScript := CMD_OPEN
  else
    RunScript := CMD_CLOSE;
end;

// Carrega um .run do disco e o executa. Usado pelo desktop para abrir
// atalhos (.run) diretamente, sem passar pelo prompt do shell.
function ShellRunFile(Path: PChar; Silent: Boolean): Integer;
var
  N: LongInt;
  CY: Integer;
begin
  N := FSReadFile(Path, @ScriptBuf[0], SCRIPT_MAX);
  if N <= 0 then
  begin
    SerialWriteString('runfile: nao encontrado ');
    SerialWriteString(Path);
    SerialWriteChar(#13);
    SerialWriteChar(#10);
    ShellRunFile := CMD_CLOSE;
    Exit;
  end;
  SerialWriteString('runfile: executando ');
  SerialWriteString(Path);
  SerialWriteChar(#13);
  SerialWriteChar(#10);
  CY := 60;
  ShellRunFile := RunScript(@ScriptBuf[0], N, CY, Silent);
end;

// Despacha um comando. Silent = True significa modo headless (nao desenha
// o texto das respostas; so executa os efeitos colaterais, ex.: rodar
// programas). Em modo headless, o comando 'cls' abre o shell (CMD_OPEN).
function ProcCommand(Line: PChar; Len: Integer; var CY: Integer; Silent: Boolean): Integer;
var
  Arg: array[0..63] of Char;
  Path: array[0..95] of Char;
  ArgLen, I, J, K, N: Integer;
  Ok, HasExt, HasPath: Boolean;
begin
  ProcCommand := CMD_CONTINUE;
  if Len >= 64 then Len := 64;
  if StartsWith(Line, Len, 'help') then
  begin
    if not Silent then
    begin
      CY := CY + 16;
      WriteAt(3, CY, 'Comandos: run <NOME>, file <ARQ.RUN>, cls, help, exit', 12);
    end;
  end
  else if StartsWith(Line, Len, 'cls') and (Len = 3) then
  begin
    if Silent then
    begin
      // cls forcou a abertura do shell
      ClearScreen($0F);
      WriteAt(3, 3, 'Aether OpenShell', 16);
      WriteAt(3, 24, 'boas-vindas. digite help', 12);
      CY := 56;
      ProcCommand := CMD_OPEN;
    end
    else
    begin
      ClearScreen($0F);
      WriteAt(3, 3, 'Aether OpenShell', 16);
      WriteAt(3, 24, 'boas-vindas. digite help', 12);
      CY := 56;
    end;
  end
  else if StartsWith(Line, Len, 'exit') and (Len = 4) then
  begin
    if not Silent then
    begin
      CY := CY + 16;
      WriteAt(3, CY, 'Voltando ao desktop...', 16);
    end;
    ProcCommand := CMD_EXIT;
  end
  else if StartsWith(Line, Len, 'run') then
  begin
    ExtractArg(Line, Len, @Arg[0], ArgLen);
    if ArgLen = 0 then
    begin
      if not Silent then
      begin
        CY := CY + 16;
        WriteAt(3, CY, 'uso: run <NOME DO PROGRAMA>', 12);
      end;
    end
    else
    begin
      // verifica se o nome ja tem extensao/caminho (nao forca .BIN nesse caso)
      HasExt := False;
      for I := 0 to ArgLen - 1 do
        if (Arg[I] = '.') or (Arg[I] = '\') or (Arg[I] = '/') then
          HasExt := True;

      // 1) nome literal (caminho completo/exato)
      Ok := RunProgram(@Arg[0]);

      // 2) raiz do disco com .BIN (run hello -> HELLO.BIN)
      if not Ok and not HasExt then
      begin
        for I := 0 to ArgLen - 1 do
          Path[I] := Arg[I];
        Path[ArgLen] := '.';
        Path[ArgLen + 1] := 'B';
        Path[ArgLen + 2] := 'I';
        Path[ArgLen + 3] := 'N';
        Path[ArgLen + 4] := #0;
        Ok := RunProgram(@Path[0]);
      end;

      // 3) fallback: SYSTEM\COMPILED\<NOME>.BIN
      if not Ok then
      begin
        I := 0;
        while I < 16 do
        begin
          Path[I] := 'SYSTEM\COMPILED\'[I + 1];
          Inc(I);
        end;
        for I := 0 to ArgLen - 1 do
          Path[16 + I] := UpStr(Arg[I]);
        J := 16 + ArgLen;
        for I := 0 to 3 do
        begin
          Path[J + I] := '.BIN'[I + 1];
        end;
        Path[J + 4] := #0;
        Ok := RunProgram(@Path[0]);
      end;

      if not Silent then
      begin
        CY := CY + 16;
        WriteAt(3, CY, 'Executando ', 12);
        WriteAt(105, CY, @Arg[0], 12);
        if Ok then
          WriteAt(320, CY, '[ok]', 12)
        else
          WriteAt(320, CY, '[nao encontrado]', 12);
      end;
      SerialWriteString('shell: run ');
      SerialWriteString(@Arg[0]);
      SerialWriteChar(#13);
      SerialWriteChar(#10);
    end;
  end
  else if StartsWith(Line, Len, 'file') then
  begin
    ExtractArg(Line, Len, @Arg[0], ArgLen);
    if ArgLen = 0 then
    begin
      if not Silent then
      begin
        CY := CY + 16;
        WriteAt(3, CY, 'uso: file <ARQUIVO.RUN>', 12);
      end;
    end
    else
    begin
      // Tenta com a raiz do disco primeiro (file demo.run -> DEMO.RUN) e,
      // se nao achar, tenta SCRIPTS\DEMO.RUN. Se o nome ja tiver um
      // caminho, usa-o literalmente.
      HasExt := False;
      HasPath := False;
      for I := 0 to ArgLen - 1 do
      begin
        if (Arg[I] = '.') or (Arg[I] = '\') or (Arg[I] = '/') then
          HasExt := True;
        if (Arg[I] = '\') or (Arg[I] = '/') then
          HasPath := True;
      end;

      N := 0;
      K := 0;
      // 1) nome literal (caminho como digitado, ou nome na raiz): <ARG>.RUN
      for I := 0 to ArgLen - 1 do
        Path[I] := UpStr(Arg[I]);
      K := ArgLen;
      if not HasExt then
      begin
        Path[K] := '.';
        Path[K + 1] := 'R';
        Path[K + 2] := 'U';
        Path[K + 3] := 'N';
        K := K + 4;
      end;
      Path[K] := #0;
      N := FSReadFile(@Path[0], @ScriptBuf[0], SCRIPT_MAX);

      // 2) fallback: SCRIPTS\<ARG>.RUN (somente se o nome nao tiver caminho)
      if (N <= 0) and not HasPath then
      begin
        I := 0;
        while I < 8 do
        begin
          Path[I] := 'SCRIPTS\'[I + 1];
          Inc(I);
        end;
        for I := 0 to ArgLen - 1 do
          Path[8 + I] := UpStr(Arg[I]);
        K := 8 + ArgLen;
        if not HasExt then
        begin
          Path[K] := '.';
          Path[K + 1] := 'R';
          Path[K + 2] := 'U';
          Path[K + 3] := 'N';
          K := K + 4;
        end;
        Path[K] := #0;
        N := FSReadFile(@Path[0], @ScriptBuf[0], SCRIPT_MAX);
      end;

      if N <= 0 then
      begin
        if not Silent then
        begin
          CY := CY + 16;
          WriteAt(3, CY, 'script nao encontrado', 12);
        end;
        SerialWriteString('file: nao encontrado ');
        SerialWriteString(@Path[0]);
        SerialWriteChar(#13);
        SerialWriteChar(#10);
      end
      else
      begin
        SerialWriteString('file: executando ');
        SerialWriteString(@Path[0]);
        SerialWriteChar(#13);
        SerialWriteChar(#10);
        ProcCommand := RunScript(@ScriptBuf[0], N, CY, Silent);
      end;
    end;
  end
  else
  begin
    if not Silent then
    begin
      CY := CY + 16;
      WriteAt(3, CY, 'comando desconhecido', 12);
    end;
  end;
  if ProcCommand = CMD_CONTINUE then
    CY := CY + 16;   // linha em branco antes do proximo prompt
end;

procedure ShellLoop;
var
  Line: array[0..MAXLINE - 1] of Char;
  Len, CX, CY, I, Sc: Integer;
  Ch: Char;
begin
  // Reconhece as teclas ja seguras (ex.: 'o'/'f' do Alt+O+F) para nao
  // digita-las quando o shell abre.
  KeyboardPoll;
  for I := 0 to 127 do
    LastScan[I] := ScanIsPressed(I);
  Len := 0;
  ClearScreen($0F);
  WriteAt(20, 20, 'Aether OpenShell', 24);
  WriteAt(20, 60, 'digite help para ver os comandos', 12);

  CY := 90;
  CX := 3;
  WriteAt(CX, CY, '> ', 12);
  CX := CX + 20;
  while True do
  begin
    KeyboardPoll;
    for Sc := 1 to 127 do
    begin
      if ScanIsPressed(Sc) and not LastScan[Sc] then
      begin
        if Sc = SCAN_ENTER then
        begin
          Line[Len] := #0;
          // interactive: sempre visivel (Silent = False)
          if ProcCommand(@Line[0], Len, CY, False) in [CMD_EXIT, CMD_CLOSE] then
            Exit;   // volta ao desktop
          if CY > (RHeight - 56) then
          begin
            ClearScreen($0F);
            WriteAt(20, 20, 'Aether OpenShell', 24);
            WriteAt(20, 60, 'digite help para ver os comandos', 12);
            CY := 90;
          end;
          CX := 3;
          WriteAt(CX, CY, '> ', 12);
          CX := CX + 20;
          Len := 0;
        end
        else if Sc = SCAN_BKSP then
        begin
          if Len > 0 then
          begin
            Dec(Len);
            Line[Len] := #0;
            CX := CX - 12;
            // apaga apenas a celula do ultimo caractere (cada caractere ja foi
            // desenhado na sua posicao; redesenhar a linha toda causava duplicacao)
            FillRect(CX, CY, 12, 16, $0F);
          end;
        end
        else
        begin
          Ch := ScanToChar(Sc);
          if (Ch <> #0) and (Len < MAXLINE - 1) then
          begin
            if ScanIsPressed(SCAN_LSHIFT) or ScanIsPressed(SCAN_RSHIFT) then
              if (Ch >= 'a') and (Ch <= 'z') then
                Ch := Char(Ord(Ch) - 32);
            if (Len = 0) and (CX < 3) then
              CX := 3;
            Line[Len] := Ch;
            Inc(Len);
            Line[Len] := #0;
            // desenha apenas o caractere novo (nao a linha toda) para nao
            // duplicar texto para a direita
            WriteAt(CX, CY, @Line[Len - 1], 12);
            CX := CX + 12;
          end;
        end;
      end;
    end;
    for Sc := 1 to 127 do
      LastScan[Sc] := ScanIsPressed(Sc);
  end;
end;

procedure ShellInit;
begin
end;

end.
