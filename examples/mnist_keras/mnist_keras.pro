TEMPLATE = app
CONFIG += console c++11
CONFIG -= app_bundle
CONFIG -= qt

SOURCES += \
        main.cpp \
        workingbreast.cpp \
        workingmnist.cpp

INCLUDEPATH += $$PWD/../../builds/include

LIBS += -L$$PWD/../../builds/_nix/ -lsnKeras

HEADERS += \
    workingbreast.h \
    workingmnist.h

