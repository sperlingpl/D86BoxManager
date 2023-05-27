unit Forms.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Forms.About, Forms.AddVM, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TMainForm = class(TForm)
    ListView1: TListView;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

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
  FrmAddVM := TAddVMForm.Create(nil);
  try
    FrmAddVM.ShowModal;
  finally
    FrmAddVM.Free;
  end;
end;

end.
