unit VM.Manager;

interface

uses
  Generics.Collections, VM.Machine;

type
  TVMManager = class
  public
    VirtualMachines: TList<TVirtualMachine>;
  end;

implementation

end.
