TEMPLATE = lib
CONFIG += console c++14 staticlib
CONFIG -= qt

QMAKE_CXXFLAGS += -mavx -fopenmp
QMAKE_LFLAGS += -fopenmp

DEFINES += SN_AVX

HEADERS += \
    snOperator.h \
    src/Operator/activation.h \
    src/Operator/batchNorm.h \
    src/Operator/concat.h \
    src/Operator/convolution.h \
    src/Operator/crop.h \
    src/Operator/deconvolution.h \
    src/Operator/fullyConnected.h \
    src/Operator/input.h \
    src/Operator/lock.h \
    src/Operator/lossFunction.h \
    src/Operator/output.h \
    src/Operator/pooling.h \
    src/Operator/resize.h \
    src/Operator/summator.h \
    src/Operator/switch.h \
    src/Operator/userLayer.h \
    src/activationFunctions.h \
    src/batchNormFunctions.h \
    src/dropOut.h \
    src/optimizer.h \
    src/paddingOffs.h \
    src/random.h \
    src/stdafx.h \
    src/structurs.h \
    src/weightInit.h

SOURCES += \
    src/CPU/convolutionCPU.cpp \
    src/CPU/deconvolutionCPU.cpp \
    src/CPU/fullyConnectedCPU.cpp \
    src/CPU/poolingCPU.cpp \
    src/CPU/tensor.cpp \
    src/Operator/activation.cpp \
    src/Operator/batchNorm.cpp \
    src/Operator/concat.cpp \
    src/Operator/convolution.cpp \
    src/Operator/crop.cpp \
    src/Operator/deconvolution.cpp \
    src/Operator/fullyConnected.cpp \
    src/Operator/input.cpp \
    src/Operator/lock.cpp \
    src/Operator/lossFunction.cpp \
    src/Operator/output.cpp \
    src/Operator/pooling.cpp \
    src/Operator/resize.cpp \
    src/Operator/summator.cpp \
    src/Operator/switch.cpp \
    src/Operator/userLayer.cpp \
    src/activationFunctions.cpp \
    src/batchNormFunctions.cpp \
    src/dropOut.cpp \
    src/optimizer.cpp \
    src/paddingOffs.cpp \
    src/random.cpp \
    src/snOperator.cpp \
    src/weightInit.cpp

INCLUDEPATH += \
    src \
    src/CPU \
    src/Operator \
    ..

unix {
    QMAKE_POST_LINK += mkdir -p $$PWD/../../builds/_nix;
    QMAKE_POST_LINK += cp -rf *.a $$PWD/../../builds/_nix/
}
