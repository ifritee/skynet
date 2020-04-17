#ifndef MNISTSET_H
#define MNISTSET_H

#include <string>
#include <vector>
#include <fstream>

namespace cpp_keras {

  /** @brief Параметры датасета */
  class DatasetParameters {
  public:
    /** @brief Конструктор по-умолчанию */
    DatasetParameters() :
      m_batchs(0), m_rows(0), m_cols(0) {}
    /** @brief Конструктор с параметрами */
    DatasetParameters(unsigned int batchs, unsigned int rows, unsigned int cols) :
      m_batchs(batchs), m_rows(rows), m_cols(cols) {}
    unsigned int qty() { return m_batchs * m_rows * m_cols; }

    unsigned int m_batchs;  ///< @brief Количество картинок в сете
    unsigned int m_rows;  ///< @brief Количество строк в картинке
    unsigned int m_cols;  ///< @brief Количество столбцов в картинке
  };

  /** @brief Обработка изображения для дальнейшей передачи в Keras */
  class MnistSet
  {
    std::string m_dataFile; ///< @brief Файл данных
    std::string m_labelFile; ///< @brief Файл меток
    DatasetParameters m_trainParameters;
    std::string m_lastError;  ///< @brief Последняя ошибка

  public:
    /**
     * @brief MnistSet Конструктор
     * @param pathToData Путь к файлу с данными
     * @param pathToLabel Путь к файлу с метками
     */
    MnistSet(const std::string& pathToData, const std::string& pathToLabel);
    /** @brief Деструктор */
    virtual ~MnistSet();
    /**
     * @brief readData Чтение данных
     * @param qty Количество данных (0 - все данные за раз)
     * @param step Номер шага чтения
     * @param data Куда сохранять данные
     * @return labels Куда сохранять метки
     */
    bool readData(unsigned int qty = 0, unsigned int step = 0, float * data = nullptr, uint8_t * labels = nullptr);

    DatasetParameters trainParameters();
    /**
     * @brief lastError Возвращает последнюю ошибку
     * @return Строка с ошибкой
     */
    std::string lastError() { return m_lastError; };

  private:
    DatasetParameters extractDatasetParameters(std::ifstream & is);
    int extractDataset(std::ifstream & is, DatasetParameters param, float * data, unsigned int step = 0);
    DatasetParameters extractLabelParameters(std::ifstream & is);
    int extractLabels(std::ifstream & is, DatasetParameters param, uint8_t * data, unsigned int step = 0);

    /**
     * @brief ReadUint32 Чтение 4-х байт из потока
     * @param is поток данных
     * @return считанное значение
     */
    uint32_t readUint32(std::ifstream & is);
    /**
     * @brief ReadUint8 Чтение 1 байта из потока
     * @param is поток данных
     * @return считанное значение
     */
    uint8_t readUint8(std::ifstream & is);
  };
}

#endif // IMAGEPROCESSING_H
