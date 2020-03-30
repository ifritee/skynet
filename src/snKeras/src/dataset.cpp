#include <iostream>
#include <vector>
#include <algorithm>

#include "mnistset.h"
#include "dataset.h"
#include "trainingdata.h"

using namespace std;

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
    *data = new float[sizeData->bsz * sizeData->w * sizeData->h];
    *label = new uint8_t[sizeData->bsz];
    if( !mnistObj.readData(qty, step, *data, *label) ) {
      return STATUS_FAILURE;
    }
  } catch (...) {
    return STATUS_FAILURE;
  }

  return STATUS_OK;
}

Status bikeTrainData(const char * filename, bool isDay, float **data,
                     float **label, LayerSize *sizeData, LayerSize *sizeLabel, int qty, unsigned int step)
{
  TrainingData trainingData(filename, sizeData, sizeLabel);
  trainingData.readBikeData(isDay, data, label, qty, step);
  return trainingData.lastStatus();
}

Status bostonTrainData(const char *filename, float **data, float **label, LayerSize *sizeData, LayerSize *sizeLabel,
                       int qty, unsigned int step)
{
  TrainingData trainingData(filename, sizeData, sizeLabel);
  trainingData.readBostonData(data, label, qty, step);
  return trainingData.lastStatus();
}

Status breastTrainData(const char *filename, int flag, float **data, unsigned char **label,
                       LayerSize *sizeData, LayerSize *sizeLabel, int qty, unsigned int step)
{
  TrainingData trainingData(filename, sizeData, sizeLabel);
  trainingData.readBreastData(flag, data, label, qty, step);
  return trainingData.lastStatus();
}

Status irisTrainData(const char *filename, float **data, unsigned char **label,
                       LayerSize *sizeData, LayerSize *sizeLabel, int qty, unsigned int step)
{
  TrainingData trainingData(filename, sizeData, sizeLabel);
  trainingData.readIrisData(data, label, qty, step);
  return trainingData.lastStatus();
}

Status wineTrainData(const char *filename, float **data, unsigned char **label,
                     LayerSize *sizeData, LayerSize *sizeLabel, int qty, unsigned int step)
{
  TrainingData trainingData(filename, sizeData, sizeLabel);
  trainingData.readWineData(data, label, qty, step);
  return trainingData.lastStatus();
}

Status titanicTrainData(const char *filename, float **data, unsigned char **label,
                     LayerSize *sizeData, LayerSize *sizeLabel, int qty, unsigned int step)
{
  TrainingData trainingData(filename, sizeData, sizeLabel);
  trainingData.readTitanicData(data, label, qty, step);
  return trainingData.lastStatus();
}
