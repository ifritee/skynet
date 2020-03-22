#include <string>
#include <iostream>
#include <map>
#include <string.h>
#include <vector>

#include "snNet.h"
#include "snOperator.h"
#include "snTensor.h"
#include "snType.h"

#include "keras.h"

namespace sn = SN_API;

static std::vector<sn::Net *> modelSet; ///< @brief Набор моделей

int createModel()
{
  try {
    sn::Net * model = new sn::Net;
    modelSet.push_back(model);
    return modelSet.size() - 1;
  } catch(...) {
    return -1;
  }
  return -1;
}

Status deleteModel( int id )
{
  sn::Net * model = modelSet[id];
  delete model;
  modelSet[id] = nullptr;
  return STATUS_OK;
}

Status addInput(int id, const char * name, const char * nodes)
{
  sn::Net * model = modelSet[id];
  if(!model) {
    return STATUS_FAILURE;
  }
  model->addNode(name, sn::Input(), nodes);
  return STATUS_OK;
}

Status addConvolution(int id, const char * name, const char * nodes, unsigned int filters_, Activation act_,
                      Optimizer opt_, float dropOut_, BatchNormType bnorm_, unsigned int fWidth_,
                      unsigned int fHeight_, int padding_, unsigned int stride_, unsigned int dilate_,
                      unsigned int gpuDeviceId_)
{
  sn::Net * model = modelSet[id];
  if(!model) {
    return STATUS_FAILURE;
  }
  model->addNode(name, sn::Convolution(filters_,
                                       static_cast<sn::active>(act_),
                                       static_cast<sn::optimizer>(opt_),
                                       dropOut_,
                                       static_cast<sn::batchNormType>(bnorm_),
                                       fWidth_, fHeight_, padding_, stride_, dilate_, gpuDeviceId_),
                 nodes);
  return STATUS_OK;
}

Status addDeconvolution(int id, const char *name, const char *nodes, unsigned int filters_, Activation act_,
                        Optimizer opt_, float dropOut_, BatchNormType bnorm_, unsigned int fWidth_,
                        unsigned int fHeight_, unsigned int stride_, unsigned int gpuDeviceId_)
{
  sn::Net * model = modelSet[id];
  if(!model) {
    return STATUS_FAILURE;
  }
  model->addNode(name, sn::Deconvolution(filters_,
                                         static_cast<sn::active>(act_),
                                         static_cast<sn::optimizer>(opt_),
                                         dropOut_,
                                         static_cast<sn::batchNormType>(bnorm_),
                                         fWidth_, fHeight_, stride_, gpuDeviceId_),
                 nodes);
  return STATUS_OK;
}


Status addPooling(int id, const char *name, const char *nodes, unsigned int kernel_, unsigned int stride_,
                  PoolType pool_, unsigned int gpuDeviceId_)
{
  sn::Net * model = modelSet[id];
  if(!model) {
    return STATUS_FAILURE;
  }
  if(gpuDeviceId_ == 0) {
    model->addNode(name, sn::Pooling(kernel_, stride_, static_cast<sn::poolType>(pool_)), nodes);
  } else {
    model->addNode(name, sn::Pooling(gpuDeviceId_), nodes);
  }
  return STATUS_OK;
}

Status addDense(int id, const char *name, const char *nodes, unsigned int units_, Activation act_, Optimizer opt_,
                float dropOut_, BatchNormType bnorm_, unsigned int gpuDeviceId_)
{
  sn::Net * model = modelSet[id];
  if(!model) {
    return STATUS_FAILURE;
  }
  model->addNode(name, sn::FullyConnected(units_,
                                          static_cast<sn::active>(act_),
                                          static_cast<sn::optimizer>(opt_),
                                          dropOut_,
                                          static_cast<sn::batchNormType>(bnorm_),
                                          gpuDeviceId_),
                 nodes);
  return STATUS_OK;
}

Status addConcat(int id, const char *name, const char *nodes, const char * sequence)
{
  sn::Net * model = modelSet[id];
  if(!model) {
    return STATUS_FAILURE;
  }
  model->addNode(name, sn::Concat(sequence), nodes);
  return STATUS_OK;
}

Status addResize(int id, const char *name, const char *nodes, unsigned int fwdBegin, unsigned int fwdEnd,
                 unsigned int bwdBegin, unsigned int bwdEnd)
{
  sn::Net * model = modelSet[id];
  if(!model) {
    return STATUS_FAILURE;
  }
  model->addNode(name, sn::Resize(sn::diap(fwdBegin, fwdEnd), sn::diap(bwdBegin, bwdEnd)), nodes);
  return STATUS_OK;
}

Status addCrop(int id, const char *name, const char *nodes, unsigned int x, unsigned int y,
               unsigned int w, unsigned int h)
{
  sn::Net * model = modelSet[id];
  if(!model) {
    return STATUS_FAILURE;
  }
  model->addNode(name, sn::Crop(sn::rect(x, y, w, h)), nodes);
  return STATUS_OK;
}

Status addSummator(int id, const char *name, const char *nodes, SummatorType type)
{
  sn::Net * model = modelSet[id];
  if(!model) {
    return STATUS_FAILURE;
  }
  model->addNode(name, sn::Summator(static_cast<sn::summatorType>(type)), nodes);
  return STATUS_OK;
}

Status addActivator(int id, const char *name, const char *nodes, Activation active)
{
  sn::Net * model = modelSet[id];
  if(!model) {
    return STATUS_FAILURE;
  }
  model->addNode(name, sn::Activation(static_cast<sn::active>(active)), nodes);
  return STATUS_OK;
}

Status addLossFunction(int id, const char *name, const char *nodes, LossType loss_)
{
  sn::Net * model = modelSet[id];
  if(!model) {
    return STATUS_FAILURE;
  }
  model->addNode(name, sn::LossFunction(static_cast<sn::lossType>(loss_)), nodes);
  return STATUS_OK;
}

Status netArchitecture(int id, char * buffer, unsigned int length)
{
  sn::Net * model = modelSet[id];
  if(!model) {
    return STATUS_FAILURE;
  }
  std::string architecture = model->getArchitecNetJN();
  if(architecture.size() > length) {
    return STATUS_FAILURE;
  } else if (architecture.empty()) {
    return STATUS_WARNING;
  }
  strcpy(buffer, architecture.c_str());
  return STATUS_OK;
}

void lastError(int id, char *buffer, unsigned int length)
{
  sn::Net * model = modelSet[id];
  if(model) {
    std::string error = model->getLastErrorStr();
    if(length >= error.size()) {
      strcpy(buffer, error.c_str());
    }
  }
}

void printLastError(int id, Status status)
{
  sn::Net * model = modelSet[id];
  if(model && status == STATUS_WARNING) {
    std::cout<<"MODEL WARNING: "<<model->getLastErrorStr()<<std::endl;
  } else if (model && status == STATUS_FAILURE) {
    std::cout<<"MODEL ERROR: "<<model->getLastErrorStr()<<std::endl;
  }
}

Status fit(int id, float *data, LayerSize dataSize, unsigned char *label, LayerSize labelsSize,
           unsigned int epochs, float learningRate, float & accuracy)
{
  sn::Net * model = modelSet[id];
  if(!model) {
    return STATUS_FAILURE;
  }
  if (labelsSize.bsz != dataSize.bsz) {
    return STATUS_FAILURE;
  }
  sn::Tensor inputLayer(sn::snLSize(dataSize.w, dataSize.h, dataSize.ch, dataSize.bsz), data);
  sn::Tensor targetLayer(sn::snLSize(labelsSize.w, labelsSize.h, labelsSize.ch, dataSize.bsz));
  sn::Tensor outputLayer(sn::snLSize(labelsSize.w, labelsSize.h, labelsSize.ch, dataSize.bsz));
  accuracy = 0;
  int classes = labelsSize.w;
  for(unsigned int epoch = 0; epoch < epochs; ++epoch) {
    for (unsigned int i = 0; i < dataSize.bsz; ++i) { // Запись распределения ответов по нейронам выходным
      float* tarData = targetLayer.data() + classes * i;
      tarData[label[i]] = 1;
    }
    // Запуск тренировки -----
    float trainAccuracy = 0.f;
    model->training(learningRate, inputLayer, outputLayer, targetLayer, trainAccuracy);
    // Расчет ошибки -----
    sn::snFloat* targetData = targetLayer.data();
    sn::snFloat* outData = outputLayer.data();
    size_t accCnt = 0, bsz = dataSize.bsz;
    for (size_t i = 0; i < bsz; ++i) {
      float* refTarget = targetData + i * classes;
      float* refOutput = outData + i * classes;
      // Вычисление правдивости предположения -----
      auto maxOutInx = std::distance(refOutput, std::max_element(refOutput, refOutput + classes));
      auto maxTargInx = std::distance(refTarget, std::max_element(refTarget, refTarget + classes));

      if (maxTargInx == maxOutInx) {  // Если угадали
        ++accCnt;
      }
    }
    accuracy += (accCnt * 1.F) / bsz;  // Расчет показателя угадывания (до 100%)
  }
  return STATUS_OK;
}

Status fitOneValue(int id, float *data, LayerSize dataSize, float *label, LayerSize labelsSize,
           unsigned int epochs, float learningRate)
{
  sn::Net * model = modelSet[id];
  if(!model) {
    return STATUS_FAILURE;
  }
  if (labelsSize.bsz != dataSize.bsz) {
    return STATUS_FAILURE;
  }
  sn::Tensor inputLayer(sn::snLSize(dataSize.w, dataSize.h, dataSize.ch, dataSize.bsz), data);
  sn::Tensor targetLayer(sn::snLSize(labelsSize.w, labelsSize.h, labelsSize.ch, dataSize.bsz), label);
  sn::Tensor outputLayer(sn::snLSize(labelsSize.w, labelsSize.h, labelsSize.ch, dataSize.bsz));
  int classes = labelsSize.w;

  for(unsigned int epoch = 0; epoch < epochs; ++epoch) {
    // Запуск тренировки -----
    float trainAccuracy = 0.f;
    model->training(learningRate, inputLayer, outputLayer, targetLayer, trainAccuracy);
    // Расчет ошибки -----
    sn::snFloat* targetData = targetLayer.data();
    sn::snFloat* outData = outputLayer.data();
    for (size_t i = 0; i < dataSize.bsz; ++i) {
//      float* refTarget = targetData + i * classes;
//      float* refOutput = outData + i * classes;
//      std::cout<<*refTarget<<" "<<*refOutput<<std::endl;
    }
  }
  return STATUS_OK;
}

Status evaluate(int id, float *data, LayerSize dataSize, unsigned char *label, LayerSize labelsSize,
                unsigned int /*verbose*/, float & accuracy)
{
  sn::Net * model = modelSet[id];
  if(!model) {
    return STATUS_FAILURE;
  }
  if (labelsSize.bsz != dataSize.bsz) {
    return STATUS_FAILURE;
  }
  accuracy = 0.f;
  sn::Tensor inputLayer(sn::snLSize(dataSize.w, dataSize.h, dataSize.ch, dataSize.bsz), data);
  sn::Tensor outputLayer(sn::snLSize(labelsSize.w, labelsSize.h, labelsSize.ch, dataSize.bsz));
  model->forward(false, inputLayer, outputLayer);
  uint32_t errors = 0;
  sn::snFloat* outData = outputLayer.data();
  for (size_t i = 0; i < dataSize.bsz; ++i) {
    float* refOutput = outData + i * labelsSize.w;
    auto maxOutInx = std::distance(refOutput, std::max_element(refOutput, refOutput + labelsSize.w));
    if(label[i] != maxOutInx) {
      ++errors;
    }
  }
  accuracy = 1.f - (float(errors) / float(dataSize.bsz));
  return STATUS_OK;
}

Status forecasting(int id, float * data, LayerSize dataSize, float * label, LayerSize labelsSize)
{
  sn::Net * model = modelSet[id];
  if(!model) {
    return STATUS_FAILURE;
  }
  if (labelsSize.bsz != dataSize.bsz) {
    return STATUS_FAILURE;
  }
  sn::Tensor inputLayer(sn::snLSize(dataSize.w, dataSize.h, dataSize.ch, dataSize.bsz), data);
  sn::Tensor outputLayer(sn::snLSize(labelsSize.w, labelsSize.h, labelsSize.ch, dataSize.bsz));
  model->forward(false, inputLayer, outputLayer);
  for(int i = 0; i < dataSize.bsz; ++i) {
    label[i] = outputLayer.data()[i];
  }
  return STATUS_OK;
}

Status run(int id, float* data, LayerSize dataSize, LayerSize labelsSize, int& result)
{
    sn::Net* model = modelSet[id];
    if (!model) {
        return STATUS_FAILURE;
    }
    if (labelsSize.bsz != dataSize.bsz) {
        return STATUS_FAILURE;
    }
    sn::Tensor inputLayer(sn::snLSize(dataSize.w, dataSize.h, dataSize.ch, dataSize.bsz), data);
    sn::Tensor outputLayer(sn::snLSize(labelsSize.w, labelsSize.h, labelsSize.ch, dataSize.bsz));
    model->forward(false, inputLayer, outputLayer);
    sn::snFloat* outData = outputLayer.data();
    float* refOutput = outData;
    result = std::distance(refOutput, std::max_element(refOutput, refOutput + labelsSize.w));
    return STATUS_OK;
}

Status saveModel(int id, const char *filename)
{
  sn::Net * model = modelSet[id];
  if(!model) {
    return STATUS_FAILURE;
  }
  if(!model->saveAllWeightToFile(filename)) {
    return STATUS_FAILURE;
  }
  return STATUS_OK;
}

Status loadModel(int id, const char *filename)
{
  sn::Net * model = modelSet[id];
  if(!model) {
    return STATUS_FAILURE;
  }
  if(!model->loadAllWeightFromFile(filename)) {
    return STATUS_FAILURE;
  }
  return STATUS_OK;
}
