#ifndef TRAININGDATA_H
#define TRAININGDATA_H

#include <vector>
#include <string>

#include "keras.h"

class TrainingData
{
  std::string m_fileName;
  LayerSize * m_sizeData = nullptr;
  LayerSize * m_sizeLabel = nullptr;
  Status m_lastStatus = STATUS_OK;

public:
  TrainingData(const char * filename, LayerSize *sizeData, LayerSize *sizeLabel);
  virtual ~TrainingData();
  /**
   * @brief readBikeData Чтение данных для набора BIKE
   * @param isDay true - для дней, false - для часов
   */
  void readBikeData(bool isDay, float **data, float **label);
  void readBostonData(float **data, float **label);

  Status lastStatus() { return m_lastStatus; }

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
                          const std::vector<uint32_t> &ign);
};

#endif // TRAININGDATA_H
