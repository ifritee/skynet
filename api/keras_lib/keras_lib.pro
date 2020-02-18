TEMPLATE = lib
CONFIG += console c++11
CONFIG -= qt

DEFINES += KERAS_LIB

SOURCES += \
    src/dllmain.cpp \
    src/keras.cpp \
    src/snNet.cpp \
    src/snOperator.cpp \
    src/snTensor.cpp \
    src/snType.cpp

HEADERS += \
    src/keras.h \
    src/snNet.h \
    src/snOperator.h \
    src/snTensor.h \
    src/snType.h

INCLUDEPATH += \
    $$PWD/src

DEPENDPATH += \
    $$PWD/src
