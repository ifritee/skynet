unit dataset;

interface
uses
  keras
  ;
type
  PPSingle = ^PSingle;
  PPByte = ^PByte;

/// @brief mnistTrainData Считывание данных из БД MNIST
/// @param datafilename Имя файла с данными
/// @param labelfilename Имя файла с метками
/// @param data Хранилище данных для записи
/// @param label Хранилище меток для записи
/// @param sizeData Параметры считываемых данных
/// @param sizeLabel Параметры считываемых меток
/// @param qty Количество, считываемое за раз
/// @param step Шаг считывания
/// @return Состояние считывания
Function mnistTrainData(datafilename : PAnsiChar;
                        labelfilename : PAnsiChar;
                        data_ : PPSingle;
                        label_ : PPSingle;
                        sizeData : PLayerSize;
                        sizeLabel : PLayerSize;
                        qty: Integer; step: Integer
                        ) : keras.TStatus; cdecl; external KERAS_EXPORT;

/// @brief bikeTrainData Считывание данных о количестве велосипедов взятых в аренду
/// @param filename Имя файла с данными
/// @param isDay Флаг (0 - за час, 1 - за день)
/// @param data Хранилище данных для записи
/// @param label Хранилище меток для записи
/// @param sizeData Параметры считываемых данных
/// @param sizeLabel Параметры считываемых меток
/// @param qty Количество, считываемое за раз
/// @param step Шаг считывания
/// @return Состояние считывания
Function bikeTrainData(filename : PAnsiChar;
                       isDay : Boolean;
                       data_ : PPSingle;
                       label_ : PPSingle;
                       sizeData : PLayerSize;
                       sizeLabel : PLayerSize;
                       qty: Integer; step: Integer
                       ) : keras.TStatus; cdecl; external KERAS_EXPORT;

/// @brief bostonTrainData Считывание данных о ценах аренды квартир в Бостоне
/// @param filename Имя файла с данными
/// @param data Хранилище данных для записи
/// @param label Хранилище меток для записи
/// @param sizeData Параметры считываемых данных
/// @param sizeLabel Параметры считываемых меток
/// @param qty Количество, считываемое за раз
/// @param step Шаг считывания
/// @return Состояние считывания
Function bostonTrainData(filename : PAnsiChar;
                         data_ : PPSingle;
                         label_ : PPSingle;
                         sizeData : PLayerSize;
                         sizeLabel : PLayerSize;
                         qty: Integer; step: Integer
                         ) : keras.TStatus; cdecl; external KERAS_EXPORT;

/// @brief breastTrainData Считывание данных о заболевших раком в Висконсине
/// @param filename Имя файла с данными
/// @param flag Флаг, показывающий тип считываемой информации (1 - Wisconsin, 2 - wdbc, 3 - wpbc)
/// @param data Хранилище данных для записи
/// @param label Хранилище меток для записи
/// @param sizeData Параметры считываемых данных
/// @param sizeLabel Параметры считываемых меток
/// @param qty Количество, считываемое за раз
/// @param step Шаг считывания
/// @return Состояние считывания
Function breastTrainData(filename : PAnsiChar;
                         flag_ : Integer;
                         data_ : PPSingle;
                         label_ : PPSingle;
                         sizeData : PLayerSize;
                         sizeLabel : PLayerSize;
                         qty: Integer; step: Integer
                         ) : keras.TStatus; cdecl; external KERAS_EXPORT;

/// @brief irisTrainData Считывание данных о сортах Ирисов (Ирисы Фишера)
/// @param filename Имя файла с данными
/// @param data Хранилище данных для записи
/// @param label Хранилище меток для записи
/// @param sizeData Параметры считываемых данных
/// @param sizeLabel Параметры считываемых меток
/// @param qty Количество, считываемое за раз
/// @param step Шаг считывания
/// @return Состояние считывания
Function irisTrainData(filename : PAnsiChar;
                           data_ : PPSingle;
                           label_ : PPByte;
                           sizeData : PLayerSize;
                           sizeLabel : PLayerSize;
                          qty: Integer; step: Integer
                           ) : keras.TStatus; cdecl; external KERAS_EXPORT;

/// @brief wineTrainData Считывание данных о сортах вин
/// @param filename Имя файла с данными
/// @param data Хранилище данных для записи
/// @param label Хранилище меток для записи
/// @param sizeData Параметры считываемых данных
/// @param sizeLabel Параметры считываемых меток
/// @param qty Количество, считываемое за раз
/// @param step Шаг считывания
/// @return Состояние считывания
Function wineTrainData(filename : PAnsiChar;
                           data_ : PPSingle;
                           label_ : PPByte;
                           sizeData : PLayerSize;
                           sizeLabel : PLayerSize;
                          qty: Integer; step: Integer
                           ) : keras.TStatus; cdecl; external KERAS_EXPORT;

/// @brief titanicTrainData Считывание данных о выживаемости пассажиров на борту Титаника
/// @param filename Имя файла с данными
/// @param data Хранилище данных для записи
/// @param label Хранилище меток для записи
/// @param sizeData Параметры считываемых данных
/// @param sizeLabel Параметры считываемых меток
/// @param qty Количество, считываемое за раз
/// @param step Шаг считывания
/// @return Состояние считывания

Function titanicTrainData(filename : PAnsiChar;
                           data_ : PPSingle;
                           label_ : PPByte;
                           sizeData : PLayerSize;
                           sizeLabel : PLayerSize;
                          qty: Integer; step: Integer
                           ) : keras.TStatus; cdecl; external KERAS_EXPORT;

/// @brief Освобождение памяти
Procedure freeTrainData(data_ : PPSingle; label_ : PPByte); cdecl; external KERAS_EXPORT;

/// @brief Освобождение памяти
Procedure freeTrainDataF(data_ : PPSingle; label_ : PPSingle); cdecl; external KERAS_EXPORT;

/// @brief Записывает последнюю ошибку в буфер
/// @param buffer Буфер
/// @param length Размер буфера
Procedure dsLastError(buffer: PAnsiChar; length: Cardinal); cdecl; external KERAS_EXPORT;

implementation

end.

