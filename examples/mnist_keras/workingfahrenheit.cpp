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

#include "workingfahrenheit.h"

using namespace std;

namespace fahrenheit {

  float far[] = {-40, -20, -7,  0,   20, 28, 45, 90};
  float far2[] = {-53, -1, 22,  14,   70, 33, 11, 9};
  float cel[] = {-40, -29, -22, -18, -7, -2,  7, 32};
  float cel2[8] = {0};  // Тут ответы будут

  int workingFahrenheit(bool isTraining)
  {
    //----- Создание модели -----
    int modelID = createModel();
    addInput(modelID, "Input", "D2");
    addDense(modelID, "D2", "LS", 1, ACTIV_NONE, OPTIM_ADAM, 0.0, BATCH_NONE);
    addLossFunction(modelID, "LS", "Output", LOSS_REGRESSION_MSE);
    //=================================

    //----- Вывод модели --------------
    char buffer[2048];
    netArchitecture(modelID, buffer, sizeof(buffer));
    cout<<buffer<<endl;
    //=================================

    LayerSize layerDataSize, layerLabelSize;
    //----- Тренировка -----
    if (isTraining) {

      const int epoche = 600;

      for(int i = 0; i < epoche; ++i) {
        layerDataSize.bsz = sizeof (far) / sizeof(float);
        layerDataSize.ch = 1;
        layerDataSize.w = 1;
        layerDataSize.h = 1;
        layerLabelSize.bsz = layerDataSize.bsz;
        layerLabelSize.w = 1;
        layerLabelSize.h = 1;
        layerLabelSize.ch = 1;
        //----- Эпохи не важны (1 штука) -----
        fitOneValue(modelID, far, layerDataSize, cel, layerLabelSize, 1, 0.1f);
      }
      saveModel(modelID, "00_fahrenheit.dat");
    }
    //----- Тестирование --------------
    else {
      layerDataSize.bsz = sizeof (far2) / sizeof(float);
      layerDataSize.ch = 1;
      layerDataSize.w = 1;
      layerDataSize.h = 1;

      loadModel(modelID, "00_fahrenheit.dat");

      forecasting(modelID, far2, layerDataSize, cel2, layerDataSize);
      for(unsigned int i = 0; i < layerLabelSize.bsz; ++i) {
        std::cout<<"FAR: "<<far2[i]<<" CEL: "<<cel2[i]<<std::endl;
      }
    }
    deleteModel(modelID);
    return 0;
  }

}


