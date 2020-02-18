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

#include <string>

namespace SN_API{

  /**
   * @enum active
   * @brief Нумератор функций активации
   */
  enum class active{
    none = -1,
    sigmoid = 0,
    relu = 1,
    leakyRelu = 2,
    elu = 3,
  };

  /**
   * @brief activeStr Преобразование номера функции активации в строковое имя
   * @param act Индекс функции активации
   * @return Строка с названием функции активации
   */
  std::string activeStr(active act);

  /** @brief Типы инициализации весов */
  enum class weightInit{
    uniform = 0,
    he = 1,
    lecun = 2,
    xavier = 3,
  };
  /**
   * @brief weightInitStr Преобразование номера типа инициализации весов в строковое имя
   * @param act Индекс типа инициализации
   * @return Строка с названием типа инициализации
   */
  std::string weightInitStr(weightInit wini);

  /** @brief Типы нормализации набора */
  enum class batchNormType{
    none = -1,
    beforeActive = 0,
    postActive = 1,
  };
  /**
   * @brief batchNormTypeStr Преобразование номера нормализации набора в строковое имя
   * @param act Индекс нормализации набора
   * @return Строка с названием нормализации набора
   */
  std::string batchNormTypeStr(batchNormType bnorm);

  /// Optimizer of weights
  enum class optimizer{
    sgd = 0,
    sgdMoment = 1,
    adagrad = 2,
    RMSprop = 3,
    adam = 4,
  };
  std::string optimizerStr(optimizer opt);

  /// pooling
  enum class poolType{
    max = 0,
    avg = 1,
  };
  std::string poolTypeStr(poolType poolt);

  enum class lockType{
    lock = 0,
    unlock = 1,
  };
  std::string lockTypeStr(lockType ltp);

  enum class summatorType{
    summ = 0,
    diff = 1,
    mean = 2,
  };
  std::string summatorTypeStr(summatorType stp);

  enum class lossType{
    softMaxToCrossEntropy = 0,
    binaryCrossEntropy = 1,
    regressionMSE = 2,
    userLoss = 3,
  };
  std::string lossTypeStr(lossType stp);

  struct diap{

    uint32_t begin;
    uint32_t end;

    diap(uint32_t begin_, uint32_t end_) :
      begin(begin_), end(end_){}
  };

  /** @brief Описание прямоугольника */
  struct rect {
    uint32_t x; ///< @brief Координата X
    uint32_t y; ///< @brief Координата Y
    uint32_t w; ///< @brief Длина
    uint32_t h; ///< @brief Высота

    /**
     * @brief rect Конструктор по-умолчанию
     * @param x_ Координата X
     * @param y_ Координата Y
     * @param w_ Длина
     * @param h_ Высота
     */
    rect(uint32_t x_, uint32_t y_, uint32_t w_, uint32_t h_) :
      x(x_), y(y_), w(w_), h(h_){}
  };
}
