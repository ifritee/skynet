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
    // ��������� ������ ���� � ������
    procedure addLayerToModel(); virtual; abstract;

    // ��������� ��������� ���� ����� � ����
    procedure appendNode(nodeName: String);

  protected
   shortName: AnsiString;
   nodes: AnsiString;

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
