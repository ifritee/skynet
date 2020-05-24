unit UTestingBlock;

interface

uses Windows, Classes, DataTypes, SysUtils, RunObjts, dataset, keras;

type

  TTestingBlock = class(TRunObject)
  public
    // Конструктор класса
    constructor  Create(Owner: TObject); override;
    // Деструктор
    destructor   Destroy; override;
    function     InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;override;
    function     RunFunc(var at,h : RealType;Action:Integer):NativeInt;override;
    function     GetParamID(const ParamName:string;var DataType:TDataType;var IsConst: boolean):NativeInt;override;

  strict private
    stepCount: NativeInt; // Счетчик шагов
    m_id : Integer;
    m_workType : Cardinal;
    m_resultQty, m_maxQty: Integer; // Количество ответов
    m_label: array of Byte;
  end;

implementation
  uses UNNConstants, NN_Texts;

constructor  TTestingBlock.Create;
begin
  inherited;
  m_workType := 0;
  m_resultQty := 1;
end;

destructor   TTestingBlock.Destroy;
begin
  inherited;
end;

function    TTestingBlock.GetParamID;
begin
  Result:=inherited GetParamId(ParamName,DataType,IsConst);
  if Result = -1 then begin
    if StrEqu(ParamName,'result_qty') then begin
      Result:=NativeInt(@m_resultQty);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'max_qty') then begin
      Result:=NativeInt(@m_maxQty);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'work_type') then begin
      Result:=NativeInt(@m_workType);
      DataType:=dtInteger;
      Exit;
    end;
  end
end;

function TTestingBlock.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
begin
  Result:=0;
  case Action of
    i_GetCount: begin
      cY[0] := m_maxQty;
      cY[1] := m_resultQty;
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
  returnCode: NativeInt;
  m_data: PDataArr; /// Данные, которые проходят через слои модели
  accuracy, calcLabel : Single;
  labelPoint, reciveLabels: array of Single;   /// Метки для
  crossOut: Integer; /// Количество выходных нейронов
begin
 Result:=0;
  case Action of
    f_UpdateOuts: begin

    end;
    f_InitState: begin
      stepCount := 0;
    end;
    f_GoodStep: begin
//    if stepCount = 0 then // Только для первого шага
      // Вход 0 - данные
      // Вход 1 - метки (Может и не быть)
      // Вход 2 - ширина, высота, глубина
      if cU.FCount = 3 then begin
        m_id := Round(U[0].Arr^[0]);
        p64 := Round(U[0].Arr^[1]);
        p64 := p64 shl 32;
        p64 := p64 OR UInt64(Round(U[0].Arr^[2]));
        m_data := PDataArr(p64);
        crossOut := Round(U[0].Arr^[3]);
        ///------
        SetLength(m_label, U[1].Count);
        SetLength(reciveLabels, U[1].Count);
        for I := 0 to Length(m_label) - 1 do begin
          m_label[I] := Round(U[1].Arr^[I]);
          reciveLabels[I] := U[1].Arr^[I];
        end;
        datas.w := Round(U[0].Arr^[4]);
        datas.h := Round(U[0].Arr^[5]);
        datas.ch := Round(U[0].Arr^[6]);
        datas.bsz := Length(m_label);
        labels.w := crossOut;
        labels.h := 1;
        labels.ch := 1;
        labels.bsz := Length(m_label);
        if m_workType = 0 then begin // Для сравнения с тестовыми значениями
          if crossOut > 1 then begin // Для сравнения с набором из N элементов
            returnCode := evaluate(m_id, @m_data^[0], datas, @m_label[0], labels, 2, accuracy);
            if returnCode <> STATUS_OK then begin
              ErrorEvent(txtNN_TestCrash, msError, VisualObject);
              Result := r_Fail;
              Exit;
            end;
            Y[1].Arr^[0] := accuracy;
          end else begin // Для стремления к тестовому значению
            SetLength(labelPoint, datas.bsz);
            returnCode := keras.forecasting(m_id, @m_data^[0], datas, @labelPoint[0], labels);
            if returnCode <> STATUS_OK then begin
              ErrorEvent(txtNN_TestCrash, msError, VisualObject);
              Result := r_Fail;
              Exit;
            end;
            calcLabel := 0;
            for I := 0 to datas.bsz - 1 do begin
              calcLabel := calcLabel + abs( reciveLabels[i] - labelPoint[i]);
            end;
            Y[1].Arr^[0] := calcLabel / datas.bsz; //labelPoint[0];
          end;
        end else begin // Для определения значения из набора
          if crossOut > 1 then begin // Для сравнения с набором из N элементов
            returnCode := evaluate(m_id, @m_data^[0], datas, Nil, labels, 2, accuracy, @m_label[0]);
            if returnCode <> STATUS_OK then begin
              ErrorEvent(txtNN_TestCrash, msError, VisualObject);
              Result := r_Fail;
              Exit;
            end;
            for I := 0 to m_resultQty - 1 do begin
              if I >= datas.bsz then
                Break;
              Y[1].Arr^[i] := m_label[i];
            end;
          end else begin
            SetLength(labelPoint, datas.bsz);
            returnCode := keras.forecasting(m_id, @m_data^[0], datas, @labelPoint[0], labels);
            if returnCode <> STATUS_OK then begin
              ErrorEvent(txtNN_TestCrash, msError, VisualObject);
              Result := r_Fail;
              Exit;
            end;
            for I := 0 to m_resultQty - 1 do begin
              if I >= datas.bsz then
                Break;
              Y[1].Arr^[i] := labelPoint[i];
            end;
          end;
        end;
        if Length(m_data^) <= m_maxQty then begin
          for I := 0 to Length(m_data^) - 1 do begin
            Y[0].Arr^[I] := m_data^[I];
          end;
        end else begin
          ErrorEvent(txtNN_DataSize, msError, VisualObject);
          Result := r_Fail;
          Exit;
        end;
      end;

      inc(stepCount);
    end;
    f_Stop : begin
      SetLength(m_label, 0);
      SetLength(labelPoint, 0);
    end;
  end;
end;
end.
