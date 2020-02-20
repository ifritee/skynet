#ifndef DATASET_H
#define DATASET_H

#include "keras.h"

#if defined(__cplusplus)
extern "C" {
#endif //__cplusplus

/** @brief Данные для наборов MNIST */
struct MnistDATA {
  float * data; ///< @brief Нормализованные данные
  unsigned char * labels; ///< @brief Метки
  int quantity; ///< @brief Количество данных
  int rows; ///< @brief Количество строк в одном данном
  int cols; ///< @brief Количество столбцов в одном данном
};

/**
 * @brief readMnist Чтение БД с MNIST
 * @param path Путь к файлам БД
 * @return состояние
 */
KERAS_EXPORT Status readMnist(const char * path);
/**
 * @brief mnistTrainParams Возвращает данные тренировочного набора MNIST
 */
KERAS_EXPORT MnistDATA mnistTrainParams();
/**
 * @brief mnistTestParams Возвращает данные тестового набора MNIST
 */
KERAS_EXPORT MnistDATA mnistTestParams();

#if defined(__cplusplus)
}
#endif /* __cplusplus */

#endif // DATASET_H
