unit keras;

interface
const
{$ifdef FPC}
  KERAS_EXPORT = 'libsnkeras.so';
{$else}
  KERAS_EXPORT = 'snkeras.dll';
{$endif}

type
  TStatus = Integer;  // Статус выполнения задачи
  TActivation = Integer; // Функции активации
  TOptimizer = Integer; // Метод оптимизации
  TBatchNormType = Integer; // Типы нормализации наборов
  TLossType = Integer; // Типы функции потерь
  TPoolType = Integer; // Типы объединения
  TSummatorType = Integer; // Типы суммирования

  // Размер данных в слое
  pLayerSize = ^TLayerSize;
  TLayerSize = Record
     w: Cardinal;  // Ширина
     h: Cardinal;  // Длина
     ch: Cardinal; // Канальность
     bsz: Cardinal;// Количество данных  в наборе
     end;

const
  STATUS_OK = 0; ///< Успешное выполнение задачи
  STATUS_FAILURE = 1; ///< Критическая ошибка
  STATUS_WARNING = 2; ///< Задача выполнена, но были проблемы

  ACTIV_NONE = -1;      // Без функции активации
  ACTIV_SIGMOID = 0;    // Сигмойдная функция
  ACTIV_RELU = 1;       // Функция RELU
  ACTIV_LEAKY_RELU = 2; // Функция LEAKY RELU
  ACTIV_ELU = 3;        // Функция ELU

  OPTIM_SGD = 0;
  OPTIM_SGD_MOMENT = 1;
  OPTIM_ADAGRAD = 2;
  OPTIM_RMSPROP = 3;
  OPTIM_ADAM = 4;

  BATCH_NONE = -1;         // Без нормализации
  BATCH_BEFORE_ACTIVE = 0; // до активации
  BATCH_POST_ACTIVE = 1;   // после активации

  LOSS_SOFTMAX_CROSS_ENTROPY = 0;
  LOSS_BINARY_CROSS_ENTROPY = 1;
  LOSS_REGRESSION_MSE = 2;
  LOSS_USER_LOSS = 3;  // Пользовтельская функция потерь

  POOL_MAX = 0; //  Тип объединения по максимуму
  POOL_AVG = 1; //  Тип объединения по среднему

  SUMMATOR_SUMM = 0;
  SUMMATOR_DIFF = 1;
  SUMMATOR_MEAN = 2;

// Создание модели
// return id модели или -1
Function createModel(): Integer; cdecl; external KERAS_EXPORT;

/// Удаление модели
Function deleteModel(id : Integer): TStatus; cdecl; external KERAS_EXPORT;

// addInput Добавляет сходной слой
// name Имя слоя
// nodes узли с которыми связан слой (через пробел)
// Статус добавления входного слоя в модель
Function addInput(id : Integer; name: PAnsiChar; nodes: PAnsiChar): TStatus; cdecl; external KERAS_EXPORT;

// addConvolution Добавляет сверточный слой
// name Имя слоя
// nodes узлы с которыми связан слой (через пробел)
// return Статус добавления слоя в модель
Function addConvolution(id : Integer; name: PAnsiChar; nodes: PAnsiChar;
                        filters_: Cardinal;
                        act_: TActivation = ACTIV_RELU;
                        opt_: TOptimizer = OPTIM_ADAM;
                        dropOut_: Single = 0.0;
                        bnorm_: TBatchNormType = BATCH_NONE;
                        fWidth_: Cardinal = 3;
                        fHeight_: Cardinal = 3;
                        padding_: Integer = 0;
                        stride_: Cardinal = 1;
                        dilate_: Cardinal = 1;
                        gpuDeviceId_: Cardinal = 0
                        ): TStatus; cdecl; external KERAS_EXPORT;

// addDeconvolution Добавляет анти-сверточный слой
// name Имя слоя
// nodes узлы с которыми связан слой (через пробел)
// act_ функция активации
// opt_ Оптимизатор
// dropOut_
// bnorm_
// fWidth_
// fHeight_
// stride_
// gpuDeviceId_ ID видеокарты для рсчетов
// return Статус добавления слоя в модель
Function addDeconvolution(id : Integer; name: PAnsiChar; nodes: PAnsiChar;
                          filters_: Cardinal;
                          act_: TActivation = ACTIV_RELU;
                          opt_: TOptimizer = OPTIM_ADAM;
                          dropOut_: Single = 0.0;
                          bnorm_: TBatchNormType = BATCH_NONE;
                          fWidth_: Cardinal = 3;
                          fHeight_: Cardinal = 3;
                          stride_: Cardinal = 1;
                          gpuDeviceId_: Cardinal = 0
                          ) : TStatus; cdecl; external KERAS_EXPORT;


// brief addPooling Добавляет слой объединения
// name Имя слоя
// nodes узлы с которыми связан слой (через пробел)
// kernel_
// stride_
// pool_
// gpuDeviceId_ ID видеокарты для рсчетов
// return Статус добавления слоя в модель
Function addPooling(id : Integer; name: PAnsiChar; nodes: PAnsiChar;
                    kernel_: Cardinal;
                    stride_: Cardinal;
                    pool_: TPoolType = POOL_MAX;
                    gpuDeviceId_: Cardinal = 0
                    ) : TStatus; cdecl; external KERAS_EXPORT;

// addDense Добавляет плотный слой
// name Имя слоя
// nodes узли с которыми связан слой (через пробел)
// return Статус добавления слоя в модель
Function addDense(id : Integer; name: PAnsiChar; nodes: PAnsiChar; units_: Cardinal;
                  act_: TActivation = ACTIV_RELU;
                  opt_: TOptimizer = OPTIM_ADAM;
                  dropOut_: Single = 0.0;
                  bnorm_: TBatchNormType = BATCH_NONE;
                  gpuDeviceId_: Cardinal = 0
                  ): TStatus; cdecl; external KERAS_EXPORT;

// addConcat Слой объединения
// name Имя слоя
// nodes узлы с которыми связан слой (через пробел)
// sequence Имена объединяемых слоев (через пробел)
// return Статус добавления слоя в модель
Function addConcat(id : Integer; name: PAnsiChar; nodes: PAnsiChar; sequence: PAnsiChar): TStatus; cdecl; external KERAS_EXPORT;

// addResize Слой изменения размера
// name Имя слоя
// nodes узлы с которыми связан слой (через пробел)
// fwdBegin Начальное значение перед
// fwdEnd Конечное значение перед
// bwdBegin Начальное значение зад
// bwdEnd Конечное значение зад
// return Статус добавления слоя в модель
Function addResize(id : Integer; name: PAnsiChar; nodes: PAnsiChar; fwdBegin : Cardinal; fwdEnd : Cardinal;
                              bwdBegin : Cardinal; bwdEnd : Cardinal): TStatus; cdecl; external KERAS_EXPORT;

// addCrop Отсечение каналов в изображении
// name Имя слоя
// nodes узлы с которыми связан слой (через пробел)
// x координата
// y координата
// w длина
// h ширина
// return Статус добавления слоя в модель
Function addCrop(id : Integer; name: PAnsiChar; nodes: PAnsiChar; x : Cardinal; y : Cardinal;
                 w : Cardinal; h : Cardinal): TStatus; cdecl; external KERAS_EXPORT;

// addSummator Добавляет слой сумирования
// name Имя слоя
// nodes узлы с которыми связан слой (через пробел)
// type тип сумирования
// return Статус добавления слоя в модель
Function addSummator(id : Integer; name: PAnsiChar; nodes: PAnsiChar; type_ : TSummatorType): TStatus; cdecl; external KERAS_EXPORT;

// addActivator Добавляет слой с ф-ией активации
// name Имя слоя
// nodes узлы с которыми связан слой (через пробел)
// active Функции активации
// return Статус добавления слоя в модель
Function addActivator(id : Integer; name: PAnsiChar; nodes: PAnsiChar; active: TActivation): TStatus; cdecl; external KERAS_EXPORT;

// addLossFunction Добавляет функцию потерь в модель
// name Имя слоя
// nodes  узли с которыми связан слой (через пробел)
// loss_ тип функции потерь
// return Статус добавления слоя в модель
Function addLossFunction(id : Integer; name: PAnsiChar; nodes: PAnsiChar;
                         loss_: TLossType): TStatus; cdecl; external KERAS_EXPORT;

// netArchitecture Записывает архитектуру сети в JSON виде
// buffer Буфер для записи
// length Размер буфера
//return Статус вывода архитектуры
Function netArchitecture(id : Integer; buffer: PAnsiChar; length: Cardinal
                         ): TStatus; cdecl; external KERAS_EXPORT;

// fit Запуск упрощенной тренировки для известных наборов
// data тренировочные данные
// dataSize количество тренировочных данных
// label метки тренировочных данных
// labelsSize количество меток
// epochs @brief Эпохи
// classes вероятностное распределения на N классов
// Статус тренировки
Function fit(id : Integer; data: PSingle; dataSize: TLayerSize;
             label_: PByte; labelsSize: TLayerSize;
             epochs: Cardinal; learningRate: Single; var accuracy : Single
             ): TStatus; cdecl; external KERAS_EXPORT;

Function fitOneValue(id : Integer; data: PSingle; dataSize: TLayerSize;
                     label_: PSingle; labelsSize: TLayerSize;
                     epochs: Cardinal; learningRate: Single; var accuracy : Single
                     ) : TStatus; cdecl; external KERAS_EXPORT;

// evaluate Проверка с тестовым сетом
// data тестовые данные
// dataSize количество тестовых данных
// label метки тестовые данных
// labelsSize количество меток
// verbose уровень подробности
// return Статус тестирования
Function evaluate(id : Integer; data: PSingle; dataSize: TLayerSize;
                  label_: PByte; labelsSize: TLayerSize;
                  verbose: Cardinal; var accuracy : Single; ans_: PByte = Nil
                  ): TStatus; cdecl; external KERAS_EXPORT;

Function forecasting(id : Integer; data: PSingle; dataSize: TLayerSize;
                     label_: PSingle; labelsSize : TLayerSize
                    ): TStatus; cdecl; external KERAS_EXPORT;

Function run(id : Integer; data: PSingle; dataSize: TLayerSize;
                  labelsSize: TLayerSize; var result : Integer
                  ): TStatus; cdecl; external KERAS_EXPORT;

// saveModel Сохраняет модель с весами
// filename имя с путем
// return Статус сохранения
Function saveModel(id : Integer; filename: PAnsiChar): TStatus; cdecl; external KERAS_EXPORT;

// saveModel Загружает модель с весами
// filename имя с путем
// return Статус загрузки
Function loadModel(id : Integer; filename: PAnsiChar): TStatus; cdecl; external KERAS_EXPORT;

// lastError Вывод последней ошибки в буфер
// buffer Буфер для текста ошибки
// length размер буфера
Procedure lastError(id : Integer; buffer: PAnsiChar; length: Cardinal); cdecl; external KERAS_EXPORT;

// printLastError Вывод последней ошибки в stdout
Procedure printLastError(id : Integer; status: TStatus); cdecl; external KERAS_EXPORT;

implementation

end.

