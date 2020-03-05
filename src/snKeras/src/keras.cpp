#include <string>
#include <iostream>
#include <map>
#include <string.h>

#include "snNet.h"
#include "snOperator.h"
#include "snTensor.h"
#include "snType.h"

#include "keras.h"

namespace sn = SN_API;

static sn::Net * model = nullptr; ///< @brief Модель
static float accuratSummLast = 0;

static sn::Tensor * spInputLayer = nullptr;
static sn::Tensor * spTargetLayer = nullptr;
static sn::Tensor * spOutputLayer = nullptr;
static int sClasses = 0;
static int sEpochs = 0;
static float sAccuratSumm = 0.f, sTestPercent = 0.f;

Status createModel()
{
  int createStatus = STATUS_OK;
  if(model) { // Если модель существует,
    delete model; //то удаляем ее
    createStatus = STATUS_WARNING;
  }
  try {
    model = new sn::Net;
  } catch(...) {
    createStatus = STATUS_FAILURE;
    model = nullptr;
  }
  return createStatus;
}

Status addInput(const char * name, const char * nodes)
{
  if(!model) {
    return STATUS_FAILURE;
  }
  model->addNode(name, sn::Input(), nodes);
  return STATUS_OK;
}

Status addConvolution(const char * name, const char * nodes, unsigned int filters_, Activation act_,
                      Optimizer opt_, float dropOut_, BatchNormType bnorm_, unsigned int fWidth_,
                      unsigned int fHeight_, int padding_, unsigned int stride_, unsigned int dilate_,
                      unsigned int gpuDeviceId_)
{
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

Status addDeconvolution(const char *name, const char *nodes, unsigned int filters_, Activation act_,
                        Optimizer opt_, float dropOut_, BatchNormType bnorm_, unsigned int fWidth_,
                        unsigned int fHeight_, unsigned int stride_, unsigned int gpuDeviceId_)
{
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


Status addPooling(const char *name, const char *nodes, unsigned int kernel_, unsigned int stride_,
                  PoolType pool_, unsigned int gpuDeviceId_)
{
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

Status addDense(const char *name, const char *nodes, unsigned int units_, Activation act_, Optimizer opt_,
                float dropOut_, BatchNormType bnorm_, unsigned int gpuDeviceId_)
{
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

Status addLossFunction(const char *name, const char *nodes, LossType loss_)
{
  if(!model) {
    return STATUS_FAILURE;
  }
  model->addNode(name, sn::LossFunction(static_cast<sn::lossType>(loss_)), nodes);
  return STATUS_OK;
}

Status netArchitecture(char * buffer, unsigned int length)
{
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

void lastError(char *buffer, unsigned int length)
{
  if(model) {
    std::string error = model->getLastErrorStr();
    if(length >= error.size()) {
      strcpy(buffer, error.c_str());
    }
  }
}

void printLastError(Status status)
{
  if(model && status == STATUS_WARNING) {
    std::cout<<"MODEL WARNING: "<<model->getLastErrorStr()<<std::endl;
  } else if (model && status == STATUS_FAILURE) {
    std::cout<<"MODEL ERROR: "<<model->getLastErrorStr()<<std::endl;
  }
}

Status fit(float *data, LayerSize dataSize, unsigned char *label, LayerSize labelsSize,
           unsigned int epochs, float learningRate)
{
  if(!model) {
    return STATUS_FAILURE;
  }
  if (labelsSize.bsz != dataSize.bsz) {
    return STATUS_FAILURE;
  }
  sn::Tensor inputLayer(sn::snLSize(dataSize.w, dataSize.h, dataSize.ch, dataSize.bsz), data);
  sn::Tensor targetLayer(sn::snLSize(labelsSize.w, labelsSize.h, labelsSize.ch, dataSize.bsz));
  sn::Tensor outputLayer(sn::snLSize(labelsSize.w, labelsSize.h, labelsSize.ch, dataSize.bsz));
  float accuratSumm = 0;
  int classes = labelsSize.w;
  for(unsigned int epoch = 0; epoch < epochs; ++epoch) {
    for (unsigned int i = 0; i < dataSize.bsz; ++i) { // Запись распределения ответов по нейронам выходным
      float* tarData = targetLayer.data() + classes * i;
      tarData[label[i]] = 1;
    }
    // Запуск тренировки -----
    float accurat = 0;
    model->training(learningRate, inputLayer, outputLayer, targetLayer, accurat);
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

    accuratSumm += (accCnt * 1.F) / bsz;  // Расчет показателя угадывания (до 100%)
    accuratSummLast = epoch > 0 ? accuratSumm / epoch: accuratSumm;
    accuratSummLast = accuratSummLast > 1.f ? 1.00f : accuratSummLast;
    //std::cout << epoch << " accurate " << accuratSummLast << " " << model->getLastErrorStr() << std::endl;
  }
  return STATUS_OK;
}

float lastAccurateSum()
{
    return accuratSummLast;
}

Status trainCreate(float *data, LayerSize dataSize, unsigned char *label, LayerSize labelsSize)
{
  if(!model) {
    return STATUS_FAILURE;
  }
  if (labelsSize.bsz != dataSize.bsz) {
    return STATUS_FAILURE;
  }
  if(spInputLayer != nullptr || spTargetLayer != nullptr || spOutputLayer != nullptr) {
    return STATUS_FAILURE;
  }
  sClasses = labelsSize.w;
  spInputLayer = new sn::Tensor(sn::snLSize(dataSize.w, dataSize.h, dataSize.ch, dataSize.bsz), data);
  spTargetLayer = new sn::Tensor(sn::snLSize(labelsSize.w, labelsSize.h, labelsSize.ch, dataSize.bsz));
  spOutputLayer = new sn::Tensor(sn::snLSize(labelsSize.w, labelsSize.h, labelsSize.ch, dataSize.bsz));
  for (unsigned int i = 0; i < dataSize.bsz; ++i) { // Запись распределения ответов по нейронам выходным
    float* tarData = spTargetLayer->data() + sClasses * i;
    tarData[label[i]] = 1;
  }
  accuratSummLast = 0;
  sEpochs = 0;
  sAccuratSumm = 0;
  return STATUS_OK;
}

Status trainStep(float learningRate, LayerSize dataSize)
{
  if(!model) {
    return STATUS_FAILURE;
  }
  // Запуск тренировки -----
  float accurat = 0;
  model->training(learningRate, *spInputLayer, *spOutputLayer, *spTargetLayer, accurat);
  // Расчет ошибки -----
  sn::snFloat* targetData = spTargetLayer->data();
  sn::snFloat* outData = spOutputLayer->data();
  size_t accCnt = 0, bsz = dataSize.bsz;
  for (size_t i = 0; i < bsz; ++i) {
    float* refTarget = targetData + i * sClasses;
    float* refOutput = outData + i * sClasses;

    // Вычисление правдивости предположения -----
    auto maxOutInx = std::distance(refOutput, std::max_element(refOutput, refOutput + sClasses));
    auto maxTargInx = std::distance(refTarget, std::max_element(refTarget, refTarget + sClasses));

    if (maxTargInx == maxOutInx) {  // Если угадали
      ++accCnt;
    }
  }

  sAccuratSumm += (accCnt * 1.F) / bsz;  // Расчет показателя угадывания (до 100%)
  accuratSummLast = sEpochs > 0 ? sAccuratSumm / sEpochs : sAccuratSumm;
  accuratSummLast = accuratSummLast > 1.f ? 1.00f : accuratSummLast;
  ++sEpochs;
  return STATUS_OK;
}

Status trainStop()
{
  if(!model) {
    return STATUS_FAILURE;
  }
  if(spInputLayer != nullptr || spTargetLayer != nullptr || spOutputLayer != nullptr) {
    spInputLayer->clear();
    spTargetLayer->clear();
    spOutputLayer->clear();
  }
  delete spInputLayer;
  delete spTargetLayer;
  delete spOutputLayer;
  spInputLayer = nullptr;
  spTargetLayer = nullptr;
  spOutputLayer = nullptr;

  return STATUS_OK;
}

Status evaluate(float *data, LayerSize dataSize, unsigned char *label, LayerSize labelsSize,
                unsigned int /*verbose*/)
{
  if(!model) {
    return STATUS_FAILURE;
  }
  if (labelsSize.bsz != dataSize.bsz) {
    return STATUS_FAILURE;
  }
  sTestPercent = 0.f;
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
  sTestPercent = 100.00f - float(errors) * 100.f / float(dataSize.bsz);
  //std::cout<<"ERRORS QTY = "<<errors<<std::endl;
  return STATUS_OK;
}

float testPercents() 
{
  return sTestPercent;
}

Status saveModel(const char *filename)
{
  if(!model) {
    return STATUS_FAILURE;
  }
  if(!model->saveAllWeightToFile(filename)) {
    return STATUS_FAILURE;
  }
  return STATUS_OK;
}

Status loadModel(const char *filename)
{
  if(!model) {
    return STATUS_FAILURE;
  }
  if(!model->loadAllWeightFromFile(filename)) {
    return STATUS_FAILURE;
  }
  return STATUS_OK;
}
