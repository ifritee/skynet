TEMPLATE = app
CONFIG += console c++11
CONFIG -= app_bundle
CONFIG -= qt

SOURCES += \
        main.cpp

INCLUDEPATH += $$PWD/../../builds/include

LIBS += -L$$PWD/../../builds/_nix/ -lsnKeras

