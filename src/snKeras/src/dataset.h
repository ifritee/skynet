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
 * @param dataFile Полный путь к файлу БД с данным для тренировки
 * @param labelFile Полный путь к файлу БД с метками для тренировки
 * @return состояние
 */
KERAS_EXPORT Status readMnistTrain(const char * dataFile, const char * labelFile, unsigned int qty = 0);

/**
 * @param dataFile Полный путь к файлу БД с данным для тестирования
 * @param labelFile Полный путь к файлу БД с метками для тестирования
 * @return состояние
 */
KERAS_EXPORT Status readMnistTest(const char* dataFile, const char* labelFile, unsigned int qty = 0);

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
