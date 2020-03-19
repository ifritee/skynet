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

std::vector<std::string> getLinesFromFile(string filename)
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

void setDatafromStrings(std::vector<std::string> & lines, float * datas, uint8_t * labels,
                        unsigned int id, unsigned int labIndex, map<string, uint8_t> & answerDict)
{
  int dataCount = 0, labelCount = 0;
  for(auto line : lines) {
    if (line != "") {
      auto tokens = split(line, ',');
      for(unsigned int i = 0; i < tokens.size(); ++i) {
        if (i == id) {
        } else if (i == labIndex) { // Метки
          if(tokens[i] != "") {
            if(answerDict.find(tokens[i]) == answerDict.end()) {
              std::cerr<<"Label didn't find "<<tokens[i]<<endl;
              return;
            }
            labels[labelCount++] = answerDict[tokens[i] ];
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

int workingBreast(bool isTraining)
{
  //----- Создание графа модели -----
  map<string, uint8_t> answerDict;
#define BREAST_WPBC
#if defined (BREAST_CANCER)
  answerDict["2"] = 0;
  answerDict["4"] = 1;
  auto lines = getLinesFromFile("../data/02_BreastCancer/breast-cancer-wisconsin.data");
  int id = 0, labelIndex = 10;
#elif defined (BREAST_WDBC)
  answerDict["M"] = 0;
  answerDict["B"] = 1;
  auto lines = getLinesFromFile("../data/02_BreastCancer/wdbc.data");
  int id = 0, labelIndex = 1;
#elif defined (BREAST_WPBC)
  answerDict["R"] = 0;
  answerDict["N"] = 1;
  auto lines = getLinesFromFile("../data/02_BreastCancer/wpbc.data");
  int id = 0, labelIndex = 1;
#endif
  const int dataQty = split(lines[0], ',').size() - 2;  // Количество значений - id - label
  int classCnt = answerDict.size();  // выход: вероятностное распределение на N классов
  const int bsz = lines.size();
  float * data = new float[bsz * dataQty];
  uint8_t * label = new uint8_t[bsz];

  setDatafromStrings(lines, data, label, id, labelIndex, answerDict);
  //----- Создание модели -----
  int modelID = createModel();
  addInput(modelID, "Input", "D1");
  addDense(modelID, "D1", "D2", 200);
  addDense(modelID, "D2", "D3", 400);
  addDense(modelID, "D3", "D4", 800);
  addDense(modelID, "D4", "LS", classCnt);
  addLossFunction(modelID, "LS", "Output", LOSS_SOFTMAX_CROSS_ENTROPY);
  //=================================

  //----- Вывод модели --------------
  char buffer[2048];
  netArchitecture(modelID, buffer, sizeof(buffer));
  cout<<buffer<<endl;
  //=================================

  LayerSize layerDataSize, layerLabelSize;
  //----- Тренировка -----
  if (isTraining) {

    float accuracySum = 0.f;
    const int epoche = 300, reset = 10;

    for(int i = 0; i < epoche; ++i) {
      if(i % reset == 0) {
        accuracySum = 0.f;
      }
      layerDataSize.bsz = bsz - 40;//trainData.quantity;
      layerDataSize.ch = 1;
      layerDataSize.w = dataQty;
      layerDataSize.h = 1;
      layerLabelSize.bsz = bsz - 40;//trainData.quantity;
      layerLabelSize.w = classCnt;
      layerLabelSize.h = 1;
      layerLabelSize.ch = 1;
      //----- Эпохи не важны (1 штука) -----
      float accuracy = 0.f;
      fit(modelID, data, layerDataSize, label, layerLabelSize, 1, 0.001f, accuracy);
      accuracySum += accuracy;
      cout<<"EPOCHE "<<i<<" ==> "<<accuracySum / ((i % reset) + 1)<<endl;
    }
    saveModel(modelID, "02_breast.dat");
  }
  //----- Тестирование --------------
  else {
    layerDataSize.bsz = 40;
    layerDataSize.ch = 1;
    layerDataSize.w = dataQty;
    layerDataSize.h = 1;
    layerLabelSize.bsz = 40;
    layerLabelSize.w = classCnt;
    layerLabelSize.h = 1;
    layerLabelSize.ch = 1;

    loadModel(modelID, "02_breast.dat");
    float accuracy = 0.f;
    evaluate(modelID, &data[(bsz - 40) * dataQty], layerDataSize, &label[bsz - 40], layerLabelSize, 2, accuracy);
    cout<<"Testing: "<<accuracy<<endl;
  }
  delete [] data;
  delete [] label;
  deleteModel(modelID);
  return 0;
}

