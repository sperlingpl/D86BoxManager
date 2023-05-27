program D86BoxMan;

uses
  Vcl.Forms,
  Forms.Main in 'Forms.Main.pas' {MainForm},
  Forms.About in 'Forms.About.pas' {AboutForm},
  Forms.AddVM in 'Forms.AddVM.pas' {AddVMForm},
  VM.Manager in 'VM.Manager.pas',
  VM.Machine in 'VM.Machine.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAddVMForm, AddVMForm);

  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  Application.Run;
end.
