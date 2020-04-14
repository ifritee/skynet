#include <iostream>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <vector>
#include <fstream>
#include <sstream>
#include <iomanip>
#include <stdlib.h>
#include <map>

#include "keras.h"
#include "dataset.h"

#include "workingbreast.h"

using namespace std;

namespace breast {

  int workingBreast(bool isTraining)
  {
    const char * netName = "02_breast.json";
    const char * weightName = "02_breast.dat";

    LayerSize layerDataSize, layerLabelSize;
    //----- Тренировка -----
    if (isTraining) {
      float * data = nullptr; uint8_t * label = nullptr;
      //----- Создание модели -----
      int modelID = createModel();
      addInput(modelID, "Input", "D1");
      addDense(modelID, "D1", "D2", 200);
      addDense(modelID, "D2", "D3", 400);
      addDense(modelID, "D3", "D4", 800);
      addDense(modelID, "D4", "LS", 2);
      addLossFunction(modelID, "LS", "Output", LOSS_SOFTMAX_CROSS_ENTROPY);
      //=================================

      //----- Вывод модели --------------
      char buffer[2048];
      netArchitecture(modelID, buffer, sizeof(buffer));
      cout<<buffer<<endl;
      //=================================
      float accuracySum = 0.f;
      const int epoche = 100, reset = 10;

      for(int i = 0; i < epoche; ++i) {
        breastTrainData("../data/02_BreastCancer/breast-cancer-wisconsin.data", 1, &data, &label,
                        &layerDataSize, &layerLabelSize, 100, i);
        if(i % reset == 0) {
          accuracySum = 0.f;
        }

        //----- Эпохи не важны (1 штука) -----
        float accuracy = 0.f;
        fit(modelID, data, layerDataSize, label, layerLabelSize, 1, 0.001f, accuracy);
        accuracySum += accuracy;
        cout<<"EPOCHE "<<i<<" ==> "<<accuracySum / ((i % reset) + 1)<<endl;
      }
      saveModel(modelID, netName, weightName);
      deleteModel(modelID);
      delete [] data;
      delete [] label;
    }
    //----- Тестирование --------------
    else {
      float * data = nullptr; uint8_t * label = nullptr;
      int modelID = createModel(netName, weightName);
      breastTrainData("../data/02_BreastCancer/breast-cancer-wisconsin.data", 1, &data, &label, &layerDataSize, &layerLabelSize, 0, 0);
//      loadWeight(modelID, "02_breast.dat");
      float accuracy = 0.f;
      evaluate(modelID, data, layerDataSize, label, layerLabelSize, 2, accuracy);
      cout<<"Testing: "<<accuracy<<endl;
      deleteModel(modelID);
      delete [] data;
      delete [] label;
    }
    return 0;
  }

}

