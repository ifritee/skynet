unit UWorkModeBlock;

interface

uses Windows, Classes, DataTypes, SysUtils, RunObjts, dataset, keras, UNNConstants;

type
  // ��������� ������� ������
  TWorkModeType = (dtTraining, dtTesting, dtRun);

  TWorkModeBlock = class(TRunObject)
  public
    // ����������� ������
    constructor  Create(Owner: TObject); override;
    // ����������
    destructor   Destroy; override;
    function     InfoFunc(Action: integer; aParameter: NativeInt):NativeInt;override;
    function     RunFunc(var at,h : RealType;Action:Integer):NativeInt;override;
    function     GetParamID(const ParamName:string;var DataType:TDataType;var IsConst: boolean):NativeInt;override;
    // ������� ��� ����������� ��������� ���������� ���������� �����
    procedure EditFunc(Props:TList;
                       SetPortCount:TSetPortCount;
                       SetCondPortCount:TSetCondPortCount;
                       ExecutePropScript:TExecutePropScript);override;

  strict private
    stepCount: NativeInt; // ������� �����
    m_id : Integer;
    m_workType : TWorkModeType;
    m_resultQty, m_maxQty: Integer; // ���������� �������
    m_label: array of Byte;
    m_fLabel: array of Single;
    m_labelPoint, m_reciveLabels: array of Single;   /// ����� ���
    m_learningRate : double; // ��� �������

    // ������� ���������� ������
    function training(crossOut: Integer; data: PDataArr): Boolean;
    // ������� ������������ ������
    function testing(crossOut: Integer; data: PDataArr): Boolean;
    // ������� ���������� �������� �� ������ ��
    function guessing(crossOut: Integer; data: PDataArr): Boolean;
  end;

implementation
  uses NN_Texts;

constructor  TWorkModeBlock.Create;
begin
  inherited;
  m_workType := dtTraining;
  m_resultQty := 1;
  m_learningRate := 0.001;
end;

destructor   TWorkModeBlock.Destroy;
begin
  inherited;
end;

function    TWorkModeBlock.GetParamID;
begin
  Result:=inherited GetParamId(ParamName,DataType,IsConst);
  if Result = -1 then begin
    if StrEqu(ParamName,'result_qty') then begin
      Result:=NativeInt(@m_resultQty);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'max_qty') then begin
      Result:=NativeInt(@m_maxQty);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'work_type') then begin
      Result:=NativeInt(@m_workType);
      DataType:=dtEnum;
      Exit;
    end else if StrEqu(ParamName,'learning_rate') then begin
      Result:=NativeInt(@m_learningRate);
      DataType:=dtDouble;
      Exit;
    end;
  end
end;

//----- �������������� ������� ����� -----
procedure TWorkModeBlock.EditFunc;
begin
  case m_workType of
    dtTraining: begin
      SetCondPortCount(VisualObject, 1, pmInput, 0, sdLeft, 'label');
      SetCondPortCount(VisualObject, 0, pmOutput, 0, sdRight, 'data_out');
    end;
    dtTesting: begin
      SetCondPortCount(VisualObject, 1, pmInput, 0, sdLeft, 'label');
      SetCondPortCount(VisualObject, 0, pmOutput, 0, sdRight, 'data_out');
    end;
    dtRun: begin
      SetCondPortCount(VisualObject, 0, pmInput, 0, sdLeft, 'label');
      SetCondPortCount(VisualObject, 1, pmOutput, 0, sdRight, 'data_out');
    end;
  end;
end;

function TWorkModeBlock.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
begin
  Result:=0;
  case Action of
    i_GetCount: begin
      case m_workType of
        dtTraining: begin
          cY[0] := 1;
        end;
        dtTesting: begin
          cY[0] := m_resultQty;
        end;
        dtRun: begin
          cY[0] := m_resultQty;
          cY[1] := m_maxQty;
        end;
      end;
    end;
  else
    Result:=inherited InfoFunc(Action,aParameter);
  end
end;

function   TWorkModeBlock.RunFunc;
var
  returnFlag: Boolean; // ��������� ������
  p64: UInt64;
  data: PDataArr; /// ������, ������� �������� ����� ���� ������
  crossOut: Integer; /// ���������� �������� ��������

begin
  Result:=0;
  case Action of
    f_UpdateOuts: begin

    end;
    f_InitState: begin
      stepCount := 0;
    end;

    f_GoodStep: begin
      m_id := Round(U[0].Arr^[0]);
      p64 := Round(U[0].Arr^[1]);
      p64 := p64 shl 32;
      p64 := p64 OR UInt64(Round(U[0].Arr^[2]));
      data := PDataArr(p64);
      crossOut := Round(U[0].Arr^[3]);
      if crossOut <= 0 then begin // ��������� ���������� �������� ��������� ����
        ErrorEvent(txtNN_CrossOutFail, msError, VisualObject);
        Result := r_Fail;
        Exit;
      end;
      case m_workType of
        dtTraining: begin
        returnFlag := training(crossOut, data);
      end;
      dtTesting: begin
        returnFlag := testing(crossOut, data);
      end;
      dtRun: begin
        returnFlag := guessing(crossOut, data);
      end;
      end;
      if returnFlag <> True then begin // �������� �� ���������� ���������� ����
        Result := r_Fail;
        Exit;
      end;
      inc(stepCount);
    end;
    f_Stop : begin
      SetLength(m_label, 0);
      SetLength(m_flabel, 0);
      SetLength(m_labelPoint, 0);
      SetLength(m_reciveLabels, 0);
    end;
  end;
end;

function TWorkModeBlock.training(crossOut: Integer; data: PDataArr): Boolean;
var
  I : Integer;
  datas, labels : TLayerSize;  /// ������� �������� ������ � �����
  accuracy : Single;
  returnCode : TStatus; /// ������ ������ �� ������� �������
begin
  Result := True;
  // [0] - ������, [1] - �����
  if cU.FCount <> 2 then begin
    ErrorEvent(txtNN_DataSize, msError, VisualObject);
    Result := False;
    Exit;
  end;
  SetLength(m_label, U[1].Count);
  SetLength(m_flabel, U[1].Count);
  for I := 0 to Length(m_label) - 1 do begin
    if crossOut = 1 then begin
      m_flabel[I] := U[1].Arr^[I];
    end else begin
      m_label[I] := Round(U[1].Arr^[I]);
    end;
  end;
  datas.w := Round(U[0].Arr^[4]);
  datas.h := Round(U[0].Arr^[5]);
  datas.ch := Round(U[0].Arr^[6]);
  datas.bsz := Length(m_label);
  labels.w := crossOut;
  labels.h := 1;
  labels.ch := 1;
  labels.bsz := Length(m_label);
  if crossOut = 1 then begin
    returnCode := fitOneValue(m_id, @data^[0], datas, @m_flabel[0], labels, 1, m_learningRate, accuracy);
    accuracy := 1.0 - accuracy;
  end else begin
    returnCode := fit(m_id, @data^[0], datas, @m_label[0], labels, 1, m_learningRate, accuracy);
  end;
  if returnCode <> STATUS_OK then begin
    ErrorEvent(txtNN_TrainCrash, msError, VisualObject);
    Result := False;
    Exit;
  end;
  Y[0].Arr^[0] := accuracy;
end;

function TWorkModeBlock.testing(crossOut: Integer; data: PDataArr): Boolean;
var
  I : Integer;
  datas, labels : TLayerSize;  /// ������� �������� ������ � �����
  returnCode : TStatus; /// ������ ������ �� ������� �������
  accuracy, calcLabel : Single;
begin
  Result := True;
  // [0] - ������, [1] - �����
  if cU.FCount <> 2 then begin
    ErrorEvent(txtNN_DataSize, msError, VisualObject);
    Result := False;
    Exit;
  end;
  SetLength(m_label, U[1].Count);
  SetLength(m_reciveLabels, U[1].Count);
  for I := 0 to Length(m_label) - 1 do begin
    m_label[I] := Round(U[1].Arr^[I]);
    m_reciveLabels[I] := U[1].Arr^[I];
  end;
  datas.w := Round(U[0].Arr^[4]);
  datas.h := Round(U[0].Arr^[5]);
  datas.ch := Round(U[0].Arr^[6]);
  datas.bsz := Length(m_label);
  labels.w := crossOut;
  labels.h := 1;
  labels.ch := 1;
  labels.bsz := Length(m_label);
  if crossOut > 1 then begin // ��� ��������� � ������� �� N ���������
    returnCode := evaluate(m_id, @data^[0], datas, @m_label[0], labels, 2, accuracy);
    if returnCode <> STATUS_OK then begin
      ErrorEvent(txtNN_TestCrash, msError, VisualObject);
      Result := False;
      Exit;
    end;
    Y[0].Arr^[0] := accuracy;
  end else begin // ��� ���������� � ��������� ��������
    SetLength(m_labelPoint, datas.bsz);
    returnCode := keras.forecasting(m_id, @data^[0], datas, @m_labelPoint[0], labels);
    if returnCode <> STATUS_OK then begin
      ErrorEvent(txtNN_TestCrash, msError, VisualObject);
      Result := False;
      Exit;
    end;
    calcLabel := 0;
    for I := 0 to datas.bsz - 1 do begin
      calcLabel := calcLabel + abs( m_reciveLabels[i] - m_labelPoint[i]);
    end;
    Y[0].Arr^[0] := calcLabel / datas.bsz;
  end;
end;

function TWorkModeBlock.guessing(crossOut: Integer; data: PDataArr): Boolean;
var
  I : Integer;
  datas, labels : TLayerSize;  /// ������� �������� ������ � �����
  returnCode : TStatus; /// ������ ������ �� ������� �������
  accuracy, calcLabel : Single;
begin
  Result := True;
  // [0] - ������
  if cU.FCount <> 1 then begin
    ErrorEvent(txtNN_DataSize, msError, VisualObject);
    Result := False;
    Exit;
  end;

  datas.w := Round(U[0].Arr^[4]);
  datas.h := Round(U[0].Arr^[5]);
  datas.ch := Round(U[0].Arr^[6]);
  I := Round(Length(data^) / (datas.w * datas.h * datas.ch));
  SetLength(m_label, I);
  datas.bsz := Length(m_label);
  labels.w := crossOut;
  labels.h := 1;
  labels.ch := 1;
  labels.bsz := Length(m_label);

  if crossOut > 1 then begin // ��� ��������� � ������� �� N ���������
    returnCode := evaluate(m_id, @data^[0], datas, Nil, labels, 2, accuracy, @m_label[0]);
    if returnCode <> STATUS_OK then begin
      ErrorEvent(txtNN_TestCrash, msError, VisualObject);
      Result := False;
      Exit;
    end;
    for I := 0 to m_resultQty - 1 do begin
      if I >= datas.bsz then
        Break;
      Y[0].Arr^[i] := m_label[i];
    end;
  end else begin
    SetLength(m_labelPoint, datas.bsz);
    returnCode := keras.forecasting(m_id, @data^[0], datas, @m_labelPoint[0], labels);
    if returnCode <> STATUS_OK then begin
      ErrorEvent(txtNN_TestCrash, msError, VisualObject);
      Result := False;
      Exit;
    end;
    for I := 0 to m_resultQty - 1 do begin
      if I >= datas.bsz then
        Break;
      Y[0].Arr^[i] := m_labelPoint[i];
    end;
  end;
  if Length(data^) <= m_maxQty then begin
    for I := 0 to Length(data^) - 1 do begin
      Y[1].Arr^[I] := data^[I];
    end;
  end else begin
    ErrorEvent(txtNN_DataSize, msError, VisualObject);
    Result := False;
    Exit;
  end;
end;

end.
