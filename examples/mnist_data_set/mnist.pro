TEMPLATE = app
CONFIG += console c++14
CONFIG -= app_bundle
CONFIG -= qt

SOURCES += \
        src/main.cpp \
        src/imageprocessing.cpp

HEADERS += \
        src/imageprocessing.h

INCLUDEPATH += \
        $$PWD/../../api/cpp \
        $$PWD/..

unix:!macx: LIBS += -L$$PWD/../libs/ -lskynet

INCLUDEPATH += $$PWD/../libs
DEPENDPATH += $$PWD/../libs
