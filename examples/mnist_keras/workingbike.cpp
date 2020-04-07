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

    //----- Загрузка сета --------------
    LayerSize layerDataSize, layerLabelSize;
    float * data, * label;  // Используем указатели на указатели
    int retCode = bikeTrainData("../data/07_bike/day.csv", true, &data, &label,
                                &layerDataSize, &layerLabelSize, 0, 0);
    if(retCode != STATUS_OK) {
      cout<<"Read data file is failure!!!"<<endl;
      exit (-1);
    }
    //=================================
    if (isTraining) { //----- Тренировка -----
      const int epoches = 5000;
      float accuracy = 0.f;
      fitOneValue(modelID, data, layerDataSize, label, layerLabelSize, epoches, 0.01f, accuracy);
      std::cout<<"ACCURACY: "<<accuracy<<std::endl;
      saveModel(modelID, "07_bike.json", "07_bike.dat");
    } else {  //----- Тестирование --------------
      float * out = new float[layerDataSize.bsz];
      loadWeight(modelID, "07_bike.dat");
      forecasting(modelID, data, layerDataSize, out, layerLabelSize);
      for(unsigned int i = 0; i < layerLabelSize.bsz; ++i) {
        std::cout<<"LABEL: "<<label[i]<<" OUT: "<<out[i]<<std::endl;
      }
    }
    delete [] data;
    delete [] label;
    deleteModel(modelID);
    return 0;
  }
}


