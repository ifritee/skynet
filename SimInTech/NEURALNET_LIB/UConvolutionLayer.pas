unit UConvolutionLayer;

interface
uses Windows, Classes, DataTypes, SysUtils, RunObjts, UAbstractLayer;

type

  TConvolutionLayer = class(TAbstractLayer)
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
    m_activate: NativeInt; // ����� ���������
    m_opimized: NativeInt; // ������� �����������
    m_filters: NativeInt; // ���������� ��������
    m_dropout:  double;  // �����
    m_batchnorm: NativeInt; // ������������ �������
    m_width : NativeInt;  // ����� �������
    m_height: NativeInt;  // ������ �������
    m_padding: NativeInt;  //
    m_stride: NativeInt;  //
    m_dilate: NativeInt;  //

  const
    PortType = 0; // ��� ����������� ������ (��� �������������� �����)
  end;

implementation
uses keras;

constructor  TConvolutionLayer.Create;
begin
  inherited;
  shortName := 'CN' + IntToStr(getLayerNumber);
  isCreate := False;
end;

destructor   TConvolutionLayer.Destroy;
begin
  inherited;

end;

function    TConvolutionLayer.GetParamID;
begin
  Result:=inherited GetParamId(ParamName,DataType,IsConst);
  if Result = -1 then begin
    if StrEqu(ParamName,'output_qty') then begin
      Result:=NativeInt(@m_outputQty);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'active') then begin
      Result:=NativeInt(@m_activate);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'optim') then begin
      Result:=NativeInt(@m_opimized);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'filters') then begin
      Result:=NativeInt(@m_filters);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'dropout') then begin
      Result:=NativeInt(@m_dropout);
      DataType:=dtDouble;
      Exit;
    end else if StrEqu(ParamName,'batchnorm') then begin
      Result:=NativeInt(@m_dropout);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'width') then begin
      Result:=NativeInt(@m_width);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'height') then begin
      Result:=NativeInt(@m_height);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'padding') then begin
      Result:=NativeInt(@m_padding);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'stride') then begin
      Result:=NativeInt(@m_stride);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'dilate') then begin
      Result:=NativeInt(@m_dilate);
      DataType:=dtInteger;
      Exit;
    end;
  end;
end;

procedure TConvolutionLayer.addLayerToModel();
var
  returnCode: TStatus;
begin
  returnCode := addConvolution(PAnsiChar(shortName),
                         PAnsiChar(nodes),
                         m_activate,
                         m_opimized,
                         m_filters,
                         m_dropout,
                         m_batchnorm,
                         m_width,
                         m_height,
                         m_padding,
                         m_stride,
                         m_dilate);
  if returnCode <> STATUS_OK then begin
    ErrorEvent('Neural model not added activation layer', msError, VisualObject);
    Exit;
  end;
end;

//----- �������������� ������� ����� -----
procedure TConvolutionLayer.EditFunc;
var
  InputPortsNmb, OutputPortsNmb: integer;
  MsgLength: Integer;
begin
  SetCondPortCount(VisualObject, m_outputQty - 1, pmOutput, PortType, sdRight, 'outport_1');
end;

function TConvolutionLayer.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
begin
  Result:=0;
  case Action of
    i_GetCount: begin

    end;
  else
    Result:=inherited InfoFunc(Action, aParameter);
  end
end;

function   TConvolutionLayer.RunFunc;
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
