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
    function addLayerToModel(id : Integer) : Boolean; override;

  private
    isCreate: Boolean;
    m_lfName : AnsiString;
    m_units: Integer; // Количество нейронов
    m_activate: Integer; // Метод активации
    m_opimized: Integer; // Функция оптимизации
    m_dropout:  double;  // Отсев
    m_batchnorm: Integer; // Нормализация наборов
    m_lossType: Integer; // Тип функции потерь
  end;

implementation

uses keras, UNNConstants, NN_Texts, UInputLayer;

constructor TOutputLayer.Create;
begin
  inherited;
  shortName := 'OD' + IntToStr(getLayerNumber);
  m_lfName := 'OLF' + IntToStr(getLayerNumber);
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
    if StrEqu(ParamName,'units') then begin
      Result:=NativeInt(@m_units);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'active') then begin
      Result:=NativeInt(@m_activate);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'optim') then begin
      Result:=NativeInt(@m_opimized);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'dropout') then begin
      Result:=NativeInt(@m_dropout);
      DataType:=dtDouble;
      Exit;
    end else if StrEqu(ParamName,'batchnorm') then begin
      Result:=NativeInt(@m_batchnorm);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'loss_type') then begin
      Result:=NativeInt(@m_lossType);
      DataType:=dtInteger;
      Exit;
    end;
  end
end;

function TOutputLayer.addLayerToModel(id : Integer) : Boolean;
var
  returnCode : TStatus;
begin
  Result := True;
  if (id = m_modelID) AND (LayersFromJSON = False) then begin
    returnCode := addDense(id, PAnsiChar(shortName),
                           PAnsiChar(m_lfName),
                           m_units,
                           m_activate - 1,
                           m_opimized,
                           m_dropout,
                           m_batchnorm);
    if returnCode <> STATUS_OK then begin
      ErrorEvent(txtNN_ModelNotAdded + String(shortName), msError, VisualObject);
      Result := False;
      Exit;
    end;
    returnCode := addLossFunction(id, PAnsiChar(m_lfName), PAnsiChar('Output'), m_lossType);
    if returnCode <> STATUS_OK then begin
      ErrorEvent(txtNN_ModelNotAdded + String(m_lfName), msError, VisualObject);
      Result := False;
      Exit;
    end;
  end;
end;

function TOutputLayer.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
begin
  Result:=0;
  case Action of
    i_GetCount: begin
      cY[0] := UNN_SIZE_WITHDATA;
    end;
  else
    Result:=inherited InfoFunc(Action,aParameter);
  end
end;

function   TOutputLayer.RunFunc;
var
  rootLayer, layer: TAbstractLayer; // Родительский слой
  inputLayer : TInputLayer; // Входной слой
  rootIndex: NativeInt;      // Индекс родительского слоя
  i: integer;
  netJSON: array[0..2048] of AnsiChar;
  returnCode: TStatus;
  isInputWas: Boolean;
begin
  Result:=0;
  isInputWas := False;
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
                  if layer.addLayerToModel(m_modelID) = False then begin
                    Result := r_Fail;
                    Exit;
                  end;
                  inputLayer := TInputLayer(layer);
                  isInputWas := True;
                end;
              end;
            end;
            if isInputWas = False then begin // Защита от отсутствия inputLayer
              ErrorEvent(txtNN_NoInputLayer, msError, VisualObject);
              Result := r_Fail;
              Exit;
            end;
            
            for i := 0 to LayersDict.Count - 1 do begin // Затем все остальное
               layer := TAbstractLayer(LayersDict[i]);
               if layer <> Nil then begin
                 if (layer.getShortName <> AnsiString('Input')) then begin
                   if layer.addLayerToModel(m_modelID) = False then begin
                     Result := r_Fail;
                     Exit;
                   end;
                 end;
               end;
            end;
            inputLayer.NetLoadWeight;
            // Выведем архитектуру в статусное окно
            returnCode := netArchitecture(m_modelID, netJSON, Length(netJSON));
            if returnCode <> STATUS_OK then begin
              lastError(m_modelID, netJSON, Length(netJSON));
              ErrorEvent(String(netJSON), msError, VisualObject);
              Result := r_Fail;
              Exit;
            end;
//            ErrorEvent(String(netJSON), msInfo, VisualObject);
          end;
        end;
      end;
      Y[0].Arr^[0] := m_modelID; // Пошлем ID сети или -1
      if U[0].FCount = UNN_SIZE_WITHDATA then begin
        Y[0].Arr^[1] := U[0].Arr^[2];
        Y[0].Arr^[2] := U[0].Arr^[3];
        Y[0].Arr^[4] := U[0].Arr^[4];
        Y[0].Arr^[5] := U[0].Arr^[5];
        Y[0].Arr^[6] := U[0].Arr^[6];
      end;
      Y[0].Arr^[3] := m_units;
    end;
  end
end;

end.
