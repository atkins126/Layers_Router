unit Samples.Controller.Funcoes.Routers;

interface

type
  TRouters = class
    private
    public
      constructor Create;
      destructor Destroy; override;
  end;

var
  Router : TRouters;

implementation

{ TRouters }

uses
  Layers_Router,
  //Samples.View.Pages.Welcome,
  Samples.View.Pages.Template,
  Samples.View.Frames.Menu;

constructor TRouters.Create;
begin
  TLayers_Router
    .Switch
      //.Router('Principal', TPageWelcome)
      .Router('Menu', TFrameMenu)
      .Router('Template', TfViewPageTemplate);
end;

destructor TRouters.Destroy;
begin

  inherited;
end;

initialization
  Router := TRouters.Create;

finalization
  Router.Free;

end.