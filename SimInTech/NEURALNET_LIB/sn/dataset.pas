unit dataset;

interface
uses
  keras
  ;
type
  PPSingle = ^PSingle;
  PPByte = ^PByte;

   Function mnistTrainData(datafilename : PAnsiChar;
                          labelfilename : PAnsiChar;
                          data_ : PPSingle;
                          label_ : PPSingle;
                          sizeData : PLayerSize;
                          sizeLabel : PLayerSize;
                          qty: Integer; step: Integer
                          ) : keras.TStatus; cdecl; external KERAS_EXPORT;

  Function bikeTrainData(filename : PAnsiChar;
                         isDay : Boolean;
                         data_ : PPSingle;
                         label_ : PPSingle;
                         sizeData : PLayerSize;
                         sizeLabel : PLayerSize;
                          qty: Integer; step: Integer
                         ) : keras.TStatus; cdecl; external KERAS_EXPORT;

  Function bostonTrainData(filename : PAnsiChar;
                           data_ : PPSingle;
                           label_ : PPSingle;
                           sizeData : PLayerSize;
                           sizeLabel : PLayerSize;
                          qty: Integer; step: Integer
                           ) : keras.TStatus; cdecl; external KERAS_EXPORT;

  Function breastTrainData(filename : PAnsiChar;
                           flag_ : Integer;
                           data_ : PPSingle;
                           label_ : PPSingle;
                           sizeData : PLayerSize;
                           sizeLabel : PLayerSize;
                          qty: Integer; step: Integer
                           ) : keras.TStatus; cdecl; external KERAS_EXPORT;

Function irisTrainData(filename : PAnsiChar;
                           data_ : PPSingle;
                           label_ : PPByte;
                           sizeData : PLayerSize;
                           sizeLabel : PLayerSize;
                          qty: Integer; step: Integer
                           ) : keras.TStatus; cdecl; external KERAS_EXPORT;

Function wineTrainData(filename : PAnsiChar;
                           data_ : PPSingle;
                           label_ : PPByte;
                           sizeData : PLayerSize;
                           sizeLabel : PLayerSize;
                          qty: Integer; step: Integer
                           ) : keras.TStatus; cdecl; external KERAS_EXPORT;

Function titanicTrainData(filename : PAnsiChar;
                           data_ : PPSingle;
                           label_ : PPByte;
                           sizeData : PLayerSize;
                           sizeLabel : PLayerSize;
                          qty: Integer; step: Integer
                           ) : keras.TStatus; cdecl; external KERAS_EXPORT;
Procedure freeTrainData(data_ : PPSingle; label_ : PPByte); cdecl; external KERAS_EXPORT;

Procedure freeTrainDataF(data_ : PPSingle; label_ : PPSingle); cdecl; external KERAS_EXPORT;

implementation

end.

