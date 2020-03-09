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
    float * m_trainData = nullptr;
    uint8_t * m_trainLabel = nullptr;
    DatasetParameters m_trainParameters;
    float * m_testData = nullptr;
    uint8_t * m_testLabel = nullptr;
    DatasetParameters m_testParameters;

  public:
    /** @brief Конструктор */
    MnistSet();
    /** @brief Деструктор */
    virtual ~MnistSet();

    bool readTrainData(const std::string & pathTo);
    bool readTrainData(const std::string& pathToData, const std::string& pathToLabel, unsigned int qty = 0);
    bool readTestData(const std::string & pathTo);
    bool readTestData(const std::string& pathToData, const std::string& pathToLabel, unsigned int qty = 0);

    float *trainData() const;
    uint8_t *trainLabel() const;
    DatasetParameters trainParameters() const;
    float *testData() const;
    uint8_t *testLabel() const;
    DatasetParameters testParameters() const;

  private:
    bool readData(const std::string & pathToData, const std::string &pathToLabels,
                  bool isTrain, DatasetParameters &param, unsigned int qty = 0);
    DatasetParameters extractDatasetParameters(std::ifstream & is);
    void extractDataset(std::ifstream & is, DatasetParameters param, float * data);
    DatasetParameters extractLabelParameters(std::ifstream & is);
    void extractLabels(std::ifstream & is, DatasetParameters param, uint8_t * data);

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
