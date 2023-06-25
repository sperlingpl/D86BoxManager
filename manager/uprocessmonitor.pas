{
    D86Box Manager - Simple 86Box emulator manager
    Copyright (C) 2023  Paweł Wróblewski

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
}

unit uProcessMonitor;

{$mode ObjFPC}{$H+}

interface

uses
  process, Classes;

{ TCheckRunningThread }

type
  TCheckRunningThread = class(TThread)
    Process: TProcess;
    OnProcessExit: procedure of object;

    procedure Execute; override;
  end;

implementation

{ TCheckRunningThread }

procedure TCheckRunningThread.Execute;
begin
  while Assigned(Process) and Process.Active do
  begin

    Sleep(100);
  end;

  if Assigned(Process) then
  begin
    Process.Free;
    Process := nil;

    if Assigned(OnProcessExit) then
      OnProcessExit;
  end;
end;

end.

