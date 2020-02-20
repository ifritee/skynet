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
    src/keras_lib_global.h \
    src/mnistset.h \
    src/snNet.h \
    src/snOperator.h \
    src/snTensor.h \
    src/snType.h

INCLUDEPATH += \
    $$PWD/src

DEPENDPATH += \
    $$PWD/src

#LIBS += -L$$PWD/../../examples/libs -lskynet

#include(ext/snaux.pri)
#include(ext/snbase.pri)
#include(ext/snengine.pri)
#include(ext/snoperatorcpu.pri)
#include(ext/snsimd.pri)
#include(ext/skynet.pri)
