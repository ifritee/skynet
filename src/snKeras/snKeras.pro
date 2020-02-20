TEMPLATE = lib
CONFIG += console c++14
CONFIG -= qt

DEFINES += QT_DEPRECATED_WARNINGS KERAS_LIBRARY

SOURCES += \
    src/dataset.cpp \
    src/dllmain.cpp \
    src/keras.cpp \
    src/mnistset.cpp \
    src/snNet.cpp \
    src/snOperator.cpp \
    src/snTensor.cpp \
    src/snType.cpp

HEADERS += \
    ../../src/skynet/skyNet.h \
    src/dataset.h \
    src/keras.h \
    src/mnistset.h \
    src/snNet.h \
    src/snOperator.h \
    src/snTensor.h \
    src/snType.h \
    src/snkeras_global.h

INCLUDEPATH += \
    $$PWD/src

DEPENDPATH += \
    $$PWD/src

QMAKE_CXXFLAGS += -mavx -fopenmp
QMAKE_LFLAGS += -fopenmp

LIBS += -L$$PWD/../../builds/_nix -lsnSkynet \
        -L$$PWD/../../builds/_nix -lsnEngine \
        -L$$PWD/../../builds/_nix -lsnOperatorCPU \
        -L$$PWD/../../builds/_nix -lsnSIMD \
        -L$$PWD/../../builds/_nix -lsnAux

LIBS += -lopenblas

unix {
    QMAKE_POST_LINK += mkdir -p $$PWD/../../builds/_nix;
    QMAKE_POST_LINK += mkdir -p $$PWD/../../builds/include;
    QMAKE_POST_LINK += cp -rf *.so* $$PWD/../../builds/_nix;
    QMAKE_POST_LINK += cp -rf $$PWD/src/dataset.h $$PWD/src/*keras*.h  $$PWD/../../builds/include;
}
