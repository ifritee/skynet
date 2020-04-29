unit NN_Texts;


interface

const

  {$IFNDEF ENG}

  txtNN_ModelNotAdded       = 'Невозможно добавить слой в модель: ';
  txtNN_NCreated = 'Нейронная модель не была создана';
  txtNN_TestCrash = 'Процесс тестирования завершился ошибкой';
  txtNN_WeightLoad = 'Загрузка весов для модели завершилась крахом';
  txtNN_ModelSave = 'Сохранение параметров модели завершилась крахом';
  txtNN_WeightOpen = 'Невозможно открыть файл с весами модели';
  txtNN_DataSize = 'Несовпадение размеров пришедших данных и максимума возможных данных';
  txtNN_NoInputLayer = 'Нет входного слоя';
  txtNN_NetFileNotFound = 'Файл сети не существует';
  txtNN_CrossOutFail = 'Размер выходного слоя <= 0';
  txtDS_NotLoaded = 'Набор тестовых задач не был загружен';
  txtDS_NotEqualsLoadSet = 'Был изменен набор во время моделирования';
  txtDS_MNISTTrainNF = 'Файлы тренировочного набора MNIST не существуют';
  txtDS_MNISTTestNF = 'Файлы тестового набора MNIST не существуют';
  txtDS_BreastTrainNF = 'Файлы набора с опухолью не существуют';
  txtDS_WineTrainNF = 'Файлы набора с сортами вина не существуют';
  txtDS_IrisTrainNF = 'Файлы набора с ирисами Фишера не существуют';
  txtDS_BostonTrainNF = 'Файлы набора с ценами на квартиры не существуют';
  txtDS_BikeTrainNF = 'Файлы набора с количеством взятых в аренду велосипедов не существуют';
  txtDS_TitanicTrainNF = 'Файлы набора с пассажирами Титаника не существуют';
  {$ELSE}

  txtNN_ModelNotAdded       = 'Neural model not added layer: ';
  txtNN_NCreated = 'Neural model not created';
  txtNN_TestCrash = 'Test process is crashed';
  txtNN_WeightLoad = 'Crashed load model weight';
  txtNN_ModelSave = 'Crashed save model parameters';
  txtNN_WeightOpen = 'Open weight file is crashed';
  txtNN_DataSize = 'Data size more Output size!';
  txtNN_NoInputLayer = 'Was not input layer';
  txtNN_NetFileNotFound = 'Net file not found';
  txtNN_CrossOutFail = 'Output layer size <= 0';
  txtDS_NotLoaded = 'Test set not loaded';
  txtDS_NotEqualsLoadSet = 'Dataset was changed during the simulation';
  txtDS_MNISTTrainNF = 'MNIST files with train set is not exist!';
  txtDS_MNISTTestNF = 'MNIST files with test set is not exist!';
  txtDS_BreastTrainNF = 'Breast files with train set is not exist!';
  txtDS_WineTrainNF = 'Wine files with train set is not exist!';
  txtDS_IrisTrainNF = 'Iris files with train set is not exist!';
  txtDS_BostonTrainNF = 'Apartment price files with train set is not exist!';
  txtDS_BikeTrainNF = 'Bike rent files with train set is not exist!';
  txtDS_TitanicTrainNF = 'Titanic passenger files with train set is not exist!';
  {$ENDIF}

implementation

end.
