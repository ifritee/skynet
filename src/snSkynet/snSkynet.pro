TEMPLATE = lib
CONFIG += console c++14 staticlib
CONFIG -= qt

HEADERS += \
    skyNet.h \
    src/snet.h

SOURCES += \
    src/dllmain.cpp \
    src/jnNet.cpp \
    src/skynet.cpp \
    src/snet.cpp

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

