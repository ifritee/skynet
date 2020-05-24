unit UTrainingBlock;

interface

uses Windows, Classes, DataTypes, SysUtils, RunObjts, dataset, keras;

type
  TTrainingBlock = class(TRunObject)
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
    stepCount: NativeInt; // Счетчик шагов
    m_learningRate : double;
    m_label: array of Byte;
    m_fLabel: array of Single;
    m_lastDataType : Integer;
    m_id : Integer;
  end;

implementation
  uses UNNConstants, NN_Texts;

constructor  TTrainingBlock.Create;
begin
  m_id := -1;
  inherited;
end;

destructor   TTrainingBlock.Destroy;
begin
  inherited;
end;

function    TTrainingBlock.GetParamID;
begin
  Result:=inherited GetParamId(ParamName,DataType,IsConst);
  if Result = -1 then begin
    if StrEqu(ParamName,'learning_rate') then begin
      Result:=NativeInt(@m_learningRate);
      DataType:=dtDouble;
      Exit;
    end;
  end
end;

//----- Редактирование свойств блока -----
procedure TTrainingBlock.EditFunc;
begin
end;

function TTrainingBlock.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
begin
  Result:=0;
  case Action of
    i_GetCount: begin
      cY[0] := 1;
    end;
  else
    Result:=inherited InfoFunc(Action,aParameter);
  end
end;

function   TTrainingBlock.RunFunc;
var
  i : NativeInt;
  p64: UInt64;
  accuracy : Single;
  m_data: PDataArr; /// Данные, которые проходят через слои модели
  crossOut: Integer; /// Количество выходных нейронов
  datas, labels : TLayerSize;
begin
  Result:=0;
  case Action of
    f_UpdateOuts: begin

    end;
    f_InitState: begin
      stepCount := 0;
      m_lastDataType := 0;
    end;
    f_GoodStep: begin
      // Вход 0 - данные
      // Вход 1 - метки
      if cU.FCount <> 2 then begin
        ErrorEvent(txtNN_DataSize, msError, VisualObject);
        Result := r_Fail;
        Exit;
      end;
      m_id := Round(U[0].Arr^[0]);
      if m_id = -1 then begin
        ErrorEvent(txtNN_NCreated, msError, VisualObject);
        Result := r_Fail;
        Exit;
      end;
      p64 := Round(U[0].Arr^[1]);
      p64 := p64 shl 32;
      p64 := p64 OR UInt64(Round(U[0].Arr^[2]));
      m_data := PDataArr(p64);
      crossOut := Round(U[0].Arr^[3]);
      SetLength(m_label, U[1].Count);
      SetLength(m_flabel, U[1].Count);
      if crossOut <= 0 then begin
        ErrorEvent(txtNN_CrossOutFail, msError, VisualObject);
        Result := r_Fail;
        Exit;
      end;
      for I := 0 to Length(m_label) - 1 do begin
        if crossOut = 1 then begin
          m_flabel[I] := U[1].Arr^[I];
        end else begin
          m_label[I] := Round(U[1].Arr^[I]);
        end;
      end;
      datas.w := Round(U[0].Arr^[4]);
      datas.h := Round(U[0].Arr^[5]);
      datas.ch := Round(U[0].Arr^[6]);
      datas.bsz := Length(m_label);
      labels.w := crossOut;
      labels.h := 1;
      labels.ch := 1;
      labels.bsz := Length(m_label);
      if crossOut = 1 then begin
        fitOneValue(m_id, @m_data^[0], datas, @m_flabel[0], labels, 1, m_learningRate, accuracy);
        accuracy := 1.0 - accuracy;
      end else begin
        fit(m_id, @m_data^[0], datas, @m_label[0], labels, 1, m_learningRate, accuracy);
      end;
      Y[0].Arr^[0] := accuracy;
      inc(stepCount);
    end;
    f_Stop: begin
      SetLength(m_label, 0);
      SetLength(m_flabel, 0);
    end;
  end;
end;
end.
