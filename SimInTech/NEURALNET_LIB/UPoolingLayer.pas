unit UPoolingLayer;

interface
uses Windows, Classes, DataTypes, SysUtils, RunObjts, UAbstractLayer;

type

  TPoolingLayer = class(TAbstractLayer)
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
    m_outputQty: NativeInt;// Количество связей с другими слоями
    m_kernel : NativeInt; // Размер квадратной маски
    m_stride: NativeInt; // Шаг маски
    m_poolType: NativeInt; // Тип объединения

  const
    PortType = 0; // Тип создаваемых портов (под математическую связь)
  end;

implementation
uses keras;

constructor  TPoolingLayer.Create;
begin
  inherited;
  shortName := 'P' + IntToStr(getLayerNumber);
  isCreate := False;
end;

destructor   TPoolingLayer.Destroy;
begin
  inherited;

end;

function    TPoolingLayer.GetParamID;
begin
  Result:=inherited GetParamId(ParamName,DataType,IsConst);
  if Result = -1 then begin
    if StrEqu(ParamName,'output_qty') then begin
      Result:=NativeInt(@m_outputQty);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'kernel') then begin
      Result:=NativeInt(@m_kernel);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'stride') then begin
      Result:=NativeInt(@m_stride);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'pool_type') then begin
      Result:=NativeInt(@m_poolType);
      DataType:=dtInteger;
      Exit;
    end;
  end;
end;

procedure TPoolingLayer.addLayerToModel(id : Integer);
var
  returnCode: TStatus;
begin
  if id = m_modelID then begin
    returnCode := addPooling(id, PAnsiChar(shortName),
                             PAnsiChar(nodes),
                             m_kernel,
                             m_stride,
                             m_poolType
                             );
    if returnCode <> STATUS_OK then begin
      ErrorEvent('Neural model not added activation layer', msError, VisualObject);
      Exit;
    end;
  end;
end;

//----- Редактирование свойств блока -----
procedure TPoolingLayer.EditFunc;
var
  InputPortsNmb, OutputPortsNmb: integer;
  MsgLength: Integer;
begin
  SetCondPortCount(VisualObject, m_outputQty - 1, pmOutput, PortType, sdRight, 'outport_1');
end;

function TPoolingLayer.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
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

function   TPoolingLayer.RunFunc;
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
//      if isCreate = False then begin
      if U[0].FCount > 1 then begin
        m_modelID := Round(U[0].Arr^[0]);
        rootIndex := Round(U[0].Arr^[1]);
        if ((rootIndex >= 0) AND (rootIndex < LayersDict.Count)) then begin
          rootLayer := TAbstractLayer(LayersDict[rootIndex]);
          rootLayer.appendNode(shortName);
          for J := 0 to cY.Count - 1 do begin
            Y[J].Arr^[0] := m_modelID;
            Y[J].Arr^[1] := getLayerNumber;
          end;
          isCreate := True;
        end;
        if U[0].FCount = 4 then begin
          Y[0].Arr^[2] := U[0].Arr^[2];
          Y[0].Arr^[3] := U[0].Arr^[3];
        end;
      end;
//      end;
    end;
  end
end;
end.
