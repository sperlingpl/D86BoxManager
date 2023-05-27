unit Forms.AddVM;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls;

type
  TAddVMForm = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    LabeledEdit1: TLabeledEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AddVMForm: TAddVMForm;

implementation

{$R *.dfm}

procedure TAddVMForm.Button1Click(Sender: TObject);
begin
  Close;
end;

end.
