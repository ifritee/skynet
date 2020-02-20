#include "snOperator.h"

namespace SN_API{

  Input::Input()
  {

  };

  Input::~Input()
  {

  };

  std::string Input::getParamsJn()
  {
    std::stringstream ss;
    ss << "{"
          "}";
    return  ss.str();
  }

  std::string Input::name()
  {
    return "Input";
  }

  //----------------------------------------------------------------------------
  FullyConnected::FullyConnected(uint32_t units_, active act_, optimizer opt_, snFloat dropOut_,
                                 batchNormType bnorm_, uint32_t gpuDeviceId_):
    units(units_),
    act(act_),
    opt(opt_),
    dropOut(dropOut_),
    bnorm(bnorm_),
    gpuDeviceId(gpuDeviceId_)
  {

  };

  FullyConnected::FullyConnected(uint32_t units_, batchNormType bnorm_) :
    units(units_),
    bnorm(bnorm_)
  {

  }

  FullyConnected::~FullyConnected()
  {

  };

  std::string FullyConnected::getParamsJn()
  {
    std::stringstream ss;
    ss << "{\"units\":\"" << units << "\","
           "\"active\":\"" << activeStr(act) << "\","
           "\"weightInit\":\"" << weightInitStr(wini) << "\","
           "\"batchNorm\":\"" << batchNormTypeStr(bnorm) << "\","
           "\"batchNormLr\":\"" << batchNormLr << "\","
           "\"optimizer\":\"" << optimizerStr(opt) << "\","
           "\"decayMomentDW\":\"" << decayMomentDW << "\","
           "\"decayMomentWGr\":\"" << decayMomentWGr << "\","
           "\"lmbRegular\":\"" << lmbRegular << "\","
           "\"dropOut\":\"" << dropOut << "\","
           "\"gpuDeviceId\":\"" << gpuDeviceId << "\","
           "\"freeze\":\"" << (freeze ? 1 : 0) << "\","
           "\"useBias\":\"" << (useBias ? 1 : 0) << "\""
           "}";

    return ss.str();
  }

  std::string FullyConnected::name()
  {
    return "FullyConnected";
  }

//----------------------------------------------------------------------------
    Convolution::Convolution(uint32_t filters_, active act_, optimizer opt_, snFloat dropOut_,
                batchNormType bnorm_, uint32_t fWidth_, uint32_t fHeight_, int padding_,
                uint32_t stride_, uint32_t dilate_, uint32_t gpuDeviceId_):
      filters(filters_),
      act(act_),
      opt(opt_),
      dropOut(dropOut_),
      bnorm(bnorm_),
      fWidth(fWidth_),
      fHeight(fHeight_),
      padding(padding_),
      stride(stride_),
      dilate(dilate_),
      gpuDeviceId(gpuDeviceId_)
    {

    }

    Convolution::Convolution(uint32_t filters_, uint32_t kernelSz, int padding_, uint32_t stride_,
                batchNormType bnorm_, active act_) :
      filters(filters_),
      act(act_),
      bnorm(bnorm_),
      fWidth(kernelSz),
      fHeight(kernelSz),
      padding(padding_),
      stride(stride_)
    {

    }

    Convolution::Convolution(uint32_t filters_, int padding_) :
      filters(filters_),
      padding(padding_)
    {

    }

    Convolution::~Convolution()
    {

    };

    std::string Convolution::getParamsJn()
    {
      std::stringstream ss;
      ss << "{\"filters\":\"" << filters << "\","
             "\"fWidth\":\"" << fWidth << "\","
             "\"fHeight\":\"" << fHeight << "\","
             "\"padding\":\"" << padding << "\","
             "\"stride\":\"" << stride << "\","
             "\"dilate\":\"" << dilate << "\","
             "\"active\":\"" << activeStr(act) << "\","
             "\"weightInit\":\"" << weightInitStr(wini) << "\","
             "\"batchNorm\":\"" << batchNormTypeStr(bnorm) << "\","
             "\"batchNormLr\":\"" << batchNormLr << "\","
             "\"optimizer\":\"" << optimizerStr(opt) << "\","
             "\"decayMomentDW\":\"" << decayMomentDW << "\","
             "\"decayMomentWGr\":\"" << decayMomentWGr << "\","
             "\"lmbRegular\":\"" << lmbRegular << "\","
             "\"dropOut\":\"" << dropOut << "\","
             "\"gpuDeviceId\":\"" << gpuDeviceId << "\","
             "\"freeze\":\"" << (freeze ? 1 : 0) << "\","
             "\"useBias\":\"" << (useBias ? 1 : 0) << "\""
             "}";

      return ss.str();
    }

    std::string Convolution::name()
    {
      return "Convolution";
    }

//-----------------------------------------------------------------------------
    Deconvolution::Deconvolution(uint32_t filters_, active act_, optimizer opt_, snFloat dropOut_,
                  batchNormType bnorm_, uint32_t fWidth_, uint32_t fHeight_, uint32_t stride_,
                                 uint32_t gpuDeviceId_):
      filters(filters_),
      act(act_),
      opt(opt_),
      dropOut(dropOut_),
      bnorm(bnorm_),
      fWidth(fWidth_),
      fHeight(fHeight_),
      stride(stride_),
      gpuDeviceId(gpuDeviceId_)
    {

    }

    Deconvolution::Deconvolution(uint32_t filters_) :
      filters(filters_)
    {

    }

    Deconvolution::~Deconvolution()
    {

    };

    std::string Deconvolution::getParamsJn()
    {
      std::stringstream ss;
      ss << "{\"filters\":\"" << filters << "\","
             "\"fWidth\":\"" << fWidth << "\","
             "\"fHeight\":\"" << fHeight << "\","
             "\"stride\":\"" << stride << "\","
             "\"active\":\"" << activeStr(act) << "\","
             "\"weightInit\":\"" << weightInitStr(wini) << "\","
             "\"batchNorm\":\"" << batchNormTypeStr(bnorm) << "\","
             "\"batchNormLr\":\"" << batchNormLr << "\","
             "\"optimizer\":\"" << optimizerStr(opt) << "\","
             "\"decayMomentDW\":\"" << decayMomentDW << "\","
             "\"decayMomentWGr\":\"" << decayMomentWGr << "\","
             "\"lmbRegular\":\"" << lmbRegular << "\","
             "\"dropOut\":\"" << dropOut << "\","
             "\"gpuDeviceId\":\"" << gpuDeviceId << "\","
             "\"freeze\":\"" << (freeze ? 1 : 0) << "\""
             "}";

      return ss.str();
    }

    std::string Deconvolution::name(){
      return "Deconvolution";
    }

//----------------------------------------------------------------------------
    Pooling::Pooling(uint32_t gpuDeviceId_):
      gpuDeviceId(gpuDeviceId_)
    {

    }

    Pooling::Pooling(uint32_t kernel_, uint32_t stride_, poolType pool_) :
      kernel(kernel_),
      stride(stride_),
      pool(pool_)
    {

    }

    Pooling::~Pooling()
    {

    };

    std::string Pooling::getParamsJn()
    {
      std::stringstream ss;
      ss << "{\"kernel\":\"" << kernel << "\","
             "\"stride\":\"" << stride << "\","
             "\"pool\":\"" << poolTypeStr(pool) << "\","
             "\"gpuDeviceId\":\"" << gpuDeviceId << "\""
             "}";
      return ss.str();
    }

    std::string Pooling::name()
    {
      return "Pooling";
    }

//----------------------------------------------------------------------------

    Lock::Lock(lockType lockTp_) : lockTp(lockTp_)
    {

    }

    Lock::~Lock()
    {

    };

    std::string Lock::getParamsJn()
    {
      std::stringstream ss;
      ss << "{\"state\":\"" << lockTypeStr(lockTp) << "\""
             "}";
      return ss.str();
    }

    std::string Lock::name()
    {
      return "Lock";
    }

//----------------------------------------------------------------------------

    Switch::Switch(const std::string& nextWay_) :nextWay(nextWay_)
    {

    };

    Switch::~Switch()
    {

    };

    std::string Switch::getParamsJn()
    {
      std::stringstream ss;
      ss << "{\"nextWay\":\"" << nextWay << "\""
                                            "}";
      return ss.str();
    }

    std::string Switch::name()
    {
      return "Switch";
    }

//------------------------------------------------------------------------------

    Summator::Summator(summatorType summType_) :
      summType(summType_)
    {

    };

    Summator::~Summator()
    {

    };

    std::string Summator::getParamsJn()
    {
      std::stringstream ss;
      ss << "{\"type\":\"" << summatorTypeStr(summType) << "\""
             "}";
      return ss.str();
    }

    std::string Summator::name()
    {
      return "Summator";
    }

//------------------------------------------------------------------------------

    Concat::Concat(const std::string& sequence_) :
      sequence(sequence_)
    {

    };

    Concat::~Concat()
    {

    };

    std::string Concat::getParamsJn()
    {
      std::stringstream ss;
      ss << "{\"sequence\":\"" << sequence << "\""
             "}";
      return ss.str();
    }

    std::string Concat::name()
    {
      return "Concat";
    }

//--------------------------------------------------------------------------------

    Resize::Resize(const diap& fwdDiap_, const diap& bwdDiap_) :
      fwdDiap(fwdDiap_),
      bwdDiap(bwdDiap_)
    {

    };

    Resize::~Resize()
    {

    };

    std::string Resize::getParamsJn()
    {
      std::stringstream ss;
      ss << "{\"fwdDiap\":\"" << fwdDiap.begin << " " << fwdDiap.end << "\","
             "\"bwdDiap\":\"" << bwdDiap.begin << " " << bwdDiap.end << "\""
             "}";
      return ss.str();
    }

    std::string Resize::name()
    {
      return "Resize";
    }

//-----------------------------------------------------------------------------

    Crop::Crop(const rect& rct_) :
      rct(rct_)
    {

    };

    Crop::~Crop()
    {

    };

    std::string Crop::getParamsJn()
    {
      std::stringstream ss;
      ss << "{\"roi\":\"" << rct.x << " " << rct.y << " " << rct.w << " " << rct.h << "\""
             "}";
      return ss.str();
    }

    std::string Crop::name()
    {
      return "Crop";
    }

//----------------------------------------------------------------------------

    Activation::Activation(const active& act_) :
      act(act_)
    {

    };

    Activation::~Activation()
    {

    };

    std::string Activation::getParamsJn()
    {
      std::stringstream ss;
      ss << "{\"active\":\"" << activeStr(act) + "\"}";
      return ss.str();
    }

    std::string Activation::name()
    {
      return "Activation";
    }

//---------------------------------------------------------------------------------------------

    UserLayer::UserLayer(const std::string& cbackName_) :
      cbackName(cbackName_)
    {

    };

    UserLayer::~UserLayer()
    {

    };

    std::string UserLayer::getParamsJn()
    {
      std::stringstream ss;
      ss << "{\"cbackName\":\"" << cbackName << "\""
                                                "}";
      return ss.str();
    }

    std::string UserLayer::name()
    {
      return "UserLayer";
    }

//-----------------------------------------------------------------------------------

    LossFunction::LossFunction(lossType loss_) :
      loss(loss_)
    {

    };

    LossFunction::~LossFunction()
    {

    };

    std::string LossFunction::getParamsJn()
    {
      std::stringstream ss;
      ss << "{\"loss\":\"" << lossTypeStr(loss) << "\""
             "}";
      return ss.str();
    }

    std::string LossFunction::name()
    {
      return "LossFunction";
    }

//--------------------------------------------------------------------------------------

    BatchNormLayer::BatchNormLayer()
    {

    };

    BatchNormLayer::~BatchNormLayer()
    {

    };

    std::string BatchNormLayer::getParamsJn()
    {
      std::stringstream ss;
      ss << "{}";
      return ss.str();
    }

    std::string BatchNormLayer::name()
    {
      return "BatchNorm";
    }

}
