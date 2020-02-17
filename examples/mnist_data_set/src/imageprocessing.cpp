#include <iostream>
#include <arpa/inet.h>

#include "imageprocessing.h"

using namespace std;

namespace cpp_keras {

  ImageProcessing::ImageProcessing()
  {

  }

  ImageProcessing::~ImageProcessing()
  {
    m_dataTrain.clear();
    m_labelTrain.clear();
    m_dataTest.clear();
    m_labelTest.clear();
  }

  TImagesData & ImageProcessing::dataTrain()
  {
    return m_dataTrain;
  }

  std::vector<uint8_t> & ImageProcessing::labelTrain()
  {
    return m_labelTrain;
  }

  TImagesData & ImageProcessing::dataTest()
  {
    return m_dataTest;
  }

  std::vector<uint8_t> &ImageProcessing::labelTest()
  {
    return m_labelTest;
  }

  void ImageProcessing::consoleOut(bool isTraining, int number)
  {
    int count = 0, shift = 28;

    TImagesData * images = isTraining ? &m_dataTrain : &m_dataTest;
    std::vector<uint8_t> * labels = isTraining ? &m_labelTrain : &m_labelTest;
    for(auto v: (*images)[number]) {
      for(auto s: v) {
        if(count++ % shift == 0) {
          cout<<endl;
        }
        cout<< ((s > 0.7f) ? "#" : (s > 0.4f) ? "*" : (s > 0.1f) ? "." : " " );
      }
    }
    cout<<endl<<"LABEL="<<(int)(*labels)[number]<<endl;
  }

  void ImageProcessing::loadMNISTDataset(const std::string &pathToMnistDB)
  {
    uint32_t numTrain = 0, rowsTrain = 0, colsTrain = 0;
    { //----- Сохраняем тренировочные данные в тензоре -----
      m_dataTrain = extractImages(pathToMnistDB + "/train-images-idx3-ubyte", numTrain, rowsTrain, colsTrain);
      //----- Сохраняем метки тренировочных данных в тензоре -----
      m_labelTrain = extractLabels(pathToMnistDB + "/train-labels-idx1-ubyte");
    }
    { //----- Сохраняем тестовые данные в тензоре -----
      uint32_t numTest = 0, rowsTest = 0, colsTest = 0;
      m_dataTest = extractImages(pathToMnistDB + "/t10k-images-idx3-ubyte", numTest, rowsTest, colsTest);
      //----- Сохраняем метки тестовых данных в тензоре -----
      m_labelTest = extractLabels(pathToMnistDB + "/t10k-labels-idx1-ubyte");
    }
  }

  std::pair<uint32_t, uint32_t> ImageProcessing::sizeMnistImage()
  {
    if(m_dataTrain.size() == 0 || m_dataTrain[0].size() == 0 || m_dataTrain[0][0].size() == 0) {
      throw logic_error("not reading correct data");
    }
    std::pair<uint32_t, uint32_t> size(m_dataTrain[0].size(), m_dataTrain[0][0].size());
    return size;
  }

  TImagesData ImageProcessing::extractImages(const std::string & file, uint32_t & num, uint32_t & rows, uint32_t & cols)
  {
    ifstream is(file);
    if (!is) {
      throw logic_error("can't open file: " + file);
    }
    uint32_t magic = readUint32(is);
    if (magic != 2051) {
      throw logic_error("bad magic: " + to_string(magic));
    }
    num = readUint32(is);
    rows = readUint32(is);
    cols = readUint32(is);
    TImagesData imagesData;
    while(num--) {  // Пройдем по всем элементам
      vector< vector< float > > image;
      for (uint32_t r = 0; r < rows; ++r) {
        vector< float > row;
        for(uint32_t c = 0; c < cols; ++c) {
          uint8_t byte = readUint8(is);
          row.push_back(static_cast<float>(byte)/255.f);
        }
        image.push_back(row);
      }
//      for(uint32_t i = 0; i < rows*cols; ++i) {
//        uint8_t byte = readUint8(is);
//        image.push_back(byte);
////        image.push_back(static_cast<float>(byte)/255.f);
//      }
      imagesData.push_back(image);
    }
    return imagesData;
  }

  std::vector<uint8_t> ImageProcessing::extractLabels(const string& file)
  {
    ifstream is(file);
    if (!is) {
      throw logic_error("can't open file: " + file);
    }
    uint32_t magic = readUint32(is);
    if (magic != 0x801) {
      throw logic_error("bad magic: " + to_string(magic));
    }
    uint32_t num = readUint32(is);
    vector<uint8_t> labels;
    for (size_t i = 0; i < num; ++i) {
      uint8_t byte = readUint8(is);
      labels.push_back(byte);
    }
    return labels;
  }

  uint8_t ImageProcessing::readUint8(ifstream & is)
  {
    uint8_t data = 0;
    auto read_count = is.readsome(reinterpret_cast<char*>(&data), 1);
    if (read_count != 1) {
      throw logic_error("can't read 1 byte");
    }
    return data;
  }

  uint32_t ImageProcessing::readUint32(ifstream & is)
  {
    uint32_t data = 0;
    auto read_count = is.readsome(reinterpret_cast<char*>(&data), 4);
    if (read_count != 4) {
      throw logic_error("can't read 4 bytes");
    }
    return ntohl(data);
  }
}
