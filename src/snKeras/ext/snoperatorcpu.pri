 
DEFINES += SN_AVX

SOURCES += \
    $$PWD/../../../src/snOperatorCPU/src/CPU/convolutionCPU.cpp \
    $$PWD/../../../src/snOperatorCPU/src/CPU/deconvolutionCPU.cpp \
    $$PWD/../../../src/snOperatorCPU/src/CPU/fullyConnectedCPU.cpp \
    $$PWD/../../../src/snOperatorCPU/src/CPU/poolingCPU.cpp \
    $$PWD/../../../src/snOperatorCPU/src/CPU/tensor.cpp \
    $$PWD/../../../src/snOperatorCPU/src/Operator/activation.cpp \
    $$PWD/../../../src/snOperatorCPU/src/Operator/batchNorm.cpp \
    $$PWD/../../../src/snOperatorCPU/src/Operator/concat.cpp \
    $$PWD/../../../src/snOperatorCPU/src/Operator/convolution.cpp \
    $$PWD/../../../src/snOperatorCPU/src/Operator/crop.cpp \
    $$PWD/../../../src/snOperatorCPU/src/Operator/deconvolution.cpp \
    $$PWD/../../../src/snOperatorCPU/src/Operator/fullyConnected.cpp \
    $$PWD/../../../src/snOperatorCPU/src/Operator/input.cpp \
    $$PWD/../../../src/snOperatorCPU/src/Operator/lock.cpp \
    $$PWD/../../../src/snOperatorCPU/src/Operator/lossFunction.cpp \
    $$PWD/../../../src/snOperatorCPU/src/Operator/output.cpp \
    $$PWD/../../../src/snOperatorCPU/src/Operator/pooling.cpp \
    $$PWD/../../../src/snOperatorCPU/src/Operator/resize.cpp \
    $$PWD/../../../src/snOperatorCPU/src/Operator/summator.cpp \
    $$PWD/../../../src/snOperatorCPU/src/Operator/switch.cpp \
    $$PWD/../../../src/snOperatorCPU/src/Operator/userLayer.cpp \
    $$PWD/../../../src/snOperatorCPU/src/activationFunctions.cpp \
    $$PWD/../../../src/snOperatorCPU/src/batchNormFunctions.cpp \
    $$PWD/../../../src/snOperatorCPU/src/dropOut.cpp \
    $$PWD/../../../src/snOperatorCPU/src/optimizer.cpp \
    $$PWD/../../../src/snOperatorCPU/src/paddingOffs.cpp \
    $$PWD/../../../src/snOperatorCPU/src/random.cpp \
    $$PWD/../../../src/snOperatorCPU/src/snOperator.cpp \
    $$PWD/../../../src/snOperatorCPU/src/weightInit.cpp

HEADERS += \
    $$PWD/../../../src/snOperatorCPU/src/Operator/activation.h \
    $$PWD/../../../src/snOperatorCPU/src/Operator/batchNorm.h \
    $$PWD/../../../src/snOperatorCPU/src/Operator/concat.h \
    $$PWD/../../../src/snOperatorCPU/src/Operator/convolution.h \
    $$PWD/../../../src/snOperatorCPU/src/Operator/crop.h \
    $$PWD/../../../src/snOperatorCPU/src/Operator/deconvolution.h \
    $$PWD/../../../src/snOperatorCPU/src/Operator/fullyConnected.h \
    $$PWD/../../../src/snOperatorCPU/src/Operator/input.h \
    $$PWD/../../../src/snOperatorCPU/src/Operator/lock.h \
    $$PWD/../../../src/snOperatorCPU/src/Operator/lossFunction.h \
    $$PWD/../../../src/snOperatorCPU/src/Operator/output.h \
    $$PWD/../../../src/snOperatorCPU/src/Operator/pooling.h \
    $$PWD/../../../src/snOperatorCPU/src/Operator/resize.h \
    $$PWD/../../../src/snOperatorCPU/src/Operator/summator.h \
    $$PWD/../../../src/snOperatorCPU/src/Operator/switch.h \
    $$PWD/../../../src/snOperatorCPU/src/Operator/userLayer.h \
    $$PWD/../../../src/snOperatorCPU/src/activationFunctions.h \
    $$PWD/../../../src/snOperatorCPU/src/batchNormFunctions.h \
    $$PWD/../../../src/snOperatorCPU/src/dropOut.h \
    $$PWD/../../../src/snOperatorCPU/src/optimizer.h \
    $$PWD/../../../src/snOperatorCPU/src/paddingOffs.h \
    $$PWD/../../../src/snOperatorCPU/src/random.h \
    $$PWD/../../../src/snOperatorCPU/src/stdafx.h \
    $$PWD/../../../src/snOperatorCPU/src/structurs.h \
    $$PWD/../../../src/snOperatorCPU/src/weightInit.h


INCLUDEPATH += $$PWD/../../../src/snOperatorCPU \
               $$PWD/../../../src/snOperatorCPU/src \
               $$PWD/../../../src/snOperatorCPU/src/CPU \
               $$PWD/../../../src/snOperatorCPU/src/Operator
