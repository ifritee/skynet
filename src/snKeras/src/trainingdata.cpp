#include <fstream>
#include <sstream>
#include <assert.h>
#include <algorithm>
#include <map>

#include "trainingdata.h"

using namespace std;

TrainingData::TrainingData(const char *filename,
                           LayerSize *sizeData, LayerSize *sizeLabel) :
  m_fileName(filename),
  m_sizeData(sizeData),
  m_sizeLabel(sizeLabel)
{

}

TrainingData::~TrainingData()
{

}

void TrainingData::readBikeData(bool isDay, float ** data, float ** label)
{
  const int labelIndex = isDay ? 15 : 16;
  const int shift = 3;
  auto lines = getLinesFromFile(m_fileName);
  if(lines.size() == 0) {
    m_lastStatus = STATUS_FAILURE;
    return;
  }
  lines.erase(lines.begin());
  const int dataQty = split(lines[0], ',').size() - shift;
  const int bsz = lines.size();
  *data = new float[bsz * dataQty];
  *label = new float[bsz];
  std::vector<uint32_t> ign;
  ign.push_back(0);
  ign.push_back(1);
  setDatafromStrings(lines, *data, *label, labelIndex, ign);
  m_sizeData->bsz = bsz;
  m_sizeData->ch = 1;
  m_sizeData->w = dataQty;
  m_sizeData->h = 1;
  m_sizeLabel->bsz = bsz;
  m_sizeLabel->w = 1;
  m_sizeLabel->h = 1;
  m_sizeLabel->ch = 1;
  m_lastStatus = STATUS_OK;
}

void TrainingData::readBostonData(float **data, float **label)
{
  const int labelIndex = (label == nullptr ? -1 : 13);
  const int shift = (label == nullptr ? 0 : 1);
  auto lines = getLinesFromFile(m_fileName);
  if(lines.size() == 0) {
    m_lastStatus = STATUS_FAILURE;
    return;
  }
  lines.erase(lines.begin());
  const int dataQty = split(lines[0], ',').size() - shift;
  const int bsz = lines.size();
  *data = new float[bsz * dataQty];
  std::vector<uint32_t> ign;
  if(label == nullptr) {
    setDatafromStrings(lines, *data, (float * )(nullptr), labelIndex, ign);
  } else {
    *label = new float[bsz];
    setDatafromStrings(lines, *data, *label, labelIndex, ign);
  }

  m_sizeData->bsz = bsz;
  m_sizeData->ch = 1;
  m_sizeData->w = dataQty;
  m_sizeData->h = 1;

  m_sizeLabel->bsz = bsz;
  m_sizeLabel->w = 1;
  m_sizeLabel->h = 1;
  m_sizeLabel->ch = 1;

  m_lastStatus = STATUS_OK;
}

void TrainingData::readBreastData(int flag, float **data, uint8_t **label)
{
  map<string, uint8_t> answerDict;
  int id = 0, labelIndex = 1, shift = 2;
  if(flag == 1) {
    answerDict["2"] = 0;
    answerDict["4"] = 1;
    labelIndex = 10;
  } else if (flag == 2) {
    answerDict["M"] = 0;
    answerDict["B"] = 1;
  } else if (flag == 3) {
    answerDict["R"] = 0;
    answerDict["N"] = 1;
  }
  auto lines = getLinesFromFile(m_fileName);
  const int dataQty = split(lines[0], ',').size() - shift;  // Количество значений - id - label
  const int bsz = lines.size();
  *data = new float[bsz * dataQty];
  *label = new uint8_t[bsz];
  std::vector<uint32_t> ign;
  ign.push_back(id);
  setDatafromStrings(lines, *data, *label, labelIndex, ign, answerDict);
  m_sizeData->bsz = bsz;
  m_sizeData->ch = 1;
  m_sizeData->w = dataQty;
  m_sizeData->h = 1;

  m_sizeLabel->bsz = bsz;
  m_sizeLabel->w = answerDict.size();
  m_sizeLabel->h = 1;
  m_sizeLabel->ch = 1;

  m_lastStatus = STATUS_OK;
}

void TrainingData::readIrisData(float **data, uint8_t **label)
{
  map<string, uint8_t> answerDict;
  int labelIndex = 4, shift = 1;
  answerDict["Iris-setosa"] = 0;
  answerDict["Iris-versicolor"] = 1;
  answerDict["Iris-virginica"] = 2;

  auto lines = getLinesFromFile(m_fileName);
  const int dataQty = split(lines[0], ',').size() - shift;  // Количество значений - id - label
  const int bsz = lines.size();
  *data = new float[bsz * dataQty];
  *label = new uint8_t[bsz];
  std::vector<uint32_t> ign;
  setDatafromStrings(lines, *data, *label, labelIndex, ign, answerDict);
  m_sizeData->bsz = bsz;
  m_sizeData->ch = 1;
  m_sizeData->w = dataQty;
  m_sizeData->h = 1;

  m_sizeLabel->bsz = bsz;
  m_sizeLabel->w = answerDict.size();
  m_sizeLabel->h = 1;
  m_sizeLabel->ch = 1;

  m_lastStatus = STATUS_OK;
}


void TrainingData::readWineData(float **data, uint8_t **label)
{
  map<string, uint8_t> answerDict;
  int labelIndex = 0, shift = 1;
  answerDict["1"] = 0;
  answerDict["2"] = 1;
  answerDict["3"] = 2;

  auto lines = getLinesFromFile(m_fileName);
  const int dataQty = split(lines[0], ',').size() - shift;  // Количество значений - id - label
  const int bsz = lines.size();
  *data = new float[bsz * dataQty];
  *label = new uint8_t[bsz];
  std::vector<uint32_t> ign;
  setDatafromStrings(lines, *data, *label, labelIndex, ign, answerDict);
  m_sizeData->bsz = bsz;
  m_sizeData->ch = 1;
  m_sizeData->w = dataQty;
  m_sizeData->h = 1;

  m_sizeLabel->bsz = bsz;
  m_sizeLabel->w = answerDict.size();
  m_sizeLabel->h = 1;
  m_sizeLabel->ch = 1;

  m_lastStatus = STATUS_OK;
}

void TrainingData::readTitanicData(float **data, uint8_t **label)
{
  map<string, uint8_t> answerDict;
  int id = 0, labelIndex = 1, shift = 2;
  answerDict["0"] = 0;
  answerDict["1"] = 1;
  auto lines = getLinesFromFile(m_fileName);
  lines.erase(lines.begin());
  for(unsigned int i = 0; i < lines.size(); ++i) {
    std::string temp; bool isQ = false;
    for(unsigned int j = 0; j < lines[i].size(); ++j) {
      if(lines[i][j] == '"') {
        isQ = !isQ;
        continue;
      }
      if(!isQ) {
        temp.push_back(lines[i][j]);
      }
    }
    lines[i] = temp;
  }

  const int dataQty = split(lines[0], ',').size() - shift;  // Количество значений - id - label
  const int bsz = lines.size();
  *data = new float[bsz * dataQty];
  *label = new uint8_t[bsz];
  std::vector<uint32_t> ign;
  ign.push_back(id);
  ign.push_back(id);

  setDatafromStrings(lines, *data, *label, labelIndex, ign, answerDict);
  m_sizeData->bsz = bsz;
  m_sizeData->ch = 1;
  m_sizeData->w = dataQty;
  m_sizeData->h = 1;

  m_sizeLabel->bsz = bsz;
  m_sizeLabel->w = answerDict.size();
  m_sizeLabel->h = 1;
  m_sizeLabel->ch = 1;

  m_lastStatus = STATUS_OK;
}

std::vector<std::string> TrainingData::getLinesFromFile(const std::string & filename)
{
  std::vector<std::string> lines;
  ifstream is(filename);
  string line;
  while ( getline( is, line ) ) {
    if (line != "") {
      if(line.at(line.size() - 1) == '\r') {
        line.pop_back();
      }
      lines.push_back(line);
    }
  }
  return lines;
}

std::vector<std::string> TrainingData::split(const string & s, char d)
{
  vector<string> tokens;
  string token;
  istringstream ts(s);
  while (std::getline(ts, token, d)) {
    tokens.push_back(token);
  }
  return tokens;
}

void TrainingData::setDatafromStrings(const std::vector<std::string> & lines, float * datas, float * labels,
                                      unsigned int labIndex, const std::vector<uint32_t> & ign)
{
  int dataCount = 0, labelCount = 0;
  for(auto line : lines) {
    if (line != "") {
      auto tokens = split(line, ',');
      for(unsigned int i = 0; i < tokens.size(); ++i) {
        if(std::find(ign.begin(), ign.end(), i) != ign.end()) {
          continue;
        } else if (i == labIndex) { // Метки
          if(tokens[i] != "") {
            float value = 0;
            std::istringstream ss(tokens[i]);
            ss >> value;
            labels[labelCount++] = value;
          }
        } else {
          if(tokens[i] != "") {
            float value = 0;
            std::istringstream ss(tokens[i]);
            ss >> value;
            datas[dataCount++] = value;
          }
        }
      }
    }
  }
}

void TrainingData::setDatafromStrings(const std::vector<string> &lines, float *datas,
                                      uint8_t *labels, unsigned int labIndex, const std::vector<uint32_t> &ign,
                                      std::map<std::string, uint8_t> & answer)
{
  int dataCount = 0, labelCount = 0;
  for(auto line : lines) {
    if (line != "") {
      auto tokens = split(line, ',');
      for(unsigned int i = 0; i < tokens.size(); ++i) {
        if(std::find(ign.begin(), ign.end(), i) != ign.end()) {
          continue;
        } else if (i == labIndex) { // Метки
          if(tokens[i] != "") {
            if(answer.find(tokens[i]) == answer.end()) {
              return;
            }
            labels[labelCount++] = answer[tokens[i] ];
          }
        } else {
          if(tokens[i] != "") {
            float value = 0;
            std::istringstream ss(tokens[i]);
            ss >> value;
            datas[dataCount++] = value;
          } else {
            datas[dataCount++] = 0;
          }
        }
      }
    }
  }
}

