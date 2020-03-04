//**************************************************************************//
 // ������ �������� ��� �������� ��������� ������ �������             //
 // �����������:        ������� �. �.                                        //
 //**************************************************************************//

unit UDataSet;

interface

uses Windows, Classes, DataTypes, SysUtils, RunObjts, dataset;

type

  TDataSet = class(TRunObject)
  public
    // ����������� ������
    constructor  Create(Owner: TObject); override;
    // ����������
    destructor   Destroy; override;
    function       InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;override;
    function       RunFunc(var at,h : RealType;Action:Integer):NativeInt;override;
    function       GetParamID(const ParamName:string;var DataType:TDataType;var IsConst: boolean):NativeInt;override;

  strict private
     isCreate: Boolean;

     m_datasetType: NativeInt;  /// ��� ������
     m_trainData: String; /// ������������ ������������� ������
     m_trainlabel: String;  /// ������������ ������������� �����
     m_testData: String;  /// ������������ �������� ������
     m_testLabel: String; /// ������������ �������� �����
     m_trainMnistData: TMNIST_DATA; /// ������������� ������ � MNIST
     m_testMnistData: TMNIST_DATA;  /// �������� ������ � MNIST
  end;

implementation

uses keras, UNNConstants;

constructor  TDataSet.Create;
begin
  inherited;
  isCreate:= False;
end;

destructor   TDataSet.Destroy;
begin
  inherited;
end;

function    TDataSet.GetParamID;
begin
  Result:=inherited GetParamId(ParamName,DataType,IsConst);
  if Result = -1 then begin
     if StrEqu(ParamName,'TrainData') then begin
      Result:=NativeInt(@m_trainData);
      DataType:=dtString;
      Exit;
    end else if StrEqu(ParamName,'TrainLabel') then begin
      Result:=NativeInt(@m_trainlabel);
      DataType:=dtString;
      Exit;
    end else if StrEqu(ParamName,'TestData') then begin
      Result:=NativeInt(@m_testData);
      DataType:=dtString;
      Exit;
    end else if StrEqu(ParamName,'TestLabel') then begin
      Result:=NativeInt(@m_testLabel);
      DataType:=dtString;
      Exit;
    end else if StrEqu(ParamName,'DataSet') then begin
      Result:=NativeInt(@m_datasetType);
      DataType:=dtInteger;
      Exit;
    end;

  end
end;

function TDataSet.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
begin
  Result:=0;
  case Action of
    i_GetCount: begin
      cY[0] := 5;
    end;
  else
    Result:=inherited InfoFunc(Action,aParameter);
  end
end;

function   TDataSet.RunFunc;
var
  returnCode: TStatus;
  p64: UInt64;
  i, j: Integer;
begin
 Result:=0;
 case Action of
    f_UpdateOuts: begin

    end;
    f_InitState: begin
      isCreate := False;
      m_trainMnistData.quantity := 0;
      m_testMnistData.quantity := 0;
      // ��������� �������� ������
      for I := 0 to cY.Count - 1 do begin
        cY.Arr^[I] := 0;
        for J := 0 to Y[I].Count - 1 do  begin
          Y[I].Arr^[J] := 0;
        end;
      end;

//      if FileExists(m_trainData) AND FileExists(m_trainLabel) then begin
//        returnCode := dataset.readMnistTrain(PAnsiChar(AnsiString(m_trainData)), PAnsiChar(AnsiString(m_trainLabel)));
//        if returnCode <> STATUS_OK then begin
//          ErrorEvent('Read MNIST train db is failure!', msError, VisualObject);
//          Exit;
//        end;
//        m_trainMnistData := mnistTrainParams;
//        ErrorEvent('Read MNIST train: ' + IntToStr(m_trainMnistData.quantity), msInfo, VisualObject);
//      end;
      if FileExists(m_testData) AND FileExists(m_testLabel) then begin
        returnCode := dataset.readMnistTest(PAnsiChar(AnsiString(m_testData)), PAnsiChar(AnsiString(m_testLabel)));
        if returnCode <> STATUS_OK then begin
          ErrorEvent('Read MNIST test db is failure!', msError, VisualObject);
          Exit;
        end;
        m_testMnistData := mnistTestParams;
        ErrorEvent('Read MNIST test: ' + IntToStr(m_testMnistData.quantity), msInfo, VisualObject);
      end;
    end;
    f_GoodStep: begin
      if isCreate = False then
      begin
        isCreate := True;
        Y[0].Arr^[0] := UNN_DATASEMNIST;
        p64 := UInt64(@m_trainMnistData);
        Y[0].Arr^[1] := p64 shr 32;
        Y[0].Arr^[2]:= (p64 shl 32) shr 32;
        p64 := UInt64(@m_testMnistData);
        Y[0].Arr^[3] := p64 shr 32;
        Y[0].Arr^[4]:= (p64 shl 32) shr 32;
      end;
    end;
  end
end;
end.
