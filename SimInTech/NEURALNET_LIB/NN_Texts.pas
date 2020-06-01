unit NN_Texts;


interface

const

  {$IFNDEF ENG}

  txtNN_ModelNotAdded       = '���������� �������� ���� � ������: ';
  txtNN_NCreated = '��������� ������ �� ���� �������';
  txtNN_TestCrash = '������� ������������ ���������� �������';
  txtNN_TrainCrash = '������� ���������� ���������� �������';
  txtNN_WeightLoad = '�������� ����� ��� ������ ����������� ������';
  txtNN_ModelSave = '���������� ���������� ������ ����������� ������';
  txtNN_WeightOpen = '���������� ������� ���� � ������ ������';
  txtNN_DataSize = '������������ �������� ��������� ������ � ��������� ��������� ������';
  txtNN_NoInputLayer = '��� �������� ����';
  txtNN_NetFileNotFound = '���� ���� �� ����������';
  txtNN_CrossOutFail = '������ ��������� ���� <= 0';
  txtDS_NotLoaded = '����� �������� ����� �� ��� ��������';
  txtDS_NotEqualsLoadSet = '��� ������� ����� �� ����� �������������';
  txtDS_MNISTTrainNF = '����� �������������� ������ MNIST �� ����������';
  txtDS_MNISTTestNF = '����� ��������� ������ MNIST �� ����������';
  txtDS_BreastTrainNF = '����� ������ � �������� �� ����������';
  txtDS_WineTrainNF = '����� ������ � ������� ���� �� ����������';
  txtDS_IrisTrainNF = '����� ������ � ������� ������ �� ����������';
  txtDS_BostonTrainNF = '����� ������ � ������ �� �������� �� ����������';
  txtDS_BikeTrainNF = '����� ������ � ����������� ������ � ������ ����������� �� ����������';
  txtDS_TitanicTrainNF = '����� ������ � ����������� �������� �� ����������';
  {$ELSE}

  txtNN_ModelNotAdded       = 'Neural model not added layer: ';
  txtNN_NCreated = 'Neural model not created';
  txtNN_TestCrash = 'Test process is crashed';
  txtNN_TrainCrash = 'Train process is crashed';
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
