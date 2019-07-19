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

#include <cuda_runtime.h>
#include "../stdafx.h"

using namespace SN_Base;

void setDeviceId(int id){

   cuAssert(cudaSetDevice(id));
}

snFloat* memAlloc(size_t sz, int initVal){

    snFloat* mem = nullptr;
    cuAssert(cudaMalloc(&mem, sz * sizeof(snFloat)));

    cuAssert(cudaMemset(mem, initVal, sz * sizeof(snFloat)));

    return mem;
}

snFloat* memRealloc(size_t csz, size_t nsz, snFloat* data, int initVal){

    ASSERT_MESS(nsz > 0, "");

    if (csz < nsz){

        snFloat* mem = nullptr;
        cuAssert(cudaMalloc(&mem, nsz * sizeof(snFloat)));

        cuAssert(cudaMemset(mem, initVal, nsz * sizeof(snFloat)));
        
        if (data){
            if (csz > 0)
               cuAssert(cudaMemcpy(mem, data, csz * sizeof(snFloat), cudaMemcpyKind::cudaMemcpyDeviceToDevice));
            cuAssert(cudaFree(data));
        }
        data = mem;
    }
   
    return data;
}

void memCpyCPU2GPU(size_t dstSz, SN_Base::snFloat* dstGPU, size_t srcSz, SN_Base::snFloat* srcCPU){

    ASSERT_MESS(dstSz == srcSz, "");

    cuAssert(cudaMemcpy(dstGPU, srcCPU, srcSz * sizeof(snFloat), cudaMemcpyKind::cudaMemcpyHostToDevice));
}

void memCpyGPU2CPU(size_t dstSz, SN_Base::snFloat* dstCPU, size_t srcSz, SN_Base::snFloat* srcGPU){

    ASSERT_MESS(dstSz == srcSz, "");

    cuAssert(cudaMemcpy(dstCPU, srcGPU, srcSz * sizeof(snFloat), cudaMemcpyKind::cudaMemcpyDeviceToHost));
}

void memFree(snFloat* data){

    cuAssert(cudaFree(data));
}