TEMPLATE = app
CONFIG += console c++17
CONFIG -= app_bundle
CONFIG -= qt

SOURCES += \
        main.cpp \
        workingbike.cpp \
        workingboston.cpp \
        workingbreast.cpp \
        workingfahrenheit.cpp \
        workingiris.cpp \
        workingmnist.cpp \
        workingtitanic.cpp \
        workingwine.cpp

INCLUDEPATH += $$PWD/../../builds/include

LIBS += -L$$PWD/../../builds/_nix/ -lsnKeras

HEADERS += \
    workingbike.h \
    workingboston.h \
    workingbreast.h \
    workingfahrenheit.h \
    workingiris.h \
    workingmnist.h \
    workingtitanic.h \
    workingwine.h

