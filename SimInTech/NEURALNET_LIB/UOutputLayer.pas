unit UOutputLayer;

interface

uses Windows, Classes, DataTypes, SysUtils, RunObjts, UAbstractLayer;

type

  TOutputLayer = class(TAbstractLayer)
  public
    // ����������� ������
    constructor  Create(Owner: TObject); override;
    // ����������
    destructor   Destroy; override;
    function       InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;override;
    function       RunFunc(var at,h : RealType;Action:Integer):NativeInt;override;
    function       GetParamID(const ParamName:string;var DataType:TDataType;var IsConst: boolean):NativeInt;override;
    // ��������� ������ ���� � ������
    procedure addLayerToModel(); override;

  private
    isCreate: Boolean;
  end;

implementation

uses keras, UNNConstants;

constructor TOutputLayer.Create;
begin
  inherited;
  shortName := 'Output';
  isCreate := False;
end;

destructor TOutputLayer.Destroy;
begin
  inherited;

end;

function TOutputLayer.GetParamID;
begin
  Result:=inherited GetParamId(ParamName,DataType,IsConst);
  if Result = -1 then begin


  end
end;

procedure TOutputLayer.addLayerToModel();
begin

end;

function TOutputLayer.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
  var i: integer;
begin
  Result:=0;
  case Action of
    i_GetCount: begin

    end;
  else
    Result:=inherited InfoFunc(Action,aParameter);
  end
end;

function   TOutputLayer.RunFunc;
var
  rootLayer, layer: TAbstractLayer; // ������������ ����
  rootIndex: NativeInt;      // ������ ������������� ����
  i: integer;
  netJSON: array[0..1024] of AnsiChar;
  returnCode: TStatus;
begin
  Result:=0;
  case Action of
    f_UpdateOuts: begin

    end;
    f_InitState: begin
      shortName := '';
      isCreate := False;
    end;
    f_GoodStep: begin
      if isCreate = False then begin
        if U[0].FCount > 0 then begin
          rootIndex := Round(U[0].Arr^[0]);
          if ((rootIndex >= 0) AND (rootIndex < LayersDict.Count)) then begin
            rootLayer := TAbstractLayer(LayersDict[rootIndex]);
            rootLayer.appendNode(shortName);
            isCreate := True;
            //----- �������� �� ���� ����� ��������� ���� -----
            for i := 0 to LayersDict.Count - 1 do begin
               layer := TAbstractLayer(LayersDict[i]);
               layer.addLayerToModel;
            end;
            returnCode := netArchitecture(netJSON, 1024);
            Y[0].Arr^[0] := UNN_NNMAGICWORD;
            if returnCode <> STATUS_OK then begin
              lastError(netJSON, 1024);
              ErrorEvent(String(netJSON), msError, VisualObject);
              Y[0].Arr^[1] := 0; // ������, ��� ���� ��������
              Exit;
            end else begin
              Y[0].Arr^[1] := 1; // ������, ��� �������� ���� �������
            end;
            ErrorEvent(String(netJSON), msInfo, VisualObject);
          end;
        end;
      end;
    end;
  end
end;

end.
