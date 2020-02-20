#include <iostream>

#include "../src/keras.h"
#include "../src/dataset.h"

#define KR_CHECK(A) printLastError(A)

using namespace std;

int main()
{
  //----- Создание графа модели -----
  KR_CHECK(createModel());
  KR_CHECK(addInput("Input", "D1"));
  KR_CHECK(addDense("D1", "D2", 200));
  KR_CHECK(addDense("D2", "LS", 10));
  KR_CHECK(addLossFunction("LS", "Output", LOSS_SOFTMAX_CROSS_ENTROPY));
  //=================================

  //----- Вывод модели --------------
  char buffer[1024];
  KR_CHECK(netArchitecture(buffer, 1024));
  cout<<buffer<<endl;
  //=================================
  KR_CHECK(readMnist("data"));
  int classCnt = 10;  // выход: вероятностное распределение на 10 классов

  //----- Тренировка ----------------
#define __TRAINING__
  MnistDATA trainData = mnistTrainParams();
  LayerSize layerDataSize, layerLabelSize;
  layerDataSize.bsz = trainData.quantity;
  layerDataSize.ch = 1;
  layerDataSize.w = trainData.rows;
  layerDataSize.h = trainData.cols;
  layerLabelSize.bsz = trainData.quantity;
  layerLabelSize.w = classCnt;
  layerLabelSize.h = 1;
  layerLabelSize.ch = 1;

  KR_CHECK(fit(trainData.data, layerDataSize, trainData.labels, layerLabelSize, 100, 0.001f));

#if defined(__TRAINING__)
  //----- Тестирование --------------
#elif defined(__TESTING__)
  MnistDATA testData = mnistTestParams();


#endif //__TRAINING__ or __TESTING__


  return 0;
}
