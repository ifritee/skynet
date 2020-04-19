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

#include "workingwine.h"

using namespace std;

namespace wine {

  int workingWine(bool isTraining)
  {
    //----- Создание модели -----
    int modelID = createModel();
    addInput(modelID, "Input", "D1");
    addDense(modelID, "D1", "D2", 300);
    addDense(modelID, "D2", "D3", 10);
    addDense(modelID, "D3", "LS", 3);
    addLossFunction(modelID, "LS", "Output", LOSS_SOFTMAX_CROSS_ENTROPY);
    //=================================

    //----- Вывод модели --------------
    char buffer[2048];
    netArchitecture(modelID, buffer, sizeof(buffer));
    cout<<buffer<<endl;
    //=================================

    LayerSize layerDataSize, layerLabelSize;
    float * data = nullptr;
    uint8_t * label = nullptr;
    wineTrainData("../data/03_Wine/wine.data", &data, &label, &layerDataSize, &layerLabelSize, 0, 0);
    //----- Тренировка -----
    if (isTraining) {

      float accuracySum = 0.f;
      const int epoche = 3000, reset = 10;

      for(int i = 0; i < epoche; ++i) {
        if(i % reset == 0) {
          accuracySum = 0.f;
        }
        //----- Эпохи не важны (1 штука) -----
        float accuracy = 0.f;
        fit(modelID, data, layerDataSize, label, layerLabelSize, 1, 0.001f, accuracy);
        accuracySum += accuracy;
        cout<<"EPOCHE "<<i<<" ==> "<<accuracySum / ((i % reset) + 1)<<endl;
      }
      saveModel(modelID, "03_wine.json", "03_wine.dat");
    }
    //----- Тестирование --------------
    else {
      loadWeight(modelID, "03_wine.dat");
      float accuracy = 0.f;
      evaluate(modelID, data, layerDataSize, label, layerLabelSize, 2, accuracy);
      cout<<"Testing: "<<accuracy<<endl;
    }
    delete [] data;
    delete [] label;
    deleteModel(modelID);
    return 0;
  }

}


