unit Layers_Router.Story;

{$I Layers_Router.inc}

interface

uses
  Classes,
  SysUtils,
  {$IFDEF HAS_FMX}
  FMX.Forms,
  FMX.Types,
  {$ELSE}
  Vcl.Forms,
  Vcl.ExtCtrls,
  {$ENDIF}
  System.Generics.Collections,
  Layers_Router.Interfaces,
  Layers_Router.Propersys;

type
  TCachePersistent = record
    FPatch : String;
    FisVisible : Boolean;
    FSBKey : String;
    FPersistentClass : TPersistentClass;
  end;

  TLayers_RouterStory = class
    private
      FListCache : TObjectDictionary<String, TObject>;
      {$IFDEF HAS_FMX}
      FListCacheContainer : TObjectDictionary<String, TFMXObject>;
      FMainRouter : TFMXObject;
      FIndexRouter : TFMXObject;
      {$ELSE}
      FListCacheContainer : TObjectDictionary<String, TPanel>;
      FMainRouter : TPanel;
      FIndexRouter : TPanel;
      {$ENDIF}
      FListCache2 : TDictionary<String, TCachePersistent>;
      FInstanteObject : ILayers_RouterComponent;
      FListCacheOrder : TList<String>;
      FIndexCache : Integer;
      procedure CreateInstancePersistent( APath : String);
      //procedure CacheKeyNotify(Sender: TObject; const Key: String; Action: TCollectionNotification);
    public
      constructor Create;
      destructor Destroy; override;

      {$IFDEF HAS_FMX}

      function MainRouter ( AValue : TFMXObject ) : TLayers_RouterStory; overload;
      function MainRouter : TFMXObject; overload;
      function IndexRouter ( AValue : TFMXObject ) : TLayers_RouterStory; overload;
      function IndexRouter : TFMXObject; overload;
      function AddStoryConteiner ( AKey : String; LObject : TFMXObject) : TLayers_RouterStory; overload;
      function GetStoryContainer ( AKey : String ) : TFMXObject;

      {$ELSE}

      function MainRouter ( AValue : TPanel ) : TLayers_RouterStory; overload;
      function MainRouter : TPanel; overload;
      function IndexRouter ( AValue : TPanel ) : TLayers_RouterStory; overload;
      function IndexRouter : TPanel; overload;
      function AddStoryConteiner ( AKey : String; AObject : TPanel) : TLayers_RouterStory; overload;
      function GetStoryContainer ( AKey : String ) : TPanel;

      {$ENDIF}

      function AddStory ( AKey : String; LObject : TObject ) : ILayers_RouterComponent; overload;
      function AddStory ( AKey : String; LObject : TPersistentClass ) : ILayers_RouterComponent; overload;
      function AddStory ( AKey : String; LObject : TPersistentClass; ASBKey : String; IsVisible : Boolean ) : ILayers_RouterComponent; overload;
      function RemoveStory ( AKey : String ) : TLayers_RouterStory;
      function GetStory ( AKey : String ) : ILayers_RouterComponent;
      function RoutersList : TDictionary<String, TObject>;
      function RoutersListPersistent : TDictionary<String, TCachePersistent>;
      function InstanteObject : ILayers_RouterComponent;
      function GoBack : String;
      function BreadCrumb(ADelimiter: Char = '/') : String;
      function IndexCache : Integer;
  end;

var
  Layers_RouterStory : TLayers_RouterStory;

implementation

{ TLayers_RouterStory }

{$IFDEF HAS_FMX}

function TLayers_RouterStory.MainRouter(AValue: TFMXObject): TLayers_RouterStory;
begin
  Result := Self;
  FMainRouter := AValue;
end;

function TLayers_RouterStory.MainRouter: TFMXObject;
begin
  Result := FMainRouter;
end;

function TLayers_RouterStory.IndexRouter(AValue: TFMXObject): TLayers_RouterStory;
begin
  Result := Self;
  FIndexRouter := AValue;
end;

function TLayers_RouterStory.IndexRouter: TFMXObject;
begin
  Result := FIndexRouter;
end;

function TLayers_RouterStory.AddStoryConteiner( AKey : String; LObject : TFMXObject) : TLayers_RouterStory;
var
  LObject : TFMXObject;
begin
  Result := Self;
  if not FListCacheContainer.TryGetValue(AKey, LObject) then
    FListCacheContainer.Add(AKey, LObject);
end;

function TLayers_RouterStory.GetStoryContainer(AKey: String): TFMXObject;
begin
  FListCacheContainer.TryGetValue(AKey, Result);
end;

{$ELSE}

function TLayers_RouterStory.MainRouter(AValue: TPanel): TLayers_RouterStory;
begin
  Result := Self;
  FMainRouter := AValue;
end;

function TLayers_RouterStory.MainRouter: TPanel;
begin
  Result := FMainRouter;
end;

function TLayers_RouterStory.IndexRouter(AValue: TPanel): TLayers_RouterStory;
begin
  Result := Self;
  FIndexRouter := AValue;
end;

function TLayers_RouterStory.IndexRouter: TPanel;
begin
  Result := FIndexRouter;
end;

function TLayers_RouterStory.AddStoryConteiner( AKey : String; AObject : TPanel) : TLayers_RouterStory;
var
  LObject : TPanel;
begin
  Result := Self;
  if not FListCacheContainer.TryGetValue(AKey, LObject) then
    FListCacheContainer.Add(AKey, AObject);
end;

function TLayers_RouterStory.GetStoryContainer(AKey: String): TPanel;
begin
  FListCacheContainer.TryGetValue(AKey, Result);
end;

{$ENDIF}

function TLayers_RouterStory.IndexCache: Integer;
begin
  Result := Self.FIndexCache;
end;

function TLayers_RouterStory.BreadCrumb(ADelimiter: Char): String;
var
  i : integer;
begin
  Result := '';

 if Self.FIndexCache = - 1 then
    Exit;

 Result := Self.FListCacheOrder[Self.FIndexCache];

 for i := Self.FIndexCache- 1 downto 0 do
 begin
    Result := Self.FListCacheOrder[i] + ADelimiter + Result;
 end;
end;

function TLayers_RouterStory.GoBack: String;
begin
  if Self.FIndexCache > 0 then
    Dec(Self.FIndexCache);

 Result := Self.FListCacheOrder[Self.FIndexCache];
end;

function TLayers_RouterStory.AddStory( AKey : String; LObject : TObject ) : ILayers_RouterComponent;
var
  vKey : String;
begin
  if not Supports(LObject, ILayers_RouterComponent, Result) then
    raise Exception.Create('Form not Implement ILayers_Router Interface!');

  try GlobalEventBus.RegisterSubscriber(LObject); except end;

  if FListCache.Count > 25 then
    for vKey in FListCache.Keys do
    begin
      FListCache.Remove(AKey);
      exit;
    end;

  FListCache.Add(AKey, LObject);

end;

function TLayers_RouterStory.AddStory(AKey: String;
  LObject: TPersistentClass): ILayers_RouterComponent;
var
  LCachePersistent : TCachePersistent;
begin
  LCachePersistent.FPatch := AKey;
  LCachePersistent.FisVisible := True;
  LCachePersistent.FPersistentClass := LObject;
  LCachePersistent.FSBKey := 'SBIndex';

  try FListCache2.Add(AKey, LCachePersistent); except end;
end;

function TLayers_RouterStory.AddStory(AKey: String; LObject: TPersistentClass;
  ASBKey : String; IsVisible: Boolean): ILayers_RouterComponent;
var
  LCachePersistent : TCachePersistent;
begin
  LCachePersistent.FPatch := AKey;
  LCachePersistent.FisVisible := IsVisible;
  LCachePersistent.FPersistentClass := LObject;
  LCachePersistent.FSBKey := ASBKey;

  try FListCache2.Add(AKey, LCachePersistent); except end;
end;

constructor TLayers_RouterStory.Create;
begin
  FListCache :=  TObjectDictionary<String, TObject>.Create;
  FListCache2 := TDictionary<String, TCachePersistent>.Create;
  {$IFDEF HAS_FMX}
  FListCacheContainer := TObjectDictionary<String, TFMXObject>.Create;
  {$ELSE}
  FListCacheContainer := TObjectDictionary<String, TPanel>.Create;
  {$ENDIF}
end;

procedure TLayers_RouterStory.CreateInstancePersistent( APath : String);
var
  LPersistentClass :  TCachePersistent;
begin
  if not FListCache2.TryGetValue(APath, LPersistentClass) then
    raise Exception.Create('Does not have any route Created! ' + APath);

  Self.AddStory(
    APath,
    TComponentClass(
      FindClass(
        LPersistentClass
          .FPersistentClass
          .ClassName
      )
    ).Create(Application)
  );
end;

destructor TLayers_RouterStory.Destroy;
begin
  FListCache.Free;
  FListCache2.Free;
  FListCacheContainer.Free;
  inherited;
end;

function TLayers_RouterStory.GetStory(AKey: String): ILayers_RouterComponent;
var
  LObject : TObject;
begin

  if not FListCache.TryGetValue(AKey, LObject) then
    Self.CreateInstancePersistent(AKey);

  if not Supports(FListCache.Items[AKey], ILayers_RouterComponent, Result) then
    raise Exception.Create('Object does not implement ILayers_RouterComponent Interface!');

  FInstanteObject := Result;
end;

function TLayers_RouterStory.InstanteObject: ILayers_RouterComponent;
begin
  Result := FInstanteObject;
end;

function TLayers_RouterStory.RemoveStory(AKey: String): TLayers_RouterStory;
begin
  Result := Self;
  FListCache.Remove(AKey);
end;

function TLayers_RouterStory.RoutersList: TDictionary<String, TObject>;
begin
  Result := FListCache;
end;

function TLayers_RouterStory.RoutersListPersistent: TDictionary<String, TCachePersistent>;
begin
  Result := FListCache2;
end;

initialization
  Layers_RouterStory := TLayers_RouterStory.Create;

finalization
  Layers_RouterStory.Free;
end.
