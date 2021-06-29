unit Layers_Router.Sidebars;

{$I Layers_Router.inc}

interface

{$IFDEF HAS_FMX}
uses
  Classes,
  SysUtils,
  FMX.Types,
  FMX.ListBox,
  FMX.SearchBox,
  FMX.Layouts,
  Layers_Router.Interfaces,
  System.UITypes;

type
  TLayers_RouterSidebar = class(TInterfacedObject, ILayers_RouterSidebars)
    private
      FName : String;
      FMainContainer : TFMXObject;
      FLinkContainer : TFMXObject;
      FAnimation : TProc<TFMXObject>;
      FFontSize : Integer;
      FFontColor : TAlphaColor;
      FItemHeigth : Integer;
    public
      constructor Create;
      destructor Destroy; override;
      class function New : ILayers_RouterSidebars;
      function Layer_Animation ( ALayer_Animation : TProc<TFMXObject> ) : ILayers_RouterSidebars;
      function MainContainer ( AValue : TFMXObject ) : ILayers_RouterSidebars; overload;
      function MainContainer  : TFMXObject; overload;
      function LinkContainer ( AValue : TFMXObject ) : ILayers_RouterSidebars;
      function RenderToListBox : ILayers_RouterSidebars;
      function Name ( AValue : String ) : ILayers_RouterSidebars; overload;
      function Name  : String; overload;
      function FontSize ( AValue : Integer ) : ILayers_RouterSidebars;
      function FontColor ( AValue : TAlphaColor ) : ILayers_RouterSidebars;
      function ItemHeigth ( AValue : Integer ) : ILayers_RouterSidebars;
  end;

implementation

uses
  Layers_Router,
  Layers_Router.History,
  Layers_Router.Utils;

{ TLayers_RouterSidebar }

function TLayers_RouterSidebar.Layer_Animation(
  ALayer_Animation: TProc<TFMXObject>): ILayers_RouterSidebars;
begin
  Result := Self;
  FAnimation := ALayer_Animation;
end;

function TLayers_RouterSidebar.LinkContainer(AValue: TFMXObject): ILayers_RouterSidebars;
begin
  Result := Self;
  FLinkContainer := AValue;
end;

function TLayers_RouterSidebar.MainContainer(AValue: TFMXObject): ILayers_RouterSidebars;
begin
  Result := Self;
  FMainContainer := AValue;
end;

function TLayers_RouterSidebar.MainContainer: TFMXObject;
begin
  Result := FMainContainer;
end;

function TLayers_RouterSidebar.RenderToListBox: ILayers_RouterSidebars;
var
  vListBox : TListBox;
  vListBoxItem : TListBoxItem;
  vListBoxSearch : TSearchBox;
  vItem : TCachePersistent;
begin
  vListBox := TListBox.Create(FMainContainer);
  vListBox.Align := TAlignLayout.Client;

  vListBox.StyleLookup := 'transparentlistboxstyle';

  vListBox.BeginUpdate;

  vListBoxSearch := TSearchBox.Create(vListBox);
  vListBoxSearch.Height := FItemHeigth - 25;
  vListBox.ItemHeight   := FItemHeigth;

  vListBox.AddObject(vListBoxSearch);

  for vItem in Layers_RouterStory.RoutersListPersistent.Values do
  begin
    if vItem.FisVisible and (vItem.FSBKey = FName) then
    begin
      vListBoxItem := TListBoxItem.Create(vListBox);
      vListBoxItem.Parent         := vListBox;
      vListBoxItem.StyledSettings := [TStyledSetting.Other];
      vListBoxItem.TextSettings.Font.Size := FFontSize;
      vListBoxItem.FontColor  := FFontColor;
      vListBoxItem.Text       := vItem.FPatch;
      vListBox.AddObject(vListBoxItem);
    end;
  end;
  vListBox.EndUpdate;


  Layers_RouterHistory.AddHistoryConteiner(FName, FLinkContainer);

  vListBox.OnClick :=

  TNotifyEventWrapper
    .AnonProc2NotifyEvent(
      vListBox,
      procedure(Sender: TObject; Aux : String)
      begin
        TLayers_Router
          .Link
            .Layer_Animation(
              procedure ( AObject : TFMXObject )
              begin
                TLayout(AObject).Opacity := 0;
                TLayout(AObject).AnimateFloat('Opacity', 1, 0.2);
              end)
            .&To(
              (Sender as TListBox).Items[(Sender as TListBox).ItemIndex],
              Aux
            )
      end,
      FName
    );

  FMainContainer.AddObject(vListBox);
end;

constructor TLayers_RouterSidebar.Create;
begin
  FName := 'SBIndex';
  FLinkContainer := Layers_RouterHistory.MainRouter;
end;

destructor TLayers_RouterSidebar.Destroy;
begin

  inherited;
end;

function TLayers_RouterSidebar.FontColor(AValue: TAlphaColor): ILayers_RouterSidebars;
begin
  Result := Self;
  FFontColor := AValue;
end;

function TLayers_RouterSidebar.FontSize(AValue: Integer): ILayers_RouterSidebars;
begin
  Result := Self;
  FFontSize := AValue;
end;

function TLayers_RouterSidebar.ItemHeigth(AValue: Integer): ILayers_RouterSidebars;
begin
  Result := Self;
  FItemHeigth := AValue;
end;

function TLayers_RouterSidebar.Name(AValue: String): ILayers_RouterSidebars;
begin
  Result := Self;
  FName := AValue;
end;

function TLayers_RouterSidebar.Name: String;
begin
  Result := FName;
end;

class function TLayers_RouterSidebar.New: ILayers_RouterSidebars;
begin
    Result := Self.Create;
end;


{$ELSE}
implementation
{$ENDIF}

end.
