#include <iostream>
#include <vector>

#include "mnistset.h"
#include "dataset.h"
#include "trainingdata.h"

using namespace std;

static vector<cpp_keras::MnistSet *> mnistSet;

int createMnistDataset(const char *dataFile, const char *labelFile)
{
  try {
    cpp_keras::MnistSet * mnist = new cpp_keras::MnistSet(dataFile, labelFile);
    mnistSet.push_back(mnist);
    return mnistSet.size() - 1;
  } catch(std::logic_error & e) {
    cerr<<"READ MNIST ERROR: "<<e.what()<<endl;
    return -1;
  }
  return -1;
}

Status deleteMnistDataset(int id)
{
  cpp_keras::MnistSet * mnist = mnistSet[id];
  delete mnist;
  mnistSet[id] = nullptr;
  return STATUS_OK;
}

Status readMnist(int id, float *datas, unsigned char *labels, unsigned int qty, unsigned int step)
{
  cpp_keras::MnistSet * mnist = mnistSet[id];
  if (mnist) {
    if( !mnist->readData(qty, step,datas, labels) ) {
      return STATUS_FAILURE;
    }
  } else {
    return STATUS_FAILURE;
  }
  return STATUS_OK;
}

LayerSize mnistParameters(int id)
{
  LayerSize mnistData;
  cpp_keras::MnistSet * mnist = mnistSet[id];
  if(mnist) {
    cpp_keras::DatasetParameters param = mnist->trainParameters();
    mnistData.bsz = param.m_batchs;
    mnistData.w = param.m_rows;
    mnistData.h = param.m_cols;
    mnistData.ch = 1;
  }
  return mnistData;
}


Status bikeTrainData(const char * filename, bool isDay, float **data,
                     float **label, LayerSize *sizeData, LayerSize *sizeLabel)
{
  TrainingData trainingData(filename, sizeData, sizeLabel);
  trainingData.readBikeData(isDay, data, label);
  return trainingData.lastStatus();
}

Status bostonTrainData(const char *filename, float **data, float **label, LayerSize *sizeData, LayerSize *sizeLabel)
{
  TrainingData trainingData(filename, sizeData, sizeLabel);
  trainingData.readBostonData(data, label);
  return trainingData.lastStatus();
}

Status breastTrainData(const char *filename, int flag, float **data, unsigned char **label,
                       LayerSize *sizeData, LayerSize *sizeLabel)
{
  TrainingData trainingData(filename, sizeData, sizeLabel);
  trainingData.readBreastData(flag, data, label);
  return trainingData.lastStatus();
}

Status irisTrainData(const char *filename, float **data, unsigned char **label,
                       LayerSize *sizeData, LayerSize *sizeLabel)
{
  TrainingData trainingData(filename, sizeData, sizeLabel);
  trainingData.readIrisData(data, label);
  return trainingData.lastStatus();
}

Status wineTrainData(const char *filename, float **data, unsigned char **label,
                     LayerSize *sizeData, LayerSize *sizeLabel)
{
  TrainingData trainingData(filename, sizeData, sizeLabel);
  trainingData.readWineData(data, label);
  return trainingData.lastStatus();
}

Status titanicTrainData(const char *filename, float **data, unsigned char **label,
                     LayerSize *sizeData, LayerSize *sizeLabel)
{
  TrainingData trainingData(filename, sizeData, sizeLabel);
  trainingData.readTitanicData(data, label);
  return trainingData.lastStatus();
}
