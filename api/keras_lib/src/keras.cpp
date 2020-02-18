#include <string>
#include <map>

#include "snNet.h"
#include "snOperator.h"
#include "snTensor.h"
#include "snType.h"

#include "keras.h"

namespace sn = SN_API;

static sn::Net * model = nullptr; ///< @brief Модель

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
