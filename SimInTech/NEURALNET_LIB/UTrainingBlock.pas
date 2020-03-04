unit UTrainingBlock;

interface

uses Windows, Classes, DataTypes, SysUtils, RunObjts, dataset;

type

  TTrainingBlock = class(TRunObject)
  public
    // ����������� ������
    constructor  Create(Owner: TObject); override;
    // ����������
    destructor   Destroy; override;
    function       InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;override;
    function       RunFunc(var at,h : RealType;Action:Integer):NativeInt;override;
    function       GetParamID(const ParamName:string;var DataType:TDataType;var IsConst: boolean):NativeInt;override;

  strict private
    stepCount: NativeInt; // ������� �����
    m_nnState: Boolean; // ��������� ����
    m_trainData : pMNIST_DATA;
    m_testData : pMNIST_DATA;
  end;

implementation
  uses keras, UNNConstants;

constructor  TTrainingBlock.Create;
begin
  inherited;
end;

destructor   TTrainingBlock.Destroy;
begin
  inherited;
end;

function    TTrainingBlock.GetParamID;
begin
  Result:=inherited GetParamId(ParamName,DataType,IsConst);
  if Result = -1 then begin


  end
end;

function TTrainingBlock.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
begin
  Result:=0;
  case Action of
    i_GetCount: begin

    end;
  else
    Result:=inherited InfoFunc(Action,aParameter);
  end
end;

function   TTrainingBlock.RunFunc;
var
  i : NativeInt;
  p64: UInt64;
  datas, labels : TLayerSize;
begin
  Result:=0;
  case Action of
    f_UpdateOuts: begin

    end;
    f_InitState: begin
      stepCount := 0;
    end;
    f_GoodStep: begin
      if stepCount = 0 then // ������ ��� ������� ����
      begin
        for I := 0 to cU.FCount - 1 do begin  // ������� �� ������
          if U[I].FCount > 0 then begin
            if U[I].Arr^[0] = UNN_NNMAGICWORD then // ���� ������ ��������� ����
            begin
              m_nnState := False;
              if U[I].FCount = 2 then
                m_nnState := (U[I].Arr^[1] = 1); // ��������� ��������� ����
              if m_nnState = True then
                ErrorEvent('State of NN FALSE', msError, VisualObject);
            end else if ((U[I].Arr^[0] = UNN_DATASEMNIST) AND (U[I].FCount = 5 )) then // ���� ������ ������
            begin
              p64 := Round(U[I].Arr^[1]);
              p64 := p64 shl 32;
              p64 := p64 OR UInt64(Round(U[I].Arr^[2]));
              m_trainData := pMNIST_DATA(p64);
              p64 := Round(U[I].Arr^[3]);
              p64 := p64 shl 32;
              p64 := p64 OR UInt64(Round(U[I].Arr^[4]));
              m_testData := pMNIST_DATA(p64);
            end;
          end;
        end;
      end else begin
        datas.w := m_testData.rows;
        datas.h := m_testData.cols;
        datas.ch := 1;
        datas.bsz := m_testData.quantity;
        labels.w := 10;
        labels.h := 1;
        labels.ch := 1;
        labels.bsz := m_testData.quantity;
        fit(m_testData.data, datas, m_testData.labels, labels, 10, 0.001);
        ErrorEvent('Accurate: ' + FloatToStr(lastAccurateSum), msInfo, VisualObject);
      end;
      inc(stepCount);
    end;
  end
end;
end.
