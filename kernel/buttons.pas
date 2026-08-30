unit Buttons;

{$mode objfpc}
{$H-}
{$rtti off}
{$asmmode intel}

interface

uses Video, Mouse;

const
  MaxButtons = 64;

// Torna uma area (X, Y, W, H) clicavel. OnClick = endereco da funcao
// (passe @MinhaProc ou nil). Retorna o indice do botao (-1 se cheio).
function AddButton(X, Y, W, H: Integer; OnClick: Pointer): Integer;

// Como AddButton, mas tambem recebe um OnDblClick (chamado quando o mesmo
// botao e clicado duas vezes rapidamente). Passe @Proc ou nil.
function AddButtonEx(X, Y, W, H: Integer; OnClick, OnDblClick: Pointer): Integer;

// Indice do ultimo botao atingido pelo clique (ou -1 se clicou fora de
// qualque botao). Usado dentro dos OnClick/OnDblClick para saber qual
// elemento foi acionado.
function GetLastHit: Integer;

// Retorna (e limpa) se o ultimo clique foi fora de qualquer botao.
function GetOutsideClick: Boolean;

// Remove um botao pelo indice retornado pelo AddButton/CreateButton.
procedure RemoveButton(Index: Integer);

// Remove todos os botoes registrados.
procedure ClearButtons;

function GetButtonCount: Integer;

// Desenha um botao padrao (fundo branco, bordas pretas, texto centralizado).
procedure DrawButton(X, Y, W, H: Integer; Text: PChar);

// Desenha o botao padrao E o registra como clicavel. Retorna o indice.
function CreateButton(X, Y, W, H: Integer; Text: PChar; OnClick: Pointer): Integer;

// Chame no loop principal: verifica clique do mouse e chama o OnClick dos botoes.
procedure CheckButtons;

// Compara dois PChar byte a byte (sem RTL). Use em vez de `S = 'texto'`.
function StrEqual(A, B: PChar): Boolean;

implementation

type
  TButtonProc = procedure;
  TButtonDblProc = procedure;

  TButton = record
    X, Y, W, H: Integer;
    OnClick: Pointer;
    OnDblClick: Pointer;
  end;

var
  ButtonList: array[0..MaxButtons - 1] of TButton;
  ButtonCount: Integer;
  PrevButtons: Byte;
  LastHit: Integer;
  PrevHit: Integer;
  PrevHitSec: Integer;
  OutsideHit: Boolean;

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

// Segundos monotonicos do RTC (horas*3600 + min*60 + seg). Usado para
// medir o intervalo entre cliques (double-click) sem precisar de IRQ.
function RTCMonotonic: Integer;
var
  H, M, S: Byte;
  HH, MM, SS: Integer;
begin
  OutB($70, $04);
  H := InB($71);
  OutB($70, $02);
  M := InB($71);
  OutB($70, $00);
  S := InB($71);
  HH := (H shr 4) * 10 + (H and $0F);
  MM := (M shr 4) * 10 + (M and $0F);
  SS := (S shr 4) * 10 + (S and $0F);
  Result := HH * 3600 + MM * 60 + SS;
end;

function StrLen(S: PChar): Integer;
begin
  Result := 0;
  if S = nil then
    Exit;
  while S[Result] <> #0 do
    Result := Result + 1;
end;

function StrEqual(A, B: PChar): Boolean;
var
  i: Integer;
begin
  if A = nil then
    Exit(false);
  if B = nil then
    Exit(false);
  i := 0;
  while True do
  begin
    if A[i] <> B[i] then
      Exit(false);
    if A[i] = #0 then
      Break;
    Inc(i);
  end;
  Result := True;
end;

function AddButtonEx(X, Y, W, H: Integer; OnClick, OnDblClick: Pointer): Integer;
begin
  if ButtonCount >= MaxButtons then
    Exit(-1);
  ButtonList[ButtonCount].X := X;
  ButtonList[ButtonCount].Y := Y;
  ButtonList[ButtonCount].W := W;
  ButtonList[ButtonCount].H := H;
  ButtonList[ButtonCount].OnClick := OnClick;
  ButtonList[ButtonCount].OnDblClick := OnDblClick;
  Result := ButtonCount;
  Inc(ButtonCount);
end;

function AddButton(X, Y, W, H: Integer; OnClick: Pointer): Integer;
begin
  Result := AddButtonEx(X, Y, W, H, OnClick, nil);
end;

function GetLastHit: Integer;
begin
  Result := LastHit;
end;

function GetOutsideClick: Boolean;
begin
  Result := OutsideHit;
  OutsideHit := False;
end;

procedure RemoveButton(Index: Integer);
var
  i: Integer;
begin
  if (Index < 0) or (Index >= ButtonCount) then
    Exit;
  for i := Index to ButtonCount - 2 do
    ButtonList[i] := ButtonList[i + 1];
  Dec(ButtonCount);
end;

procedure ClearButtons;
begin
  ButtonCount := 0;
end;

function GetButtonCount: Integer;
begin
  Result := ButtonCount;
end;

procedure DrawButton(X, Y, W, H: Integer; Text: PChar);
const
  Size = 12;
var
  TX, TY: Integer;
begin
  FillRect(X, Y, W, H, $0F);
  FillRect(X, Y, W, 1, 0);          // borda superior
  FillRect(X, Y + H - 1, W, 1, 0);  // borda inferior
  FillRect(X, Y, 1, H, 0);          // borda esquerda
  FillRect(X + W - 1, Y, 1, H, 0);  // borda direita
  TX := X + (W - StrLen(Text) * Size) div 2;
  TY := Y + (H - Size) div 2;
  WriteAt(TX, TY, Text, Size);
end;

function CreateButton(X, Y, W, H: Integer; Text: PChar; OnClick: Pointer): Integer;
begin
  DrawButton(X, Y, W, H, Text);
  Result := AddButton(X, Y, W, H, OnClick);
end;

procedure CheckButtons;
var
  B, i, MX, MY, NowSec: Integer;
  P: TButtonProc;
  D: TButtonDblProc;
begin
  B := GetMouseButtons;
  if (B and 1) <> 0 then
    if (PrevButtons and 1) = 0 then
    begin
      MX := GetMouseX;
      MY := GetMouseY;
      LastHit := -1;
      for i := 0 to ButtonCount - 1 do
        if (MX >= ButtonList[i].X) and (MX < ButtonList[i].X + ButtonList[i].W) and
           (MY >= ButtonList[i].Y) and (MY < ButtonList[i].Y + ButtonList[i].H) then
        begin
          LastHit := i;
          Break;
        end;

      if LastHit >= 0 then
      begin
        NowSec := RTCMonotonic;
        if (LastHit = PrevHit) and (PrevHitSec >= 0) and
           (NowSec - PrevHitSec <= 1) then
        begin
          // Double-click no mesmo botao: chama OnDblClick (ignora OnClick).
          PrevHit := -1;
          PrevHitSec := -1;
          if ButtonList[LastHit].OnDblClick <> nil then
          begin
            D := TButtonDblProc(ButtonList[LastHit].OnDblClick);
            D;
          end;
        end
        else
        begin
          // Clique simples: seleciona/aciona e registra o instante.
          PrevHit := LastHit;
          PrevHitSec := NowSec;
          if ButtonList[LastHit].OnClick <> nil then
          begin
            P := TButtonProc(ButtonList[LastHit].OnClick);
            P;
          end;
        end;
      end
      else
      begin
        // Clique fora de qualquer botao: cancela selecao pendente de double.
        PrevHit := -1;
        PrevHitSec := -1;
        OutsideHit := True;
      end;
    end;
  PrevButtons := B;
end;

end.
