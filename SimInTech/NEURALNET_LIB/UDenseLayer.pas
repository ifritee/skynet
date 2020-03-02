unit UDenseLayer;

interface

uses Windows, Classes, DataTypes, SysUtils, RunObjts, UAbstractLayer;

type

  TDenseLayer = class(TAbstractLayer)
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
    m_units: NativeInt; // ���������� ��������
    m_activate: NativeInt; // ����� ���������
    m_opimized: NativeInt; // ������� �����������
    m_dropout:  double;  // �����
    m_batchnorm: NativeInt; // ������������ �������
    m_outputQty: NativeInt;// ���������� ������ � ������� ������
    
  const
    PortType = 0; // ��� ����������� ������ (��� �������������� �����)  
  end;

implementation

uses keras;

constructor  TDenseLayer.Create;
begin
  inherited;
  shortName := 'DN' + IntToStr(getLayerNumber);
  isCreate := False;
end;

destructor   TDenseLayer.Destroy;
begin
  inherited;
  
end;

function    TDenseLayer.GetParamID;
begin
  Result:=inherited GetParamId(ParamName,DataType,IsConst);
  if Result = -1 then begin
    if StrEqu(ParamName,'output_qty') then begin
      Result:=NativeInt(@m_outputQty);
      DataType:=dtInteger;
      Exit;
    end else if StrEqu(ParamName,'units') then begin
      Result:=NativeInt(@m_units);
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
    end else if StrEqu(ParamName,'dropout') then begin
      Result:=NativeInt(@m_dropout);
      DataType:=dtDouble;    
      Exit;
    end else if StrEqu(ParamName,'batchnorm') then begin
      Result:=NativeInt(@m_dropout);
      DataType:=dtInteger;    
      Exit;
    end;

  end;
end;

procedure TDenseLayer.addLayerToModel();
var
  returnCode: TStatus;
begin
  returnCode := addDense(PAnsiChar(shortName),
                         PAnsiChar(nodes),
                         m_units, 
                         m_activate, 
                         m_opimized,
                         m_dropout, 
                         m_batchnorm);
  if returnCode <> STATUS_OK then begin
    ErrorEvent('Neural model not added dense layer', msError, VisualObject);
    Exit;
  end;
end;

//----- �������������� ������� ����� -----
procedure TDenseLayer.EditFunc;
var
  InputPortsNmb, OutputPortsNmb: integer;
  MsgLength: Integer;
begin
  SetCondPortCount(VisualObject, m_outputQty - 1, pmOutput, PortType, sdRight, 'outport_1');
end;

function TDenseLayer.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
begin
  Result:=0;
  case Action of
    i_GetCount: begin
      
    end;
  else
    Result:=inherited InfoFunc(Action,aParameter);
  end
end;

function   TDenseLayer.RunFunc;
var
  rootLayer: TAbstractLayer; // ������������ ����
  rootIndex: NativeInt;      // ������ ������������� ����
begin
  Result:=0;
  case Action of
    f_UpdateOuts: begin

    end;
    f_InitState: begin
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
