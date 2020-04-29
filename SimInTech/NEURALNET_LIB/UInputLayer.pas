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
    // Загрузка весов (только) после формирования сети
    procedure NetLoadWeight();
    // Добавляет данный слой в модель
    function addLayerToModel(id : Integer) : Boolean; override;
    // Функция для обеспечения изменения визуальных параметров блока
    procedure EditFunc(Props:TList;
                       SetPortCount:TSetPortCount;
                       SetCondPortCount:TSetCondPortCount;
                       ExecutePropScript:TExecutePropScript);override;

  strict private
    stepCount: NativeInt; // Счетчик шагов
    m_outputQty: NativeInt;// Количество связей с другими слоями
    m_loadNetFile : String; // Файл с описанием сети
    m_loadWeightFile : String; /// Файл с весами
    m_isSaveNet : Boolean; // Флаг сохранения сети по окончании работы
    m_saveWeightFile : String; // Файл расчитанных весов
    m_saveNetFile : String; // Файл сохранения состояния сети
    m_data: array of Single;  /// Данные, которые проходят через слои модели

  const
    PortType = 0; // Тип создаваемых портов (под математическую связь)

 end;

implementation

uses keras, NN_Texts, UNNConstants;

constructor  TInputLayer.Create;
begin
  inherited;
    shortName := 'Input';
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
    end else if StrEqu(ParamName,'net_from_file') then begin
      Result:=NativeInt(@LayersFromJSON);
      DataType:=dtBool;
      Exit;
    end else if StrEqu(ParamName,'load_weight_file') then begin
      Result:=NativeInt(@m_loadWeightFile);
      DataType:=dtString;
      Exit;
    end  else if StrEqu(ParamName,'load_net_file') then begin
      Result:=NativeInt(@m_loadNetFile);
      DataType:=dtString;
      Exit;
    end else if StrEqu(ParamName,'is_save_net') then begin
      Result:=NativeInt(@m_isSaveNet);
      DataType:=dtBool;
      Exit;
    end else if StrEqu(ParamName,'save_weight_file') then begin
      Result:=NativeInt(@m_saveWeightFile);
      DataType:=dtString;
      Exit;
    end else if StrEqu(ParamName,'save_net_file') then begin
      Result:=NativeInt(@m_saveNetFile);
      DataType:=dtString;
      Exit;
    end;

  end
end;

procedure TInputLayer.NetLoadWeight;
begin
  if (FileExists(m_loadWeightFile) = True) then begin// Если он существует
   loadWeight(m_modelID, PAnsiChar(AnsiString(m_loadWeightFile)));
  end;
end;

//----- Редактирование свойств блока -----
procedure TInputLayer.EditFunc;
begin
  SetCondPortCount(VisualObject, m_outputQty, pmOutput, PortType, sdRight, 'output');
end;

function TInputLayer.addLayerToModel(id : Integer) : Boolean;
var
  returnCode: TStatus;
begin
  Result := True;
  if (id = m_modelID) AND (LayersFromJSON = False) then begin
    returnCode := addInput(id, PAnsiChar(shortName), PAnsiChar(nodes));
    if returnCode <> STATUS_OK then begin
      ErrorEvent(txtNN_ModelNotAdded + String(shortName), msError, VisualObject);
      Result := False;
      Exit;
    end;
  end;
end;

function TInputLayer.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
  var
  i: integer;
begin
  Result:=0;
  case Action of
    i_GetCount: begin
      for I := 0 to m_outputQty - 1 do
        cY[I] := 2;
      cY[0] := UNN_SIZE_WITHDATA;
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
var
  J : Integer;
  p64: UInt64;
  returnCode : TStatus;
  netFile, weightFile: String;
begin
  Result:=0;
  netFile := '';
  weightFile := '';
  case Action of
    f_UpdateOuts: begin

    end;
    f_InitState: begin
      stepCount:= 0;
      nodes := '';
      if LayersFromJSON = True then begin // Если используем JSON файл сети
        if (FileExists(m_loadNetFile) = True) then begin// Если он существует
          netFile := m_loadNetFile;
        end else begin
          ErrorEvent(txtNN_NetFileNotFound, msError, VisualObject);
          Result := r_Fail;
          Exit;
        end;
      end;
      m_modelID:= createModel(PAnsiChar(AnsiString(netFile)), '');
      // Проверим состояние создания модели
      if m_modelID = -1 then begin
        ErrorEvent(txtNN_NCreated, msError, VisualObject);
        Result := r_Fail;
        Exit;
      end;
    end;
    f_GoodStep: begin
      for J := 0 to cY.Count - 1 do begin
        Y[J].Arr^[0] := m_modelID;
        Y[J].Arr^[1] := getLayerNumber;
      end;
      SetLength(m_data, U[0].Count);
      for J := 0 to Length(m_data) - 1 do begin
        m_data[J] := U[0].Arr^[J];
      end;
        p64 := UInt64(@m_data);
        Y[0].Arr^[2] := p64 shr 32;
        Y[0].Arr^[3] := (p64 shl 32) shr 32;
    end;
    f_Stop: begin
      if (m_isSaveNet = True) AND (m_modelID >= 0) then begin
        returnCode := saveModel(m_modelID, PAnsiChar(AnsiString(m_saveNetFile)),
                                PAnsiChar(AnsiString(m_saveWeightFile)));
        if returnCode <> STATUS_OK then begin
          ErrorEvent(txtNN_ModelSave, msError, VisualObject);
          Exit;
        end;
      end;
      deleteModel(m_modelID);
      SetLength(m_data, 0);
    end;
  end
end;

end.
