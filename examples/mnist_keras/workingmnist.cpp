#include <iostream>
#include <stdio.h>
#include <string.h>
#include <math.h>

#include "keras.h"
#include "dataset.h"

#include "workingmnist.h"

using namespace std;

namespace mnist {
  int workingMNIST(bool isTraining) {
    //----- Создание графа модели -----
    int classCnt = 10;  // выход: вероятностное распределение на 10 классов
    const char * netName = "01_mnist.json";
    const char * weightName = "01_mnist.dat";
    //=================================
    LayerSize layerDataSize, layerLabelSize;
    float * data = nullptr;
    unsigned char * label = nullptr;  // Используем указатели на указатели
    //----- Тренировка -----
    if (isTraining) {
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

      int reset = 1;
      float accuracySum = 0.f;
      for(int i = 0; i < 10; ++i) {
        if(i % reset == 0) {
          accuracySum = 0.f;
        }
        int retCode = mnistTrainData("../data/01_MNIST/train-images-idx3-ubyte",
                                     "../data/01_MNIST/train-labels-idx1-ubyte",
                                     &data,
                                     &label,
                                     &layerDataSize,
                                     &layerLabelSize, 0, i);
        if(retCode != STATUS_OK) {
          cout<<"Read data file is failure!!!"<<endl;
          exit (-1);
        }

        float accuracy = 0.f;
        fit(modelID, data, layerDataSize, label, layerLabelSize, 1, 0.001f, accuracy);
        accuracySum += accuracy;
        cout<<"EPOCHE "<<i<<" ==> "<<accuracySum / ((i % reset) + 1)<<endl;
      }
      saveModel(modelID, netName, weightName);
      delete [] data;
      delete [] label;
      deleteModel(modelID);
    }
  //  //----- Тестирование --------------
    else {
      int modelID = createModel(netName, weightName);
      int retCode = mnistTrainData("../data/01_MNIST/t10k-images-idx3-ubyte",
                                   "../data/01_MNIST/t10k-labels-idx1-ubyte",
                                   &data,
                                   &label,
                                   &layerDataSize,
                                   &layerLabelSize, 10, 0);
      if(retCode != STATUS_OK) {
        cout<<"Read test data file is failure!!!"<<endl;
        exit (-1);
      }
//      loadWeight(modelID, "01_mnist.dat");
      float accuracy = 0.f;
      evaluate(modelID, data, layerDataSize, label, layerLabelSize, 2, accuracy);
      cout<<"Testing: "<<accuracy<<endl;
      delete [] data;
      delete [] label;
      deleteModel(modelID);
    }

  //
    return 0;
  }
}


