unit dataset;

interface
uses
  keras
  ;

type
  // Данные для наборов MNIST
  pMNIST_DATA = ^TMNIST_DATA;
  TMNIST_DATA = Record
     data: ^Single;     // Нормализованные данные
     labels: ^Byte;     // Метки
     quantity: Integer; // Количество данных
     rows: Integer;     // Количество строк в одном данном
     cols: Integer;     // Количество столбцов в одном данном
     end;

  // Чтение БД с MNIST
  // path - Путь к файлам БД
  // return - состояние
  Function readMnist(path: PChar): keras.TStatus; cdecl; external KERAS_EXPORT;

  // Возвращает данные тренировочного набора MNIST
  Function mnistTrainParams(): TMNIST_DATA; cdecl; external KERAS_EXPORT;
  // Возвращает данные тестового набора MNIST
  Function mnistTestParams(): TMNIST_DATA; cdecl; external KERAS_EXPORT;

implementation

end.

