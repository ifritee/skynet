unit UDeconvolutionLayer;

interface
uses Windows, Classes, DataTypes, SysUtils, RunObjts, UAbstractLayer;

type

  TDeconvolutionLayer = class(TAbstractLayer)
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
    m_outputQty: NativeInt;// Количество связей с другими слоями
    m_activate: NativeInt; // Метод активации
    m_opimized: NativeInt; // Функция оптимизации
    m_filters: NativeInt; // Количество фильтров
    m_dropout:  double;  // Отсев
    m_batchnorm: NativeInt; // Нормализация наборов
    m_width : NativeInt;  // Длина свертки
    m_height: NativeInt;  // Высота свертки
    m_stride: NativeInt;  //

  const
    PortType = 18300; // Тип создаваемых портов (под нейронную связь)
  end;

implementation
uses keras, NN_Texts, UNNConstants;

constructor  TDeconvolutionLayer.Create;
begin
  inherited;
  shortName := AnsiString('DN' + IntToStr(getLayerNumber));
  isCreate := False;
end;

destructor TDeconvolutionLayer.Destroy;
begin
  inherited;

end;

function TDeconvolutionLayer.GetParamID;
begin
  Result:=inherited GetParamId(ParamName,DataType,IsConst);
  if Result = -1 then begin
    if StrEqu(ParamName,'output_qty') then begin
      Result:=NativeInt(@m_outputQty);
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
    end else if StrEqu(ParamName,'filters') then begin
      Result:=NativeInt(@m_filters);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'dropout') then begin
      Result:=NativeInt(@m_dropout);
      DataType:=dtDouble;
      Exit;
    end else if StrEqu(ParamName,'batchnorm') then begin
      Result:=NativeInt(@m_dropout);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'width') then begin
      Result:=NativeInt(@m_width);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'height') then begin
      Result:=NativeInt(@m_height);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'stride') then begin
      Result:=NativeInt(@m_stride);
      DataType:=dtInteger;
      Exit;
    end;
  end;
end;

function TDeconvolutionLayer.addLayerToModel(id : Integer) : Boolean;
var
  returnCode: TStatus;
begin
  Result := True;
  if (id = m_modelID)  AND (LayersFromJSON = False) then begin
    returnCode := addDeconvolution(id, PAnsiChar(shortName),
                           PAnsiChar(nodes),
                           m_filters,
                           m_activate,
                           m_opimized,
                           m_dropout,
                           m_batchnorm,
                           m_width,
                           m_height,
                           m_stride);
    if returnCode <> STATUS_OK then begin
      ErrorEvent(txtNN_ModelNotAdded + String(shortName), msError, VisualObject);
      Result := False;
      Exit;
    end;
  end;
end;

//----- Редактирование свойств блока -----
procedure TDeconvolutionLayer.EditFunc;
begin
  SetCondPortCount(VisualObject, m_outputQty, pmOutput, PortType, sdRight, 'out');
end;

function TDeconvolutionLayer.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
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

function   TDeconvolutionLayer.RunFunc;
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
