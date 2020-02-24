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
#include <cstring>
#include <string>
#include <vector>
#include "../snSkynet/skyNet.h"
#include "snkeras_global.h"

namespace SN_API {
  /**
   * @brief The Tensor class Описание тензора
   */
  class Tensor {

  public:
    /**
     * @brief Tensor Основной конструктор со значениями по-умолчанию
     * @param lsz размер данных (количество)
     * @param data набор данных
     */
    Tensor(const snLSize& lsz = snLSize(), const std::vector<snFloat>& data = std::vector<snFloat>());
    /**
     * @brief Tensor конструктор для уже готовых данных
     * @param lsz размер данных (количество
     * @param data указатель на набор данных
     */
    Tensor(const snLSize& lsz, snFloat* data);
    /**
     * Деструктор
     */
    ~Tensor();

    bool addChannel(uint32_t w, uint32_t h, std::vector<snFloat>& data);

    bool addChannel(uint32_t w, uint32_t h, snFloat* data);
    /**
     * @brief clear Очистка данных тензора
     */
    void clear();
    /**
     * @brief data возвращает указатель на данные
     * @return указатель на набор данных
     */
    snFloat* data();
    /**
     * @brief size Возвращает количество данных
     */
    snLSize size();

  private:
    size_t chsz_ = 0;
    snLSize lsz_;
    std::vector<snFloat> data_;

  };
}
