unit UTestingBlock;

interface

uses Windows, Classes, DataTypes, SysUtils, RunObjts, uExtMath;

type

  TTestingBlock = class(TRunObject)
  public
    function       InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;override;
    function       RunFunc(var at,h : RealType;Action:Integer):NativeInt;override;
    function       GetParamID(const ParamName:string;var DataType:TDataType;var IsConst: boolean):NativeInt;override;
  end;

implementation
  uses keras;

function    TTestingBlock.GetParamID;
begin
  Result:=inherited GetParamId(ParamName,DataType,IsConst);
  if Result = -1 then begin


  end
end;

function TTestingBlock.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
begin
  Result:=0;
  case Action of
    i_GetCount: begin

    end;
  else
    Result:=inherited InfoFunc(Action,aParameter);
  end
end;

function   TTestingBlock.RunFunc;
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
