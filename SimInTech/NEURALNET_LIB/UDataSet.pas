//**************************************************************************//
 // Данный исходный код является составной частью системы             //
 // Программист:        Никишин Е. В.                                        //
 //**************************************************************************//

unit UDataSet;

interface

uses Windows, Classes, DataTypes, SysUtils, RunObjts, dataset;

type
  TDataSetType = (dtMNIST, dtBREAST, dtWINE, dtIRIS, dtBOSTON, dtBIKE, dtTITANIC);

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
     m_fLabelPoint: array of Single;   /// Метки для
     m_id: Integer;

     m_datasetType: Cardinal;  /// Тип набора
     m_sendDataType : Cardinal; /// Отправляемый тип (тренировочные или тестовые)
     m_trainData: String; /// Расположение тренировочных данных
     m_trainlabel: String;  /// Расположение тренировочных меток
     m_testData: String;  /// Расположение тестовых данных
     m_testLabel: String; /// Расположение тестовых меток
     m_breastSource: Cardinal; /// Источник информации о больных раком
     m_breastFile: String; /// Файл с данными о больных
     m_wine: String; /// Классификация вин
     m_iris: String; /// Классификация ирисов
     m_bostonTrain: String;  /// Цена квартир (тренировка)
     m_bostonTest: String;  ///  Цена квартир (тест)
     m_bikeDay: String; /// Прокат велосипедов по дням
     m_bikeHour: String; /// Прокат велосипедов по часам
     m_bikeTime: Cardinal; /// Тип набора (0 - по дням, 1 - по часам)
     m_titanicTrain: String;  /// Выживет ли пассажир (тренировка)
     m_titanicTest: String; /// Выживет ли пассажир (тест)
     m_trainQty : Integer; /// Количество считываемых данны
     m_lastDatasetType: TDataSetType; /// Сохраним последний тип
     m_lastSendDataType : Cardinal; /// Сохраним последний тип данных
     m_latestBreastSrc : Cardinal; /// Сохраним последний тип раковой опухоли
     m_latestBikeTime : Cardinal; /// Сохраним последний тип набора проката велосипедов

     /// Проверка наличия файлов с датасетом
     Function checkFiles(): Boolean;
  end;

implementation

uses keras, UNNConstants, NN_Texts;

constructor  TDataSet.Create;
begin
  inherited;
  m_stepNumber:= 0;
  m_width := 1;
  m_height := 1;
  m_depth := 1;
  m_id := -1;
  m_bikeTime := 0;
  m_dataPoint := Nil;
  m_labelPoint := Nil;
  m_fLabelPoint := Nil;
end;

destructor   TDataSet.Destroy;
begin
  inherited;
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
      Result:=NativeInt(@m_breastSource);
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
    end else if StrEqu(ParamName,'bike_time') then begin
      Result:=NativeInt(@m_bikeTime);
      DataType:=dtInteger;
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
      if m_datasetType = Cardinal(dtMNIST) then begin
        m_width := 28;
        m_height := 28;
        m_depth := 1;
        if m_trainQty = 0 then
          m_trainQty := 1000;
      end else if m_datasetType = Cardinal(dtBREAST) then begin
        breastTrainData(PAnsiChar(AnsiString(m_breastFile)),
                        m_breastSource + 1, @m_dataPoint, @m_labelPoint,
                        @dataParam, @labelParam,0,0);
        m_width := dataParam.w;
        m_height := dataParam.h;
        m_depth := dataParam.ch;
        if m_trainQty = 0 then
          m_trainQty := dataParam.bsz;
      end else if m_datasetType = Cardinal(dtWINE) then begin
        wineTrainData(PAnsiChar(AnsiString(m_wine)),
                      @m_dataPoint, @m_labelPoint,
                      @dataParam, @labelParam,0,0);
        m_width := dataParam.w;
        m_height := dataParam.h;
        m_depth := dataParam.ch;
        if m_trainQty = 0 then
          m_trainQty := dataParam.bsz;
      end else if m_datasetType = Cardinal(dtIRIS) then begin
        irisTrainData(PAnsiChar(AnsiString(m_iris)),
                      @m_dataPoint, @m_labelPoint,
                      @dataParam, @labelParam,0,0);
        m_width := dataParam.w;
        m_height := dataParam.h;
        m_depth := dataParam.ch;
        if m_trainQty = 0 then
          m_trainQty := dataParam.bsz;
      end else if m_datasetType = Cardinal(dtBOSTON) then begin
        if m_sendDataType = 0 then begin
          bostonTrainData(PAnsiChar(AnsiString(m_bostonTrain)),
                          @m_dataPoint, @m_flabelPoint,
                          @dataParam, @labelParam,0,0);
        end else begin
          bostonTrainData(PAnsiChar(AnsiString(m_bostonTest)),
                          @m_dataPoint, Nil,
                          @dataParam, @labelParam,0,0);
        end;
        m_width := dataParam.w;
        m_height := dataParam.h;
        m_depth := dataParam.ch;
        if m_trainQty = 0 then
          m_trainQty := dataParam.bsz;
      end else if m_datasetType = Cardinal(dtBIKE) then begin
        if m_bikeTime = 0 then begin
          bikeTrainData(PAnsiChar(AnsiString(m_bikeDay)), True,
                      @m_dataPoint, @m_flabelPoint,
                      @dataParam, @labelParam, 0, 0);
        end else begin
          bikeTrainData(PAnsiChar(AnsiString(m_bikeHour)), False,
                      @m_dataPoint, @m_flabelPoint,
                      @dataParam, @labelParam, 0, 0);
        end;
        m_width := dataParam.w;
        m_height := dataParam.h;
        m_depth := dataParam.ch;
        if m_trainQty = 0 then
          m_trainQty := dataParam.bsz;
      end else if m_datasetType = Integer(dtTITANIC) then begin
        if m_sendDataType = 0 then begin
          titanicTrainData(PAnsiChar(AnsiString(m_titanicTrain)),
                        @m_dataPoint, @m_labelPoint,
                        @dataParam, @labelParam,0,0);
        end else begin
          titanicTrainData(PAnsiChar(AnsiString(m_titanicTest)),
                        @m_dataPoint, Nil,
                        @dataParam, @labelParam, 0,0);
        end;
        m_width := dataParam.w;
        m_height := dataParam.h;
        m_depth := dataParam.ch;
        if m_trainQty = 0 then
          m_trainQty := dataParam.bsz;
      end;
      cY[0] := m_trainQty * m_width * m_height * m_depth; // Количество данных = количеству наборов * W * H
      cY[1] := m_trainQty; // Количество меток = количеству наборов
      cY[2] := 3;
    end;
  else
    Result:=inherited InfoFunc(Action,aParameter);
  end
end;

function   TDataSet.RunFunc;
var
  returnCode: TStatus;
  i, j: Integer;
  dataParam, labelParam: keras.TLayerSize;
  dataLength: Integer;
begin
  Result:=0;
  dataLength := 0;
  returnCode := 0;
  case Action of
    f_UpdateOuts: begin

    end;
    f_InitState: begin
      m_stepNumber := 0;
      m_lastDatasetType :=  TDataSetType(m_datasetType);
      m_lastSendDataType := m_sendDataType;
      m_latestBreastSrc := m_breastSource;
      m_latestBikeTime := m_bikeTime;
      // Зануление выходных портов
      for I := 0 to cY.Count - 1 do begin
        cY.Arr^[I] := 0;
        for J := 0 to Y[I].Count - 1 do  begin
          Y[I].Arr^[J] := 0;
        end;
      end;
      if checkFiles = False then begin // Проверка на существование файлов
        Result := r_Fail;
        Exit;
      end;
    end;
    f_GoodStep: begin
      if (m_lastDatasetType <> TDataSetType(m_datasetType)) OR
         (m_lastSendDataType <> m_sendDataType) OR
         (m_latestBreastSrc <> m_breastSource) OR
         (m_latestBikeTime <> m_bikeTime) then
      begin
        ErrorEvent(txtDS_NotEqualsLoadSet, msWarning, VisualObject);
        Result := r_Fail;
        Exit;
      end;
      if m_lastDatasetType = dtMNIST then begin  // MNIST
        if m_lastSendDataType = 0 then begin
          returnCode := mnistTrainData(PAnsiChar(AnsiString(m_trainData)),
                                    PAnsiChar(AnsiString(m_trainlabel)),
                                    @m_dataPoint, @m_labelPoint,
                                    @dataParam, @labelParam,
                                    m_trainQty, m_stepNumber);
          dataLength := dataParam.bsz * dataParam.w * dataParam.h * dataParam.ch;
        end else begin
          returnCode := mnistTrainData(PAnsiChar(AnsiString(m_testData)),
                                    PAnsiChar(AnsiString(m_testLabel)),
                                    @m_dataPoint, @m_labelPoint,
                                    @dataParam, @labelParam,
                                    m_trainQty, m_stepNumber);
          dataLength := dataParam.bsz * dataParam.w * dataParam.h * dataParam.ch;
        end;
      end else if m_lastDatasetType = dtBREAST then begin // BREAST (Опухоль)
          returnCode := breastTrainData(PAnsiChar(AnsiString(m_breastFile)),
                        m_breastSource + 1, @m_dataPoint, @m_labelPoint,
                        @dataParam, @labelParam,
                        m_trainQty, m_stepNumber);
          dataLength := dataParam.bsz * dataParam.w * dataParam.h * dataParam.ch;
      end else if m_lastDatasetType = dtWINE then begin // WINE (Классификация вин)
          returnCode := wineTrainData(PAnsiChar(AnsiString(m_wine)),
                        @m_dataPoint, @m_labelPoint,
                        @dataParam, @labelParam,
                        m_trainQty, m_stepNumber);
          dataLength := dataParam.bsz * dataParam.w * dataParam.h * dataParam.ch;
      end else if m_lastDatasetType = dtIRIS then begin // WINE (Классификация вин)
          returnCode := irisTrainData(PAnsiChar(AnsiString(m_iris)),
                        @m_dataPoint, @m_labelPoint,
                        @dataParam, @labelParam,
                        m_trainQty, m_stepNumber);
          dataLength := dataParam.bsz * dataParam.w * dataParam.h * dataParam.ch;
      end else if m_lastDatasetType = dtBOSTON then begin //
      if m_lastSendDataType = 0 then begin
          returnCode := bostonTrainData(PAnsiChar(AnsiString(m_bostonTrain)),
                          @m_dataPoint, @m_fLabelPoint,
                          @dataParam, @labelParam, m_trainQty, m_stepNumber);
        end else begin
          returnCode := bostonTrainData(PAnsiChar(AnsiString(m_bostonTest)),
                          @m_dataPoint, Nil,
                          @dataParam, @labelParam, m_trainQty, m_stepNumber);
        end;
        dataLength := dataParam.bsz * dataParam.w * dataParam.h * dataParam.ch;
      end else if m_lastDatasetType = dtBIKE then begin // WINE (Классификация вин)
        if m_bikeTime = 0 then begin
          returnCode := bikeTrainData(PAnsiChar(AnsiString(m_bikeDay)), True,
                      @m_dataPoint, @m_flabelPoint,
                      @dataParam, @labelParam, m_trainQty, m_stepNumber);
        end else begin
          returnCode := bikeTrainData(PAnsiChar(AnsiString(m_bikeHour)), False,
                      @m_dataPoint, @m_flabelPoint,
                      @dataParam, @labelParam, m_trainQty, m_stepNumber);
        end;
        dataLength := dataParam.bsz * dataParam.w * dataParam.h * dataParam.ch;
      end else if m_lastDatasetType = dtTITANIC then begin // TITANIC (Выживет ли пассажир)
        if m_lastSendDataType = 0 then begin
          returnCode := titanicTrainData(PAnsiChar(AnsiString(m_titanicTrain)),
                                      @m_dataPoint, @m_labelPoint,
                                      @dataParam, @labelParam, m_trainQty, m_stepNumber);
        end else begin
          returnCode := titanicTrainData(PAnsiChar(AnsiString(m_titanicTest)),
                                      @m_dataPoint, Nil,
                                      @dataParam, @labelParam, m_trainQty, m_stepNumber);
        end;
        dataLength := dataParam.bsz * dataParam.w * dataParam.h * dataParam.ch;
      end;
      if returnCode <> STATUS_OK then begin
        ErrorEvent(txtDS_NotLoaded, msError, VisualObject);
        Result := r_Fail;
        Exit;
      end;

      for I := 0 to dataLength - 1 do
        Y[0].Arr^[I] := m_dataPoint[I];
      if (m_lastDatasetType = dtBOSTON) OR (m_lastDatasetType = dtBIKE) then begin
        if m_lastSendDataType = 0 then begin
          for I := 0 to labelParam.bsz - 1 do
            Y[1].Arr^[I] := m_fLabelPoint[I];
        end;
      end else begin
        if (m_lastDatasetType = dtTITANIC) AND (m_lastSendDataType = 1) then begin

        end else begin
          for I := 0 to labelParam.bsz - 1 do
            Y[1].Arr^[I] := m_labelPoint[I];
        end;
      end;
      Y[2].Arr^[0] := m_width;
      Y[2].Arr^[1] := m_height;
      Y[2].Arr^[2] := m_depth;
      inc(m_stepNumber);
    end;
    f_Stop: begin
      if (m_lastDatasetType = dtBOSTON) OR (m_lastDatasetType = dtBIKE) then begin
        freeTrainDataF(@m_dataPoint, @m_flabelPoint);
      end else begin
        freeTrainData(@m_dataPoint, @m_labelPoint);
      end;
    end;
  end
end;

  Function TDataSet.checkFiles(): Boolean;
  begin
    Result := True;
    if m_datasetType = Cardinal(dtMNIST) then begin  // MNIST
      if m_sendDataType = 0  then begin
        if (FileExists(m_trainData) = False) OR (FileExists(m_trainlabel) = False) then begin
          ErrorEvent(txtDS_MNISTTrainNF, msError, VisualObject);
          Result := False;
        end;
      end else begin
        if (FileExists(m_testData) = False) OR (FileExists(m_testLabel) = False) then begin
          ErrorEvent(txtDS_MNISTTestNF, msError, VisualObject);
          Result := False;
        end;
      end;
    end else if m_datasetType = Cardinal(dtBREAST) then begin // BREAST (Опухоль)
      if not FileExists(m_breastFile) then begin
        ErrorEvent(txtDS_BreastTrainNF, msError, VisualObject);
        Result := False;
      end;
    end else if m_datasetType = Cardinal(dtWINE) then begin // wine (Вино)
      if not FileExists(m_wine) then begin
        ErrorEvent(txtDS_WineTrainNF, msError, VisualObject);
        Result := False;
      end;
    end else if m_datasetType = Cardinal(dtIRIS) then begin // iris (Ирисы Фишера)
      if not FileExists(m_iris) then begin
        ErrorEvent(txtDS_IrisTrainNF, msError, VisualObject);
        Result := False;
      end;
    end else if m_datasetType = Cardinal(dtBOSTON) then begin // Boston (цена квартиры)
      if (FileExists(m_bostonTrain) = False) AND (m_sendDataType = 0) then begin
        ErrorEvent(txtDS_BostonTrainNF, msError, VisualObject);
        Result := False;
      end else if (FileExists(m_bostonTest) = False) AND (m_sendDataType = 1) then begin
        ErrorEvent(txtDS_BostonTrainNF, msError, VisualObject);
        Result := False;
      end;
    end else if m_datasetType = Cardinal(dtBIKE) then begin // Bike (прокат великов)
      if (FileExists(m_bikeDay) = False) AND (m_bikeTime = 0) then begin
        ErrorEvent(txtDS_BikeTrainNF, msError, VisualObject);
        Result := False;
      end else if (FileExists(m_bikeHour) = False) AND (m_bikeTime = 1) then begin
        ErrorEvent(txtDS_BikeTrainNF, msError, VisualObject);
        Result := False;
      end;
    end else if m_datasetType = Cardinal(dtTITANIC) then begin // Titanic (Пассажиры Титаника)
    if (FileExists(m_titanicTrain) = False) AND (m_sendDataType = 0) then begin
      ErrorEvent(txtDS_TitanicTrainNF, msError, VisualObject);
      Result := False;
    end else if (FileExists(m_titanicTest) = False) AND (m_sendDataType = 1) then begin
      ErrorEvent(txtDS_TitanicTrainNF, msError, VisualObject);
      Result := False;
    end;
    end;
  end;
end.
