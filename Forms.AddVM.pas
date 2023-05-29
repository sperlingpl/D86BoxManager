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

unit Forms.AddVM;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls,
  Vcl.Buttons, VM.Manager;

type
  TAddVMForm = class(TForm)
    BtnCancel: TButton;
    BtnAdd: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    EdtName: TEdit;
    CbEmulator: TComboBox;
    Label2: TLabel;
    BtnNewEmulator: TButton;
    Label3: TLabel;
    EdtDescription: TEdit;
    procedure BtnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EdtNameChange(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
  private
    VMManager: TVMManager;

    procedure Validate;
  public
    constructor Create(AOwner: TComponent; AVMManager: TVMManager); reintroduce;
  end;

implementation

uses
  VM.Machine;

{$R *.dfm}

procedure TAddVMForm.BtnAddClick(Sender: TObject);
var
  Machine: TVirtualMachine;
begin
  Machine := TVirtualMachine.Create;
  Machine.Name := Trim(EdtName.Text);
  Machine.Description := Trim(EdtDescription.Text);

  try
    VMManager.Add(Machine);
    Close;
  except
    on E: Exception do
    begin
      MessageDlg(E.Message, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
      Machine.Free;
    end;
  end;
end;

procedure TAddVMForm.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

constructor TAddVMForm.Create(AOwner: TComponent; AVMManager: TVMManager);
begin
  inherited Create(AOwner);

  VMManager := AVMManager;
end;

procedure TAddVMForm.EdtNameChange(Sender: TObject);
begin
  Validate;
end;

procedure TAddVMForm.FormCreate(Sender: TObject);
begin
  Validate;
end;

procedure TAddVMForm.Validate;
begin
  BtnAdd.Enabled := (Trim(EdtName.Text) <> '');// and (CbEmulator.ItemIndex >= 0);
end;

end.
