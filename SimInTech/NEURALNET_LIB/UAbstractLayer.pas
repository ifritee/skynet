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
    // Деструктор
    destructor Destroy; override;
    function getLayerNumber(): NativeInt;
    function getShortName(): AnsiString;
    // Добавляет данный слой в модель
    procedure addLayerToModel(id : Integer); virtual; abstract;

    // Добавляет очередную ноду связи к слою
    procedure appendNode(nodeName: AnsiString);

  protected
   shortName: AnsiString;
   nodes: AnsiString;
   m_modelID : Integer;

  private
    layerNumber: NativeInt;

  end;
  PAbstractLayer = ^TAbstractLayer;

var
  LayersDict: TList<TObject>;// Список слоев
  LayerCount: NativeInt;     // Счетчик слоев
  LayersFromJSON: Boolean;   // Флаг загрузки сети из файла

implementation

constructor  TAbstractLayer.Create;
begin
  inherited;
  layerNumber:= LayerCount;
  inc(LayerCount);
  LayersDict.Add(Self);
  LayersFromJSON := False;
  nodes := '';
  m_modelID := -1;
end;

destructor  TAbstractLayer.Destroy;
begin
  inherited;
//  dec(LayerCount);
  LayersDict[layerNumber] := Nil;;
end;

function TAbstractLayer.getLayerNumber(): NativeInt;
begin
  Result:= layerNumber;
end;

function TAbstractLayer.getShortName : AnsiString;
begin
  Result:= shortName;
end;

procedure TAbstractLayer.appendNode(nodeName: AnsiString);
begin
  if Length(nodes) > 0 then begin
    nodes := nodes + ' ' + nodeName;
  end else begin
    nodes := nodeName;
  end;
end;

initialization
  LayerCount:= 0;
  LayersDict := TList<TObject>.Create;

end.
