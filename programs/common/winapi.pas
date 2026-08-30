unit WinAPI;

{$mode objfpc}
{$H-}
{$N-}
{$E-}
{$asmmode intel}

// API de janelas para programas (.bin). Cada rotina chama o WindowManager
// do kernel (kernel\windows.pas) atraves da tabela de servicos.
//
// O desenho dentro da janela usa as funcoes normais do SvcAPI (WriteAt,
// FillRect, PutPixel, DrawLine, DrawBMP, ...) que ja aplicam o offset da
// janela automaticamente enquanto ela estiver aberta.

interface

{$include '../../svc.inc'}

procedure WinCreate(Title: PChar; W, H: Integer);
procedure WinDestroy;
function WinPoll: Integer;
function WinKey: Char;

implementation

function SvcProc(Index: Integer): Pointer;
begin
  SvcProc := Pointer(PLongWord(PByte(SERVICE_TABLE_ADDR) + Index * 4)^);
end;

type
  TProcWinCreate = function(Title: PChar; W, H: Integer): Integer;
  TProcWinDestroy = procedure;
  TFuncWinPoll    = function: Integer;
  TFuncWinKey     = function: Char;

procedure WinCreate(Title: PChar; W, H: Integer);
var P: TProcWinCreate;
begin P := TProcWinCreate(SvcProc(SVC_WINCREATE)); P(Title, W, H); end;

procedure WinDestroy;
var P: TProcWinDestroy;
begin P := TProcWinDestroy(SvcProc(SVC_WINDESTROY)); P; end;

function WinPoll: Integer;
var P: TFuncWinPoll;
begin P := TFuncWinPoll(SvcProc(SVC_WINPOLL)); WinPoll := P(); end;

function WinKey: Char;
var P: TFuncWinKey;
begin P := TFuncWinKey(SvcProc(SVC_WINKEY)); WinKey := P(); end;

end.
