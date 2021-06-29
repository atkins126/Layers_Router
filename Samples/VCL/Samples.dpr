program Samples;

uses
  Vcl.Forms,
  Samples.View.Pages.Template in 'src\View\Pages\Samples.View.Pages.Template.pas' {fViewPageTemplate},
  Samples.View.Main in 'src\View\Samples.View.Main.pas' {fMain},
  Samples.Controller.Funcoes.Routers in 'src\Controller\Function\Samples.Controller.Funcoes.Routers.pas',
  Samples.View.Frames.Menu in 'src\View\Frames\Samples.View.Frames.Menu.pas' {FrameMenu: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
