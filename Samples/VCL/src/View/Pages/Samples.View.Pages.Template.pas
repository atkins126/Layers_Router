unit Samples.View.Pages.Template;

interface

uses
  Data.DB,
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.Grids,
  Vcl.DBGrids,
  Vcl.Buttons,
  System.ImageList,
  Vcl.ImgList,

  // Framework Layers_Router
  Layers_Router,
  Layers_Router.Interfaces,
  Layers_Router.Propersys;

type
  TfViewPageTemplate = class(TForm, ILayers_RouterComponent)
    imgList32: TImageList;
    pnlPrincipal: TPanel;
    pnlLayout_Style: TPanel;
    lbLayout_Title: TLabel;
    pnlLayout_StyleBtn: TPanel;
    btnMinimized: TSpeedButton;
    btnMaximized: TSpeedButton;
    btnClose: TSpeedButton;
    pnlMain: TPanel;
    pnlMain_Body: TPanel;
    pnlMain_BodyTop: TPanel;
    pnlMain_Body_TopLine: TPanel;
    pnlMain_TopBody_Menu: TPanel;
    btnAtualizar: TSpeedButton;
    btnNovo: TSpeedButton;
    pnlMain_TopBody_Search: TPanel;
    lbSearch: TLabel;
    pnlMain_TopBody_SearchLine: TPanel;
    edtSearch: TEdit;
    pnlMain_BodyData: TPanel;
    pnlMain_Body_DataForm: TPanel;
    pnMain_BottomBody_DataForm: TPanel;
    btnExcluir: TSpeedButton;
    btnSalvar: TSpeedButton;
    btnCancelar: TSpeedButton;
    pnMain_TopBody_DataForm: TPanel;
    pnlMain_Body_DataSearch: TPanel;
    DBGrid1: TDBGrid;
    pnlTop: TPanel;
    pnlTop_Body: TPanel;
    btnConfig: TSpeedButton;
    btnRelatorio: TSpeedButton;
    btnHistorico: TSpeedButton;
    pnlTop_BodyTitle: TPanel;
    lbTitle: TLabel;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    lbPagina: TLabel;
    btnNext: TSpeedButton;
    procedure btnBackClick(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  private
    function RendTheForm : TForm;
    function RendTheFrame : TFrame;
    procedure UnRender;
  public
    [Subscribe]
    procedure Propertys(AValue: TPropersys);
  end;

var
  fViewPageTemplate: TfViewPageTemplate;

implementation

uses
  Samples.View.Main;

{$R *.dfm}

{ TfViewPageTemplate }

procedure TfViewPageTemplate.btnBackClick(Sender: TObject);
begin
  TLayers_Router.Link.&Throw('Start');
end;
procedure TfViewPageTemplate.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if fMain.splMenu.Opened then
    fMain.TaskEnd_Menu(0);
end;

procedure TfViewPageTemplate.Propertys(AValue: TPropersys);
begin
  lbTitle.Caption := AValue.ProprsString;

  AValue.Free;
end;

function TfViewPageTemplate.RendTheForm: TForm;
begin
  Result := Self;
end;

function TfViewPageTemplate.RendTheFrame: TFrame;
begin
//
end;

procedure TfViewPageTemplate.UnRender;
begin

end;

end.

