#include <iostream>
#if defined (WIN32)
#include <WinSock2.h>
#else 
#include <arpa/inet.h>
#endif //WIN32
#include "mnistset.h"

using namespace std;

namespace cpp_keras {

  float *MnistSet::trainData() const
  {
    return m_trainData;
  }

  uint8_t *MnistSet::trainLabel() const
  {
    return m_trainLabel;
  }

  DatasetParameters MnistSet::trainParameters() const
  {
    return m_trainParameters;
  }

  float *MnistSet::testData() const
  {
    return m_testData;
  }

  uint8_t *MnistSet::testLabel() const
  {
    return m_testLabel;
  }

  DatasetParameters MnistSet::testParameters() const
  {
    return m_testParameters;
  }

  MnistSet::MnistSet()
  {

  }

  MnistSet::~MnistSet()
  {
    delete [] m_trainData;
    m_trainData = nullptr;
    delete [] m_trainLabel;
    m_trainLabel = nullptr;
    delete [] m_testData;
    m_testData = nullptr;
    delete [] m_testLabel;
    m_testLabel = nullptr;
  }

  bool MnistSet::readTrainData(const string &pathTo)
  {
    return readData(pathTo + "/train-images-idx3-ubyte", pathTo + "/train-labels-idx1-ubyte",
                    true, m_trainParameters);
  }

  bool MnistSet::readTrainData(const std::string& pathToData, const std::string& pathToLabel)
  {
      return readData(pathToData, pathToLabel, true, m_trainParameters);
  }

  bool MnistSet::readTestData(const string &pathTo)
  {
    return readData(pathTo + "/t10k-images-idx3-ubyte", pathTo + "/t10k-labels-idx1-ubyte",
                    false, m_testParameters);
  }

  bool MnistSet::readTestData(const std::string& pathToData, const std::string& pathToLabel)
  {
      return readData(pathToData, pathToLabel, false, m_testParameters);
  }

  bool MnistSet::readData(const string & pathToData, const string & pathToLabels,
                          bool isTrain, DatasetParameters & param)
  {
    ifstream datasetStream(pathToData, std::ios::binary);
    ifstream labelsStream(pathToLabels, std::ios::binary);
    try {
      float * data = nullptr;
      uint8_t * labels = nullptr;
      //----- Чтение основных параметров -----
      param = extractDatasetParameters(datasetStream);
      unsigned int length = param.qty();
      if (length > 0) {
        data = new float[length];
        if(isTrain) {
          delete [] m_trainData;
          m_trainData = data;
        } else {
          delete [] m_testData;
          m_testData = data;
        }
        //----- Чтение данных ------
        extractDataset(datasetStream, param, data);
        datasetStream.close();
      }
      //----- Чтение основных параметров -----
      DatasetParameters datasetParameters = extractLabelParameters(labelsStream);
      length = datasetParameters.qty();
      if (length > 0) {
        labels = new uint8_t[length];
        if(isTrain) {
          delete [] m_trainLabel;
          m_trainLabel = labels;
        } else {
          delete [] m_testLabel;
          m_testLabel = labels;
        }
        //----- Чтение данных ------
        extractLabels(labelsStream, datasetParameters, labels);
        labelsStream.close();
      }
    } catch (std::logic_error & e) {
      cerr<<e.what()<<endl;
      datasetStream.close();
      labelsStream.close();
      return false;
    }
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

  void MnistSet::extractDataset(ifstream &is, DatasetParameters param, float * data)
  {
    if (!is) {
      throw logic_error("can't open file dataset");
    }
    int count = 0;
    while(param.m_batchs--) {
      for (uint32_t r = 0; r < param.m_rows; ++r) {
        for(uint32_t c = 0; c < param.m_cols; ++c) {
          uint8_t byte = readUint8(is);
          data[count++] = static_cast<float>(byte) / 255.f;
        }
      }
    }
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

  void MnistSet::extractLabels(ifstream &is, DatasetParameters param, uint8_t *data)
  {
    if (!is) {
      throw logic_error("can't open file dataset");
    }
    int count = 0;
    while(param.m_batchs--) {
      data[count] = readUint8(is);
      ++count;
    }
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
