unit USummatorLayer;

interface
uses Windows, Classes, DataTypes, SysUtils, RunObjts, UAbstractLayer;

type

  TSummatorLayer = class(TAbstractLayer)
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
    m_sumType : Integer; // Тип суммирования
  const
    PortType = 18300; // Тип создаваемых портов (под нейронную связь)
  end;

implementation
uses keras, NN_Texts, UNNConstants, DataObjts;

constructor  TSummatorLayer.Create;
begin
  inherited;
  shortName := AnsiString('SUM' + IntToStr(getLayerNumber));
  isCreate := False;
end;

destructor   TSummatorLayer.Destroy;
begin
  inherited;

end;

function    TSummatorLayer.GetParamID;
begin
  Result:=inherited GetParamId(ParamName,DataType,IsConst);
  if Result = -1 then begin
    if StrEqu(ParamName,'output_qty') then begin
      Result:=NativeInt(@m_outputQty);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'sum_type') then begin
      Result:=NativeInt(@m_sumType);
      DataType:=dtInteger;
      Exit;
    end;
  end;
end;

function TSummatorLayer.addLayerToModel(id : Integer) : Boolean;
var
  returnCode: TStatus;
begin
  Result := True;
  if (id = m_modelID) AND (LayersFromJSON = False) then begin
    returnCode := addSummator(id, PAnsiChar(shortName),
                              PAnsiChar(nodes),
                              m_sumType);
    if returnCode <> STATUS_OK then begin
      ErrorEvent(txtNN_ModelNotAdded + String(shortName), msError, VisualObject);
      Result := False;
      Exit;
    end;
  end;
end;

//----- Редактирование свойств блока -----
procedure TSummatorLayer.EditFunc;
var
  Data : TData;
  pOutputQty : PInteger;
begin
  Data := TEvalData(FindVar(Props, 'output_qty'));
  if m_outputQty > UNN_MAX_LAYER_OUT then begin
    m_outputQty := UNN_MAX_LAYER_OUT;
    pOutputQty := Data.Data;
    pOutputQty^ := m_outputQty;
  end;
  SetCondPortCount(VisualObject, m_outputQty, pmOutput, PortType, sdRight, 'out');
end;

function TSummatorLayer.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
var
  I : Integer;
begin
  Result:=0;
  case Action of
    i_GetCount: begin
      for I := 0 to m_outputQty - 1 do
        cY[I] := 2;
      cY[0] := 4;
    end;
  else
    Result:=inherited InfoFunc(Action, aParameter);
  end
end;

function   TSummatorLayer.RunFunc;
var
  rootLayer: TAbstractLayer; // Родительский слой
  rootIndex: NativeInt;      // Индекс родительского слоя
  J : Integer;
begin
  Result:=0;
  case Action of
    f_UpdateOuts: begin

    end;
    f_InitState: begin
      nodes := '';
      isCreate := False;
    end;
    f_GoodStep: begin
      if U[0].FCount > 1 then begin
        m_modelID := Round(U[0].Arr^[0]);
        rootIndex := Round(U[0].Arr^[1]);
        if ((rootIndex >= 0) AND (rootIndex < LayersDict.Count)) then begin
          if isCreate = False then begin
            rootLayer := TAbstractLayer(LayersDict[rootIndex]);
            rootLayer.appendNode(shortName);
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
        end;
      end;
    end;
  end
end;
end.
