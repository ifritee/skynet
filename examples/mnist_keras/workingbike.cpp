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

#include "workingbike.h"

using namespace std;

namespace bike {

  int workingBike(bool isTraining)
  {
    const char * netName = "07_bike.json";
    const char * weightName = "07_bike.dat";

    //----- Загрузка сета --------------
    LayerSize layerDataSize, layerLabelSize;
    float * data = nullptr, * label = nullptr;  // Используем указатели на указатели
    Status retStatus = bikeTrainData("../data/07_bike/hour.csv", false, &data, &label, &layerDataSize, &layerLabelSize, 0, 0);
    if(retStatus != STATUS_OK) {
      char errBuffer[1024];
      dsLastError(errBuffer, sizeof (errBuffer));
      cout<<"(ERROR): "<<errBuffer<<endl;
      return 1;
    }
    //=================================
    if (isTraining) { //----- Тренировка -----
      //----- Создание модели -----
      int modelID = createModel();
      addInput(modelID, "Input", "D2");
      addDense(modelID, "D2", "D4", 52, ACTIV_NONE, OPTIM_ADAM, 0.0, BATCH_POST_ACTIVE);
      addDense(modelID, "D4", "LS", 1, ACTIV_NONE, OPTIM_ADAM, 0.0, BATCH_POST_ACTIVE);
      addLossFunction(modelID, "LS", "Output", LOSS_REGRESSION_MSE);
      //=================================

      //----- Вывод модели --------------
      char buffer[2048];
      netArchitecture(modelID, buffer, sizeof(buffer));
      cout<<buffer<<endl;
      //=================================
      const int epoches = 5000;
      float accuracy = 0.f;
      fitOneValue(modelID, data, layerDataSize, label, layerLabelSize, epoches, 0.01f, accuracy);
      std::cout<<"ACCURACY: "<<accuracy<<std::endl;
      saveModel(modelID, netName, weightName);
      deleteModel(modelID);
      delete [] data;
      delete [] label;
    } else {  //----- Тестирование --------------
      int modelID = createModel(netName, weightName);
      float * out = new float[layerDataSize.bsz];
      forecasting(modelID, data, layerDataSize, out, layerLabelSize);
      for(unsigned int i = 0; i < layerLabelSize.bsz; ++i) {
        std::cout<<"LABEL: "<<label[i]<<" OUT: "<<out[i]<<std::endl;
      }
      deleteModel(modelID);
      delete [] data;
      delete [] label;
    }
    return 0;
  }
}


