TEMPLATE = app
CONFIG += console c++11
CONFIG -= app_bundle
CONFIG -= qt

SOURCES += \
        main.cpp

HEADERS += \
        ../src/keras.h

unix:!macx: LIBS += -L$$PWD/../../../../build-keras_lib-Desktop_Qt_5_12_6_GCC_64bit-Debug/ -lkeras_lib
unix:!macx: LIBS += -L$$PWD/../../../examples/libs/ -lskynet

