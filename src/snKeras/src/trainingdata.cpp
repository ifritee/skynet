#include <fstream>
#include <sstream>
#include <assert.h>
#include <algorithm>

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
    setDatafromStrings(lines, *data, 0, labelIndex, ign);
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

std::vector<std::string> TrainingData::getLinesFromFile(const std::string & filename)
{
  std::vector<std::string> lines;
  ifstream is(filename);
  string line;
  while ( getline( is, line ) ) {
    if (line != "") {
      line.pop_back();
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

