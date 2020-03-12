unit UTrainingBlock;

interface

uses Windows, Classes, DataTypes, SysUtils, RunObjts, dataset;

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

  strict private
    stepCount: NativeInt; // Счетчик шагов
    m_nnState: Boolean; // Состояние сети
    m_trainData : pMNIST_DATA;
    m_testData : pMNIST_DATA;

    m_crossOut: NativeInt;
    m_learningRate : double;
    m_fileSave : String;
    m_fileLoad: String;

    m_lastDataType : Integer;
  end;

implementation
  uses keras, UNNConstants;

constructor  TTrainingBlock.Create;
begin
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
    if StrEqu(ParamName,'cross_out') then begin
      Result:=NativeInt(@m_crossOut);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'learning_rate') then begin
      Result:=NativeInt(@m_learningRate);
      DataType:=dtDouble;
      Exit;
    end else if StrEqu(ParamName,'file_save') then begin
      Result:=NativeInt(@m_fileSave);
      DataType:=dtString;
      Exit;
    end else if StrEqu(ParamName,'file_load') then begin
      Result:=NativeInt(@m_fileLoad);
      DataType:=dtString;
      Exit;
    end;
  end
end;

function TTrainingBlock.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
begin
  Result:=0;
  case Action of
    i_GetCount: begin

    end;
  else
    Result:=inherited InfoFunc(Action,aParameter);
  end
end;

function   TTrainingBlock.RunFunc;
var
  i, val : NativeInt;
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
      m_lastDataType := 0;
    end;
    f_GoodStep: begin
      if stepCount = 0 then // Только для первого шага
      begin
        for I := 0 to cU.FCount - 1 do begin  // Пройдем по входам
          if U[I].FCount > 0 then begin
            val := Round(U[I].Arr^[0]);
            if val = UNN_NNMAGICWORD then // Если пришло состояние сети
            begin
              m_nnState := False;
              if U[I].FCount = 2 then
                m_nnState := (U[I].Arr^[1] = 1); // Установим состояние сети
              if m_nnState <> True then
                ErrorEvent('State of NN FALSE', msError, VisualObject);
            end else if ((val = UNN_DATASEMNIST) AND (U[I].FCount = 3 )) then // Если пришли данные MNIST
            begin
              m_lastDataType := UNN_DATASEMNIST;
              p64 := Round(U[I].Arr^[1]);
              p64 := p64 shl 32;
              p64 := p64 OR UInt64(Round(U[I].Arr^[2]));
              m_trainData := pMNIST_DATA(p64);
              datas.w := m_trainData.rows;
              datas.h := m_trainData.cols;
              datas.ch := m_trainData.channels;
              datas.bsz := m_trainData.quantity;
              labels.w := m_crossOut;
              labels.h := 1;
              labels.ch := 1;
              labels.bsz := m_trainData.quantity;
              if m_fileLoad.Length > 0 then begin
                returnCode := loadModel(PAnsiChar(AnsiString(m_fileLoad)));
                if returnCode <> STATUS_OK then begin
                  ErrorEvent('Crashed load model weight', msError, VisualObject);
                end;
              end;
              returnCode := trainCreate(m_trainData.data, datas, m_trainData.labels, labels);
            end else if ((val = UNN_DATASTEPBYSTEP) AND (U[I].FCount = 3 )) then begin
              m_lastDataType := UNN_DATASTEPBYSTEP;
              if m_fileLoad.Length > 0 then begin
                returnCode := loadModel(PAnsiChar(AnsiString(m_fileLoad)));
                if returnCode <> STATUS_OK then begin
                  ErrorEvent('Crashed load model weight', msError, VisualObject);
                end;
              end;
            end else begin
              ErrorEvent('Not know data ' + IntToStr(val), msError, VisualObject);
            end;
          end;
        end;
      end else begin
        for I := 0 to cU.FCount - 1 do begin  // Пройдем по входам
          if (U[I].FCount >= 3) then begin // только если данные есть
            val := Round(U[I].Arr^[0]);
            if val = UNN_DATASEMNIST then begin
              datas.w := m_trainData.rows;
              datas.h := m_trainData.cols;
              datas.ch := 1;
              datas.bsz := m_trainData.quantity;
              returnCode := trainStep(m_learningRate, datas);
              Y[0].Arr^[0] := lastAccurateSum();
            end else if val = UNN_DATASTEPBYSTEP then begin
              p64 := Round(U[I].Arr^[1]);
              p64 := p64 shl 32;
              p64 := p64 OR UInt64(Round(U[I].Arr^[2]));
              m_trainData := pMNIST_DATA(p64);
              datas.w := m_trainData.rows;
              datas.h := m_trainData.cols;
              datas.ch := m_trainData.channels;
              datas.bsz := m_trainData.quantity;
              labels.w := m_crossOut;
              labels.h := 1;
              labels.ch := 1;
              labels.bsz := m_trainData.quantity;
              fit(m_trainData.data, datas, m_trainData.labels, labels, 1, m_learningRate);
              ErrorEvent(IntToStr(stepCount) + ' Accurate: ' + FloatToStr(lastAccurateSum()), msInfo, VisualObject);
            end;
          end;
        end;

//        ErrorEvent(IntToStr(stepCount) + ' Accurate: ' + FloatToStr(lastAccurateSum()), msInfo, VisualObject);
//        labels.w := 10;
//        labels.h := 1;
//        labels.ch := 1;
//        labels.bsz := m_trainData.quantity;
//        fit(m_trainData.data, datas, m_trainData.labels, labels, m_epochs, m_learningRate);
//        ErrorEvent(IntToStr(stepCount) + ' Accurate: ' + FloatToStr(lastAccurateSum()), msInfo, VisualObject);
      end;
      inc(stepCount);
    end;
    f_Stop : begin
      if m_lastDataType = UNN_DATASEMNIST then begin
        returnCode := trainStop();
        if returnCode <> STATUS_OK then begin
          ErrorEvent('Crashed stop train', msError, VisualObject);
        end;
      end;
      if m_fileSave.Length > 0 then begin
        returnCode := saveModel(PAnsiChar(AnsiString(m_fileSave)));
        if returnCode <> STATUS_OK then begin
          ErrorEvent('Crashed save model weight', msError, VisualObject);
        end;
      end;
    end;
  end;
end;
end.
