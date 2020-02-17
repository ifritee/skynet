#ifndef IMAGEPROCESSING_H
#define IMAGEPROCESSING_H

#include <string>
#include <vector>
#include <fstream>

namespace cpp_keras {

  typedef std::vector<std::vector< std::vector< float> > > TImagesData;

  /** @brief Обработка изображения для дальнейшей передачи в Keras */
  class ImageProcessing
  {
    TImagesData m_dataTrain;  ///< @brief тренировочные данные
    std::vector<uint8_t> m_labelTrain;  ///< @brief метки тренировочных данных
    TImagesData m_dataTest; ///< @brief тестовые данные
    std::vector<uint8_t> m_labelTest; ///< @brief метки тестовых данных

  public:
    /** @brief Конструктор */
    ImageProcessing();
    /** @brief Деструктор */
    virtual ~ImageProcessing();
    /**
     * @brief loadMnistDataset Загрузка сета картинок MNIST
     * @param pathToMnistDB Путь к картинкам */
    void loadMNISTDataset(const std::string & pathToMnistDB);
    /**
     * @brief sizeMnistImage Собирает и возвращает размер картинки (28х28)
     * @return Пара размеров (width, height)
     */
    std::pair<uint32_t, uint32_t> sizeMnistImage();

    /** @brief тренировочные данные */
    TImagesData & dataTrain();
    /** @brief метки тренировочных данных */
    std::vector<uint8_t> & labelTrain() ;
    /** @brief тестовые данные */
    TImagesData & dataTest() ;
    /** @brief метки тестовых данных */
    std::vector<uint8_t> & labelTest();
    /** @brief Вывод в консоль данного */
    void consoleOut(bool isTraining, int number);

  private:
    /**
     * @brief extractImages Распаковка картинок из БД
     * @param file Путь к файлу
     * @return Массив данных картинок */
    TImagesData extractImages(const std::string & file, uint32_t & num, uint32_t & rows, uint32_t & cols);
    /**
     * @brief extractLabels Распаковка меток картинок из БД
     * @param file Путь к файлу
     * @return Массив данных меток */
    std::vector<uint8_t> extractLabels(const std::string & file);

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
