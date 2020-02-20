#include "snType.h"

namespace SN_API {

  std::string activeStr(active act){

    switch (act){
    case active::none:      return "none";
    case active::sigmoid:   return "sigmoid";
    case active::relu:      return "relu";
    case active::leakyRelu: return "leakyRelu";
    case active::elu:       return "elu";
    default:                return "none";
    }
  }

  std::string weightInitStr(weightInit wini){

    switch (wini){
    case weightInit::uniform: return "uniform";
    case weightInit::he:      return "he";
    case weightInit::lecun:   return "lecun";
    case weightInit::xavier:  return "xavier";
    default:                  return "uniform";
    }
  }

  std::string batchNormTypeStr(batchNormType bnorm){

    switch (bnorm){
    case batchNormType::none:         return "none";
    case batchNormType::beforeActive: return "beforeActive";
    case batchNormType::postActive:   return "postActive";
    default:                          return "none";
    }
  }

  std::string optimizerStr(optimizer opt){

    switch (opt){
    case optimizer::sgd:       return "sgd";
    case optimizer::sgdMoment: return "sgdMoment";
    case optimizer::adagrad:   return "adagrad";
    case optimizer::RMSprop:   return "RMSprop";
    case optimizer::adam:      return "adam";
    default:                   return "adam";
    }
  }

  std::string poolTypeStr(poolType poolt){

    switch (poolt){
    case poolType::max: return "max";
    case poolType::avg: return "avg";
    default:            return "max";
    }
  }

  std::string lockTypeStr(lockType ltp){

    switch (ltp){
    case lockType::lock:   return "lock";
    case lockType::unlock: return "unlock";
    default:               return "unlock";
    }
  }

  std::string summatorTypeStr(summatorType stp){

    switch (stp){
    case summatorType::summ: return "summ";
    case summatorType::diff: return "diff";
    case summatorType::mean: return "mean";
    default:                 return "summ";
    }
  }

  std::string lossTypeStr(lossType stp){

    switch (stp){
    case lossType::softMaxToCrossEntropy: return "softMaxToCrossEntropy";
    case lossType::binaryCrossEntropy: return "binaryCrossEntropy";
    case lossType::regressionMSE: return "regressionMSE";       ///< Mean Square Error
    case lossType::userLoss: return "userLoss";
    default:  return "userLoss";
    }
  }
}
