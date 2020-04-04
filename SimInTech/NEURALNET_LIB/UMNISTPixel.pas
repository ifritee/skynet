unit UMNISTPixel;

interface
uses Classes, DataTypes, SysUtils, RunObjts;

type

  TMNISTPixel = class(TRunObject)
  public
    // Конструктор класса
    constructor  Create(Owner: TObject); override;
    // Деструктор
    destructor   Destroy; override;
    function       InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;override;
    function       RunFunc(var at,h : RealType;Action:Integer):NativeInt;override;
    function       GetParamID(const ParamName:string;var DataType:TDataType;var IsConst: boolean):NativeInt;override;
    // Функция для обеспечения изменения визуальных параметров блока
    procedure EditFunc(Props:TList;
                       SetPortCount:TSetPortCount;
                       SetCondPortCount:TSetCondPortCount;
                       ExecutePropScript:TExecutePropScript);override;

  strict private
    m_elemQty: NativeInt;// Количество элемнтов

  const
    PortType = 0; // Тип создаваемых портов (под математическую связь)

 end;

implementation

constructor  TMNISTPixel.Create;
begin
  inherited;
end;

destructor   TMNISTPixel.Destroy;
begin
  inherited;
end;

function    TMNISTPixel.GetParamID;
begin
  Result:=inherited GetParamId(ParamName,DataType,IsConst);
  if Result = -1 then begin
     if StrEqu(ParamName,'qty') then begin
      Result:=NativeInt(@m_elemQty);
      DataType:=dtInteger;
      Exit;
    end;
  end
end;

//----- Редактирование свойств блока -----
procedure TMNISTPixel.EditFunc;
begin
end;

function TMNISTPixel.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
begin
  Result:=0;
  case Action of
    i_GetCount: begin
      cY[0] := m_elemQty;
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

function   TMNISTPixel.RunFunc;
var
  I, Alpha, Color : Integer;
begin
  Result:=0;
  case Action of
    f_UpdateOuts: begin

    end;
    f_InitState: begin

    end;
    f_GoodStep: begin
      Alpha := 255;
      for I := 0 to U[0].Count - 1 do begin
        if I >= m_elemQty then
          Break;
        Color := Round(U[0].Arr^[I] * 255.0);
        Y[0].Arr^[I] := (Integer(Alpha) SHL 24) or (Integer(Color) SHL 16) or (Integer(Color) SHL 8) or Integer(Color);
      end;
    end;
  end
end;
end.
