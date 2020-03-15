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
 uses keras;

constructor TLossFunction.Create;
begin
  inherited;
  shortName := 'LF' + IntToStr(getLayerNumber);
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
  returnCode := addLossFunction(id, PAnsiChar(shortName), PAnsiChar(nodes), m_lossType);
  if returnCode <> STATUS_OK then begin
    ErrorEvent('Neural model not added loss function', msError, VisualObject);
    Exit;
  end;
end;

//----- Редактирование свойств блока -----
procedure TLossFunction.EditFunc;
var
  InputPortsNmb, OutputPortsNmb: integer;
  MsgLength: Integer;
begin
//  SetCondPortCount(VisualObject, m_outputQty - 1, pmOutput, PortType, sdRight, 'outport_1');
end;

function TLossFunction.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
var
  I : Integer;
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
      if U[0].FCount > 0 then begin
        rootIndex := Round(U[0].Arr^[0]);
        if ((rootIndex >= 0) AND (rootIndex < LayersDict.Count)) then begin
          rootLayer := TAbstractLayer(LayersDict[rootIndex]);
          rootLayer.appendNode(String(shortName));
          Y[0].Arr^[0] := getLayerNumber;
          isCreate := True;
        end;
        if U[0].FCount = 3 then begin
          Y[0].Arr^[1] := U[0].Arr^[1];
          Y[0].Arr^[2] := U[0].Arr^[2];
        end;
      end;
//      end;
    end;
  end
end;
end.
