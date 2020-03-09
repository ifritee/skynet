unit UResizeLayer;

interface
uses Windows, Classes, DataTypes, SysUtils, RunObjts, UAbstractLayer;

type

  TResizeLayer = class(TAbstractLayer)
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
    m_fwdBegin : Cardinal;
    m_fwdEnd : Cardinal;
    m_bwdBegin : Cardinal;
    m_bwdEnd : Cardinal;

  const
    PortType = 0; // Тип создаваемых портов (под математическую связь)
  end;

implementation
uses keras;

constructor  TResizeLayer.Create;
begin
  inherited;
  shortName := 'RSZ' + IntToStr(getLayerNumber);
  isCreate := False;
end;

destructor   TResizeLayer.Destroy;
begin
  inherited;

end;

function    TResizeLayer.GetParamID;
begin
  Result:=inherited GetParamId(ParamName,DataType,IsConst);
  if Result = -1 then begin
    if StrEqu(ParamName,'output_qty') then begin
      Result:=NativeInt(@m_outputQty);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'fwd_begin') then begin
      Result:=NativeInt(@m_fwdBegin);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'fwd_end') then begin
      Result:=NativeInt(@m_fwdEnd);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'bwd_begin') then begin
      Result:=NativeInt(@m_bwdBegin);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'bwd_end') then begin
      Result:=NativeInt(@m_bwdEnd);
      DataType:=dtInteger;
      Exit;
    end;
  end;
end;

procedure TResizeLayer.addLayerToModel();
var
  returnCode: TStatus;
begin
  returnCode := addResize(PAnsiChar(shortName),
                          PAnsiChar(nodes),
                          m_fwdBegin,
                          m_fwdEnd,
                          m_bwdBegin,
                          m_bwdEnd
                          );
  if returnCode <> STATUS_OK then begin
    ErrorEvent('Neural model not added activation layer', msError, VisualObject);
    Exit;
  end;
end;

//----- Редактирование свойств блока -----
procedure TResizeLayer.EditFunc;
var
  InputPortsNmb, OutputPortsNmb: integer;
  MsgLength: Integer;
begin
  SetCondPortCount(VisualObject, m_outputQty - 1, pmOutput, PortType, sdRight, 'outport_1');
end;

function TResizeLayer.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
begin
  Result:=0;
  case Action of
    i_GetCount: begin

    end;
  else
    Result:=inherited InfoFunc(Action, aParameter);
  end
end;

function   TResizeLayer.RunFunc;
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
