unit USummatorLayer;

interface
uses Windows, Classes, DataTypes, SysUtils, RunObjts, UAbstractLayer;

type

  TSummatorLayer = class(TAbstractLayer)
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

  const
    PortType = 0; // ��� ����������� ������ (��� �������������� �����)
  end;

implementation
uses keras;

constructor  TSummatorLayer.Create;
begin
  inherited;
  shortName := 'SUM' + IntToStr(getLayerNumber);
  isCreate := False;
end;

destructor   TSummatorLayer.Destroy;
begin
  inherited;

end;

function    TSummatorLayer.GetParamID;
begin
  Result:=inherited GetParamId(ParamName,DataType,IsConst);
  if Result = -1 then begin
    if StrEqu(ParamName,'output_qty') then begin
      Result:=NativeInt(@m_outputQty);
      DataType:=dtInteger;
      Exit;
    end;
  end;
end;

procedure TSummatorLayer.addLayerToModel();
var
  returnCode: TStatus;
begin

  if returnCode <> STATUS_OK then begin
    ErrorEvent('Neural model not added activation layer', msError, VisualObject);
    Exit;
  end;
end;

//----- �������������� ������� ����� -----
procedure TSummatorLayer.EditFunc;
var
  InputPortsNmb, OutputPortsNmb: integer;
  MsgLength: Integer;
begin
  SetCondPortCount(VisualObject, m_outputQty - 1, pmOutput, PortType, sdRight, 'outport_1');
end;

function TSummatorLayer.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
begin
  Result:=0;
  case Action of
    i_GetCount: begin

    end;
  else
    Result:=inherited InfoFunc(Action, aParameter);
  end
end;

function   TSummatorLayer.RunFunc;
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
