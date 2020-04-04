unit ULossFunction;

interface

uses Windows, Classes, DataTypes, SysUtils, RunObjts, UAbstractLayer;

type

  TLossFunction = class(TAbstractLayer)
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
    // Функция для обеспечения изменения визуальных параметров блока
    procedure EditFunc(Props:TList;
                       SetPortCount:TSetPortCount;
                       SetCondPortCount:TSetCondPortCount;
                       ExecutePropScript:TExecutePropScript);override;

  private
    isCreate: Boolean;
    m_lossType: NativeInt; // Тип функции потерь

  const
    PortType = 0; // Тип создаваемых портов (под математическую связь)

  end;

implementation
 uses keras, NN_Texts, UNNConstants;

constructor TLossFunction.Create;
begin
  inherited;
  shortName := AnsiString('LF' + IntToStr(getLayerNumber));
  isCreate := False;
end;

destructor TLossFunction.Destroy;
begin
  inherited;

end;

function TLossFunction.GetParamID;
begin
  Result:=inherited GetParamId(ParamName,DataType,IsConst);
  if Result = -1 then begin
    if StrEqu(ParamName,'loss_type') then begin
      Result:=NativeInt(@m_lossType);
      DataType:=dtInteger;
      Exit;
    end;
  end;
end;

procedure TLossFunction.addLayerToModel(id : Integer);
var
  returnCode: TStatus;
begin
  if id = m_modelID then begin
    returnCode := addLossFunction(id, PAnsiChar(shortName), PAnsiChar(nodes), m_lossType);
    if returnCode <> STATUS_OK then begin
      ErrorEvent(txtNN_ModelNotAdded + String(shortName), msError, VisualObject);
      Exit;
    end;
  end;
end;

//----- Редактирование свойств блока -----
procedure TLossFunction.EditFunc;
begin
//  SetCondPortCount(VisualObject, m_outputQty - 1, pmOutput, PortType, sdRight, 'outport_1');
end;

function TLossFunction.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
begin
  Result:=0;
  case Action of
    i_GetCount: begin
      cY[0] := 4;
    end;
  else
    Result:=inherited InfoFunc(Action,aParameter);
  end
end;

function   TLossFunction.RunFunc;
var
  rootLayer: TAbstractLayer; // Родительский слой
  rootIndex: NativeInt;      // Индекс родительского слоя
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
//      if isCreate = False then begin
      if U[0].FCount > 1 then begin
        m_modelID := Round(U[0].Arr^[0]);
        rootIndex := Round(U[0].Arr^[1]);
        if ((rootIndex >= 0) AND (rootIndex < LayersDict.Count)) then begin
          rootLayer := TAbstractLayer(LayersDict[rootIndex]);
          rootLayer.appendNode(shortName);
          Y[0].Arr^[0] := m_modelID;
          Y[0].Arr^[1] := getLayerNumber;
          isCreate := True;
        end;
        if U[0].FCount = UNN_SIZE_WITHDATA then begin
          Y[0].Arr^[2] := U[0].Arr^[2];
          Y[0].Arr^[3] := U[0].Arr^[3];
        end;
      end;
//      end;
    end;
  end
end;
end.
