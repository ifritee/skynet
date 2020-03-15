#ifndef DATASET_H
#define DATASET_H

#include "keras.h"

#if defined(__cplusplus)
extern "C" {
#endif //__cplusplus

/** @brief Данные для наборов MNIST */
struct MnistDATA {
  int quantity; ///< @brief Количество данных
  int rows; ///< @brief Количество строк в одном данном
  int cols; ///< @brief Количество столбцов в одном данном
  int depth; ///< @brief Количество каналов
};

/**
 * @brief createMnistDataset Создает очередной dataset
 * @param dataFile файл с данными
 * @param labelFile файл с метками
 * @return -1 - ошибка, N - id
 */
KERAS_EXPORT int createMnistDataset(const char * dataFile, const char * labelFile);

/**
 * @brief deleteMnistDataset Освобождает память dataset'а
 * @param id Номер сета
 * @return состояние
 */
KERAS_EXPORT Status deleteMnistDataset(int id);

KERAS_EXPORT Status readMnist(int id, float * datas, unsigned char * labels, unsigned int qty = 0,
                              unsigned int step = 0);

/**
 * @brief mnistTrainParams Возвращает данные тренировочного набора MNIST
 */
KERAS_EXPORT MnistDATA mnistParameters(int id);

#if defined(__cplusplus)
}
#endif /* __cplusplus */

#endif // DATASET_H
