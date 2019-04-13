program CIFAR100_100;

uses
  Forms, 
  uFRMMain in 'uFRMMain.pas' {FRMMain},
  uClass_CNN in '..\..\Common\uClass_CNN.pas',
  uClass_Imaging in '..\..\Common\uClass_Imaging.pas',
  uClasses_Types in '..\..\Common\uClasses_Types.pas',
  uFunctions in '..\..\Common\uFunctions.pas'
  ;

{$R *.res}

begin

  Application.Initialize;
  Application.CreateForm(TFRMMain, FRMMain);
  Application.Run;
end.
