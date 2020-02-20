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
#include <sstream>
#include "snType.h"
#include "../../src/skynet/skyNet.h"
#include "snkeras_global.h"

namespace SN_API{
       
    /*
    Input layer.
    */
    class Input{

    public:

        Input();

        ~Input();

        std::string getParamsJn();

        std::string name();
    };

    /*
    Fully connected layer
    */
    class FullyConnected {

    public:

        uint32_t units;                            ///< Number of out neurons. !Required parameter [0..)
        active act = active::relu;                 ///< Activation function type. Optional parameter
        optimizer opt = optimizer::adam;           ///< Optimizer of weights. Optional parameter
        snFloat dropOut = 0.0;                     ///< Random disconnection of neurons. Optional parameter [0..1.F]
        batchNormType bnorm = batchNormType::none; ///< Type of batch norm. Optional parameter
        uint32_t gpuDeviceId = 0;                  ///< GPU Id. Optional parameter
        bool freeze = false;                       ///< Do not change weights. Optional parameter
        bool useBias = true;                       ///< +bias. Optional parameter
        weightInit wini = weightInit::he;          ///< Type of initialization of weights. Optional parameter
        snFloat decayMomentDW = 0.9F;              ///< Optimizer of weights moment change. Optional parameter [0..1.F]
        snFloat decayMomentWGr = 0.99F;            ///< Optimizer of weights moment change of prev. Optional parameter [0..1.F]
        snFloat lmbRegular = 0.001F;               ///< Optimizer of weights l2Norm. Optional parameter [0..1.F]
        snFloat batchNormLr = 0.001F;              ///< Learning rate for batch norm coef. Optional parameter [0..)
        
        FullyConnected(uint32_t units_,
                       active act_ = active::relu,                
                       optimizer opt_ = optimizer::adam,          
                       snFloat dropOut_ = 0.0,                    
                       batchNormType bnorm_ = batchNormType::none,
                       uint32_t gpuDeviceId_ = 0);

        FullyConnected(uint32_t units_, batchNormType bnorm_);

        ~FullyConnected();
              
        std::string getParamsJn();

        std::string name();
    };

    /*
    Convolution layer
    */
    class Convolution{

    public:
        
        uint32_t filters;                          ///< Number of output layers. !Required parameter [0..)
        active act = active::relu;                 ///< Activation function type. Optional parameter
        optimizer opt = optimizer::adam;           ///< Optimizer of weights. Optional parameter
        snFloat dropOut = 0.0;                     ///< Random disconnection of neurons. Optional parameter [0..1.F]
        batchNormType bnorm = batchNormType::none; ///< Type of batch norm. Optional parameter
        uint32_t fWidth = 3;                       ///< Width of mask. Optional parameter(> 0)
        uint32_t fHeight = 3;                      ///< Height of mask. Optional parameter(> 0)
        int padding = 0;                           ///< Padding around the edges. Optional parameter
        uint32_t stride = 1;                       ///< Mask movement step. Optional parameter(> 0)
        uint32_t dilate = 1;                       ///< Expansion mask. Optional parameter(> 0)
        uint32_t gpuDeviceId = 0;                  ///< GPU Id. Optional parameter
        bool freeze = false;                       ///< Do not change weights. Optional parameter
        bool useBias = true;                       ///< +bias. Optional parameter
        weightInit wini = weightInit::he;          ///< Type of initialization of weights. Optional parameter
        snFloat decayMomentDW = 0.9F;              ///< Optimizer of weights moment change. Optional parameter [0..1.F]
        snFloat decayMomentWGr = 0.99F;            ///< Optimizer of weights moment change of prev. Optional parameter [0..1.F]
        snFloat lmbRegular = 0.001F;               ///< Optimizer of weights l2Norm. Optional parameter [0..1.F]
        snFloat batchNormLr = 0.001F;              ///< Learning rate for batch norm coef. Optional parameter [0..)


        Convolution(uint32_t filters_,              
            active act_ = active::relu,                
            optimizer opt_ = optimizer::adam,          
            snFloat dropOut_ = 0.0,                    
            batchNormType bnorm_ = batchNormType::none,
            uint32_t fWidth_ = 3,                      
            uint32_t fHeight_ = 3,                    
            int padding_ = 0,
            uint32_t stride_ = 1,                      
            uint32_t dilate_ = 1,
            uint32_t gpuDeviceId_ = 0);
       
        Convolution(uint32_t filters_, uint32_t kernelSz, int padding_ = 0, uint32_t stride_ = 1,
            batchNormType bnorm_ = batchNormType::none, active act_ = active::relu);

        Convolution(uint32_t filters_, int padding_ = 0);

        ~Convolution();
      
        std::string getParamsJn();

        std::string name();
          
    };

    /*
    Deconvolution layer
    */
    class Deconvolution{

    public:

        uint32_t filters;                          ///< Number of output layers. !Required parameter [0..)
        active act = active::relu;                 ///< Activation function type. Optional parameter
        optimizer opt = optimizer::adam;           ///< Optimizer of weights. Optional parameter
        snFloat dropOut = 0.0;                     ///< Random disconnection of neurons. Optional parameter [0..1.F]
        batchNormType bnorm = batchNormType::none; ///< Type of batch norm. Optional parameter
        uint32_t fWidth = 3;                       ///< Width of mask. Optional parameter(> 0)
        uint32_t fHeight = 3;                      ///< Height of mask. Optional parameter(> 0)
        uint32_t stride = 2;                       ///< Mask movement step. Optional parameter(> 0)                
        uint32_t gpuDeviceId = 0;                  ///< GPU Id. Optional parameter      
        bool freeze = false;                       ///< Do not change weights. Optional parameter
        weightInit wini = weightInit::he;          ///< Type of initialization of weights. Optional parameter
        snFloat decayMomentDW = 0.9F;              ///< Optimizer of weights moment change. Optional parameter [0..1.F]
        snFloat decayMomentWGr = 0.99F;            ///< Optimizer of weights moment change of prev. Optional parameter [0..1.F]
        snFloat lmbRegular = 0.001F;               ///< Optimizer of weights l2Norm. Optional parameter [0..1.F]
        snFloat batchNormLr = 0.001F;              ///< Learning rate for batch norm coef. Optional parameter [0..)
        
        Deconvolution(uint32_t filters_,
            active act_ = active::relu,
            optimizer opt_ = optimizer::adam,
            snFloat dropOut_ = 0.0,
            batchNormType bnorm_ = batchNormType::none,
            uint32_t fWidth_ = 3,
            uint32_t fHeight_ = 3,
            uint32_t stride_ = 2,           
            uint32_t gpuDeviceId_ = 0);
       
        Deconvolution(uint32_t filters_);

        ~Deconvolution();
  
        std::string getParamsJn();

        std::string name();
    };

    /*
    Pooling layer
    */
    class Pooling{

    public:
            
        uint32_t kernel = 2;              ///< Square Mask Size. Optional parameter (> 0) 
        uint32_t stride = 2;              ///< Mask movement step. Optional parameter(> 0)
        poolType pool = poolType::max;    ///< Operator Type. Optional parameter 
        uint32_t gpuDeviceId = 0;         ///< GPU Id. Optional parameter
   
        Pooling(uint32_t gpuDeviceId_ = 0);
              
        Pooling(uint32_t kernel_, uint32_t stride_, poolType pool_ = poolType::max);

        ~Pooling();
                
        std::string getParamsJn();

        std::string name();
    };

    /*
    Operator to block further calculation at the current location.
    It is designed for the ability to dynamically disconnect the parallel
    branches of the network during operation.
    */
    class Lock{

    public:
             
        lockType lockTp;    ///< Blocking activity. Optional parameter

        Lock(lockType lockTp_);
        
        ~Lock();
               
        std::string getParamsJn();

        std::string name();
    };

    /*
    Operator for transferring data to several nodes at once.
    Data can only be received from one node.
    */
    class Switch{

    public:

        std::string nextWay;   // next nodes through a space
       
        Switch(const std::string& nextWay_);

        ~Switch();
        
        std::string getParamsJn();

        std::string name();
    };

    /*
    The operator is designed to combine the values of two layers.
    The consolidation can be performed by the following options: "summ", "diff", "mean".
    The dimensions of the input layers must be the same.
    */
    class Summator{

    public:
         
        summatorType summType;     

        Summator(summatorType summType_ = summatorType::summ);

        ~Summator();
             
        std::string getParamsJn();

        std::string name();
    };

    /*
    The operator connects the channels with multiple layers
    */
    class Concat{

    public:
              
        std::string sequence;    // prev nodes through a space

        Concat(const std::string& sequence_);

        ~Concat();
              
        std::string getParamsJn();

        std::string name();
    };

    /*
    Change the number of channels
    */
    class Resize{

    public:
               
        diap fwdDiap, bwdDiap;   // diap layer through a space

        Resize(const diap& fwdDiap_, const diap& bwdDiap_);

        ~Resize();

        std::string getParamsJn();

        std::string name();
    };

    /*
    ROI clipping in each image of each channel
    */
    class Crop{

    public:
        
        rect rct;         // region of interest

        Crop(const rect& rct_);

        ~Crop();
               
        std::string getParamsJn();
        
        std::string name();
    };

    /*
    Activation function operator
    */
    class Activation{

    public:

        active act = active::relu;                 ///< Activation function type. Optional parameter

        Activation(const active& act_);

        ~Activation();

        std::string getParamsJn();

        std::string name();
    };

    /*
    Custom layer
    */
    class UserLayer{

    public:
       
        std::string cbackName;

        UserLayer(const std::string& cbackName_);

        ~UserLayer();
              
        std::string getParamsJn();

        std::string name();
    };

    /*
    Error function calculation layer
    */
    class LossFunction{

    public:
           
        lossType loss;

        LossFunction(lossType loss_);

        ~LossFunction();

        std::string getParamsJn();

        std::string name();
    };

    /*
    Batch norm
    */
    class BatchNormLayer{

    public:
      
        BatchNormLayer();

        ~BatchNormLayer();

        std::string getParamsJn();

        std::string name();
    };

}
