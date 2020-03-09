unit dataset;

interface
uses
  keras
  ;

type
  // Данные для наборов MNIST
  pMNIST_DATA = ^TMNIST_DATA;
  TMNIST_DATA = Record
     data: PSingle;     // Нормализованные данные
     labels: PByte;     // Метки
     quantity: Integer; // Количество данных
     rows: Integer;     // Количество строк в одном данном
     cols: Integer;     // Количество столбцов в одном данном
     end;

  // Чтение БД с MNIST
  // path - Путь к файлам БД
  // return - состояние
  Function readMnist(path: PAnsiChar): keras.TStatus; cdecl; external KERAS_EXPORT;

  // dataFile Полный путь к файлу БД с данным для тренировки
  // labelFile Полный путь к файлу БД с метками для тренировки
  // return состояние
 Function readMnistTrain(dataFile: PAnsiChar; labelFile: PAnsiChar; qty: Cardinal = 0): keras.TStatus; cdecl; external KERAS_EXPORT;

 // dataFile Полный путь к файлу БД с данным для тестирования
 // labelFile Полный путь к файлу БД с метками для тестирования
 // return состояние
 Function readMnistTest(dataFile: PAnsiChar; labelFile: PAnsiChar; qty: Cardinal = 0): keras.TStatus; cdecl; external KERAS_EXPORT;

  // Возвращает данные тренировочного набора MNIST
  Function mnistTrainParams(): TMNIST_DATA; cdecl; external KERAS_EXPORT;
  // Возвращает данные тестового набора MNIST
  Function mnistTestParams(): TMNIST_DATA; cdecl; external KERAS_EXPORT;

implementation

end.

