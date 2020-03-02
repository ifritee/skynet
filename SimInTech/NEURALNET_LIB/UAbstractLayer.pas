unit UAbstractLayer;

interface
  uses
    Windows,
    Classes,
    DataTypes,
    SysUtils,
    RunObjts,
    Generics.Collections;

type

  TAbstractLayer = class(TRunObject)
  public
    constructor Create(Owner: TObject); override;
    function getLayerNumber(): NativeInt;
    function getShortName(): String;
    // Добавляет данный слой в модель
    procedure addLayerToModel(); virtual; abstract;

    // Добавляет очередную ноду связи к слою
    procedure appendNode(nodeName: String);

  protected
   shortName: String;
   nodes: String;

  private
    layerNumber: NativeInt;

  end;
  PAbstractLayer = ^TAbstractLayer;

var
  LayersDict: TList<TObject>;
  LayerCount: NativeInt;

implementation

constructor  TAbstractLayer.Create;
begin
  inherited;
  layerNumber:= LayerCount;
  inc(LayerCount);
  LayersDict.Add(Self);
  nodes := '';
end;

function TAbstractLayer.getLayerNumber(): NativeInt;
begin
  Result:= layerNumber;
end;

function TAbstractLayer.getShortName : String;
begin
  Result:= shortName;
end;

procedure TAbstractLayer.appendNode(nodeName: String);
begin
  nodes := nodes + ' ' + nodeName;
end;

initialization
  LayerCount:= 0;
  LayersDict := TList<TObject>.Create;

end.
