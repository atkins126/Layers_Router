unit Samples.View.Frames.Menu;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Buttons,
  Vcl.Imaging.pngimage,
  Vcl.ExtCtrls,

  Layers_Router,
  Layers_Router.Interfaces;

type
  TFrameMenu = class(TFrame, ILayers_RouterComponent)
    pnlMenu: TPanel;
    imgTools: TImage;
    imgSearch: TImage;
    imgReport: TImage;
    imgGeneral: TImage;
    btnGeneral: TSpeedButton;
    btnReport: TSpeedButton;
    btnSearch: TSpeedButton;
    btnTools: TSpeedButton;
    procedure FrameMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btnGeneralClick(Sender: TObject);
  private
    { Private declarations }
    function RendTheForm : TForm;
    function RendTheFrame : TFrame;
    procedure UnRender;
  public
    { Public declarations }
  end;

implementation

uses
  Samples.View.Main;

{$R *.dfm}

{ TFrameMenu }

procedure TFrameMenu.btnGeneralClick(Sender: TObject);
begin
  TLayers_Router.Link.&Throw('Template');
end;

procedure TFrameMenu.FrameMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if fMain.splMenu.Opened = False then
    fMain.TaskOn_Menu(0);
end;

function TFrameMenu.RendTheForm: TForm;
begin

end;

function TFrameMenu.RendTheFrame: TFrame;
begin
  Result := Self;
end;

procedure TFrameMenu.UnRender;
begin

end;

end.
