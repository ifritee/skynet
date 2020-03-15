#include <iostream>
#if defined (WIN32)
#include <WinSock2.h>
#else 
#include <arpa/inet.h>
#endif //WIN32
#include "mnistset.h"

using namespace std;

namespace cpp_keras {

  DatasetParameters MnistSet::trainParameters()
  {
    ifstream datasetStream(m_dataFile, std::ios::binary);
    DatasetParameters param = extractDatasetParameters(datasetStream);
    datasetStream.close();
    return param;
  }

  MnistSet::MnistSet(const std::string& pathToData, const std::string& pathToLabel) :
    m_dataFile(pathToData),
    m_labelFile(pathToLabel)
  {
  }

  MnistSet::~MnistSet()
  {
  }

  bool MnistSet::readData(unsigned int qty, unsigned int step, float * data, uint8_t * labels)
  {
    ifstream datasetStream(m_dataFile, std::ios::binary);
    ifstream labelsStream(m_labelFile, std::ios::binary);
    try {
      //----- Чтение основных параметров -----
      m_trainParameters = extractDatasetParameters(datasetStream);
      step = qty > 0 ? (step % (m_trainParameters.m_batchs / qty)) : 0;
      if(qty > 0 && qty < m_trainParameters.m_batchs) {
        m_trainParameters.m_batchs = qty;
      }
      unsigned int length = m_trainParameters.qty();
      if (length > 0) { //----- Чтение данных ------
        m_trainParameters.m_batchs = extractDataset(datasetStream, m_trainParameters, data, step);
        datasetStream.close();
      }
      //----- Чтение основных параметров -----
      DatasetParameters datasetParameters = extractLabelParameters(labelsStream);
      if(qty > 0 && qty < datasetParameters.m_batchs) {
        datasetParameters.m_batchs = qty;
      }
      length = datasetParameters.qty();
      if (length > 0) { //----- Чтение данных ------
        datasetParameters.m_batchs = extractLabels(labelsStream, datasetParameters, labels, step);
        labelsStream.close();
      }
    } catch (std::logic_error & e) {
      cerr<<e.what()<<endl;
      datasetStream.close();
      labelsStream.close();
      return false;
    }
    datasetStream.close();
    labelsStream.close();
    return true;
  }

  DatasetParameters MnistSet::extractDatasetParameters(ifstream & is)
  {
    if (!is) {
      throw logic_error("can't open file dataset");
    }
    uint32_t magic = readUint32(is);
    if (magic != 0x803) {
      throw logic_error("bad magic: " + to_string(magic));
    }
    DatasetParameters params;
    params.m_batchs = readUint32(is);
    params.m_rows = readUint32(is);
    params.m_cols = readUint32(is);
    return params;
  }

  int MnistSet::extractDataset(ifstream &is, DatasetParameters param, float * data, unsigned int step)
  {
    if (!is) {
      throw logic_error("can't open file dataset");
    }
    is.seekg(16 + step * (param.m_batchs * param.m_rows * param.m_cols));
    int count = 0, readBatches = 0;
    while(param.m_batchs--) {
      try {
        for (uint32_t r = 0; r < param.m_rows; ++r) {
          for(uint32_t c = 0; c < param.m_cols; ++c) {
            uint8_t byte = readUint8(is);
            data[count++] = static_cast<float>(byte) / 255.f;
          }
        }
      } catch(logic_error &) {
        return readBatches;
      }
      ++readBatches;
    }
    return readBatches;
  }

  DatasetParameters MnistSet::extractLabelParameters(ifstream &is)
  {
    if (!is) {
      throw logic_error("can't open file labels");
    }
    uint32_t magic = readUint32(is);
    if (magic != 0x801) {
      throw logic_error("bad magic: " + to_string(magic));
    }
    uint32_t num = readUint32(is);
    DatasetParameters params(num, 1, 1);
    return params;
  }

  int MnistSet::extractLabels(ifstream &is, DatasetParameters param, uint8_t *data, unsigned int step)
  {
    if (!is) {
      throw logic_error("can't open file dataset");
    }
    is.seekg(8 + step * param.m_batchs);
    int count = 0;
    while(param.m_batchs--) {
      try {
        uint8_t val = readUint8(is);
        data[count] = val;
      } catch (logic_error &) {
        return count;
      }
      ++count;
    }
    return count;
  }

  uint8_t MnistSet::readUint8(ifstream & is)
  {
    uint8_t data = 0;
    is.read(reinterpret_cast<char*>(&data), 1);
    if (is.gcount() != 1) {
      throw logic_error("can't read 1 byte");
    }
    return data;
  }

  uint32_t MnistSet::readUint32(ifstream & is)
  {
    uint32_t data = 0;
    is.read(reinterpret_cast<char*>(&data), 4);
    if (is.gcount() != 4) {
      throw logic_error("can't read 4 bytes");
    }
    return ntohl(data);
  }
}
