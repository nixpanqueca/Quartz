unit Teste;

{$mode objfpc}
{$H-}
{$N-}
{$E-}
{$asmmode intel}

// Programa de exemplo: abre uma janela do Prism e desenha dentro dela.
// O desenho usa o SvcAPI normal (WriteAt, FillRect...) que o kernel desloca
// para dentro da janela automaticamente enquanto ela estiver aberta.

interface

procedure Main; cdecl; public;

implementation

uses SvcAPI, WinAPI;

procedure Main; cdecl;
var
  ev: Integer;
begin
  // Abre uma janela 320x220 (area client); o kernel desenha a barra de titulo.
  WinCreate('Teste de Janela', 320, 220);

  // Fundo da janela (client).
  FillRect(0, 0, 320, 220, 16 + 1 * 36 + 2 * 6 + 4);
  // Faixa de titulo interna decorativa.
  FillRect(0, 0, 320, 24, 16 + 2 * 36);
  WriteAt(10, 8, 'Pyramid Toolkit', 14);

  WriteAt(10, 40, 'Ola! Sua janela esta funcionando.', 12);
  WriteAt(10, 62, 'Este texto usa coordenadas locais da janela.', 12);
  WriteAt(10, 84, 'O kernel aplicou o offset automaticamente.', 12);

  // Um retangulo colorido (outra cor da paleta 216).
  FillRect(10, 110, 120, 60, 16 + 4 * 36 + 3 * 6 + 5);
  FillRect(18, 118, 24, 44, 16 + 0 * 36 + 5 * 6 + 4);
  FillRect(34, 118, 24, 44, 16 + 4 * 36 + 0 * 6 + 4);

  WriteAt(10, 188, 'Clique no X (canto) para fechar.', 12);

  // Loop de eventos: encerra quando o usuario clicar no botao fechar.
  repeat
    ev := WinPoll;
  until ev = WINEV_CLOSE;

  // Fecha a janela (restaura o fundo do desktop).
  WinDestroy;
end;

end.
