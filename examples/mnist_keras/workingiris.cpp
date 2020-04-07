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

#include "workingiris.h"

using namespace std;

namespace iris {

  int workingIris(bool isTraining)
  {
    //----- Создание графа модели -----
    const char * weightName = "04_iris.dat";
    const char * netName = "04_iris.json";
    //----- Загрузка сета -----
    LayerSize layerDataSize, layerLabelSize;
    float * data; uint8_t * label;
    irisTrainData("../data/04_Iris/iris.data", &data, &label, &layerDataSize, &layerLabelSize, 0, 0);

    //----- Тренировка -----
    if (isTraining) {
      //----- Создание модели -----
      int modelID = createModel();
      addInput(modelID, "Input", "D1");
      addDense(modelID, "D1", "D2", 100);
      addDense(modelID, "D2", "D3", 300);
      addDense(modelID, "D3", "LS", 3);
      addLossFunction(modelID, "LS", "Output", LOSS_SOFTMAX_CROSS_ENTROPY);
      //=================================

      //----- Вывод модели --------------
      char buffer[2048];
      netArchitecture(modelID, buffer, sizeof(buffer));
      cout<<buffer<<endl;
      //=================================

      float accuracySum = 0.f;
      const int epoche = 300, reset = 10;

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
      saveModel(modelID, netName, weightName);
      deleteModel(modelID);
    }
    //----- Тестирование --------------
    else {
      int modelID = createModel(netName, weightName);
//      loadWeight(modelID, weightName);
      float accuracy = 0.f;
      evaluate(modelID, data, layerDataSize, label, layerLabelSize, 2, accuracy);
      cout<<"Testing: "<<accuracy<<endl;
      deleteModel(modelID);
    }
    delete [] data;
    delete [] label;

    return 0;
  }

}


