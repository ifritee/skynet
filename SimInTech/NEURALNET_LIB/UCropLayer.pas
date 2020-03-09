unit UCropLayer;

interface
uses Windows, Classes, DataTypes, SysUtils, RunObjts, UAbstractLayer;

type

  TCropLayer = class(TAbstractLayer)
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

  private
    isCreate: Boolean;
    m_outputQty: NativeInt;// Количество связей с другими слоями
    m_x : Integer;
    m_y : Integer;
    m_w : Integer;
    m_h : Integer;

  const
    PortType = 0; // Тип создаваемых портов (под математическую связь)
  end;

implementation
uses keras;

constructor  TCropLayer.Create;
begin
  inherited;
  shortName := 'CRP' + IntToStr(getLayerNumber);
  isCreate := False;
end;

destructor   TCropLayer.Destroy;
begin
  inherited;

end;

function    TCropLayer.GetParamID;
begin
  Result:=inherited GetParamId(ParamName,DataType,IsConst);
  if Result = -1 then begin
    if StrEqu(ParamName,'output_qty') then begin
      Result:=NativeInt(@m_outputQty);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'x_val') then begin
      Result:=NativeInt(@m_x);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'y_val') then begin
      Result:=NativeInt(@m_y);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'w_val') then begin
      Result:=NativeInt(@m_w);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'h_val') then begin
      Result:=NativeInt(@m_h);
      DataType:=dtInteger;
      Exit;
    end;
  end;
end;

procedure TCropLayer.addLayerToModel();
var
  returnCode: TStatus;
begin
  returnCode := addCrop(PAnsiChar(shortName),
                        PAnsiChar(nodes),
                        m_x,
                        m_y,
                        m_w,
                        m_h);
  if returnCode <> STATUS_OK then begin
    ErrorEvent('Neural model not added crop layer', msError, VisualObject);
    Exit;
  end;
end;

//----- Редактирование свойств блока -----
procedure TCropLayer.EditFunc;
var
  InputPortsNmb, OutputPortsNmb: integer;
  MsgLength: Integer;
begin
  SetCondPortCount(VisualObject, m_outputQty - 1, pmOutput, PortType, sdRight, 'outport_1');
end;

function TCropLayer.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
begin
  Result:=0;
  case Action of
    i_GetCount: begin

    end;
  else
    Result:=inherited InfoFunc(Action, aParameter);
  end
end;

function   TCropLayer.RunFunc;
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
      if isCreate = False then begin
        if U[0].FCount > 0 then begin
          rootIndex := Round(U[0].Arr^[0]);
          if ((rootIndex >= 0) AND (rootIndex < LayersDict.Count)) then begin
            rootLayer := TAbstractLayer(LayersDict[rootIndex]);
            rootLayer.appendNode(shortName);
            for J := 0 to cY.Count - 1 do
              Y[J].Arr^[0] := getLayerNumber;
            isCreate := True;
          end;
        end;
      end;
    end;
  end
end;
end.
