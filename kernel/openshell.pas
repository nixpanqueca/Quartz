unit OpenShell;

{$mode objfpc}
{$H-}
{$asmmode intel}

interface

procedure ShellInit;

implementation

uses
  Video, Keyboard, Serial;

procedure ShellInit;
var
  CX, CY: Integer;
begin
  ClearScreen($0F);
  WriteAt(1, 1, 'OpenShell', 16);
end;

end.
