#include "snTensor.h"

namespace SN_API{

  Tensor::Tensor(const snLSize & lsz, const std::vector<snFloat> & data)
  {
    lsz_ = lsz;
    size_t sz = lsz.w * lsz.h * lsz.ch * lsz.bsz;
    data_.resize(sz);
    if (data.size() == sz) {
      data_ = data;
    }
  };

  Tensor::Tensor(const snLSize & lsz, snFloat * data)
  {
    lsz_ = lsz;
    size_t sz = lsz.w * lsz.h * lsz.ch * lsz.bsz;
    data_.resize(sz);
    memcpy(data_.data(), data, sz * sizeof(snFloat));
  };

  Tensor::~Tensor()
  {

  };

  bool Tensor::addChannel(uint32_t w, uint32_t h, std::vector<snFloat> & data)
  {
    if ((w != lsz_.w) || (h != lsz_.h)) {
      return false;
    }
    size_t csz = data_.size();
    data_.resize(csz + w * h);
    memcpy(data_.data() + csz, data.data(), w * h * sizeof(snFloat));

    ++chsz_;
    if (chsz_ == lsz_.ch){
      chsz_ = 0;
      ++lsz_.bsz;
    }
    return true;
  }

  bool Tensor::addChannel(uint32_t w, uint32_t h, snFloat* data)
  {
    if ((w != lsz_.w) || (h != lsz_.h)) {
      return false;
    }
    size_t csz = data_.size();
    data_.resize(csz + w * h);
    memcpy(data_.data() + csz, data, w * h * sizeof(snFloat));

    ++chsz_;
    if (chsz_ == lsz_.ch){
      chsz_ = 0;
      ++lsz_.bsz;
    }
    return true;
  }

  void Tensor::clear()
  {
    std::fill(data_.begin(), data_.end(), 0);
  }

  snFloat* Tensor::data()
  {
    return data_.data();
  }

  snLSize Tensor::size()
  {
    return lsz_;
  }

}
