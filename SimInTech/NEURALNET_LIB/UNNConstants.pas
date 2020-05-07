unit UNNConstants;

interface

type
  TDataArr = array of Single;
  PDataArr = ^TDataArr;

const
  UNN_NNMAGICWORD = 1; // Окончании создании сети
  UNN_DATASEMNIST = 2; // Окончании считывани¤ MNIST и отправка всего набора
  UNN_DATASTEPBYSTEP = 3; // Пойдут наборы данных шаг за шагом

  UNN_SIZE_WITHDATA = 4; // Размер данных выходного порта (с данными)

  UNN_MAX_LAYER_OUT = 3; // Максимальное количество выходных портов для слоев

implementation

end.
