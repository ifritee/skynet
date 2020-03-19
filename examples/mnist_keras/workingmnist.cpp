#include <iostream>
#include <stdio.h>
#include <string.h>
#include <math.h>

#include "keras.h"
#include "dataset.h"

#include "workingmnist.h"

using namespace std;

int workingMNIST(bool isTraining) {
  //----- Создание графа модели -----
  int classCnt = 10;  // выход: вероятностное распределение на 10 классов
  int modelID = createModel();
  addInput(modelID, "Input", "D1");
  addDense(modelID, "D1", "D2", 800);
  addDense(modelID, "D2", "LS", classCnt);
  addLossFunction(modelID, "LS", "Output", LOSS_SOFTMAX_CROSS_ENTROPY);
  //=================================

  //----- Вывод модели --------------
  char buffer[1024];
  netArchitecture(modelID, buffer, 1024);
  cout<<buffer<<endl;
  //=================================

  LayerSize layerDataSize, layerLabelSize;
  //----- Тренировка -----
  if (isTraining) {
    int id = createMnistDataset("../data/01_MNIST/train-images-idx3-ubyte", "../data/01_MNIST/train-labels-idx1-ubyte");
    MnistDATA trainData = mnistParameters(id);
    const int qtyM = 60000, epoche = 10, reset = 1;

    float * dataM = new float[qtyM * trainData.cols * trainData.rows];
    uint8_t * labelM = new uint8_t[qtyM];
    float accuracySum = 0.f;
    for(int i = 0; i < epoche; ++i) {
      if(i % reset == 0) {
        accuracySum = 0.f;
      }
      readMnist(id, dataM, labelM, qtyM, i);
      layerDataSize.bsz = qtyM;//trainData.quantity;
      layerDataSize.ch = trainData.depth;
      layerDataSize.w = trainData.rows;
      layerDataSize.h = trainData.cols;
      layerLabelSize.bsz = qtyM;//trainData.quantity;
      layerLabelSize.w = classCnt;
      layerLabelSize.h = 1;
      layerLabelSize.ch = 1;
      //----- Эпохи не важны (1 штука) -----
      float accuracy = 0.f;
      fit(modelID, dataM, layerDataSize, labelM, layerLabelSize, 1, 0.001f, accuracy);
      accuracySum += accuracy;
      cout<<"EPOCHE "<<i<<" ==> "<<accuracySum / ((i % reset) + 1)<<endl;
    }
    deleteMnistDataset(id);

    delete [] dataM;
    delete [] labelM;
    saveModel(modelID, "01_mnist.dat");
  }
  //----- Тестирование --------------
  else {
    int id = createMnistDataset("../data/01_MNIST/t10k-images-idx3-ubyte", "../data/01_MNIST/t10k-labels-idx1-ubyte");
    MnistDATA mnistDATA = mnistParameters(id);
    float * dataM = new float[mnistDATA.quantity * mnistDATA.cols * mnistDATA.rows];
    uint8_t * labelM = new uint8_t[mnistDATA.quantity];
    readMnist(id, dataM, labelM);

    layerDataSize.bsz = mnistDATA.quantity;
    layerDataSize.ch = mnistDATA.depth;
    layerDataSize.w = mnistDATA.rows;
    layerDataSize.h = mnistDATA.cols;
    layerLabelSize.bsz = mnistDATA.quantity;
    layerLabelSize.w = classCnt;
    layerLabelSize.h = 1;
    layerLabelSize.ch = 1;

    loadModel(modelID, "01_mnist.dat");
    float accuracy = 0.f;
    evaluate(modelID, dataM, layerDataSize, labelM, layerLabelSize, 2, accuracy);
    cout<<"Testing: "<<accuracy<<endl;
    delete [] dataM;
    delete [] labelM;

  }

  deleteModel(modelID);
  return 0;
}

