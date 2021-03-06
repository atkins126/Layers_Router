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
  Samples.View.Pages.Standards_Principal,
  Samples.View.Pages.Template,
  Samples.View.Pages.Usuarios,
  Samples.View.Pages.Cidades,
  Samples.View.Frames.Menu;

constructor TRouters.Create;
begin
  TLayers_Router
    .Switch
      .Router('Principal', TfPageStandards)
      .Router('Menu', TFrameMenu)
      .Router('Template', TfPageTemplate)
      .Router('Usuario', TfPageUsuario)
      .Router('Cidade', TfPageCidades);
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
