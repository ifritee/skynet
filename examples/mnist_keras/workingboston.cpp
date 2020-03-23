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

#include "workingboston.h"

using namespace std;

namespace boston {

  int workingBoston(bool isTraining)
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

    //----- Тренировка -----
    if (isTraining) {
      //----- Загрузка сета --------------
      LayerSize layerDataSize, layerLabelSize;
      float * data, * label;  // Используем указатели на указатели
      int retCode = bostonTrainData("../data/05_boston/boston_data.csv", &data, &label, &layerDataSize, &layerLabelSize);
      if(retCode != STATUS_OK) {
        cout<<"Read data file is failure!!!"<<endl;
        exit (-1);
      }
      //=================================
      const int epoches = 5000;
      //----- Эпохи не важны (1 штука) -----
      fitOneValue(modelID, data, layerDataSize, label, layerLabelSize, epoches, 0.001f);
      saveModel(modelID, "05_boston.dat");
      delete [] data;
      delete [] label;
    }
    //----- Тестирование --------------
    else {
      //----- Загрузка сета --------------
      LayerSize layerDataSize, layerLabelSize;
      float * data;  // Используем указатели на указатели
      int retCode = bostonTrainData("../data/05_boston/boston_test_data.csv", &data, nullptr, &layerDataSize, &layerLabelSize);
      if(retCode != STATUS_OK) {
        cout<<"Read data file is failure!!!"<<endl;
        exit (-1);
      }
      //=================================
      float * out = new float[layerDataSize.bsz];

      loadModel(modelID, "05_boston.dat");

      forecasting(modelID, data, layerDataSize, out, layerLabelSize);
      for(unsigned int i = 0; i < layerLabelSize.bsz; ++i) {
        std::cout<<" OUT: "<<out[i]<<std::endl;
      }
      delete [] data;
      delete [] out;
    }
    deleteModel(modelID);
    return 0;
  }

}


