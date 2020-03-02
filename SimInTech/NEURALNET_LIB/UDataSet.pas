//**************************************************************************//
 // Данный исходный код является составной частью системы             //
 // Программист:        Никишин Е. В.                                        //
 //**************************************************************************//

unit UDataSet;

interface

uses Windows, Classes, DataTypes, SysUtils, RunObjts, uExtMath;

type

  TDataSet = class(TRunObject)
  public
    function       InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;override;
    function       RunFunc(var at,h : RealType;Action:Integer):NativeInt;override;
    function       GetParamID(const ParamName:string;var DataType:TDataType;var IsConst: boolean):NativeInt;override;
  end;

implementation

uses dataset;

function    TDataSet.GetParamID;
begin
  Result:=inherited GetParamId(ParamName,DataType,IsConst);
  if Result = -1 then begin


  end
end;

function TDataSet.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
begin
  Result:=0;
  case Action of
    i_GetCount: begin

    end;
  else
    Result:=inherited InfoFunc(Action,aParameter);
  end
end;

function   TDataSet.RunFunc;
begin
 Result:=0;
 case Action of
   f_UpdateOuts,
   f_InitState,
   f_GoodStep:
   ;
 end
end;
end.
