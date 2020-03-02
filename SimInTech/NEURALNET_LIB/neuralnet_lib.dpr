library neuralnet_lib;

 //**************************************************************************//
 // Данный исходный код является составной частью системы МВТУ-4             //
 // Программист:        Тимофеев К.А.                                        //
 //**************************************************************************//

 
  //**************************************************************************//
  //           Библиотека блоков гидроавтоматики                              //
  //        Автор версии для МВТУ-3.5: Шепель О., 2002 г.                     //
  //        Автор версии для МВТУ-4: Тимофеев К.А., апрель 2005 г.            //
  //**************************************************************************//

uses
  SimpleShareMem,
  Classes,
  Info in 'Info.pas',
  Blocks in 'Blocks.pas',
  UDataSet in 'UDataSet.pas',
  dataset in 'sn\dataset.pas',
  keras in 'sn\keras.pas',
  UInputLayer in 'UInputLayer.pas',
  UOutputLayer in 'UOutputLayer.pas',
  UDenseLayer in 'UDenseLayer.pas',
  UTrainingBlock in 'UTrainingBlock.pas',
  UTestingBlock in 'UTestingBlock.pas',
  ULossFunction in 'ULossFunction.pas',
  UAbstractLayer in 'UAbstractLayer.pas';

{$R *.res}

  //Эта функция возвращает адрес структуры DllInfo
function  GetEntry:Pointer;
begin
  Result:=@DllInfo;
end;

exports
  GetEntry name 'GetEntry',         //Функция получения адреса структуры DllInfo
  CreateObject name 'CreateObject'; //Функция создания объекта

begin
end.
