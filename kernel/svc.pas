unit Svc;

{$mode objfpc}
{$H-}
{$N-}
{$E-}
{$asmmode intel}

interface

// Preenche a tabela de servicos em SERVICE_TABLE_ADDR com os ponteiros
// para as funcoes do kernel. Deve ser chamado durante a inicializacao,
// antes de qualquer programa ser executado.
procedure ProgramSvcInit;

// Le o binario do programa Name do disco, carrega em PROGRAM_BASE e o
// executa como funcao. Retorna True se carregou e executou.
function RunProgram(Name: PChar): Boolean;

implementation

uses
  Video, Serial, CDROM, Keyboard, Mouse, OpenFirmware, Windows;

{$include '../svc.inc'}

// Escreve o endereco de uma rotina na tabela.
procedure PutSvc(Index: Integer; P: Pointer);
begin
  PLongWord(PByte(SERVICE_TABLE_ADDR) + Index * 4)^ := LongWord(P);
end;

procedure ProgramSvcInit;
begin
  PutSvc(SVC_MAGIC, Pointer(SERVICE_TABLE_MAGIC));
  // Servicos de desenho: usam os wrappers de janela (aplicam offset quando
  // ha uma janela ativa; caso contrario repassam ao desenho absoluto).
  PutSvc(SVC_CLEARSCREEN, Pointer(@SvcClearScreen));
  PutSvc(SVC_WRITEAT, Pointer(@SvcWriteAt));
  PutSvc(SVC_WRITEATCOL, Pointer(@SvcWriteAtCol));
  PutSvc(SVC_FILLRECT, Pointer(@SvcFillRect));
  PutSvc(SVC_PUTPIXEL, Pointer(@SvcPutPixel));
  PutSvc(SVC_DRAWLINE, Pointer(@SvcDrawLine));
  PutSvc(SVC_DELAYMS, Pointer(@DelayMS));
  PutSvc(SVC_SERIALSTR, Pointer(@SerialWriteString));
  PutSvc(SVC_SERIALCHAR, Pointer(@SerialWriteChar));
  PutSvc(SVC_KEYPOLL, Pointer(@KeyboardPoll));
  PutSvc(SVC_ANYKEY, Pointer(@AnyKeyPressed));
  PutSvc(SVC_KEYPRESSED, Pointer(@KeyIsPressed));
  PutSvc(SVC_FSREAD, Pointer(@FSReadFile));
  PutSvc(SVC_DRAWBMP, Pointer(@SvcDrawBMP));
  PutSvc(SVC_MOUSEX, Pointer(@SvcGetMouseX));
  PutSvc(SVC_MOUSEY, Pointer(@SvcGetMouseY));
  // Servicos de janela.
  PutSvc(SVC_WINCREATE, Pointer(@WinCreate));
  PutSvc(SVC_WINPOLL, Pointer(@WinPoll));
  PutSvc(SVC_WINDESTROY, Pointer(@WinDestroy));
  PutSvc(SVC_WINKEY, Pointer(@WinKey));
end;

function RunProgram(Name: PChar): Boolean;
type
  TProgramProc = procedure;
var
  P: PByte;
  N: LongInt;
  I: LongWord;
begin
  RunProgram := False;
  P := PByte(PROGRAM_BASE);
  // Zera toda a area do programa antes de carregar (limpa o BSS do
  // programa e o preenchimento do ultimo setor lido).
  for I := 0 to PROGRAM_MAX - 1 do
    P[I] := 0;
  N := FSReadFile(Name, P, PROGRAM_MAX);
  SerialWriteString('prog: read ');
  SerialWriteHex32(LongWord(N));
  SerialWriteString(' bytes ');
  SerialWriteString(Name);
  SerialWriteChar(#13);
  SerialWriteChar(#10);
  if N <= 0 then
    Exit;
  SerialWriteString('prog: call entry');
  SerialWriteChar(#13);
  SerialWriteChar(#10);
  TProgramProc(Pointer(P))();
  SerialWriteString('prog: returned');
  SerialWriteChar(#13);
  SerialWriteChar(#10);
  RunProgram := True;
end;

end.
