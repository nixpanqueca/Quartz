unit SvcAPI;

{$mode objfpc}
{$H-}
{$N-}
{$E-}
{$asmmode intel}

// API de servicos para programas. Cada rotina chama o kernel atraves da
// tabela de servicos em SERVICE_TABLE_ADDR (preenchida no boot).

interface

procedure ClearScreen(Color: Byte);
procedure WriteAt(X, Y: Integer; Text: PChar; Size: Integer);
procedure WriteAtCol(X, Y: Integer; Text: PChar; Size: Integer; Color: Byte);
procedure FillRect(X, Y, W, H: Integer; Color: Byte);
procedure PutPixel(X, Y: Integer; Color: Byte);
procedure DrawLine(X0, Y0, X1, Y1: Integer; Color: Byte);
procedure DelayMS(Millis: LongInt);
procedure SerialWriteString(S: PChar);
procedure SerialWriteChar(C: Char);
procedure KeyboardPoll;
function AnyKeyPressed: Boolean;
function KeyIsPressed(Ch: Char): Boolean;
function FSReadFile(Name: PChar; Dest: PByte; MaxSize: LongWord): LongInt;
procedure DrawBMP(Name: PChar; X, Y: Integer);
function GetMouseX: Integer;
function GetMouseY: Integer;

implementation

{$include '../../svc.inc'}

function SvcProc(Index: Integer): Pointer;
begin
  SvcProc := Pointer(PLongWord(PByte(SERVICE_TABLE_ADDR) + Index * 4)^);
end;

type
  TProcClear  = procedure(Color: Byte);
  TProcWrite  = procedure(X, Y: Integer; Text: PChar; Size: Integer);
  TProcWriteC = procedure(X, Y: Integer; Text: PChar; Size: Integer; Color: Byte);
  TProcFill   = procedure(X, Y, W, H: Integer; Color: Byte);
  TProcPix    = procedure(X, Y: Integer; Color: Byte);
  TProcLine   = procedure(X0, Y0, X1, Y1: Integer; Color: Byte);
  TProcDelay  = procedure(Millis: LongInt);
  TProcSStr   = procedure(S: PChar);
  TProcSChar  = procedure(C: Char);
  TProcKPoll  = procedure;
  TFuncBool0  = function: Boolean;
  TFuncBool1  = function(Ch: Char): Boolean;
  TFuncFS     = function(Name: PChar; Dest: PByte; MaxSize: LongWord): LongInt;
  TProcBMP    = procedure(Name: PChar; X, Y: Integer);
  TFuncInt0   = function: Integer;

procedure ClearScreen(Color: Byte);
var P: TProcClear;
begin P := TProcClear(SvcProc(SVC_CLEARSCREEN)); P(Color); end;

procedure WriteAt(X, Y: Integer; Text: PChar; Size: Integer);
var P: TProcWrite;
begin P := TProcWrite(SvcProc(SVC_WRITEAT)); P(X, Y, Text, Size); end;

procedure WriteAtCol(X, Y: Integer; Text: PChar; Size: Integer; Color: Byte);
var P: TProcWriteC;
begin P := TProcWriteC(SvcProc(SVC_WRITEATCOL)); P(X, Y, Text, Size, Color); end;

procedure FillRect(X, Y, W, H: Integer; Color: Byte);
var P: TProcFill;
begin P := TProcFill(SvcProc(SVC_FILLRECT)); P(X, Y, W, H, Color); end;

procedure PutPixel(X, Y: Integer; Color: Byte);
var P: TProcPix;
begin P := TProcPix(SvcProc(SVC_PUTPIXEL)); P(X, Y, Color); end;

procedure DrawLine(X0, Y0, X1, Y1: Integer; Color: Byte);
var P: TProcLine;
begin P := TProcLine(SvcProc(SVC_DRAWLINE)); P(X0, Y0, X1, Y1, Color); end;

procedure DelayMS(Millis: LongInt);
var P: TProcDelay;
begin P := TProcDelay(SvcProc(SVC_DELAYMS)); P(Millis); end;

procedure SerialWriteString(S: PChar);
var P: TProcSStr;
begin P := TProcSStr(SvcProc(SVC_SERIALSTR)); P(S); end;

procedure SerialWriteChar(C: Char);
var P: TProcSChar;
begin P := TProcSChar(SvcProc(SVC_SERIALCHAR)); P(C); end;

procedure KeyboardPoll;
var P: TProcKPoll;
begin P := TProcKPoll(SvcProc(SVC_KEYPOLL)); P; end;

function AnyKeyPressed: Boolean;
var P: TFuncBool0;
begin P := TFuncBool0(SvcProc(SVC_ANYKEY)); AnyKeyPressed := P(); end;

function KeyIsPressed(Ch: Char): Boolean;
var P: TFuncBool1;
begin P := TFuncBool1(SvcProc(SVC_KEYPRESSED)); KeyIsPressed := P(Ch); end;

function FSReadFile(Name: PChar; Dest: PByte; MaxSize: LongWord): LongInt;
var P: TFuncFS;
begin P := TFuncFS(SvcProc(SVC_FSREAD)); FSReadFile := P(Name, Dest, MaxSize); end;

procedure DrawBMP(Name: PChar; X, Y: Integer);
var P: TProcBMP;
begin P := TProcBMP(SvcProc(SVC_DRAWBMP)); P(Name, X, Y); end;

function GetMouseX: Integer;
var P: TFuncInt0;
begin P := TFuncInt0(SvcProc(SVC_MOUSEX)); GetMouseX := P(); end;

function GetMouseY: Integer;
var P: TFuncInt0;
begin P := TFuncInt0(SvcProc(SVC_MOUSEY)); GetMouseY := P(); end;

end.
