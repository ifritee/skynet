#include <iostream>
#include <string>
#include <map>

#include "imageprocessing.h"
#include "snNet.h"
#include "snOperator.h"
#include "snTensor.h"
#include "snType.h"

using namespace std;
using namespace cpp_keras;
namespace sn = SN_API;

#define __TRAINING__

int main()
{
  ImageProcessing imageProcessing;
  imageProcessing.loadMNISTDataset("data");
  std::pair<uint32_t, uint32_t> size = imageProcessing.sizeMnistImage();

  TImagesData & dataTrain = imageProcessing.dataTrain();
  std::vector<uint8_t> & labelTrain = imageProcessing.labelTrain();
  TImagesData & dataTest = imageProcessing.dataTest();
  std::vector<uint8_t> & labelTest = imageProcessing.labelTest();

  sn::Net snet;
  cout<<"Version library: "<<sn::versionLib()<<endl;  // Вывод версии
  snet.addNode("Input", sn::Input(), "FC1")
      //----- Операции свертки ------
//      .addNode("C1", sn::Convolution(15, 3, 0, 1, sn::batchNormType::none, sn::active::relu), "C2")
//      .addNode("C2", sn::Convolution(15, 3, 0, 1, sn::batchNormType::none, sn::active::relu), "P1")
//      .addNode("P1", sn::Pooling(), "FC1")
      //-------------------------------------------------------
      .addNode("FC1", sn::FullyConnected(200, sn::batchNormType::none), "FC2")
      .addNode("FC2", sn::FullyConnected(10), "LS")
      .addNode("LS", sn::LossFunction(sn::lossType::softMaxToCrossEntropy), "Output");

  cout<<"Architecture neuron network: "<<snet.getArchitecNetJN()<<endl;

  int classCnt = 10;  // выход: вероятностное распределение на 10 классов

#if defined(__TRAINING__)
  size_t batchSize = dataTrain.size();  // Размер партии
  // Зададим входные параметры -----
  int epochQty = 100;  ///< @brief Количество эпох
  float learningRate = 0.001f;  ///< @brief Шаг обучения
  float accuratSumm = 0;

  // Зададим входные тензоры -----
  sn::Tensor inLayer(sn::snLSize(size.first, size.second, 1, batchSize));
  sn::Tensor targetLayer(sn::snLSize(10, 1, 1, batchSize));
  sn::Tensor outLayer(sn::snLSize(10, 1, 1, batchSize));
  //----- Цикл по всем эпохам -----
  for(int epoch = 0; epoch < epochQty; ++epoch) {
    targetLayer.clear();  // Заполнение нулями
    //----- Цикл по всем наборам данных (28х28 = 784 (mnist) -----
    for (size_t i = 0; i < batchSize; ++i) {
      float * refData = inLayer.data() + i * size.first * size.second;  // Указатель на данные
      for(size_t row = 0; row < size.first; ++row) {
        for(size_t col = 0; col < size.second; ++col) {
          refData[row * size.second + col] = dataTrain[i][row][col];
        }
      }
      float* tarData = targetLayer.data() + classCnt * i;
      tarData[labelTrain[i]] = 1;
    }

    // Запуск тренировки -----
    float accurat = 0;
    snet.training(learningRate, inLayer, outLayer, targetLayer, accurat);

    // Расчет ошибки -----
    sn::snFloat* targetData = targetLayer.data();
    sn::snFloat* outData = outLayer.data();
    size_t accCnt = 0, bsz = batchSize;
    for (size_t i = 0; i < bsz; ++i) {
      float* refTarget = targetData + i * classCnt;
      float* refOutput = outData + i * classCnt;

      // Вычисление правдивости предположения -----
      int maxOutInx = distance(refOutput, max_element(refOutput, refOutput + classCnt));
      int maxTargInx = distance(refTarget, max_element(refTarget, refTarget + classCnt));

      if (maxTargInx == maxOutInx) {  // Если угадали
        ++accCnt;
      }
    }

    accuratSumm += (accCnt * 1.F) / bsz;  // Расчет показателя угадывания (до 100%)

    cout << epoch << " accurate " << accuratSumm / epoch << " " << snet.getLastErrorStr() << endl;
  }

  snet.saveAllWeightToFile("mnist_weight.dat");

  cout<<"TRAINING END!!!"<<endl;


#elif defined(__TESTING__)
  snet.loadAllWeightFromFile("mnist_weight.dat");

  size_t batchSize = dataTest.size();  // Размер партии
  sn::Tensor inLayer(sn::snLSize(size.first, size.second, 1, batchSize));
  sn::Tensor outLayer(sn::snLSize(classCnt, 1, 1, batchSize));

  for (size_t i = 0; i < batchSize; ++i) {
    float * refData = inLayer.data() + i * size.first * size.second;  // Указатель на данные
    for(size_t row = 0; row < size.first; ++row) {
      for(size_t col = 0; col < size.second; ++col) {
        refData[row * size.second + col] = dataTest[i][row][col];
      }
    }
  }

  //----- testing process -----
  snet.forward(false, inLayer, outLayer);
  uint32_t errors = 0;
  sn::snFloat* outData = outLayer.data();
  for (size_t i = 0; i < batchSize; ++i) {
    float* refOutput = outData + i * classCnt;
    int maxOutInx = distance(refOutput, max_element(refOutput, refOutput + classCnt));
    if(labelTest[i] != maxOutInx) {
      ++errors;
    }
  }
  std::cout<<"ERRORS QTY = "<<errors<<endl;
#endif //__TRAINING__ or __TESTING__
  return 0;
}
