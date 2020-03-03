//**************************************************************************//
 // ������ �������� ��� �������� ��������� ������ �������             //
 // �����������:        ������� �. �.                                        //
 //**************************************************************************//

unit UDataSet;

interface

uses Windows, Classes, DataTypes, SysUtils, RunObjts;

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
  end;

implementation

uses dataset, keras, UNNConstants;

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

    end;
  else
    Result:=inherited InfoFunc(Action,aParameter);
  end
end;

function   TDataSet.RunFunc;
var
  returnCode: TStatus;
  trainData: TMNIST_DATA;
  testData: TMNIST_DATA;
begin
 Result:=0;
 case Action of
    f_UpdateOuts: begin

    end;
    f_InitState: begin
      isCreate := False;
      if FileExists(m_trainData) AND FileExists(m_trainLabel) then begin
        returnCode := dataset.readMnistTrain(PAnsiChar(AnsiString(m_trainData)), PAnsiChar(AnsiString(m_trainLabel)));
        if returnCode <> STATUS_OK then begin
          ErrorEvent('Read MNIST train db is failure!', msError, VisualObject);
          Exit;
        end;
        trainData := mnistTrainParams;
        ErrorEvent('Read MNIST train: ' + IntToStr(trainData.quantity), msInfo, VisualObject);
      end;
      if FileExists(m_testData) AND FileExists(m_testLabel) then begin
        returnCode := dataset.readMnistTest(PAnsiChar(AnsiString(m_testData)), PAnsiChar(AnsiString(m_testLabel)));
        if returnCode <> STATUS_OK then begin
          ErrorEvent('Read MNIST test db is failure!', msError, VisualObject);
          Exit;
        end;
        testData := mnistTestParams;
        ErrorEvent('Read MNIST test: ' + IntToStr(testData.quantity), msInfo, VisualObject);
      end;
    end;
    f_GoodStep: begin
      if isCreate = False then begin
        isCreate := True;
        Y[0].Arr^[0] := UNN_DATASEMNIST;
        Y[0].Arr^[1] := trainData.quantity;
        Y[0].Arr^[2] := testData.quantity;
      end;
    end;
  end
end;
end.
