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
    function       RunFunc(var at,h : RealType; Action:Integer):NativeInt;override;
    function       GetParamID(const ParamName:string;var DataType:TDataType;var IsConst: boolean):NativeInt;override;

  strict private
     m_stepNumber: Cardinal;
     m_width: Integer;  /// Ширина одного набора данных
     m_height: Integer; /// Высота одного набора данных
     m_depth: Integer;  /// Глубина одного набора данных
     m_dataPoint : array of Single; /// Данные
     m_labelPoint: array of Byte;   /// Метки
     m_id: Integer;

     m_datasetType: NativeInt;  /// Тип набора
     m_trainData: String; /// Расположение тренировочных данных
     m_trainlabel: String;  /// Расположение тренировочных меток
     m_testData: String;  /// Расположение тестовых данных
     m_testLabel: String; /// Расположение тестовых меток
     m_breastSorce: Integer; /// Источник информации о больных раком
     m_breastFile: String; /// Файл с данными о больных
     m_wine: String; /// Классификация вин
     m_iris: String; /// Классификация ирисов
     m_bostonTrain: String;  /// Цена квартир (тренировка)
     m_bostonTest: String;  ///  Цена квартир (тест)
     m_bikeDay: String; /// Прокат велосипедов по дням
     m_bikeHour: String; /// Прокат велосипедов по часам
     m_titanicTrain: String;  /// Выживет ли пассажир (тренировка)
     m_titanicTest: String; /// Выживет ли пассажир (тест)

     m_trainQty : Cardinal; /// Количество считываемых данны
     m_sendDataType : Cardinal; /// Тип отправляемых данных

     /// Проверка наличия файлов с датасетом
     Function checkFiles(): Boolean;
  end;

implementation

uses keras, UNNConstants;

constructor  TDataSet.Create;
begin
  inherited;
  m_stepNumber:= 0;
  m_width := 1;
  m_height := 1;
  m_depth := 1;
  m_id := -1;
end;

destructor   TDataSet.Destroy;
begin
  inherited;
//  if m_id >= 0 then begin
//    dataset.deleteMnistDataset(m_id);
//  end;
end;

function    TDataSet.GetParamID;
begin
  Result:=inherited GetParamId(ParamName,DataType,IsConst);
  if Result = -1 then begin
     if StrEqu(ParamName,'mnist_train_data') then begin
      Result:=NativeInt(@m_trainData);
      DataType:=dtString;
      Exit;
    end else if StrEqu(ParamName,'mnist_train_label') then begin
      Result:=NativeInt(@m_trainlabel);
      DataType:=dtString;
      Exit;
    end else if StrEqu(ParamName,'mnist_test_data') then begin
      Result:=NativeInt(@m_testData);
      DataType:=dtString;
      Exit;
    end else if StrEqu(ParamName,'mnist_test_label') then begin
      Result:=NativeInt(@m_testLabel);
      DataType:=dtString;
      Exit;
    end else if StrEqu(ParamName,'dataset_type') then begin
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
    end else if StrEqu(ParamName,'breast_file') then begin
      Result:=NativeInt(@m_breastFile);
      DataType:=dtString;
      Exit;
    end else if StrEqu(ParamName,'breast_src') then begin
      Result:=NativeInt(@m_breastSorce);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'wine') then begin
      Result:=NativeInt(@m_wine);
      DataType:=dtString;
      Exit;
    end else if StrEqu(ParamName,'iris') then begin
      Result:=NativeInt(@m_iris);
      DataType:=dtString;
      Exit;
    end else if StrEqu(ParamName,'boston_train') then begin
      Result:=NativeInt(@m_bostonTrain);
      DataType:=dtString;
      Exit;
    end else if StrEqu(ParamName,'boston_test') then begin
      Result:=NativeInt(@m_bostonTest);
      DataType:=dtString;
      Exit;
    end else if StrEqu(ParamName,'bike_day') then begin
      Result:=NativeInt(@m_bikeDay);
      DataType:=dtString;
      Exit;
    end else if StrEqu(ParamName,'bike_hour') then begin
      Result:=NativeInt(@m_bikeHour);
      DataType:=dtString;
      Exit;
    end else if StrEqu(ParamName,'titanic_train') then begin
      Result:=NativeInt(@m_titanicTrain);
      DataType:=dtString;
      Exit;
    end else if StrEqu(ParamName,'titanic_test') then begin
      Result:=NativeInt(@m_titanicTest);
      DataType:=dtString;
      Exit;
    end;
  end
end;

function TDataSet.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
var
  dataParam, labelParam: keras.TLayerSize;
begin
  Result:=0;
  case Action of
    i_GetCount: begin
      if m_datasetType = 0 then begin
        m_width := 28;
        m_height := 28;
        m_depth := 1;
        if m_trainQty = 0 then
          m_trainQty := 1000;
      end else if m_datasetType = 1 then begin
        breastTrainData(PAnsiChar(AnsiString(m_breastFile)),
                        m_breastSorce + 1, @m_dataPoint, @m_labelPoint,
                        @dataParam, @labelParam,0,0);
        m_width := dataParam.w;
        m_height := dataParam.h;
        m_depth := dataParam.ch;
        if m_trainQty = 0 then
          m_trainQty := dataParam.bsz;
      end;
      cY[0] := m_trainQty * m_width * m_height * m_depth; // Количество данных = количеству наборов * W * H
      cY[1] := m_trainQty; // Количество меток = количеству наборов
      cY[2] := 1;
      cY[3] := 1;
      cY[4] := 1;
    end;
  else
    Result:=inherited InfoFunc(Action,aParameter);
  end
end;

function   TDataSet.RunFunc;
var
  returnCode: TStatus;
//  p64: UInt64;
  i, j, retCode: Integer;
//  isWorkDone: Boolean;
//  datas, labels : String;
  dataParam, labelParam: keras.TLayerSize;
  dataLength: Integer;
begin
  Result:=0;
//  isWorkDone := True;
  case Action of
    f_UpdateOuts: begin

    end;
    f_InitState: begin
      m_stepNumber := 0;
      // Зануление выходных портов
      for I := 0 to cY.Count - 1 do begin
        cY.Arr^[I] := 0;
        for J := 0 to Y[I].Count - 1 do  begin
          Y[I].Arr^[J] := 0;
        end;
      end;
      if checkFiles = False then begin
        Exit;
      end;
    end;
    f_GoodStep: begin
      if m_datasetType = 0 then begin  // MNIST
        if m_sendDataType = 0 then begin
          retCode := mnistTrainData(PAnsiChar(AnsiString(m_trainData)),
                                    PAnsiChar(AnsiString(m_trainlabel)),
                                    @m_dataPoint, @m_labelPoint,
                                    @dataParam, @labelParam,
                                    m_trainQty, m_stepNumber);
          dataLength := dataParam.bsz * dataParam.w * dataParam.h * dataParam.ch;
        end else begin
          retCode := mnistTrainData(PAnsiChar(AnsiString(m_testData)),
                                    PAnsiChar(AnsiString(m_testLabel)),
                                    @m_dataPoint, @m_labelPoint,
                                    @dataParam, @labelParam,
                                    m_trainQty, m_stepNumber);
          dataLength := dataParam.bsz * dataParam.w * dataParam.h * dataParam.ch;
        end;
      end else if m_datasetType = 1 then begin // BREAST (Опухоль)
          retCode := breastTrainData(PAnsiChar(AnsiString(m_breastFile)),
                        m_breastSorce + 1, @m_dataPoint, @m_labelPoint,
                        @dataParam, @labelParam,
                        m_trainQty, m_stepNumber);
          dataLength := dataParam.bsz * dataParam.w * dataParam.h * dataParam.ch;
      end;
//      if m_sendDataType = 0  then begin
//        datas := m_trainData;
//        labels := m_trainLabel;
//      end else begin
//        datas := m_testData;
//        labels := m_testLabel;
//      end;
//      if FileExists(datas) AND FileExists(labels) then begin
//        parameters := dataset.mnistParameters(m_id);
//        SetLength(dataPoint, m_trainQty * m_width * m_height * m_depth);
//        SetLength(labelPoint,m_trainQty);
//        returnCode := dataset.readMnist(m_id, @dataPoint[0], @labelPoint[0],
//                                        m_trainQty, m_stepNumber);
//        if returnCode <> STATUS_OK then begin
//          ErrorEvent('Read MNIST db is failure!', msError, VisualObject);
//          Exit;
//        end;
        for I := 0 to dataLength - 1 do
          Y[0].Arr^[I] := m_dataPoint[I];
        for I := 0 to labelParam.bsz - 1 do
          Y[1].Arr^[I] := m_labelPoint[I];
        Y[2].Arr^[0] := m_width;
        Y[3].Arr^[0] := m_height;
        Y[4].Arr^[0] := m_depth;
//      end else begin
//        ErrorEvent('MNIST files not exist!', msError, VisualObject);
//        Exit;
//      end;
      inc(m_stepNumber);
    end;
    f_Stop: begin

    end;
  end
end;

  Function TDataSet.checkFiles(): Boolean;
  begin
    Result := True;
    if m_datasetType = 0 then begin  // MNIST
      if m_sendDataType = 0  then begin
        if not FileExists(m_trainData) AND not FileExists(m_trainlabel) then begin
          ErrorEvent('MNIST files with train is not exist!', msError, VisualObject);
          Result := False;
        end;
      end else begin
        if not FileExists(m_testData) AND not FileExists(m_testLabel) then begin
          ErrorEvent('MNIST files with test is not exist!', msError, VisualObject);
          Result := False;
        end;
      end;
    end else if m_datasetType = 1 then begin // BREAST (Опухоль)
      if not FileExists(m_breastFile) then begin
        ErrorEvent('MNIST files with train is not exist!', msError, VisualObject);
        Result := False;
      end;
    end;

  end;
end.
