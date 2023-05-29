program D86BoxMan;

uses
  Vcl.Forms,
  Forms.Main in 'Forms.Main.pas' {MainForm},
  Forms.About in 'Forms.About.pas' {AboutForm},
  Forms.AddVM in 'Forms.AddVM.pas' {AddVMForm},
  VM.Manager in 'VM.Manager.pas',
  VM.Machine in 'VM.Machine.pas',
  VM.Emulator in 'VM.Emulator.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  {$WARN SYMBOL_PLATFORM OFF}
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := (DebugHook <> 0);
  {$ENDIF}
  {$WARN SYMBOL_PLATFORM ON}

  Application.Run;
end.
