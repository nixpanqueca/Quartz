unit About;

{$mode objfpc}
{$H-}
{$N-}
{$E-}
{$asmmode intel}

// Programa de sistema: exibe informacoes do Aether System Software.

interface

procedure Main; cdecl; public;

implementation

uses SvcAPI;

procedure Main; cdecl;
begin
  ClearScreen($0F);
  WriteAt(30, 30, 'Aether System Software', 24);
  WriteAt(30, 70, 'Kernel: Quartz - OpenShell', 16);
  WriteAt(30, 100, 'Seu programa foi carregado e executado.', 12);
  WriteAt(30, 120, 'Este e um programa de SISTEMA.', 12);
  DelayMS(3000);
end;

end.
