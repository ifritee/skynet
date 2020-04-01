#include <fstream>
#include <sstream>
#include <assert.h>
#include <algorithm>
#include <map>
#include "rapidcsv.h"

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

void TrainingData::readBikeData(bool isDay, float ** data, float ** label, int qty, unsigned int step)
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
  const int bsz = (qty > 0 ? qty : lines.size());
  *data = new float[bsz * dataQty];
  *label = new float[bsz];
  std::vector<uint32_t> ign;
  ign.push_back(0);
  ign.push_back(1);
  setDatafromStrings(lines, *data, *label, labelIndex, ign, bsz, step);
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

void TrainingData::readBostonData(float **data, float **label, int qty, unsigned int step)
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
  const int bsz = (qty > 0 ? qty : lines.size());
  *data = new float[bsz * dataQty];
  std::vector<uint32_t> ign;
  if(label == nullptr) {
    setDatafromStrings(lines, *data, (float * )(nullptr), labelIndex, ign, bsz, step);
  } else {
    *label = new float[bsz];
    setDatafromStrings(lines, *data, *label, labelIndex, ign, bsz, step);
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

void TrainingData::readBreastData(int flag, float **data, uint8_t **label, int qty, unsigned int step)
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
  const int bsz = (qty > 0 ? qty : lines.size());
  *data = new float[bsz * dataQty];
  *label = new uint8_t[bsz];
  std::vector<uint32_t> ign;
  ign.push_back(id);
  setDatafromStrings(lines, *data, *label, labelIndex, ign, answerDict, bsz, step);
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

void TrainingData::readIrisData(float **data, uint8_t **label, int qty, unsigned int step)
{
  map<string, uint8_t> answerDict;
  int labelIndex = 4, shift = 1;
  answerDict["Iris-setosa"] = 0;
  answerDict["Iris-versicolor"] = 1;
  answerDict["Iris-virginica"] = 2;

  auto lines = getLinesFromFile(m_fileName);
  const int dataQty = split(lines[0], ',').size() - shift;  // Количество значений - id - label
  const int bsz = (qty > 0 ? qty : lines.size());
  *data = new float[bsz * dataQty];
  *label = new uint8_t[bsz];
  std::vector<uint32_t> ign;
  setDatafromStrings(lines, *data, *label, labelIndex, ign, answerDict, bsz, step);
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


void TrainingData::readWineData(float **data, uint8_t **label, int qty, unsigned int step)
{
  map<string, uint8_t> answerDict;
  int labelIndex = 0, shift = 1;
  answerDict["1"] = 0;
  answerDict["2"] = 1;
  answerDict["3"] = 2;

  auto lines = getLinesFromFile(m_fileName);
  const int dataQty = split(lines[0], ',').size() - shift;  // Количество значений - id - label
  const int bsz = (qty > 0 ? qty : lines.size());
  *data = new float[bsz * dataQty];
  *label = new uint8_t[bsz];
  std::vector<uint32_t> ign;
  setDatafromStrings(lines, *data, *label, labelIndex, ign, answerDict, bsz, step);
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

void sexFunc(const std::string & pStr, float & pVal)
{
  if (pStr == "male") {
    pVal = 1.f;
  } else if (pStr == "female"){
    pVal= 0.f;
  }
}

void ageFunc(const std::string & pStr, float & pVal)
{
  if(pStr.size() == 0) {
    pVal = 0.0f;
  } else {
    std::istringstream is(pStr);
    is >> pVal;
  }
}

void embarkedFunc(const std::string & pStr, float & pVal)
{
  if (pStr == "S" || pStr.size() == 0) {
    pVal = 0.f;
  } else if (pStr == "C"){
    pVal= 1.f;
  } else if (pStr == "Q"){
    pVal= 2.f;
  }
}

void nameFunc(const std::string & pStr, float & pVal)
{
  if(static_cast<int>(pStr.find("Mr.")) >= 0 ||
     static_cast<int>(pStr.find("Sir.")) >= 0 ) {
    pVal = 30.f;
  } else if (static_cast<int>(pStr.find("Mrs.")) >= 0 ||
             static_cast<int>(pStr.find("Lady.")) >= 0 ||
             static_cast<int>(pStr.find("Mlle.")) >= 0) {
    pVal = 35.f;
  } else if (static_cast<int>(pStr.find("Mme.")) >= 0 ||
             static_cast<int>(pStr.find("Ms.")) >= 0 ||
             static_cast<int>(pStr.find("Countess")) >= 0) {
    pVal = 45.f;
  } else if (static_cast<int>(pStr.find("Master")) >= 0 ||
             static_cast<int>(pStr.find("Don.")) >= 0  ||
             static_cast<int>(pStr.find("Dr.")) >= 0 ||
             static_cast<int>(pStr.find("Rev.")) >= 0 ||
             static_cast<int>(pStr.find("Major.")) >= 0 ||
             static_cast<int>(pStr.find("Col.")) >= 0) {
    pVal = 50.f;
  } else if (static_cast<int>(pStr.find("Miss.")) >= 0) {
    pVal = 20.f;
  } else if (static_cast<int>(pStr.find("Capt.")) >= 0) {
    pVal = 40.f;
  } else {
    pVal = 50.f;
  }
}

void fareFunc(const std::string & pStr, float & pVal)
{
  if(pStr.size() == 0) {
    pVal = 10.0f;
  } else {
    std::istringstream is(pStr);
    is >> pVal;
  }
}

void TrainingData::readTitanicData(float **data, uint8_t **label, int qty, unsigned int step)
{
  rapidcsv::Document doc(m_fileName);
  std::vector<float> survived;
  if (label != nullptr) {
    survived = doc.GetColumn<float>("Survived");
  }
  std::vector<float> pclass = doc.GetColumn<float>("Pclass");
  std::vector<float> name = doc.GetColumn<float>("Name", nameFunc);
  std::vector<float> sex = doc.GetColumn<float>("Sex", sexFunc);
  std::vector<float> age = doc.GetColumn<float>("Age", ageFunc);
  std::vector<float> sibSp = doc.GetColumn<float>("SibSp");
  std::vector<float> parch = doc.GetColumn<float>("Parch");
  std::vector<float> fare = doc.GetColumn<float>("Fare", fareFunc);
  std::vector<float> embarked = doc.GetColumn<float>("Embarked", embarkedFunc);

//  const unsigned int bsz = static_cast<unsigned int>(age.size());
  const unsigned int bsz = (qty > 0 ? qty : age.size());
  const int dataQty = 6;
  unsigned int begin = bsz * step % age.size(), fullDataCount = 0;;

  *data = new float[bsz * dataQty];
  if (label != nullptr) {
    *label = new uint8_t[bsz];
  }
  unsigned int countData = 0;
  for (unsigned int i = begin; i < bsz; ++i) {
    ++fullDataCount;
    if (label != nullptr) {
      (*label)[i] = static_cast<uint8_t>(survived[i]);
    }
    (*data)[countData++] = pclass[i];
    (*data)[countData++] = sex[i];
    if(age[i] < 1.f) {
      age[i] = name[i];
    }
    (*data)[countData++] = age[i];
    (*data)[countData++] = sibSp[i] + parch[i];  // Объединил родителей и детей
    (*data)[countData++] = fare[i];
    (*data)[countData++] = embarked[i];

    if (bsz == fullDataCount) {
      break;
    } else if (i == (age.size() - 1)) {
      i = 0;
    }
  }

  m_sizeData->bsz = bsz;
  m_sizeData->ch = 1;
  m_sizeData->w = dataQty;
  m_sizeData->h = 1;

  m_sizeLabel->bsz = bsz;
  m_sizeLabel->w = 2;
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
                                      unsigned int labIndex, const std::vector<uint32_t> & ign, int qty, unsigned int step)
{
  int dataCount = 0, labelCount = 0, begin = qty * step % lines.size(), fullDataCount = 0;
  for(unsigned int num = begin; num < lines.size(); ++num) {
    ++fullDataCount;
    std::string line = lines[num];
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
    if (qty == fullDataCount) {
      break;
    } else if (num == (lines.size() - 1)) {
      num = 0;
    }
  }
}

void TrainingData::setDatafromStrings(const std::vector<string> &lines, float *datas,
                                      uint8_t *labels, unsigned int labIndex, const std::vector<uint32_t> &ign,
                                      std::map<std::string, uint8_t> & answer, int qty, unsigned int step)
{
  int dataCount = 0, labelCount = 0, begin = qty * step % lines.size(), fullDataCount = 0;
  for(unsigned int num = begin; num < lines.size(); ++num) {
    ++fullDataCount;
    std::string line = lines[num];
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
    if (qty == fullDataCount) {
      break;
    } else if (num == (lines.size() - 1)) {
      num = 0;
    }
  }
}

