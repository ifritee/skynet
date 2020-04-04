unit NN_Texts;


interface

const

  {$IFNDEF ENG}

  txtNN_ModelNotAdded       = 'Невозможно добавить слой в модель: ';
  txtNN_NCreated = 'Нейронная модель не была создана';
  txtNN_TestCrash = 'Процесс тестирования завершился ошибкой';
  txtNN_WeightLoad = 'Загрузка весов для модели завершилась крахом';
  txtNN_WeightSave = 'Сохранение весов для модели завершилась крахом';
  txtNN_WeightOpen = 'Невозможно открыть файл с весами модели';
  txtNN_DataSize = 'Несовпадение размеров пришедших данных и максимума возможных данных';
  txtDS_NotLoaded = 'Набор тестовых задач не был загружен';
  {$ELSE}

  txtNN_ModelNotAdded       = 'Neural model not added layer: ';
  txtNN_NCreated = 'Neural model not created';
  txtNN_TestCrash = 'Test process is crashed';
  txtNN_WeightLoad = 'Crashed load model weight';
  txtNN_WeightSave = 'Crashed save model weight';
  txtNN_WeightOpen = 'Open weight file is crashed';
  txtNN_DataSize = 'Data size more Output size!';
  txtDS_NotLoaded = 'Test set not loaded';
  {$ENDIF}

implementation

end.
