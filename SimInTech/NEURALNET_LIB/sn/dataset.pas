unit dataset;

interface
uses
  keras
  ;

type
  // Данные для наборов MNIST
  pMNIST_DATA = ^TMNIST_DATA;
  TMNIST_DATA = Record
     quantity: Integer; // Количество данных
     rows: Integer;     // Количество строк в одном данном
     cols: Integer;     // Количество столбцов в одном данном
     channels: Integer; // Количество каналов
     end;
/// Создает очередной dataset
/// dataFile файл с данными
/// labelFile файл с метками
/// return -1 - ошибка, N - id
  Function createMnistDataset(dataFile: PAnsiChar; labelFile: PAnsiChar):
                              Integer; cdecl; external KERAS_EXPORT;
/// Освобождает память dataset'а
  Function deleteMnistDataset(id : Integer): keras.TStatus; cdecl; external KERAS_EXPORT;
/// Считывает данные из БД MNIST в массивы  datas, labels
  Function readMnist(id : Integer; datas : PSingle; labels : PByte; qty: Cardinal = 0;
                     step: Cardinal = 0): keras.TStatus; cdecl; external KERAS_EXPORT;

/// Возвращает данные тренировочного набора MNIST
  Function mnistParameters(id : Integer) : TMNIST_DATA; cdecl; external KERAS_EXPORT;

implementation

end.

