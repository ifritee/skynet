unit UDenseLayer;

interface

uses Windows, Classes, DataTypes, SysUtils, RunObjts, UAbstractLayer;

type

  TDenseLayer = class(TAbstractLayer)
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
    m_units: NativeInt; // Количество нейронов
    m_activate: NativeInt; // Метод активации
    m_opimized: NativeInt; // Функция оптимизации
    m_dropout:  double;  // Отсев
    m_batchnorm: NativeInt; // Нормализация наборов
    m_outputQty: NativeInt;// Количество связей с другими слоями
    
  const
    PortType = 0; // Тип создаваемых портов (под математическую связь)  
  end;

implementation

uses keras;

constructor  TDenseLayer.Create;
begin
  inherited;
  shortName := 'DN' + IntToStr(getLayerNumber);
  isCreate := False;
end;

destructor   TDenseLayer.Destroy;
begin
  inherited;
  
end;

function    TDenseLayer.GetParamID;
begin
  Result:=inherited GetParamId(ParamName,DataType,IsConst);
  if Result = -1 then begin
    if StrEqu(ParamName,'output_qty') then begin
      Result:=NativeInt(@m_outputQty);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'units') then begin
      Result:=NativeInt(@m_units);
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
    end else if StrEqu(ParamName,'dropout') then begin
      Result:=NativeInt(@m_dropout);
      DataType:=dtDouble;    
      Exit;
    end else if StrEqu(ParamName,'batchnorm') then begin
      Result:=NativeInt(@m_dropout);
      DataType:=dtInteger;    
      Exit;
    end;

  end;
end;

procedure TDenseLayer.addLayerToModel();
var
  returnCode: TStatus;
begin
  returnCode := addDense(PAnsiChar(shortName),
                         PAnsiChar(nodes),
                         m_units, 
                         m_activate, 
                         m_opimized,
                         m_dropout, 
                         m_batchnorm);
  if returnCode <> STATUS_OK then begin
    ErrorEvent('Neural model not added dense layer', msError, VisualObject);
    Exit;
  end;
end;

//----- Редактирование свойств блока -----
procedure TDenseLayer.EditFunc;
var
  InputPortsNmb, OutputPortsNmb: integer;
  MsgLength: Integer;
begin
  SetCondPortCount(VisualObject, m_outputQty - 1, pmOutput, PortType, sdRight, 'outport_1');
end;

function TDenseLayer.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
begin
  Result:=0;
  case Action of
    i_GetCount: begin
      
    end;
  else
    Result:=inherited InfoFunc(Action,aParameter);
  end
end;

function   TDenseLayer.RunFunc;
var
  rootLayer: TAbstractLayer; // Родительский слой
  rootIndex: NativeInt;      // Индекс родительского слоя
  J : integer;
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
