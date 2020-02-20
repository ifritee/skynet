TEMPLATE = lib
CONFIG += console c++14 staticlib
CONFIG -= qt

HEADERS += \
    auxFunc.h

SOURCES += \
    src/auxFunc.cpp

INCLUDEPATH += \
    src \
    ..

DEPENDPATH += \
    src \
    ..

unix {
    QMAKE_POST_LINK += mkdir -p $$PWD/../../builds/_nix;
    QMAKE_POST_LINK += cp -rf *.a $$PWD/../../builds/_nix/
}
