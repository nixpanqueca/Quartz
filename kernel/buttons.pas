unit Buttons;

{$mode objfpc}
{$H-}
{$rtti off}

interface

uses Video, Mouse;

const
  MaxButtons = 64;

// Torna uma area (X, Y, W, H) clicavel. OnClick = endereco da funcao
// (passe @MinhaProc ou nil). Retorna o indice do botao (-1 se cheio).
function AddButton(X, Y, W, H: Integer; OnClick: Pointer): Integer;

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

  TButton = record
    X, Y, W, H: Integer;
    OnClick: Pointer;
  end;

var
  ButtonList: array[0..MaxButtons - 1] of TButton;
  ButtonCount: Integer;
  PrevButtons: Byte;

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

function AddButton(X, Y, W, H: Integer; OnClick: Pointer): Integer;
begin
  if ButtonCount >= MaxButtons then
    Exit(-1);
  ButtonList[ButtonCount].X := X;
  ButtonList[ButtonCount].Y := Y;
  ButtonList[ButtonCount].W := W;
  ButtonList[ButtonCount].H := H;
  ButtonList[ButtonCount].OnClick := OnClick;
  Result := ButtonCount;
  Inc(ButtonCount);
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
  B, i, MX, MY: Integer;
  P: TButtonProc;
begin
  B := GetMouseButtons;
  if (B and 1) <> 0 then
    if (PrevButtons and 1) = 0 then
    begin
      MX := GetMouseX;
      MY := GetMouseY;
      for i := 0 to ButtonCount - 1 do
        if (MX >= ButtonList[i].X) and (MX < ButtonList[i].X + ButtonList[i].W) and
           (MY >= ButtonList[i].Y) and (MY < ButtonList[i].Y + ButtonList[i].H) then
        begin
          if ButtonList[i].OnClick <> nil then
          begin
            P := TButtonProc(ButtonList[i].OnClick);
            P;
          end;
          Break;
        end;
    end;
  PrevButtons := B;
end;

end.
