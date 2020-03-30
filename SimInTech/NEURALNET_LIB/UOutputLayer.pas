unit UOutputLayer;

interface

uses Windows, Classes, DataTypes, SysUtils, RunObjts, UAbstractLayer;

type

  TOutputLayer = class(TAbstractLayer)
  public
    // Конструктор класса
    constructor  Create(Owner: TObject); override;
    // Деструктор
    destructor   Destroy; override;
    function       InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;override;
    function       RunFunc(var at,h : RealType;Action:Integer):NativeInt;override;
    function       GetParamID(const ParamName:string;var DataType:TDataType;var IsConst: boolean):NativeInt;override;
    // Добавляет данный слой в модель
    procedure addLayerToModel(id : Integer); override;

  private
    isCreate: Boolean;
//    m_modelID: Integer;
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

procedure TOutputLayer.addLayerToModel(id : Integer);
begin

end;

function TOutputLayer.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
  var i: integer;
begin
  Result:=0;
  case Action of
    i_GetCount: begin
      cY[0] := 2;
    end;
  else
    Result:=inherited InfoFunc(Action,aParameter);
  end
end;

function   TOutputLayer.RunFunc;
var
  rootLayer, layer: TAbstractLayer; // Родительский слой
  rootIndex: NativeInt;      // Индекс родительского слоя
  i: integer;
  netJSON: array[0..2048] of AnsiChar;
  returnCode: TStatus;
begin
  Result:=0;
  case Action of
    f_UpdateOuts: begin

    end;
    f_InitState: begin
      isCreate := False;
      nodes := '';
    end;
    f_GoodStep: begin
      if isCreate = False then begin
        if U[0].FCount > 0 then begin
          m_modelID := Round(U[0].Arr^[0]);
          rootIndex := Round(U[0].Arr^[1]);
          if ((rootIndex >= 0) AND (rootIndex < LayersDict.Count)) then begin
            rootLayer := TAbstractLayer(LayersDict[rootIndex]);
            rootLayer.appendNode(shortName);
            isCreate := True;
            //----- Проходим по всем слоям нейронной сети -----
//            m_modelID:= createModel();
//            // Проверим состояние создания модели
//            if m_modelID = -1 then begin
//              ErrorEvent('Neural model not created', msError, VisualObject);
//              Exit;
//            end;
            for i := 0 to LayersDict.Count - 1 do begin
               layer := TAbstractLayer(LayersDict[i]);
               layer.addLayerToModel(m_modelID);
            end;
            returnCode := netArchitecture(m_modelID, netJSON, Length(netJSON));
//            Y[0].Arr^[0] := UNN_NNMAGICWORD;
            if returnCode <> STATUS_OK then begin
              lastError(m_modelID, netJSON, Length(netJSON));
              ErrorEvent(String(netJSON), msError, VisualObject);
//              Y[0].Arr^[0] := -1; // Укажем, что были проблемы
              Exit;
//            end else begin
//              Y[0].Arr^[1] := 1; // Укажем, что создание сети успешно
            end;
            ErrorEvent(String(netJSON), msInfo, VisualObject);
          end;
        end;
      end;
      Y[0].Arr^[0] := m_modelID; // Пошлем ID сети или -1
      if U[0].FCount = 4 then begin
        Y[0].Arr^[1] := U[0].Arr^[2];
        Y[0].Arr^[2] := U[0].Arr^[3];
      end;
    end;
  end
end;

end.
