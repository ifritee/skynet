#ifndef KERAS_H
#define KERAS_H

#ifdef _WIN32
#ifdef KERASDLL_EXPORTS
#define KERAS_API __declspec(dllexport)
#else //KERASDLL_EXPORTS
#define KERAS_API __declspec(dllimport)
#endif //KERASDLL_EXPORTS
#else //_WIN32
#define KERAS_API
#endif

#if defined(__cplusplus)
extern "C" {
#endif //__cplusplus

#define STATUS_OK 0 ///< Успешное выполнение задачи
#define STATUS_FAILURE 1 ///< Критическая ошибка
#define STATUS_WARNING 2 ///< Задача выполнена, но были проблемы

typedef int Status; ///< @brief Статус выполнения задачи

#define ACTIV_NONE -1 // Без функции активации
#define ACTIV_SIGMOID 0 // Сигмойдная функция
#define ACTIV_RELU 1  // Функция RELU
#define ACTIV_LEAKY_RELU 2 // Функция LEAKY RELU
#define ACTIV_ELU 3// Функция ELU

typedef int Activation; ///< @brief Функции активации

#define OPTIM_SGD 0
#define OPTIM_SGD_MOMENT 1
#define OPTIM_ADAGRAD 2
#define OPTIM_RMSPROP 3
#define OPTIM_ADAM 4

typedef int Optimizer; ///< @brief Функции активации

#define BATCH_NONE -1 // Без нормализации
#define BATCH_BEFORE_ACTIVE 0 // до активации
#define BATCH_POST_ACTIVE 1 // после активации

typedef int BatchNormType; ///< @brief Типы нормализации наборов

#define LOSS_SOFTMAX_CROSS_ENTROPY 0
#define LOSS_BINARY_CROSS_ENTROPY 1
#define LOSS_REGRESSION_MSE 2
#define LOSS_USER_LOSS 3  // Пользовтельская функция потерь

typedef int LossType; ///< @brief Типы функции потерь

/**
 * @brief CreateModel Создание модели
 * @return Статус создания модели
 */
KERAS_API Status createModel();

/**
 * @brief addInput Добавляет сходной слой
 * @param name Имя слоя
 * @param nodes узли с которыми связан слой (через пробел)
 * @return Статус добавления входного слоя в модель
 */
KERAS_API Status addInput(const char * name, const char * nodes);

/**
 * @brief addConvolution Добавляет сверточный слой
 * @param name Имя слоя
 * @param nodes узли с которыми связан слой (через пробел)
 * @return Статус добавления слоя в модель
 */
KERAS_API Status addConvolution(const char *name, const char *nodes, unsigned int filters_,
                                Activation act_ = ACTIV_RELU,
                                Optimizer opt_ = OPTIM_ADAM,
                                float dropOut_ = 0.0,
                                BatchNormType bnorm_ = BATCH_NONE,
                                unsigned int fWidth_ = 3,
                                unsigned int fHeight_ = 3,
                                int padding_ = 0,
                                unsigned int stride_ = 1,
                                unsigned int dilate_ = 1,
                                unsigned int gpuDeviceId_ = 0);

/**
 * @brief addDense Добавляет плотный слой
 * @param name Имя слоя
 * @param nodes узли с которыми связан слой (через пробел)
 * @return Статус добавления слоя в модель
 */
KERAS_API Status addDense(const char *name, const char *nodes, unsigned int units_,
                          Activation act_ = ACTIV_RELU,
                          Optimizer opt_ = OPTIM_ADAM,
                          float dropOut_ = 0.0,
                          BatchNormType bnorm_ = BATCH_NONE,
                          unsigned int gpuDeviceId_ = 0);

/**
 * @brief addLossFunction Добавляет функцию потерь в модель
 * @param name Имя слоя
 * @param nodes  узли с которыми связан слой (через пробел)
 * @param loss_ тип функции потерь
 * @return Статус добавления слоя в модель
 */
KERAS_API Status addLossFunction(const char *name, const char *nodes, LossType loss_);

#if defined(__cplusplus)
}
#endif /* __cplusplus */

#endif // KERAS_H
