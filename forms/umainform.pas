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

unit uMainForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, Sysutils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  laz.VirtualTrees;

type

  { TMainForm }

  TMainForm = class(Tform)
    Button1: Tbutton;
    Button2: Tbutton;
    Button3: Tbutton;
    Groupbox1: Tgroupbox;
    Lazvirtualstringtree1: Tlazvirtualstringtree;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  Private

  Public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

uses
  uAddMachineForm, uConfigManager, uEmulatorsForm;

{ TMainForm }

procedure TMainForm.Button1Click(Sender: TObject);
begin
  TAddMachineForm.Execute(nil);
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  TEmulatorsForm.Execute(nil);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  ConfigManager.Load;
end;

end.

