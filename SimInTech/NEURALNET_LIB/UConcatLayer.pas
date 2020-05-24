unit UConcatLayer;

interface
uses Windows, Classes, DataTypes, SysUtils, RunObjts, UAbstractLayer;

type

  TConcatLayer = class(TAbstractLayer)
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
    // Функция для обеспечения изменения визуальных параметров блока
    procedure EditFunc(Props:TList;
                       SetPortCount:TSetPortCount;
                       SetCondPortCount:TSetCondPortCount;
                       ExecutePropScript:TExecutePropScript);override;

  private
    isCreate: Boolean;
    m_outputQty: Integer;// Количество связей с другими слоями
    m_inputQty:  Integer;// Количество объединяемых слоев
    m_ccNodes: AnsiString; // Объединяемые ноды
  const
    PortType = 18300; // Тип создаваемых портов (под нейронную связь)
  end;

implementation
  uses keras, NN_Texts, UNNConstants, DataObjts;

constructor  TConcatLayer.Create;
begin
  inherited;
  shortName := AnsiString('CC' + IntToStr(getLayerNumber));
  isCreate := False;
end;

destructor   TConcatLayer.Destroy;
begin
  inherited;

end;

function    TConcatLayer.GetParamID;
begin
  Result:=inherited GetParamId(ParamName,DataType,IsConst);
  if Result = -1 then begin
    if StrEqu(ParamName,'output_qty') then begin
      Result:=NativeInt(@m_outputQty);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'input_qty') then begin
      Result:=NativeInt(@m_inputQty);
      DataType:=dtInteger;
      Exit;
    end;
  end;
end;

function TConcatLayer.addLayerToModel(id : Integer) : Boolean;
var
  returnCode: TStatus;
begin
  Result := True;
  if (id = m_modelID)  AND (LayersFromJSON = False) then begin
    returnCode := addConcat(id, PAnsiChar(shortName),
                            PAnsiChar(nodes),
                            PAnsiChar(m_ccNodes));
    if returnCode <> STATUS_OK then begin
      ErrorEvent(txtNN_ModelNotAdded + String(shortName), msError, VisualObject);
      Result := False;
      Exit;
    end;
  end;
end;

//----- Редактирование свойств блока -----
procedure TConcatLayer.EditFunc;
var
  Data : TData;
  pOutputQty, pInputQty : PInteger;
begin
  Data := TEvalData(FindVar(Props, 'output_qty'));
  if m_outputQty > UNN_MAX_LAYER_OUT then begin
    m_outputQty := UNN_MAX_LAYER_OUT;
    pOutputQty := Data.Data;
    pOutputQty^ := m_outputQty;
  end;
  Data := TEvalData(FindVar(Props, 'input_qty'));
  if m_inputQty > UNN_MAX_LAYER_OUT then begin
    m_inputQty := UNN_MAX_LAYER_OUT;
    pInputQty := Data.Data;
    pInputQty^ := m_inputQty;
  end;
  SetCondPortCount(VisualObject, m_inputQty,  pmInput,  PortType, sdLeft,  'in');
  SetCondPortCount(VisualObject, m_outputQty, pmOutput, PortType, sdRight, 'out');
end;

function TConcatLayer.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
var
  I : Integer;
begin
  Result:=0;
  case Action of
    i_GetCount: begin
      for I := 0 to m_outputQty - 1 do
        cY[I] := 2;
      cY[0] := UNN_SIZE_WITHDATA;
    end;
  else
    Result:=inherited InfoFunc(Action, aParameter);
  end
end;

function   TConcatLayer.RunFunc;
var
  rootLayer: TAbstractLayer; // Родительский слой
  rootIndex: NativeInt;      // Индекс родительского слоя
  I, J : Integer;
begin
  Result:=0;
  case Action of
    f_UpdateOuts: begin

    end;
    f_InitState: begin
      nodes := '';
      m_ccNodes := '';
      isCreate := False;
    end;
    f_GoodStep: begin
      for I := 0 to cU.FCount - 1 do begin
        m_modelID := Round(U[I].Arr^[0]);
        rootIndex := Round(U[I].Arr^[1]);
        rootLayer := TAbstractLayer(LayersDict[rootIndex]);
        if ((rootIndex >= 0) AND (rootIndex < LayersDict.Count)) then begin
          if isCreate = False then begin
            rootLayer.appendNode(shortName);
          end;
          if Length(m_ccNodes) > 0 then begin
            m_ccNodes := m_ccNodes + AnsiString(' ') + rootLayer.getShortName;
          end else begin
            m_ccNodes := rootLayer.getShortName;
          end;
          for J := 0 to cY.Count - 1 do begin
            Y[J].Arr^[0] := m_modelID;
            Y[J].Arr^[1] := getLayerNumber;
          end;
          isCreate := True;
        end;
        if U[0].FCount = UNN_SIZE_WITHDATA then begin
          Y[0].Arr^[2] := U[0].Arr^[2];
          Y[0].Arr^[3] := U[0].Arr^[3];
          Y[0].Arr^[4] := U[0].Arr^[4];
          Y[0].Arr^[5] := U[0].Arr^[5];
          Y[0].Arr^[6] := U[0].Arr^[6];
        end;
      end;
    end;
  end
end;
end.
