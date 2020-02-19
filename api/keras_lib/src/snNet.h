//
// SkyNet Project
// Copyright (C) 2018 by Contributors <https://github.com/Tyill/skynet>
//
// This code is licensed under the MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files(the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and / or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions :
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
#pragma once


#include <cstdint>
#include <string>
#include <vector>
#include <sstream>
#include <algorithm>
#include "../../src/skynet/skyNet.h"
#include "snTensor.h"
#include "keras_lib_global.h"

namespace SN_API{
      
    /// version library
    /// @return version
    std::string versionLib();
   
    class KERAS_EXPORT Net{
               
    public:

        /// create net
        /// @param[in] jnNet - network architecture in JSON
        /// @param[in] weightPath - path to file with weight
        Net(const std::string& jnNet = "", const std::string& weightPath = "");

        ~Net();
               
        /// last error
        /// @return "" ok
        std::string getLastErrorStr();

        /// add node (layer)
        /// @param[in] name - name node in architecture of net
        /// @param[in] nd - tensor node
        /// @param[in] nextNodes - next nodes through a space
        /// @return ref Net
        template<typename Operator>
        Net& addNode(const std::string& name, Operator nd, const std::string& nextNodes) {
          nodes_.push_back(node{ name, nd.name(), nd.getParamsJn(), nextNodes });
          return *this;
        }

        /// update param node (layer)
        /// @param[in] name - name node in architecture of net
        /// @param[in] nd - tensor node
        /// @return true - ok
        template<typename Operator>
        bool updateNode(const std::string& name, Operator nd) {
          bool ok = false;
          if (net_)
            ok = snSetParamNode(net_, name.c_str(), nd.getParamsJn().c_str());
          else{
            for (auto& n : nodes_){
              if (n.name == name){
                n.params = nd.getParamsJn();
                ok = true;
                break;
              }
            }
          }

          return ok;
        }

        /// forward action
        /// @param[in] isLern - is lerning ?
        /// @param[in] inTns - in tensor NCHW(bsz, ch, h, w)
        /// @param[inout] outTns - out result tensor
        /// @return true - ok
        bool forward(bool isLern, Tensor& inTns, Tensor& outTns);

        /// backward action
        /// @param[in] lr - lerning rate
        /// @param[in] gradTns - grad error tensor NCHW(bsz, ch, h, w)
        /// @return true - ok
        bool backward(snFloat lr, Tensor& gradTns);

        /// training action - cycle forward-backward
        /// @param[in] lr - lerning rate
        /// @param[in] inTns - in tensor NCHW(bsz, ch, h, w)
        /// @param[inout] outTns - out tensor
        /// @param[in] targetTns - target tensor
        /// @param[inout] outAccurate - accurate error
        /// @return true - ok
        bool training(snFloat lr, Tensor& inTns, Tensor& outTns, Tensor& targetTns, snFloat& outAccurate);
        
        /// set weight of node
        /// @param[in] name - name node in architecture of net
        /// @param[in] weight - set weight tensor NCHW(bsz, ch, h, w)
        /// @return true - ok
        bool setWeightNode(const std::string& name, Tensor& weight);

        /// get weight of node
        /// @param[in] name - name node in architecture of net
        /// @param[out] outWeight - weight tensor NCHW(bsz, ch, h, w)
        /// @return true - ok
        bool getWeightNode(const std::string& name, Tensor& outWeight);
        
        /// get output of node
        /// @param[in] name - name node in architecture of net
        /// @param[out] output - output tensor NCHW(bsz, ch, h, w)
        /// @return true - ok
        bool getOutputNode(const std::string& name, Tensor& output);

        /// save all weight's in file
        /// @param[in] path - file path
        /// @return true - ok
        bool saveAllWeightToFile(const std::string& path);

        /// load all weight's from file
        /// @param[in] path - file path
        /// @return true - ok
        bool loadAllWeightFromFile(const std::string& path);

        /// add user callback
        /// @param[in] name - name userCBack in architecture of net
        /// @param[in] cback - call back function
        /// @param[in] udata - aux data
        /// @return true - ok
        bool addUserCBack(const std::string& name, snUserCBack cback, snUData udata);

        /// architecture of net in json
        /// @return jn arch
        std::string getArchitecNetJN();

    private:

        std::string err_;

        struct node{
            std::string name;
            std::string opr;
            std::string params;
            std::string nextNodes;
        };

        struct uCBack{
            std::string name;
            snUserCBack cback;
            snUData udata;           
        };

        std::vector<node> nodes_;
        std::vector<uCBack> ucb_;

        skyNet net_ = nullptr;

        std::string netStruct_;

        bool createNet();

        bool createNet(const std::string& jnNet);
    };

    
}
