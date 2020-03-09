unit UPoolingLayer;

interface
uses Windows, Classes, DataTypes, SysUtils, RunObjts, UAbstractLayer;

type

  TPoolingLayer = class(TAbstractLayer)
  public
    // ����������� ������
    constructor  Create(Owner: TObject); override;
    // ����������
    destructor   Destroy; override;
    function       InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;override;
    function       RunFunc(var at,h : RealType;Action:Integer):NativeInt;override;
    function       GetParamID(const ParamName:string;var DataType:TDataType;var IsConst: boolean):NativeInt;override;
    // ��������� ������ ���� � ������
    procedure addLayerToModel(); override;
    // ������� ��� ����������� ��������� ���������� ���������� �����
    procedure EditFunc(Props:TList;
                       SetPortCount:TSetPortCount;
                       SetCondPortCount:TSetCondPortCount;
                       ExecutePropScript:TExecutePropScript);override;

  private
    isCreate: Boolean;
    m_outputQty: NativeInt;// ���������� ������ � ������� ������
    m_kernel : NativeInt; // ������ ���������� �����
    m_stride: NativeInt; // ��� �����
    m_poolType: NativeInt; // ��� �����������

  const
    PortType = 0; // ��� ����������� ������ (��� �������������� �����)
  end;

implementation
uses keras;

constructor  TPoolingLayer.Create;
begin
  inherited;
  shortName := 'P' + IntToStr(getLayerNumber);
  isCreate := False;
end;

destructor   TPoolingLayer.Destroy;
begin
  inherited;

end;

function    TPoolingLayer.GetParamID;
begin
  Result:=inherited GetParamId(ParamName,DataType,IsConst);
  if Result = -1 then begin
    if StrEqu(ParamName,'output_qty') then begin
      Result:=NativeInt(@m_outputQty);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'kernel') then begin
      Result:=NativeInt(@m_kernel);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'stride') then begin
      Result:=NativeInt(@m_stride);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'pool_type') then begin
      Result:=NativeInt(@m_poolType);
      DataType:=dtInteger;
      Exit;
    end;
  end;
end;

procedure TPoolingLayer.addLayerToModel();
var
  returnCode: TStatus;
begin
  returnCode := addPooling(PAnsiChar(shortName),
                           PAnsiChar(nodes),
                           m_kernel,
                           m_stride,
                           m_poolType
                           );
  if returnCode <> STATUS_OK then begin
    ErrorEvent('Neural model not added activation layer', msError, VisualObject);
    Exit;
  end;
end;

//----- �������������� ������� ����� -----
procedure TPoolingLayer.EditFunc;
var
  InputPortsNmb, OutputPortsNmb: integer;
  MsgLength: Integer;
begin
  SetCondPortCount(VisualObject, m_outputQty - 1, pmOutput, PortType, sdRight, 'outport_1');
end;

function TPoolingLayer.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
begin
  Result:=0;
  case Action of
    i_GetCount: begin

    end;
  else
    Result:=inherited InfoFunc(Action, aParameter);
  end
end;

function   TPoolingLayer.RunFunc;
var
  rootLayer: TAbstractLayer; // ������������ ����
  rootIndex: NativeInt;      // ������ ������������� ����
begin
  Result:=0;
  case Action of
    f_UpdateOuts: begin

    end;
    f_InitState: begin
      nodes := '';
      isCreate := False;
    end;
    f_GoodStep: begin
      if isCreate = False then begin
        if U[0].FCount > 0 then begin
          rootIndex := Round(U[0].Arr^[0]);
          if ((rootIndex >= 0) AND (rootIndex < LayersDict.Count)) then begin
            rootLayer := TAbstractLayer(LayersDict[rootIndex]);
            rootLayer.appendNode(shortName);
            Y[0].Arr^[0] := getLayerNumber;
            isCreate := True;
          end;
        end;
      end;
    end;
  end
end;
end.
