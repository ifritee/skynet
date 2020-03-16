﻿unit UTestingBlock;

interface

uses Windows, Classes, DataTypes, SysUtils, RunObjts, dataset;

type

  TTestingBlock = class(TRunObject)
  public
    // Конструктор класса
    constructor  Create(Owner: TObject); override;
    // Деструктор
    destructor   Destroy; override;
    function       InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;override;
    function       RunFunc(var at,h : RealType;Action:Integer):NativeInt;override;
    function       GetParamID(const ParamName:string;var DataType:TDataType;var IsConst: boolean):NativeInt;override;

  strict private
    stepCount: NativeInt; // Счетчик шагов
    m_nnState: Boolean; // Состояние сети
    m_testData : pMNIST_DATA;

    m_crossOut: NativeInt;
    m_fileLoad: String;
    m_id : Integer;
    m_label: array of Byte;
    m_maxQty: Integer; // Максимальное кол-во элементов в посылке
  end;

implementation
  uses keras, UNNConstants;

constructor  TTestingBlock.Create;
begin
  inherited;
end;

destructor   TTestingBlock.Destroy;
begin
  inherited;
end;

function    TTestingBlock.GetParamID;
begin
  Result:=inherited GetParamId(ParamName,DataType,IsConst);
  if Result = -1 then begin
    if StrEqu(ParamName,'cross_out') then begin
      Result:=NativeInt(@m_crossOut);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'file_load') then begin
      Result:=NativeInt(@m_fileLoad);
      DataType:=dtString;
      Exit;
    end else if StrEqu(ParamName,'max_qty') then begin
      Result:=NativeInt(@m_maxQty);
      DataType:=dtInteger;
      Exit;
    end;
  end
end;

function TTestingBlock.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
begin
  Result:=0;
  case Action of
    i_GetCount: begin
      cY[0] := m_maxQty;
      cY[1] := 1;
    end;
  else
    Result:=inherited InfoFunc(Action,aParameter);
  end
end;

function   TTestingBlock.RunFunc;
var
  i : NativeInt;
  p64: UInt64;
  datas, labels : TLayerSize;
  returnCode : NativeInt;
  m_data: PDataArr; /// Данные, которые проходят через слои модели
  accuracy : Single;
  //color, alpha : Integer;
begin
 Result:=0;
  case Action of
    f_UpdateOuts: begin

    end;
    f_InitState: begin
      stepCount := 0;
    end;
    f_GoodStep: begin
    if stepCount = 0 then // Только для первого шага
      // Вход 0 - данные
      // Вход 1 - метки
      // Вход 2 - ширина
      // Вход 3 - высота
      // Вход 4 - глубина
      if cU.FCount <> 5 then begin
        ErrorEvent('Input ports qty != 5', msError, VisualObject);
        Exit;
      end;
      m_id := Round(U[0].Arr^[0]);
      p64 := Round(U[0].Arr^[1]);
      p64 := p64 shl 32;
      p64 := p64 OR UInt64(Round(U[0].Arr^[2]));
      m_data := PDataArr(p64);
      SetLength(m_label, U[1].Count);
      for I := 0 to Length(m_label) - 1 do begin
        m_label[I] := Round(U[1].Arr^[I]);
      end;
      datas.w := Round(U[2].Arr^[0]);
      datas.h := Round(U[3].Arr^[0]);
      datas.ch := Round(U[4].Arr^[0]);
      datas.bsz := Length(m_label);
      labels.w := m_crossOut;
      labels.h := 1;
      labels.ch := 1;
      labels.bsz := Length(m_label);
      if m_fileLoad.Length > 0 then begin
        returnCode := loadModel(m_id, PAnsiChar(AnsiString(m_fileLoad)));
        if returnCode <> STATUS_OK then begin
          ErrorEvent('Crashed load model weight', msError, VisualObject);
          Exit;
        end;
      end else begin
        ErrorEvent('Open weight file is crashed', msError, VisualObject);
        Exit;
      end;
      returnCode := evaluate(m_id, @m_data^[0], datas, @m_label[0], labels, 2, accuracy);
      Y[1].Arr^[0] := accuracy;
      for I := 0 to Length(m_data^) - 1 do begin
        // color := Round(m_data^[I] * 255.0);
        // alpha := 255;
        // Y[0].Arr^[I] := (Integer(alpha) SHL 24) or (Integer(color) SHL 16) or (Integer(color) SHL 8) or Integer(color);
        Y[0].Arr^[I] := m_data^[I];

      end;

      inc(stepCount);
    end;
    f_Stop : begin

    end;
  end;
end;
end.
