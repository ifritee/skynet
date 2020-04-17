#ifndef DATASET_H
#define DATASET_H

#include "keras.h"

#if defined(__cplusplus)
extern "C" {
#endif //__cplusplus

/**
 * @brief mnistTrainData Считывание данных из БД MNIST
 * @param datafilename Имя файла с данными
 * @param labelfilename Имя файла с метками
 * @param data Хранилище данных для записи
 * @param label Хранилище меток для записи
 * @param sizeData Параметры считываемых данных
 * @param sizeLabel Параметры считываемых меток
 * @param qty Количество, считываемое за раз
 * @param step Шаг считывания
 * @return Состояние считывания
 */
KERAS_EXPORT Status mnistTrainData(const char * datafilename,
                                   const char * labelfilename,
                                   float **data,
                                   unsigned char **label,
                                   LayerSize * sizeData,
                                   LayerSize * sizeLabel,
                                   int qty, unsigned int step);

/**
 * @brief bikeTrainData Считывание данных о количестве велосипедов взятых в аренду
 * @param filename Имя файла с данными
 * @param isDay Флаг (0 - за час, 1 - за день)
 * @param data Хранилище данных для записи
 * @param label Хранилище меток для записи
 * @param sizeData Параметры считываемых данных
 * @param sizeLabel Параметры считываемых меток
 * @param qty Количество, считываемое за раз
 * @param step Шаг считывания
 * @return Состояние считывания
 */
KERAS_EXPORT Status bikeTrainData(const char * filename,
                                  bool isDay, // Для дней или часов
                                  float **data,
                                  float **label,
                                  LayerSize * sizeData,
                                  LayerSize * sizeLabel,
                                  int qty, unsigned int step);

/**
 * @brief bostonTrainData Считывание данных о ценах аренды квартир в Бостоне
 * @param filename Имя файла с данными
 * @param data Хранилище данных для записи
 * @param label Хранилище меток для записи
 * @param sizeData Параметры считываемых данных
 * @param sizeLabel Параметры считываемых меток
 * @param qty Количество, считываемое за раз
 * @param step Шаг считывания
 * @return Состояние считывания
 */
KERAS_EXPORT Status bostonTrainData(const char * filename,
                                  float **data,
                                  float **label,
                                  LayerSize * sizeData,
                                  LayerSize * sizeLabel,
                                  int qty, unsigned int step);

/**
 * @brief breastTrainData Считывание данных о заболевших раком в Висконсине
 * @param filename Имя файла с данными
 * @param flag Флаг, показывающий тип считываемой информации (1 - Wisconsin, 2 - wdbc, 3 - wpbc)
 * @param data Хранилище данных для записи
 * @param label Хранилище меток для записи
 * @param sizeData Параметры считываемых данных
 * @param sizeLabel Параметры считываемых меток
 * @param qty Количество, считываемое за раз
 * @param step Шаг считывания
 * @return Состояние считывания
 */
KERAS_EXPORT Status breastTrainData(const char * filename,
                                  int flag,
                                  float **data,
                                  unsigned char **label,
                                  LayerSize * sizeData,
                                  LayerSize * sizeLabel,
                                  int qty, unsigned int step);

/**
 * @brief irisTrainData Считывание данных о сортах Ирисов (Ирисы Фишера)
 * @param filename Имя файла с данными
 * @param data Хранилище данных для записи
 * @param label Хранилище меток для записи
 * @param sizeData Параметры считываемых данных
 * @param sizeLabel Параметры считываемых меток
 * @param qty Количество, считываемое за раз
 * @param step Шаг считывания
 * @return Состояние считывания
 */
KERAS_EXPORT Status irisTrainData(const char * filename,
                                  float **data,
                                  unsigned char **label,
                                  LayerSize * sizeData,
                                  LayerSize * sizeLabel,
                                  int qty, unsigned int step);

/**
 * @brief wineTrainData Считывание данных о сортах вин
 * @param filename Имя файла с данными
 * @param data Хранилище данных для записи
 * @param label Хранилище меток для записи
 * @param sizeData Параметры считываемых данных
 * @param sizeLabel Параметры считываемых меток
 * @param qty Количество, считываемое за раз
 * @param step Шаг считывания
 * @return Состояние считывания
 */
KERAS_EXPORT Status wineTrainData(const char * filename,
                                  float **data,
                                  unsigned char **label,
                                  LayerSize * sizeData,
                                  LayerSize * sizeLabel,
                                  int qty, unsigned int step);

/**
 * @brief titanicTrainData Считывание данных о выживаемости пассажиров на борту Титаника
 * @param filename Имя файла с данными
 * @param data Хранилище данных для записи
 * @param label Хранилище меток для записи
 * @param sizeData Параметры считываемых данных
 * @param sizeLabel Параметры считываемых меток
 * @param qty Количество, считываемое за раз
 * @param step Шаг считывания
 * @return Состояние считывания
 */
KERAS_EXPORT Status titanicTrainData(const char * filename,
                                  float **data,
                                  unsigned char **label,
                                  LayerSize * sizeData,
                                  LayerSize * sizeLabel,
                                  int qty, unsigned int step);
/** @brief Освобождение памяти */
KERAS_EXPORT void freeTrainData(float** data, unsigned char** label);
/** @brief Освобождение памяти */
KERAS_EXPORT void freeTrainDataF(float** data, float** label);
/**
 * @brief Записывает последнюю ошибку в буфер
 * @param buffer Буфер
 * @param length Размер буфера
 */
KERAS_EXPORT void dsLastError(char * buffer, int length);

#if defined(__cplusplus)
}
#endif /* __cplusplus */

#endif // DATASET_H
