#include "snNet.h"

namespace SN_API {

  std::string versionLib()
  {
    char ver[32];
    snVersionLib(ver);
    return ver;
  }

  Net::Net(const std::string& jnNet, const std::string& weightPath)
  {
    if (!jnNet.empty()) {
      createNet(jnNet);
    }

    if (net_ && !weightPath.empty()) {
      loadAllWeightFromFile(weightPath);
    }
  };

  Net::~Net()
  {
    if (net_) {
      snFreeNet(net_);
    }
  };

  std::string Net::getLastErrorStr()
  {
    if (net_) {
      char err[256];
      err[0] = '\0';
      snGetLastErrorStr(net_, err);
      err_ = err;
    }
    return err_;
  }

  bool Net::forward(bool isLern, Tensor& inTns, Tensor& outTns)
  {
    if (!net_ && !createNet()) return false;
    return snForward(net_, isLern, inTns.size(), inTns.data(), outTns.size(), outTns.data());
  }

  bool Net::backward(snFloat lr, Tensor& gradTns)
  {
    if (!net_ && !createNet()) {
      return false;
    }
    return snBackward(net_, lr, gradTns.size(), gradTns.data());
  }

  bool Net::training(snFloat lr, Tensor& inTns, Tensor& outTns, Tensor& targetTns, snFloat& outAccurate)
  {

    if (!net_ && !createNet()) {
      return false;
    }
    return snTraining(net_, lr, inTns.size(), inTns.data(),
                      outTns.size(), outTns.data(),
                      targetTns.data(), &outAccurate);
  }

  bool Net::setWeightNode(const std::string& name, Tensor& weight)
  {
    if (!net_ && !createNet()) {
      return false;
    }
    return snSetWeightNode(net_, name.c_str(), weight.size(), weight.data());
  }

  bool Net::getWeightNode(const std::string& name, Tensor& outWeight)
  {
    if (!net_) {
      return false;
    }

    snLSize wsz; snFloat* wdata = nullptr;
    if (snGetWeightNode(net_, name.c_str(), &wsz, &wdata) && wdata) {
      outWeight = Tensor(wsz, wdata);
      snFreeResources(wdata, 0);
      return true;
    }
    return false;
  }

  bool Net::getOutputNode(const std::string& name, Tensor& output)
  {
    if (!net_) {
      return false;
    }
    snLSize osz; snFloat* odata = nullptr;
    if (snGetOutputNode(net_, name.c_str(), &osz, &odata) && odata)
    {
      output = Tensor(osz, odata);
      snFreeResources(odata, 0);
      return true;
    }
    return false;
  }

  bool Net::saveAllWeightToFile(const std::string& path)
  {
    if (!net_) {
      return false;
    }
    return snSaveAllWeightToFile(net_, path.c_str());
  }

  bool Net::loadAllWeightFromFile(const std::string& path)
  {
    if (!net_ && !createNet()) {
      return false;
    }
    return snLoadAllWeightFromFile(net_, path.c_str());
  }

  bool Net::addUserCBack(const std::string& name, snUserCBack cback, snUData udata)
  {
    bool ok = true;
    if (net_) {
      ok = snAddUserCallBack(net_, name.c_str(), cback, udata);
    } else {
      ucb_.push_back(uCBack{ name, cback, udata });
    }
    return ok;
  }

  std::string Net::getArchitecNetJN()
  {
    if (!net_ && !createNet()) {
      return "";
    }
    char* arch = nullptr;
    snGetArchitecNet(net_, &arch);
    std::string ret = arch;
    snFreeResources(0, arch);
    return ret;
  }


  bool Net::createNet()
  {
    if (net_) {
      return true;
    }
    if (nodes_.empty()) {
      return false;
    }
    std::string beginNode = nodes_.front().name;
    std::string prevEndNode = nodes_.back().name;

    for (auto& nd : nodes_){
      if (nd.opr == "Input") beginNode = nd.nextNodes;
      if (nd.nextNodes == "Output"){
        prevEndNode = nd.name;
        nd.nextNodes = "EndNet";
      }
    }

    std::stringstream ss;
    ss << "{"
          "\"BeginNet\":"
          "{"
          "\"NextNodes\":\"" + beginNode + "\""
                                           "},"

                                           "\"Nodes\":"
                                           "[";

    size_t sz = nodes_.size();
    for (size_t i = 0; i < sz; ++i){

      auto& nd = nodes_[i];

      if ((nd.opr == "Input") || (nd.opr == "Output"))
        continue;

      ss << "{"
            "\"NodeName\":\"" + nd.name + "\","
            "\"NextNodes\":\"" + nd.nextNodes + "\","
            "\"OperatorName\":\"" + nd.opr + "\","
            "\"OperatorParams\":" + nd.params + ""
            "}";

      if (i < sz - 1)  ss << ",";
    }

    ss << "],"

          "\"EndNet\":"
          "{"
          "\"PrevNode\":\"" + prevEndNode + "\""
                                            "}"
                                            "}";
    return createNet(ss.str().c_str());
  }

  bool Net::createNet(const std::string& jnNet)
  {

    if (net_) {
      return true;
    }

    char err[256]; err[0] = '\0';
    net_ = snCreateNet(jnNet.c_str(), err);
    err_ = err;
    if (net_) {
      for (auto& cb : ucb_) {
        snAddUserCallBack(net_, cb.name.c_str(), cb.cback, cb.udata);
      }
    }
    return net_ != nullptr;
  }
}
