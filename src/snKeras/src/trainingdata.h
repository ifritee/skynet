#ifndef TRAININGDATA_H
#define TRAININGDATA_H

#include <vector>
#include <string>
#include <map>

#include "keras.h"

class TrainingData
{
  std::string m_fileName;
  LayerSize * m_sizeData = nullptr;
  LayerSize * m_sizeLabel = nullptr;
  Status m_lastStatus = STATUS_OK; ///< @brief Последний статус
  std::string m_lastError;  ///< @brief Последняя ошибка

public:
  TrainingData(const char * filename, LayerSize *sizeData, LayerSize *sizeLabel);
  virtual ~TrainingData();
  /**
   * @brief readBikeData Чтение данных для набора BIKE
   * @param isDay true - для дней, false - для часов
   */
  void readBikeData(bool isDay, float **data, float **label, int qty, unsigned int step);
  void readBostonData(float **data, float **label, int qty, unsigned int step);
  void readBreastData(int flag, float **data, uint8_t **label, int qty, unsigned int step);
  void readIrisData(float **data, uint8_t **label, int qty, unsigned int step);
  void readWineData(float **data, uint8_t **label, int qty, unsigned int step);
  void readTitanicData(float **data, uint8_t **label, int qty, unsigned int step);

  Status lastStatus() { return m_lastStatus; }
  /**
   * @brief lastError Возвращает последнюю ошибку
   * @return строка с ошибкой
   */
  std::string lastError() { return m_lastError; }

private:
  /**
   * @brief getLinesFromFile Возвращает набор строк из файла
   * @param filename Имя файла
   * @return Массив строк
   */
  std::vector<std::string> getLinesFromFile(const std::string & filename);

  /**
   * @brief split Разбивает строку на подстроки
   * @param s строка
   * @param d делитель
   * @return Массив строк
   */
  std::vector<std::string> split(const std::string & s, char d);

  void setDatafromStrings(const std::vector<std::string> &lines, float * datas, float * labels, unsigned int labIndex,
                          const std::vector<uint32_t> &ign, int qty, unsigned int step);
  void setDatafromStrings(const std::vector<std::string> &lines, float * datas, uint8_t * labels, unsigned int labIndex,
                          const std::vector<uint32_t> &ign, std::map<std::string, uint8_t> & answer,int qty, unsigned int step);
};

#endif // TRAININGDATA_H
