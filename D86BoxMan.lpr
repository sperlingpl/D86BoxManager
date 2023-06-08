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

program D86BoxMan;

{$mode ObjFPC}{$H+}

uses
  {$IFDEF UNIX}
  Cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  Athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, uMainForm, uAddMachineForm, uVMManager, uPathHelper, uEmulatorsForm,
  uConfigManager
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Scaled := True;
  Application.Initialize;
  Application.CreateForm(TMainForm, Mainform);
  Application.Run;
end.

