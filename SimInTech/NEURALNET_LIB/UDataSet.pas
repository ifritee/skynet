//**************************************************************************//
 // Данный исходный код является составной частью системы             //
 // Программист:        Никишин Е. В.                                        //
 //**************************************************************************//

unit UDataSet;

interface

uses Windows, Classes, DataTypes, SysUtils, RunObjts, dataset;

type

  TDataSet = class(TRunObject)
  public
    // Конструктор класса
    constructor  Create(Owner: TObject); override;
    // Деструктор
    destructor   Destroy; override;
    function       InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;override;
    function       RunFunc(var at,h : RealType;Action:Integer):NativeInt;override;
    function       GetParamID(const ParamName:string;var DataType:TDataType;var IsConst: boolean):NativeInt;override;

  strict private
     m_stepNumber: Cardinal;

     m_datasetType: NativeInt;  /// Тип набора
     m_trainData: String; /// Расположение тренировочных данных
     m_trainlabel: String;  /// Расположение тренировочных меток
     m_testData: String;  /// Расположение тестовых данных
     m_testLabel: String; /// Расположение тестовых меток
     m_mnistData: TMNIST_DATA; /// Тренировочные данные о MNIST
     m_trainQty : Cardinal; /// Количество считываемых данны
     m_sendDataType : Cardinal; /// Тип отправляемых данных
     m_isOneSend : Boolean; /// Одноразовая отправка одного пакета
  end;

implementation

uses keras, UNNConstants;

constructor  TDataSet.Create;
begin
  inherited;
  m_stepNumber:= 0;
end;

destructor   TDataSet.Destroy;
begin
  inherited;
end;

function    TDataSet.GetParamID;
begin
  Result:=inherited GetParamId(ParamName,DataType,IsConst);
  if Result = -1 then begin
     if StrEqu(ParamName,'TrainData') then begin
      Result:=NativeInt(@m_trainData);
      DataType:=dtString;
      Exit;
    end else if StrEqu(ParamName,'TrainLabel') then begin
      Result:=NativeInt(@m_trainlabel);
      DataType:=dtString;
      Exit;
    end else if StrEqu(ParamName,'TestData') then begin
      Result:=NativeInt(@m_testData);
      DataType:=dtString;
      Exit;
    end else if StrEqu(ParamName,'TestLabel') then begin
      Result:=NativeInt(@m_testLabel);
      DataType:=dtString;
      Exit;
    end else if StrEqu(ParamName,'DataSet') then begin
      Result:=NativeInt(@m_datasetType);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'train_qty') then begin
      Result:=NativeInt(@m_trainQty);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'send_data_type') then begin
      Result:=NativeInt(@m_sendDataType);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'is_one_send') then begin
      Result:=NativeInt(@m_isOneSend);
      DataType:=dtBool;
      Exit;
    end;

  end
end;

function TDataSet.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
begin
  Result:=0;
  case Action of
    i_GetCount: begin
      cY[0] := 3;
    end;
  else
    Result:=inherited InfoFunc(Action,aParameter);
  end
end;

function   TDataSet.RunFunc;
var
  returnCode: TStatus;
  p64: UInt64;
  i, j: Integer;
  isWorkDone: Boolean;
  datas, labels : String;
begin
  Result:=0;
  isWorkDone := True;
  case Action of
    f_UpdateOuts: begin

    end;
    f_InitState: begin
      m_stepNumber := 0;
      m_mnistData.quantity := 0;
      // Зануление выходных портов
      for I := 0 to cY.Count - 1 do begin
        cY.Arr^[I] := 0;
        for J := 0 to Y[I].Count - 1 do  begin
          Y[I].Arr^[J] := 0;
        end;
      end;
      if m_isOneSend = True then begin // Только для пакета MNIST
        // Считываем тренировочные данные
        if m_sendDataType = 0  then begin
          datas := m_trainData;
          labels := m_trainLabel;
        end else begin
          datas := m_testData;
          labels := m_testLabel;
        end;
        // Проверяем доступность файлов
        if FileExists(datas) AND FileExists(labels) then begin
          returnCode := dataset.readMnistTrain(PAnsiChar(AnsiString(datas)),
                                               PAnsiChar(AnsiString(labels)),
                                               m_trainQty);
          if returnCode <> STATUS_OK then begin
            ErrorEvent('Read MNIST db is failure!', msError, VisualObject);
            Exit;
          end;
          m_mnistData := mnistTrainParams;
          ErrorEvent('Read MNIST: ' + IntToStr(m_mnistData.quantity), msInfo, VisualObject);
        end else begin
          ErrorEvent('Read MNIST failure ', msError, VisualObject);
          isWorkDone := False;
          Exit;
        end;
      end;
    end;
    f_GoodStep: begin
      //----- Только для одноразовой посылки всех данных -----
      if m_stepNumber = 0 then
      begin
        if (m_isOneSend = True) AND (isWorkDone = True) then begin // Только для пакета MNIST
          Y[0].Arr^[0] := UNN_DATASEMNIST;
          p64 := UInt64(@m_mnistData);  // Для тренировочных данных
          Y[0].Arr^[1] := p64 shr 32;
          Y[0].Arr^[2]:= (p64 shl 32) shr 32;
        end else begin // Если данные будут идти по шагам
          Y[0].Arr^[0] := UNN_DATASTEPBYSTEP;
          Y[0].Arr^[1] := 0;
          Y[0].Arr^[2]:= 0;
        end;
      //----- Для посылки по шагам -----
      end else begin
        if m_isOneSend = True then begin
          Y[0].Arr^[0] := UNN_DATASEMNIST;
          Y[0].Arr^[1] := 0;
          Y[0].Arr^[2]:= 0;
        end else begin
          // Считываем тренировочные данные
          if m_sendDataType = 0  then begin
            datas := m_trainData;
            labels := m_trainLabel;
          end else begin
            datas := m_testData;
            labels := m_testLabel;
          end;
          // Проверяем доступность файлов
          if FileExists(datas) AND FileExists(labels) then begin
            returnCode := dataset.readMnistTrain(PAnsiChar(AnsiString(datas)),
                                                 PAnsiChar(AnsiString(labels)),
                                                 m_trainQty, m_stepNumber);
            if returnCode <> STATUS_OK then begin
              ErrorEvent('Read MNIST db is failure!', msError, VisualObject);
              Exit;
            end;
            m_mnistData := mnistTrainParams;
            Y[0].Arr^[0] := UNN_DATASTEPBYSTEP;
            p64 := UInt64(@m_mnistData);  // Для тренировочных данных
            Y[0].Arr^[1] := p64 shr 32;
            Y[0].Arr^[2]:= (p64 shl 32) shr 32;
          end else begin
            ErrorEvent('Read MNIST failure ', msError, VisualObject);
            Exit;
          end;
        end;
      end;
      inc(m_stepNumber);
    end;
  end
end;
end.
