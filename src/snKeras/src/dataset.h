#ifndef DATASET_H
#define DATASET_H

#include "keras.h"

#if defined(__cplusplus)
extern "C" {
#endif //__cplusplus

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
KERAS_EXPORT LayerSize mnistParameters(int id);

KERAS_EXPORT Status bikeTrainData(const char * filename,
                                  bool isDay, // Для дней или часов
                                  float **data,
                                  float **label,
                                  LayerSize * sizeData,
                                  LayerSize * sizeLabel);

KERAS_EXPORT Status bostonTrainData(const char * filename,
                                  float **data,
                                  float **label,
                                  LayerSize * sizeData,
                                  LayerSize * sizeLabel);


#if defined(__cplusplus)
}
#endif /* __cplusplus */

#endif // DATASET_H
