unit UInputLayer;

interface

uses Windows, Classes, DataTypes, SysUtils, RunObjts, UAbstractLayer, Generics.Collections;

type

  TInputLayer = class(TAbstractLayer)
  public
    // Конструктор класса
    constructor  Create(Owner: TObject); override;
    // Деструктор
    destructor   Destroy; override;
    function       InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;override;
    function       RunFunc(var at,h : RealType;Action:Integer):NativeInt;override;
    function       GetParamID(const ParamName:string;var DataType:TDataType;var IsConst: boolean):NativeInt;override;
    // Добавляет данный слой в модель
    procedure addLayerToModel(); override;
    // Функция для обеспечения изменения визуальных параметров блока
    procedure EditFunc(Props:TList;
                       SetPortCount:TSetPortCount;
                       SetCondPortCount:TSetCondPortCount;
                       ExecutePropScript:TExecutePropScript);override;

  strict private
    stepCount: NativeInt; // Счетчик шагов
    m_outputQty: NativeInt;// Количество связей с другими слоями

  const
    PortType = 0; // Тип создаваемых портов (под математическую связь)

 end;

implementation

uses keras;

constructor  TInputLayer.Create;
begin
  inherited;
    shortName := 'Input';// + IntToStr(getLayerNumber);
end;

destructor   TInputLayer.Destroy;
begin
  inherited;
end;

function    TInputLayer.GetParamID;
begin
  Result:=inherited GetParamId(ParamName,DataType,IsConst);
  if Result = -1 then begin
    if StrEqu(ParamName,'output_qty') then begin
      Result:=NativeInt(@m_outputQty);
      DataType:=dtInteger;
      Exit;
    end;

  end
end;

//----- Редактирование свойств блока -----
procedure TInputLayer.EditFunc;
var
  InputPortsNmb, OutputPortsNmb: integer;
  MsgLength: Integer;
begin
//  SetCondPortCount(VisualObject, fAbonentsQty,  pmInput,  PortType, sdLeft,  'inport_1');
  SetCondPortCount(VisualObject, m_outputQty - 1, pmOutput, PortType, sdRight, 'outport_1');
end;

procedure TInputLayer.addLayerToModel();
var
  returnCode: TStatus;
begin
  returnCode:= createModel();
  // Проверим состояние создания модели
  if returnCode = STATUS_FAILURE then begin
    ErrorEvent('Neural model not created', msError, VisualObject);
    Exit;
  end;
  returnCode := addInput( PAnsiChar(shortName), PAnsiChar(nodes));
  if returnCode <> STATUS_OK then begin
    ErrorEvent('Neural model not added input layer', msError, VisualObject);
    Exit;
  end;
end;

function TInputLayer.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
  var
  i: integer;
begin
  Result:=0;
  case Action of
    i_GetCount: begin
      cY[0] := 1;
      stepCount := 0;
    end;
    i_GetInit: begin

    end;
    i_ReconnectPorts: begin

    end;
    i_HaveSpetialEditor: begin

    end;
  else
    Result:=inherited InfoFunc(Action,aParameter);
  end
end;

function   TInputLayer.RunFunc;
begin
  Result:=0;
  case Action of
    f_UpdateOuts: begin

    end;
    f_InitState: begin
      stepCount:= 0;
      nodes := '';
    end;
    f_GoodStep: begin
      if stepCount = 0 then begin
        Y[0].Arr^[0] := getLayerNumber;
        inc(stepCount);
      end;
    end;
  end
end;

end.
