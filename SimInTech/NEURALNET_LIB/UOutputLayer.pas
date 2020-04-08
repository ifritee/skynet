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

uses keras, UNNConstants, NN_Texts;

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
begin
  Result:=0;
  case Action of
    i_GetCount: begin
      cY[0] := 3;
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
            for i := 0 to LayersDict.Count - 1 do begin // Сначала Input (точка входа)
               layer := TAbstractLayer(LayersDict[i]);
               if layer <> Nil then begin
                 if (layer.getShortName = AnsiString('Input')) then begin
                   layer.addLayerToModel(m_modelID);
                 end;
               end;
            end;
            for i := 0 to LayersDict.Count - 1 do begin // Затем все остальное
               layer := TAbstractLayer(LayersDict[i]);
               if layer <> Nil then begin
                 if (layer.getShortName <> AnsiString('Input')) then begin
                   layer.addLayerToModel(m_modelID);
                 end;
               end;
            end;

            returnCode := netArchitecture(m_modelID, netJSON, Length(netJSON));
            if returnCode <> STATUS_OK then begin
              lastError(m_modelID, netJSON, Length(netJSON));
              ErrorEvent(String(netJSON), msError, VisualObject);
              Exit;
            end;
            ErrorEvent(String(netJSON), msInfo, VisualObject);
          end;
        end;
      end;
      Y[0].Arr^[0] := m_modelID; // Пошлем ID сети или -1
      if U[0].FCount = UNN_SIZE_WITHDATA then begin
        Y[0].Arr^[1] := U[0].Arr^[2];
        Y[0].Arr^[2] := U[0].Arr^[3];
      end;
    end;
  end
end;

end.
