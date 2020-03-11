#include <iostream>

#include "mnistset.h"
#include "dataset.h"

using namespace std;

static cpp_keras::MnistSet * mnistSet = nullptr;

Status readMnist(const char *path)
{
  Status status = STATUS_OK;
  try {
    if (mnistSet != nullptr) {
       delete mnistSet;
    }
    mnistSet = new cpp_keras::MnistSet;
    if( !mnistSet->readTrainData(path) ) {
      cerr<<"Read MNIST training data crashed! "<<endl;
      status = STATUS_WARNING;
    }
    if( !mnistSet->readTestData(path) ) {
      cerr<<"Read MNIST test data crashed! "<<endl;
      status = STATUS_WARNING;
    }
  } catch(std::logic_error & e) {
    cerr<<"READ MNIST ERROR: "<<e.what()<<endl;
    return STATUS_FAILURE;
  }
  return status;
}

Status readMnistTrain(const char* dataFile, const char* labelFile, unsigned int qty, unsigned int step)
{
    Status status = STATUS_OK;
    try {
        if (mnistSet == nullptr) {
            mnistSet = new cpp_keras::MnistSet;
        }
        if (!mnistSet->readTrainData(dataFile, labelFile, qty, step)) {
            cerr << "Read MNIST training data crashed! " << endl;
            status = STATUS_WARNING;
        }
    }
    catch (std::logic_error & e) {
        cerr << "READ MNIST ERROR: " << e.what() << endl;
        return STATUS_FAILURE;
    }
    return status;
}

Status readMnistTest(const char* dataFile, const char* labelFile, unsigned int qty)
{
    Status status = STATUS_OK;
    try {
        if (mnistSet == nullptr) {
            mnistSet = new cpp_keras::MnistSet;
        }
        if (!mnistSet->readTestData(dataFile, labelFile, qty)) {
            cerr << "Read MNIST training data crashed! " << endl;
            status = STATUS_WARNING;
        }
    }
    catch (std::logic_error & e) {
        cerr << "READ MNIST ERROR: " << e.what() << endl;
        return STATUS_FAILURE;
    }
    return status;
}

MnistDATA mnistTrainParams()
{
  MnistDATA mnistData;
  if(mnistSet) {
    mnistData.data = mnistSet->trainData();
    mnistData.labels = mnistSet->trainLabel();
    cpp_keras::DatasetParameters param = mnistSet->trainParameters();
    mnistData.quantity = param.m_batchs;
    mnistData.rows = param.m_rows;
    mnistData.cols = param.m_cols;
    mnistData.channels = 1;
  }
  return mnistData;
}

MnistDATA mnistTestParams()
{
  MnistDATA mnistData;
  if(mnistSet) {
    mnistData.data = mnistSet->testData();
    mnistData.labels = mnistSet->testLabel();
    cpp_keras::DatasetParameters param = mnistSet->testParameters();
    mnistData.quantity = param.m_batchs;
    mnistData.rows = param.m_rows;
    mnistData.cols = param.m_cols;
    mnistData.channels = 1;
  }
  return mnistData;
}
