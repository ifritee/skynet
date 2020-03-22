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

  std::vector<std::string> getLinesFromFile(const std::string & filename)
  {
    std::vector<std::string> lines;
    ifstream is(filename);
    while(!is.eof()) {
      string line;
      is >> line;
      if (line != "")
        lines.push_back(line);
    }
    return lines;
  }

  std::vector<std::string> split(const string & s, char d)
  {
    vector<string> tokens;
    string token;
    istringstream ts(s);
    while (std::getline(ts, token, d)) {
      tokens.push_back(token);
    }
    return tokens;
  }

  void setDatafromStrings(std::vector<std::string> & lines, float * datas, float * labels, unsigned int labIndex)
  {
    int dataCount = 0, labelCount = 0;
    for(auto line : lines) {
      if (line != "") {
        auto tokens = split(line, ',');
        for(unsigned int i = 0; i < tokens.size(); ++i) {
          if (i == labIndex) { // Метки
            if(tokens[i] != "") {

              float value = 0;
              std::istringstream ss(tokens[i]);
              ss >> value;
              labels[labelCount++] = value;
            }
          } else {
            if(tokens[i] != "") {
              float value = 0;
              std::istringstream ss(tokens[i]);
              ss >> value;
              datas[dataCount++] = value;
            }
          }
        }
      }
    }
  }

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
//      auto lines = getLinesFromFile("../data/05_boston/boston_data.csv");
//      lines.erase(lines.begin());
//      int labelIndex = 13, shift = 1;
//      const int dataQty = split(lines[0], ',').size() - shift;  // Количество значений - id - label
//      const int bsz = lines.size();
//      float * data = new float[bsz * dataQty];
//      float * label = new float[bsz];
      float * out = new float[layerDataSize.bsz];
//      setDatafromStrings(lines, data, label, labelIndex);

//      layerDataSize.bsz = bsz;
//      layerDataSize.ch = 1;
//      layerDataSize.w = dataQty;
//      layerDataSize.h = 1;
//      layerLabelSize.bsz = bsz;
//      layerLabelSize.w = 1;
//      layerLabelSize.h = 1;
//      layerLabelSize.ch = 1;

      loadModel(modelID, "05_boston.dat");

      forecasting(modelID, data, layerDataSize, out, layerLabelSize);
      for(unsigned int i = 0; i < layerLabelSize.bsz; ++i) {
        std::cout<<" OUT: "<<out[i]<<std::endl;
      }
    }
    deleteModel(modelID);
    return 0;
  }

}


