unit UTestingBlock;

interface

uses Windows, Classes, DataTypes, SysUtils, RunObjts, dataset;

type

  TTestingBlock = class(TRunObject)
  public
    // Конструктор класса
    constructor  Create(Owner: TObject); override;
    // Деструктор
    destructor   Destroy; override;
    function       InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;override;
    function       RunFunc(var at,h : RealType;Action:Integer):NativeInt;override;
    function       GetParamID(const ParamName:string;var DataType:TDataType;var IsConst: boolean):NativeInt;override;

  strict private
    stepCount: NativeInt; // Счетчик шагов
    m_nnState: Boolean; // Состояние сети
    m_testData : pMNIST_DATA;

    m_crossOut: NativeInt;
    m_fileLoad: String;
  end;

implementation
  uses keras, UNNConstants;

constructor  TTestingBlock.Create;
begin
  inherited;
end;

destructor   TTestingBlock.Destroy;
begin
  inherited;
end;

function    TTestingBlock.GetParamID;
begin
  Result:=inherited GetParamId(ParamName,DataType,IsConst);
  if Result = -1 then begin
    if StrEqu(ParamName,'cross_out') then begin
      Result:=NativeInt(@m_crossOut);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'file_load') then begin
      Result:=NativeInt(@m_fileLoad);
      DataType:=dtString;
      Exit;
    end;
  end
end;

function TTestingBlock.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
begin
  Result:=0;
  case Action of
    i_GetCount: begin

    end;
  else
    Result:=inherited InfoFunc(Action,aParameter);
  end
end;

function   TTestingBlock.RunFunc;
var
  i : NativeInt;
  p64: UInt64;
  datas, labels : TLayerSize;
  returnCode : NativeInt;
begin
 Result:=0;
  case Action of
    f_UpdateOuts: begin

    end;
    f_InitState: begin
      stepCount := 0;
    end;
    f_GoodStep: begin
      if stepCount = 0 then // Только для первого шага
      begin
//        for I := 0 to cU.FCount - 1 do begin  // Пройдем по входам
//          if U[I].FCount > 0 then begin
//            if U[I].Arr^[0] = UNN_NNMAGICWORD then // Если пришло состояние сети
//            begin
//              m_nnState := False;
//              if U[I].FCount = 2 then
//                m_nnState := (U[I].Arr^[1] = 1); // Установим состояние сети
//              if m_nnState <> True then
//                ErrorEvent('State of NN FALSE', msError, VisualObject);
//            end else if ((U[I].Arr^[0] = UNN_DATASEMNIST) AND (U[I].FCount = 3 )) then // Если пришли данные
//            begin
//              p64 := Round(U[I].Arr^[1]);
//              p64 := p64 shl 32;
//              p64 := p64 OR UInt64(Round(U[I].Arr^[2]));
//              m_testData := pMNIST_DATA(p64);
//
//              datas.w := m_testData.rows;
//              datas.h := m_testData.cols;
//              datas.ch := m_testData.channels;
//              datas.bsz := m_testData.quantity;
//              labels.w := m_crossOut;
//              labels.h := 1;
//              labels.ch := 1;
//              labels.bsz := m_testData.quantity;
//              if m_fileLoad.Length > 0 then begin
//                returnCode := loadModel(PAnsiChar(AnsiString(m_fileLoad)));
//                if returnCode <> STATUS_OK then begin
//                  ErrorEvent('Crashed load model weight', msError, VisualObject);
//                end;
//              end;
//              returnCode := evaluate(m_testData.data, datas, m_testData.labels, labels, 2);
//            end;
//          end;
//        end;
      end else begin
//        Y[0].Arr^[0] := testPercents();
      end;
      inc(stepCount);
    end;
    f_Stop : begin

    end;
  end;
end;
end.
