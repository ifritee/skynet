#include <iostream>
#include <vector>
#include <algorithm>
#include <string.h>

#include "mnistset.h"
#include "dataset.h"
#include "trainingdata.h"

using namespace std;

static std::string strDSLastError = ""; ///< @brief Последняя ошибка

Status mnistTrainData(const char * datafilename,
                      const char * labelfilename,
                      float **data,
                      unsigned char **label,
                      LayerSize * sizeData,
                      LayerSize * sizeLabel,
                      int qty, unsigned int step)
{
  try {
    cpp_keras::MnistSet mnistObj(datafilename, labelfilename);
    cpp_keras::DatasetParameters param = mnistObj.trainParameters();
    if(qty > 0) {
      sizeData->bsz = sizeLabel->bsz = std::min<unsigned int>(qty, param.m_batchs);
    } else {
      sizeData->bsz = sizeLabel->bsz = param.m_batchs;
    }
    sizeData->w = param.m_rows;
    sizeData->h = param.m_cols;
    sizeData->ch = sizeLabel->ch = 1;
    sizeLabel->w = 10;
    sizeLabel->h = 1;
    freeTrainData(data, label);
    *data = new float[sizeData->bsz * sizeData->w * sizeData->h];
    *label = new uint8_t[sizeData->bsz];
    if( !mnistObj.readData(qty, step, *data, *label) ) {
      strDSLastError = std::string("(ERROR): ").append(mnistObj.lastError());
      return STATUS_FAILURE;
    }
  } catch (std::exception & e) {
    strDSLastError = std::string("(ERROR): ").append(e.what());
    return STATUS_FAILURE;
  }

  return STATUS_OK;
}

Status bikeTrainData(const char * filename, bool isDay, float **data,
                     float **label, LayerSize *sizeData, LayerSize *sizeLabel, int qty, unsigned int step)
{
  TrainingData trainingData(filename, sizeData, sizeLabel);
  freeTrainDataF(data, label);
  trainingData.readBikeData(isDay, data, label, qty, step);
  if (trainingData.lastStatus() != STATUS_OK) {
    strDSLastError = trainingData.lastError();
  }
  return trainingData.lastStatus();
}

Status bostonTrainData(const char *filename, float **data, float **label, LayerSize *sizeData, LayerSize *sizeLabel,
                       int qty, unsigned int step)
{
  TrainingData trainingData(filename, sizeData, sizeLabel);
  freeTrainDataF(data, label);
  trainingData.readBostonData(data, label, qty, step);
  if (trainingData.lastStatus() != STATUS_OK) {
    strDSLastError = trainingData.lastError();
  }
  return trainingData.lastStatus();
}

Status breastTrainData(const char *filename, int flag, float **data, unsigned char **label,
                       LayerSize *sizeData, LayerSize *sizeLabel, int qty, unsigned int step)
{
  TrainingData trainingData(filename, sizeData, sizeLabel);
  freeTrainData(data, label);
  trainingData.readBreastData(flag, data, label, qty, step);
  if (trainingData.lastStatus() != STATUS_OK) {
    strDSLastError = trainingData.lastError();
  }
  return trainingData.lastStatus();
}

Status irisTrainData(const char *filename, float **data, unsigned char **label,
                       LayerSize *sizeData, LayerSize *sizeLabel, int qty, unsigned int step)
{
  TrainingData trainingData(filename, sizeData, sizeLabel);
  freeTrainData(data, label);
  trainingData.readIrisData(data, label, qty, step);
  if (trainingData.lastStatus() != STATUS_OK) {
    strDSLastError = trainingData.lastError();
  }
  return trainingData.lastStatus();
}

Status wineTrainData(const char *filename, float **data, unsigned char **label,
                     LayerSize *sizeData, LayerSize *sizeLabel, int qty, unsigned int step)
{
  TrainingData trainingData(filename, sizeData, sizeLabel);
  freeTrainData(data, label);
  trainingData.readWineData(data, label, qty, step);
  if (trainingData.lastStatus() != STATUS_OK) {
    strDSLastError = trainingData.lastError();
  }
  return trainingData.lastStatus();
}

Status titanicTrainData(const char *filename, float **data, unsigned char **label,
                     LayerSize *sizeData, LayerSize *sizeLabel, int qty, unsigned int step)
{
  TrainingData trainingData(filename, sizeData, sizeLabel);
  freeTrainData(data, label);
  trainingData.readTitanicData(data, label, qty, step);
  if (trainingData.lastStatus() != STATUS_OK) {
    strDSLastError = trainingData.lastError();
  }
  return trainingData.lastStatus();
}

void freeTrainData(float** data, unsigned char** label)
{
  if (data != nullptr && (*data) != nullptr) {
    delete[] * data;
    *data = nullptr;
  }
  if (label != nullptr && (*label) != nullptr) {
    delete[] * label;
    *label = nullptr;
  }
}

void freeTrainDataF(float** data, float** label)
{
  if (data != nullptr && (*data) != nullptr) {
    delete[] * data;
    *data = nullptr;
  }
  if (label != nullptr && (*label) != nullptr) {
    delete[] * label;
    *label = nullptr;
  }
}

void dsLastError(char *buffer, int length)
{
  if(length >= static_cast<int>(strDSLastError.size())) {
    strcpy(buffer, strDSLastError.c_str());
  }
}
