TEMPLATE = app
CONFIG += console c++11
CONFIG -= app_bundle
CONFIG -= qt

SOURCES += \
        main.cpp \
        workingbreast.cpp \
        workingfahrenheit.cpp \
        workingiris.cpp \
        workingmnist.cpp \
        workingwine.cpp

INCLUDEPATH += $$PWD/../../builds/include

LIBS += -L$$PWD/../../builds/_nix/ -lsnKeras

HEADERS += \
    workingbreast.h \
    workingfahrenheit.h \
    workingiris.h \
    workingmnist.h \
    workingwine.h

