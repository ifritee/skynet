
 //**************************************************************************//
 // Данный исходный код является составной частью системы МВТУ-4             //
 // Программист:        Тимофеев К.А.                                        //
 //**************************************************************************//


unit Info;

  //**************************************************************************//
  //         Здесь находится список объектов и функция для их создания        //
  //**************************************************************************//

interface

uses Classes, InterfaceUnit,DataTypes, DataObjts, RunObjts;

  //Инициализация библиотеки
function  Init:boolean;
  //Процедура создания объекта
function  CreateObject(Owner:Pointer;const Name: string):Pointer;
  //Уничтожение библиотеки
procedure Release;

  //Главная информационая запись библиотеки
  //Она содержит ссылки на процедуры инициализации, завершения библиотеки
  //и функцию создания объектов
const
  DllInfo: TDllInfo =
  (
    Init:         Init;
    Release:      Release;
    CreateObject: CreateObject;
  );

implementation

uses Blocks,
     UDataSet,
     UInputLayer,
     UOutputLayer,
     UDenseLayer,
     UTrainingBlock,
     UTestingBlock,
     UWorkModeBlock,
     ULossFunction,
     USummatorLayer,
     UResizeLayer,
     UPoolingLayer,
     UDeconvolutionLayer,
     UCropLayer,
     UActivatorLayer,
     UConvolutionLayer,
     UConcatLayer,
     UMNISTPixel;

function  Init:boolean;
begin
  //Если библиотека инициализирована правильно, то функция должна вернуть True
  Result:=True;
  //Присваиваем папку с корневой директорией базы данных программы
  DBRoot:=DllInfo.Main.DataBasePath^;

  //Здесь можно произвести регистрацию дополнительных функций интерпретатора
  //при помощи функции DllInfo.Main.RegisterFuncs
  //для того чтобы подключить функции к оболочке надо внести библиотеку в список плагинов графического редактора.

end;


type
  TClassRecord = packed record
    Name:     string;
    RunClass: TRunClass;
  end;

  //**************************************************************************//
  //    Таблица классов имеющихся в стандартной библиотеке блоков МВТУ        //
  //    в соответствии с этой таблицей создаются соответсвующие run-объекты   //
  //**************************************************************************//
const
  ClassTable:array[0..16] of TClassRecord =
  (
    //Блоки для работы с нейросетью
    (Name:'TDataSet'; RunClass:TDataSet),
    (Name:'TInputLayer'; RunClass:TInputLayer),
    (Name:'TOutputLayer'; RunClass:TOutputLayer),
    (Name:'TDenseLayer'; RunClass:TDenseLayer),
    (Name:'TTrainingBlock'; RunClass:TTrainingBlock),
    (Name:'TTestingBlock'; RunClass:TTestingBlock),
    (Name:'TWorkModeBlock'; RunClass:TWorkModeBlock),
    (Name:'TLossFunction'; RunClass:TLossFunction),
    (Name:'TActivatorLayer'; RunClass:TActivatorLayer),
    (Name:'TConcatLayer'; RunClass:TConcatLayer),
    (Name:'TConvolutionLayer'; RunClass:TConvolutionLayer),
    (Name:'TCropLayer'; RunClass:TCropLayer),
    (Name:'TDeconvolutionLayer'; RunClass:TDeconvolutionLayer),
    (Name:'TPoolingLayer'; RunClass:TPoolingLayer),
    (Name:'TResizeLayer'; RunClass:TResizeLayer),
    (Name:'TSummatorLayer'; RunClass:TSummatorLayer),
    (Name:'TMNISTPixel'; RunClass:TMNISTPixel)
  );


  //Это процедура создания объектов
  //она возвращает интерфейс на объект-плагин
function  CreateObject(Owner:Pointer;const Name: string):Pointer;
 var i: integer;
begin
  Result:=nil;
  for i:=0 to High(ClassTable) do if StrEqu(Name,ClassTable[i].Name) then begin
    Result:=ClassTable[i].RunClass.Create(Owner);
    exit;
  end;
end;

procedure Release;
begin

end;

end.
