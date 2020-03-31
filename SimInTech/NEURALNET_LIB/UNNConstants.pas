unit UNNConstants;

interface

type
  TDataArr = array of Single;
  PDataArr = ^TDataArr;

const
  UNN_NNMAGICWORD = 1; // Окончании создании сети
  UNN_DATASEMNIST = 2; // Окончании считывани¤ MNIST и отправка всего набора
  UNN_DATASTEPBYSTEP = 3; // Пойдут наборы данных шаг за шагом

implementation

end.
