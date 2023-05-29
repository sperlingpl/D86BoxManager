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

unit Forms.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Forms.About, Forms.AddVM, Vcl.StdCtrls, Vcl.ComCtrls,
  VM.Manager;

type
  TMainForm = class(TForm)
    LvMachines: TListView;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    VMManager: TVMManager;

    procedure UpdateList;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses
 VM.Machine;

{$R *.dfm}

procedure TMainForm.Button1Click(Sender: TObject);
var
  FrmAbout: TAboutForm;
begin
  FrmAbout := TAboutForm.Create(Self);
  try
    FrmAbout.ShowModal;
  finally
    FrmAbout.Free;
  end;
end;

procedure TMainForm.Button2Click(Sender: TObject);
var
  FrmAddVM: TAddVMForm;
begin
  FrmAddVM := TAddVMForm.Create(nil, VMManager);
  try
    FrmAddVM.ShowModal;
  finally
    FrmAddVM.Free;
  end;

  UpdateList;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  VMManager := TVMManager.Create;
  VMManager.Load;
  UpdateList;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  VMManager.Free;
end;

procedure TMainForm.UpdateList;
var
  Machine: TVirtualMachine;
  Item: TListItem;
begin
  LvMachines.Items.Clear;

  for Machine in VMManager.VirtualMachines do
  begin
    Item := LvMachines.Items.Add;
    Item.Caption := Machine.Name;
  end;
end;

end.
