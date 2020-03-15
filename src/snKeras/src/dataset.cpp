#include <iostream>
#include <vector>

#include "mnistset.h"
#include "dataset.h"

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

MnistDATA mnistParameters(int id)
{
  MnistDATA mnistData;
  cpp_keras::MnistSet * mnist = mnistSet[id];
  if(mnist) {
    cpp_keras::DatasetParameters param = mnist->trainParameters();
    mnistData.quantity = param.m_batchs;
    mnistData.rows = param.m_rows;
    mnistData.cols = param.m_cols;
    mnistData.depth = 1;
  }
  return mnistData;
}

