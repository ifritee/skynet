
 //**************************************************************************//
 // Данный исходный код является составной частью системы МВТУ-4             //
 // Программист:        Тимофеев К.А.                                        //
 //**************************************************************************//


unit Blocks;

 //***************************************************************************//
 //                Блоки для моделирования гидроавтоматики                    //
 //***************************************************************************//

interface

uses Windows, Classes, DataTypes, SysUtils, RunObjts, uExtMath;


type

//  //Модель насоса объёмного
//  TNS = class(TRunObject)
//  public
//    gm :           realtype;
//    wn :           realtype;
//    Ly :           realtype;
//    Lp :           realtype;
//    tip:           NativeInt;
//    function       InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;override;
//    function       RunFunc(var at,h : RealType;Action:Integer):NativeInt;override;
//    function       GetParamID(const ParamName:string;var DataType:TDataType;var IsConst: boolean):NativeInt;override;
//  end;
//
//  //Модель насоса с компрессионными потерями
//  TNS_c = class(TRunObject)
//  public
//    gm :           realtype;
//    wn :           realtype;
//    Ly :           realtype;
//    Lp :           realtype;
//    tip:           NativeInt;
//    Eg :           realtype;
//    kv :           realtype;
//    function       InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;override;
//    function       RunFunc(var at,h : RealType;Action:Integer):NativeInt;override;
//    function       GetParamID(const ParamName:string;var DataType:TDataType;var IsConst: boolean):NativeInt;override;
//  end;
//
//  //Полость
//  TPOL = class(TRunObject)
//  public
//    pmax :         realtype;
//    pmin :         realtype;
//    Eg :           realtype;
//    Wp :           realtype;
//    nu :           realtype;
//    function       InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;override;
//    function       RunFunc(var at,h : RealType;Action:Integer):NativeInt;override;
//    function       GetParamID(const ParamName:string;var DataType:TDataType;var IsConst: boolean):NativeInt;override;
//  end;
//
//  //Насос с подпиткой
//  TNS_p = class(TRunObject)
//  public
//    gmax:          realtype;
//    wn:            realtype;
//    Ly :           realtype;
//    Lp :           realtype;
//    tip :          NativeInt;
//    Eg :           realtype;
//    Wp1 :          realtype;
//    Wp2 :          realtype;
//    pmax :         realtype;
//    pmin :         realtype;
//    nu1 :          realtype;
//    nu2 :          realtype;
//    function       InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;override;
//    function       RunFunc(var at,h : RealType;Action:Integer):NativeInt;override;
//    function       GetParamID(const ParamName:string;var DataType:TDataType;var IsConst: boolean):NativeInt;override;
//  end;
//
//  //Приводной двигатель
//  TPD = class(TRunObject)
//  public
//    tau :          realtype;
//    teta :         realtype;
//    J :            realtype;
//    f :            realtype;
//    Mt :           realtype;
//    Mdmax :        realtype;
//    nu1 :          realtype;
//    nu2 :          realtype;
//    function       InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;override;
//    function       RunFunc(var at,h : RealType;Action:Integer):NativeInt;override;
//    function       GetParamID(const ParamName:string;var DataType:TDataType;var IsConst: boolean):NativeInt;override;
//  end;
//
//  //Гидроусилитель
//  TGU = class(TRunObject)
//  public
//    ymax :         realtype;
//    Vmax :         realtype;
//    Xmax :         realtype;
//    k :            realtype;
//    T :            realtype;
//    dzt :          realtype;
//    nu1 :          realtype;
//    nu2 :          realtype;
//    function       InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;override;
//    function       RunFunc(var at,h : RealType;Action:Integer):NativeInt;override;
//    function       GetParamID(const ParamName:string;var DataType:TDataType;var IsConst: boolean):NativeInt;override;
//  end;
//
//  //Вал и ротор приводного двигателя
//  TOR_tr = class(TRunObject)
//  public
//    J:             realtype;
//    f:             realtype;
//    c:             realtype;
//    Mt:            realtype;
//    nu1:           realtype;
//    nu2:           realtype;
//    function       InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;override;
//    function       RunFunc(var at,h : RealType;Action:Integer):NativeInt;override;
//    function       GetParamID(const ParamName:string;var DataType:TDataType;var IsConst: boolean):NativeInt;override;
//  end;

  //Гидродвигатель с постоянным рабочим объёмом
  TGD_c = class(TRunObject)
  public
    wd :           realtype;
    Ly :           realtype;
    Lp :           realtype;
    Eg :           realtype;
    kv :           realtype;
    function       InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;override;
    function       RunFunc(var at,h : RealType;Action:Integer):NativeInt;override;
    function       GetParamID(const ParamName:string;var DataType:TDataType;var IsConst: boolean):NativeInt;override;
  end;

  //Четырёхщелевой цилиндрический золотник
  TDR = class(TRunObject)
  public
    pc :           realtype;
    y0 :           realtype;
    my :           realtype;
    ro :           realtype;
    d :            realtype;
    dtd :          realtype;
    kisp :         realtype;
    function       InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;override;
    function       RunFunc(var at,h : RealType;Action:Integer):NativeInt;override;
    function       GetParamID(const ParamName:string;var DataType:TDataType;var IsConst: boolean):NativeInt;override;
  end;

  //Идеальный золотник
  TDR_idd = class(TRunObject)
  public
    ps :           realtype;
    yn0 :          realtype;
    ys0 :          realtype;
    my :           realtype;
    ro :           realtype;
    d :            realtype;
    kisp :         realtype;
    function       InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;override;
    function       RunFunc(var at,h : RealType;Action:Integer):NativeInt;override;
    function       GetParamID(const ParamName:string;var DataType:TDataType;var IsConst: boolean):NativeInt;override;
  end;

  //Насос с регулятором подачи
  TREG_n = class(TRunObject)
  public
    gnmax :        realtype;
    gnmin :        realtype;
    Vgnmax :       realtype;
    kreg :         realtype;
    kn :           realtype;
    kdin :         realtype;
    nu :           realtype;
    function       InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;override;
    function       RunFunc(var at,h : RealType;Action:Integer):NativeInt;override;
    function       GetParamID(const ParamName:string;var DataType:TDataType;var IsConst: boolean):NativeInt;override;
  end;

  //Гидравлический редуктор
  TRED = class(TRunObject)
  public
    ir :           realtype;
    lft :          realtype;
    fy :           realtype;
    cy :           realtype;
    M0 :           realtype;
    nu :           realtype;
    function       InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;override;
    function       RunFunc(var at,h : RealType;Action:Integer):NativeInt;override;
    function       GetParamID(const ParamName:string;var DataType:TDataType;var IsConst: boolean):NativeInt;override;
  end;

  //Объект общего вида
  TOR_tv = class(TRunObject)
  public
    J :            realtype;
    f :            realtype;
    c :            realtype;
    Mtost :        realtype;
    Mtdwg :        realtype;
    Om0 :          realtype;
    nu1 :          realtype;
    nu2 :          realtype;
    function       InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;override;
    function       RunFunc(var at,h : RealType;Action:Integer):NativeInt;override;
    function       GetParamID(const ParamName:string;var DataType:TDataType;var IsConst: boolean):NativeInt;override;
  end;

  //Инерционный предохранительный клапан
  TKLpr = class(TRunObject)
  public
    pn :           realtype;
    pk :           realtype;
    pm :           realtype;
    Qk :           realtype;
    Qm :           realtype;
    Tkl :          realtype;
    function       InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;override;
    function       RunFunc(var at,h : RealType;Action:Integer):NativeInt;override;
    function       GetParamID(const ParamName:string;var DataType:TDataType;var IsConst: boolean):NativeInt;override;
  end;

  //Инерционный подпиточный клапан
  TKLpp = class(TRunObject)
  public
    pn :           realtype;
    pk :           realtype;
    Qk :           realtype;
    Qm :           realtype;
    Tkl :          realtype;
    function       InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;override;
    function       RunFunc(var at,h : RealType;Action:Integer):NativeInt;override;
    function       GetParamID(const ParamName:string;var DataType:TDataType;var IsConst: boolean):NativeInt;override;
  end;



implementation

uses math;

  //Исходные функции для моделирования гидроавтоматики
  //Код предоставлен:  проф. д.т.н. Казмиренко
procedure NS(var Qn1,Qn2,Mn : realtype; const OMn,p1,p2,g, gm,wn,Ly,Lp : realtype; tip : integer);
var e, dp, tmpsin, tmpcos : realtype;
begin
 case tip of
   1 : begin
          MySinCos(g,tmpsin, tmpcos);
          e:= tmpsin/(tmpcos*gm);
       end;
   2 : e:= g/gm;
 else
     e:= sin(g)/sin(gm);
 end;
 dp:=p1-p2;
 Qn1:=e*OMn*wn-Ly*p1-Lp*dp;
 Qn2:=-e*OMn*wn-Ly*p2+Lp*dp;
 Mn:=dp*e*wn;
end;

procedure NS_c(var Qn1,Qn2,Mn : realtype; const OMn,p1,p2,g, gm,wn,Ly,Lp,Eg,kv : realtype; tip : integer);
var dp,e,QL1,Qp1,Qk1,QL2,Qp2,Qk2,tmpsin,tmpcos : realtype;
begin
 case tip of
  1 : begin
        MySinCos(g,tmpsin,tmpcos);
        e:= tmpsin/(tmpcos*gm);
      end;
  2 : e:= g/gm;
  else
    e:= sin (g)/sin(gm);
  end;
 dp:=p1-p2;
 Qk1:=-0.5*OMn*wn*dp*(kv+e)/Eg;
 Qk2:=0.5*OMn*wn*dp*(kv-e)/Eg;
 QL1:=-Ly*p1;
 QL2:=-Ly*p2;
 Qp1:=-Lp*dp;
 Qp2:=Lp*dp;
 Qn1:=e*OMn*wn+QL1+Qp1+Qk1;
 Qn2:=-e*OMn*wn+QL2+Qp2+Qk2;
 Mn:=dp*e*wn;
end;

procedure POL(var pW,W,p : realtype; const Qs, Eg, Wp, pmax,pmin : realtype);
var Wmax,Wmin : realtype;
label m1,m2,m3,m4;
begin
 pW:=Qs;
 Wmax:=pmax*WP/Eg;
 Wmin:=pmin*WP/Eg;
 if W>Wmax then goto m2 else goto m1;
 m1: if W>Wmin then goto m4 else goto m3;
 m2: if pW>0 then
      begin
       W:=Wmax;
       pW:=0;
      end
     else W:=Wmax;
     goto m4;
 m3: if pW>0 then W:=Wmin else
      begin
       W:=Wmin;
       pW:=0;
      end;
 m4: p:=W*Eg/WP;
end;

procedure NS_p(var pW1,pW2,W1,W2,p1,p2,Mn,dtp:realtype; const g,Qd1,Qd2,Ly,Lp,Eg,Wp1,Wp2,pmax,pmin,Omn,gmax,wn:realtype; tip: integer);
var Qn1,Qn2,Qs1,Qs2: realtype;
begin
 NS(Qn1,Qn2,Mn,OMn,p1,p2,g, gmax,wn, Ly, Lp,tip);
 Qs1:=Qn1-Qd1;
 Qs2:=Qn2+Qd2;
 POL(pW1,W1,p1,Qs1,Eg,Wp1, pmax,pmin);
 POL(pW2,W2,p2,Qs2,Eg,Wp2, pmax,pmin);
 dtp:=p1-p2;
end;

procedure PD(var pMd,pOm,Md,Om:realtype;const Om0,tau,teta,J,f,Mt,Mb,Mdmax:realtype);
begin
 if Md>Mdmax then Md:=Mdmax;
 if Md<-Mdmax then Md:=-Mdmax;
 pMd:=(Om0-Om-tau*Md)/teta;
 pOm:=(Md-Mt-Mb-f*OM)/J;
end;

procedure GU (var pV,pX,V,X,y: realtype;const ymax,Vmax,Xmax,k,T,dzt:realtype);
label m1,m4,m5,m6;
begin
 if y> ymax then y:=ymax;
 if y<-ymax then y:=-ymax;
 if V> Vmax then V:=Vmax;
 if V<-Vmax then V:=-Vmax;
 if X> Xmax then goto m1 else goto m4;

 m1: if V>0 then
      begin
       X:=Xmax;
       V:=0;
      end else X:=Xmax;
      goto m6;
 m4: if X<-Xmax then goto m5 else goto m6;
 m5: if V>0 then X:=-Xmax else
      begin
       X:=-Xmax;
       V:=0;
      end;
 m6: pV:=(k*y-2*dzt*T*V-X)/(T*T);
     pX:=V;
end;

procedure OR_tr(var pV,pa,V,a,Vp,MtV: realtype;const  md,mb,J,f,c,Mt: realtype);
label m0,m1,m2,m3,m4,m5;
var signV,signVp,signma:integer;VV,ma:realtype;
begin
 if V>0  then signV:=1  else signV:=-1;
 if V=0  then signV:=0;
 if Vp>0 then signVp:=1 else signVp:=-1;
 if Vp=0 then signVp:=0;
 if signV=-signVp then VV:=0 else VV:=V;

 ma:=md-mb-f*VV-c*a;
 if ma>0 then signma:=1 else signma:=-1;
 if ma=0 then signma:=0;

 while  abs(ma)>Mt  do goto m2;
 while  abs(ma)<Mt  do goto m3;
 while  abs(ma)=Mt  do goto m3;

 m2: if VV=0 then  goto m5 else goto m0;
 m3: if VV=0 then  goto m4 else goto m0;
 m4: MtV:=ma ;
     goto m1;
 m5: MtV:=Mt*signma;
     goto m1;
 m0: MtV:=Mt*signV;
 m1: pV:=(ma-MtV)/J;
     pa:=V;
     Vp:=VV;
end;

procedure GD_c(var Q1,Q2,md:realtype;const OMd,p1,p2,wd,Ly,Lp,Eg,kv:realtype);
var dp,QL1,Qp1,Qk1,QL2,Qp2,Qk2 :realtype;
begin
 dp:=p1-p2;
 if OMd>0 then Qk1:=-0.5*OMd*wd*dp*(kv-1)/Eg else Qk1:= 0.5*OMd*wd*dp*(kv+1)/Eg;
 if OMd=0 then Qk1:= 0;
 if OMd>0 then Qk2:= 0.5*OMd*wd*dp*(kv-1)/Eg else Qk2:= 0.5*OMd*wd*dp*(kv+1)/Eg;
 if OMd=0 then Qk2:= 0;
 QL1:=-Ly*p1;
 Qp1:=-Lp*dp;
 QL2:=-Ly*p2;
 Qp2:=Lp*dp;
 Q1:=-OMd*wd+QL1+Qp1+Qk1;
 Q2:=OMd*wd+QL2+Qp2+Qk2;
 md:=dp*wd;
end;

procedure DR (var QD1,QD2,QS: realtype;const pp,pc,p1,p2,y,y0,my,ro,d,dtd,kisp: realtype);
var fy0,fy00,fy1,fy2,fy3,fy4,q1,q2,q3,q4, kro: realtype;
begin
 fy0:= pi*d*sqrt((y+y0)*(y+y0)+dtd*dtd);
 fy00:= pi*d*dtd;
 if y+y0>0 then fy1:=fy0 else fy1:=fy00;
 fy4:=fy1;
 fy0:= pi*d*sqrt((y-y0)*(y-y0)+dtd*dtd);
 if y-y0>0 then fy2:=fy00 else fy2:=fy0;
 fy3:=fy2;
 kro:=my*sqrt(2/ro)*kisp;
 q1:=fy1*kro*sqrt(abs(pp-p1));
 if pp-p1<0 then  q1:=-q1;
 q2:=fy2*kro*sqrt(abs(pp-p2));
 if pp-p2<0 then  q2:=-q2;
 q3:=fy3*kro*sqrt(abs(p1-pc));
 if p1-pc<0 then  q3:=-q3;
 q4:=fy4*kro*sqrt(abs(p2-pc));
 if p2-pc<0 then  q4:=-q4;
 QD1:= q1-q3;
 QD2:=q2-q4;
 QS:=q1+q2;
end;

procedure DR_id (var Qd1,Qd2,Qs:realtype;const pp,ps,p1,p2,y,yn0,ys0,my,ro,d,kisp: realtype);
var q1,q2,q3,q4,f1,f2,f3,f4,fn,fn0,fs,fs0,kro: realtype;
begin
 fn:= pi*d*(yn0+abs(y));
 fn0:=pi*d*yn0;
 fs:= pi*d*(ys0+abs(y));
 fs0:=pi*d*ys0;
 if y>0 then
  begin
   f1:=fn;
   f2:=fn0;
   f3:=fs0;
   f4:=fs;
  end
 else
 if y<0 then
  begin
   f1:=fn0;
   f2:=fn;
   f3:=fs;
   f4:=fs0;
  end
 else
  begin
   f1:=fn0;
   f2:=fn0;
   f3:=fn0;
   f4:=fn0;
  end;
 kro:=my*sqrt(2/ro)*kisp;
 q1:=f1*kro*sqrt(abs(pp-p1));
 q2:=f2*kro*sqrt(abs(pp-p2));
 q3:=f3*kro*sqrt(abs(p1-ps));
 q4:=f4*kro*sqrt(abs(p2-ps));
 Qd1:=q1-q3;
 Qd2:=q2-q4;
 Qs:=q1+q2;
end;

procedure REG_n (var pgn,gn,Qn: realtype;const pn,ppit0,gnmax,gnmin,Vgnmax,kn,kreg,kdin:realtype);
var sign :integer; Qdin, dtp:realtype;
begin
 dtp:=(ppit0-pn);
 pgn:=dtp*kreg;
 if pgn >0 then sign:=1 else sign:=-1;
 if abs(pgn)>Vgnmax then pgn:=Vgnmax*sign;
 if gn>gnmax then
  begin
   gn:=gnmax;
   pgn:=0;
  end;
 if gn<gnmin then
  begin
   gn:=gnmin;
   pgn:=0;
  end;
 Qdin:=-kdin*pgn;
 Qn:=kn*gn+Qdin;
end;

procedure RED(var palf,My,Mr: realtype;const Omd,Om,alf,ir,lft,fy,cy,M0:realtype);
var Mf,Mc,M00: realtype;
begin
 palf:=(OMd/ir)-OM;
 if palf>0 then M00:=M0 else
 if palf<0 then M00:=-M0 else M00:=0;
 if abs (alf)>lft then Mf:= palf*fy else Mf:=0;
 if alf> lft then Mc:= (alf-lft)*cy else
 if alf<-lft then Mc:= (alf+lft)*cy else Mc:= 0;
 My:=Mf+Mc+M00;
 Mr:=My/ir;
end;

procedure OR_tv(var pOm,palf,Om,Omp,alf,MtOm: realtype;const Md,Mb,J,f,c,Mtost,Mtdwg,Om0: realtype);
label m0,m1,m2,m3,m4,m5;
var signOm,signOmp,signMa:integer;absMtOm,Ma:real;
begin
  if Om >0 then signOm :=1 else signOm :=-1;
  if Om =0 then signOm :=0;
  if Omp>0 then signOmp:=1 else signOmp:=-1;
  if Omp=0 then signOmp:=0;
  if signOm*signOmp<0  then Om:=0;
  Ma:=Md-Mb-f*Om-c*alf;
  if Ma >0 then signMa :=1 else signMa :=-1;
  if Ma =0 then signMa :=0;
  m2: if Om=0 then goto m3 else goto m0;
  m3: if abs(Ma)<Mtost then goto m4 else goto m5;
  m4: MtOm:=Ma;
      goto m1;
  m5: MtOm:=Mtost*signMa;
      goto m1;
  m0: if abs (Om) < Om0 then absMtOm:=Mtost-((Mtost-Mtdwg)/Om0)*abs(Om) else absMtOm:=Mtdwg;
      MtOm:=absMtOm*signOm;
  m1: pOm:=(Ma-MtOm)/J;
      palf:=Om; Omp:=Om;
end;

procedure KLpr(var pQkl,Qkl,Qklstat:realtype;const p,pm,pk,pn,Qk,Qm,Tkl:realtype);
begin
 if p > pn then Qklstat:=(p-pn)*Qk/(pk-pn) else Qklstat:=0;
 if p > pk then Qklstat:=Qk+((Qm-Qk)*(p-pk)/(pm-pk));
 pQkl:=(Qklstat-Qkl)/Tkl;
end;

procedure KLpp(var pQkl,Qkl,Qklstat:realtype;const p,pn,pk,Qk,Qm,Tkl:realtype);
begin
 if p<pn then Qklstat:=(pn-p)*Qk/(pn-pk) else Qklstat:=0;
 if p<pk then Qklstat:=Qm-((Qm-Qk)*p/pk);
 pQkl:=(Qklstat-Qkl)/Tkl;
end;



{*******************************************************************************
                              TNS
*******************************************************************************}
//function    TNS.GetParamID;
//begin
//  Result:=inherited GetParamId(ParamName,DataType,IsConst);
//  if Result = -1 then begin
//    if StrEqu(ParamName,'gm') then begin
//      Result:=NativeInt(@gm);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'wn') then begin
//      Result:=NativeInt(@wn);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'Ly') then begin
//      Result:=NativeInt(@Ly);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'Lp') then begin
//      Result:=NativeInt(@Lp);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'tip') then begin
//      Result:=NativeInt(@tip);
//      DataType:=dtInteger;
//    end;
//
//  end
//end;
//
//function TNS.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
//  var i: integer;
//begin
//  Result:=0;
//  case Action of
//    i_GetCount:     begin
//                      for i:=0 to CY.count-1 do CY.arr^[i]:=1;
//                      for i:=0 to CU.count-1 do CU.arr^[i]:=1;
//                      CY.arr^[0]:=2;
//                      CU.arr^[1]:=2;
//                    end;
//  else
//    Result:=inherited InfoFunc(Action,aParameter);
//  end
//end;
//
//function   TNS.RunFunc;
//begin
// Result:=0;
// case Action of
//   f_UpdateOuts,
//   f_InitState,
//   f_GoodStep:  NS(Y[0].arr^[0], Y[0].arr^[1], Y[1].arr^[0],
//                   U[0].arr^[0], U[1].arr^[0], U[1].arr^[1], U[2].arr^[0],
//                   gm, wn, Ly, Lp, tip)
// end
//end;
//
//{*******************************************************************************
//                              TNS_c
//*******************************************************************************}
//function    TNS_c.GetParamID;
//begin
//  Result:=inherited GetParamId(ParamName,DataType,IsConst);
//  if Result = -1 then begin
//    if StrEqu(ParamName,'gm') then begin
//      Result:=NativeInt(@gm);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'wn') then begin
//      Result:=NativeInt(@wn);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'Ly') then begin
//      Result:=NativeInt(@Ly);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'Lp') then begin
//      Result:=NativeInt(@Lp);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'Eg') then begin
//      Result:=NativeInt(@Eg);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'kv') then begin
//      Result:=NativeInt(@kv);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'tip') then begin
//      Result:=NativeInt(@tip);
//      DataType:=dtInteger;
//    end;
//
//  end
//end;
//
//function TNS_c.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
//  var i: integer;
//begin
//  Result:=0;
//  case Action of
//    i_GetCount:     begin
//                      for i:=0 to CY.count-1 do CY.arr^[i]:=1;
//                      for i:=0 to CU.count-1 do CU.arr^[i]:=1;
//                      CY.arr^[0]:=2;
//                      CU.arr^[1]:=2;
//                    end;
//  else
//    Result:=inherited InfoFunc(Action,aParameter);
//  end
//end;
//
//function   TNS_c.RunFunc;
//begin
// Result:=0;
// case Action of
//   f_UpdateOuts,
//   f_InitState,
//   f_GoodStep: NS_c(Y[0].arr^[0], Y[0].arr^[1], Y[1].arr^[0],
//                    U[0].arr^[0], U[1].arr^[0], U[1].arr^[1], U[2].arr^[0],
//                    gm, wn, Ly, Lp, Eg, kv, tip);
//
// end
//end;
//
//{*******************************************************************************
//                              TPOL
//*******************************************************************************}
//function    TPOL.GetParamID;
//begin
//  Result:=inherited GetParamId(ParamName,DataType,IsConst);
//  if Result = -1 then begin
//    if StrEqu(ParamName,'pmax') then begin
//      Result:=NativeInt(@pmax);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'pmin') then begin
//      Result:=NativeInt(@pmin);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'Eg') then begin
//      Result:=NativeInt(@Eg);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'Wp') then begin
//      Result:=NativeInt(@Wp);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'nu') then begin
//      Result:=NativeInt(@nu);
//      DataType:=dtDouble;
//    end;
//
//  end
//end;
//
//function TPOL.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
//begin
//  Result:=0;
//  case Action of
//    i_GetInit,
//    i_GetDifCount:  Result:=1;
//    i_GetCount:     begin
//                      CY.arr^[0]:=1;
//                      CU.arr^[0]:=1;
//                    end;
//  else
//    Result:=inherited InfoFunc(Action,aParameter);
//  end
//end;
//
//function   TPOL.RunFunc;
// var tmp : RealType;
//begin
// Result:=0;
// case Action of
//   f_InitState :  begin
//                    Xdif[0]:=nu;
//                    POL(Fdif[0], Xdif[0], Y[0].arr^[0], U[0].arr^[0],
//                        Eg, Wp, pmax, pmin);
//                  end;
//   f_UpdateJacoby,
//   f_GoodStep,
//   f_UpdateOuts:  POL(Fdif[0], Xdif[0], Y[0].arr^[0], U[0].arr^[0],
//                      Eg, Wp, pmax, pmin);
//   f_GetDeri :    POL(Fdif[0], Xdif[0], tmp, U[0].arr^[0],
//                      Eg, Wp, pmax, pmin);
// end
//end;
//
//{*******************************************************************************
//                              TNS_p
//*******************************************************************************}
//function    TNS_p.GetParamID;
//begin
//  Result:=inherited GetParamId(ParamName,DataType,IsConst);
//  if Result = -1 then begin
//    if StrEqu(ParamName,'gmax') then begin
//      Result:=NativeInt(@gmax);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'wn') then begin
//      Result:=NativeInt(@wn);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'Ly') then begin
//      Result:=NativeInt(@Ly);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'Lp') then begin
//      Result:=NativeInt(@Lp);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'tip') then begin
//      Result:=NativeInt(@tip);
//      DataType:=dtInteger;
//      exit;
//    end;
//    if StrEqu(ParamName,'Eg') then begin
//      Result:=NativeInt(@Eg);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'Wp1') then begin
//      Result:=NativeInt(@Wp1);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'Wp2') then begin
//      Result:=NativeInt(@Wp2);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'pmax') then begin
//      Result:=NativeInt(@pmax);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'pmin') then begin
//      Result:=NativeInt(@pmin);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'nu1') then begin
//      Result:=NativeInt(@nu1);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'nu2') then begin
//      Result:=NativeInt(@nu2);
//      DataType:=dtDouble;
//    end;
//
//  end
//end;
//
//function TNS_p.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
//  var i: integer;
//begin
//  Result:=0;
//  case Action of
//    i_GetInit:      Result:=1;
//    i_GetDifCount:  Result:=2;
//    i_GetCount:     begin
//                      for i:=0 to CY.count-1 do CY.arr^[i]:=1;
//                      for i:=0 to CU.count-1 do CU.arr^[i]:=1;
//                      CY.arr^[0]:=2;
//                      CU.arr^[1]:=2;
//                    end;
//  else
//    Result:=inherited InfoFunc(Action,aParameter);
//  end
//end;
//
//function   TNS_p.RunFunc;
//begin
// Result:=0;
// case Action of
//  f_InitState : begin
//                  Xdif[0]:=nu1;
//                  Xdif[1]:=nu2;
//                  NS_p(Fdif[0], Fdif[1], Xdif[0], Xdif[1],
//                       Y[0].arr^[0], Y[0].arr^[1], Y[1].arr^[0], Y[2].arr^[0],
//                       U[2].arr^[0], U[1].arr^[0], U[1].arr^[1], Ly, Lp, Eg,
//                       Wp1, Wp2, pmax, pmin, U[0].arr^[0], gmax, wn, tip);
//                end;
//  f_UpdateJacoby,
//  f_GoodStep,
//  f_UpdateOuts,
//  f_RestoreOuts,
//  f_GetDeri :  NS_p(Fdif[0], Fdif[1], Xdif[0], Xdif[1],
//                 Y[0].arr^[0], Y[0].arr^[1], Y[1].arr^[0], Y[2].arr^[0],
//                 U[2].arr^[0], U[1].arr^[0], U[1].arr^[1], Ly, Lp, Eg,
//                 Wp1, Wp2, pmax, pmin, U[0].arr^[0], gmax, wn, tip);
// end
//end;
//
//{*******************************************************************************
//                              TPD
//*******************************************************************************}
//function    TPD.GetParamID;
//begin
//  Result:=inherited GetParamId(ParamName,DataType,IsConst);
//  if Result = -1 then begin
//    if StrEqu(ParamName,'tau') then begin
//      Result:=NativeInt(@tau);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'teta') then begin
//      Result:=NativeInt(@teta);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'J') then begin
//      Result:=NativeInt(@J);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'f') then begin
//      Result:=NativeInt(@f);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'Mt') then begin
//      Result:=NativeInt(@Mt);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'Mdmax') then begin
//      Result:=NativeInt(@Mdmax);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'nu1') then begin
//      Result:=NativeInt(@nu1);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'nu2') then begin
//      Result:=NativeInt(@nu2);
//      DataType:=dtDouble;
//    end;
//  end
//end;
//
//function TPD.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
//begin
//  Result:=0;
//  case Action of
//    i_GetInit:      Result:=1;
//    i_GetDifCount:  Result:=2;
//  else
//    Result:=inherited InfoFunc(Action,aParameter);
//  end
//end;
//
//function   TPD.RunFunc;
//begin
// Result:=0;
// case Action of
//   f_InitState :begin
//                  Xdif[0]:=nu1;
//                  Xdif[1]:=nu2;
//                  PD(Fdif[0], Fdif[1], Xdif[0], Xdif[1],
//                     U[0].arr^[0], tau, teta, J, f, Mt, U[1].arr^[0], Mdmax);
//                  Y[0].arr^[0]:=Xdif[0];
//                  Y[1].arr^[0]:=Xdif[1];
//                end;
//   f_UpdateJacoby,
//   f_GoodStep,
//   f_UpdateOuts,
//   f_RestoreOuts,
//   f_GetDeri : begin
//                PD(Fdif[0], Fdif[1], Xdif[0], Xdif[1],
//                   U[0].arr^[0], tau, teta, J, f, Mt, U[1].arr^[0], Mdmax);
//                Y[0].arr^[0]:=Xdif[0];
//                Y[1].arr^[0]:=Xdif[1];
//               end;
// end
//end;
//
//{*******************************************************************************
//                              TGU
//*******************************************************************************}
//function    TGU.GetParamID;
//begin
//  Result:=inherited GetParamId(ParamName,DataType,IsConst);
//  if Result = -1 then begin
//    if StrEqu(ParamName,'ymax') then begin
//      Result:=NativeInt(@ymax);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'Vmax') then begin
//      Result:=NativeInt(@Vmax);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'Xmax') then begin
//      Result:=NativeInt(@Xmax);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'k') then begin
//      Result:=NativeInt(@k);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'T') then begin
//      Result:=NativeInt(@T);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'dzt') then begin
//      Result:=NativeInt(@dzt);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'nu1') then begin
//      Result:=NativeInt(@nu1);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'nu2') then begin
//      Result:=NativeInt(@nu2);
//      DataType:=dtDouble;
//    end;
//  end
//end;
//
//function TGU.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
//begin
//  Result:=0;
//  case Action of
//    i_GetInit:      Result:=1;
//    i_GetDifCount:  Result:=2;
//  else
//    Result:=inherited InfoFunc(Action,aParameter);
//  end
//end;
//
//function   TGU.RunFunc;
//begin
// Result:=0;
// case Action of
//   f_InitState : begin
//                  Xdif[0]:=nu1;
//                  Xdif[1]:=nu2;
//                  GU(Fdif[0], Fdif[1], Xdif[0], Xdif[1], U[0].arr^[0],
//                     ymax, Vmax, Xmax, k, T, dzt);
//                  Y[0].arr^[0]:=Xdif[0];
//                  Y[1].arr^[0]:=Xdif[1];
//                 end;
//   f_UpdateJacoby,
//   f_GoodStep,
//   f_UpdateOuts,
//   f_RestoreOuts,
//   f_GetDeri :  begin
//                  GU(Fdif[0], Fdif[1], Xdif[0], Xdif[1], U[0].arr^[0],
//                     ymax, Vmax, Xmax, k, T, dzt);
//                  Y[0].arr^[0]:=Xdif[0];
//                  Y[1].arr^[0]:=Xdif[1];
//                end;
// end
//end;
//
//
//{*******************************************************************************
//                              TOR_tr
//*******************************************************************************}
//function    TOR_tr.GetParamID;
//begin
//  Result:=inherited GetParamId(ParamName,DataType,IsConst);
//  if Result = -1 then begin
//    if StrEqu(ParamName,'J') then begin
//      Result:=NativeInt(@J);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'f') then begin
//      Result:=NativeInt(@f);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'c') then begin
//      Result:=NativeInt(@c);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'Mt') then begin
//      Result:=NativeInt(@Mt);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'nu1') then begin
//      Result:=NativeInt(@nu1);
//      DataType:=dtDouble;
//      exit;
//    end;
//    if StrEqu(ParamName,'nu2') then begin
//      Result:=NativeInt(@nu2);
//      DataType:=dtDouble;
//    end;
//  end
//end;
//
//function TOR_tr.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
//begin
//  Result:=0;
//  case Action of
//    i_GetInit:      Result:=1;
//    i_GetDifCount:  Result:=2;
//  else
//    Result:=inherited InfoFunc(Action,aParameter);
//  end
//end;
//
//function   TOR_tr.RunFunc;
//begin
// Result:=0;
// case Action of
//   f_InitState : begin
//                  Xdif[0]:=nu1;
//                  Xdif[1]:=nu2;
//                  OR_tr(Fdif[0], Fdif[1], Xdif[0], Xdif[1], U[0].arr^[0],
//                        Y[2].arr^[0], U[1].arr^[0],
//                        U[2].arr^[0], J, f, c, Mt);
//                  Y[0].arr^[0]:=Xdif[0];
//                  Y[1].arr^[0]:=Xdif[1];
//                 end;
//   f_UpdateJacoby,
//   f_GoodStep,
//   f_UpdateOuts,
//   f_RestoreOuts,
//   f_GetDeri :  begin
//                 OR_tr(Fdif[0], Fdif[1], Xdif[0], Xdif[1], U[0].arr^[0],
//                       Y[2].arr^[0], U[1].arr^[0],
//                       U[2].arr^[0], J, f, c, Mt);
//                 Y[0].arr^[0]:=Xdif[0];
//                 Y[1].arr^[0]:=Xdif[1];
//                end;
// end
//end;


{*******************************************************************************
                              TGD_c
*******************************************************************************}
function    TGD_c.GetParamID;
begin
  Result:=inherited GetParamId(ParamName,DataType,IsConst);
  if Result = -1 then begin
    if StrEqu(ParamName,'wd') then begin
      Result:=NativeInt(@wd);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'Ly') then begin
      Result:=NativeInt(@Ly);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'Lp') then begin
      Result:=NativeInt(@Lp);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'Eg') then begin
      Result:=NativeInt(@Eg);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'kv') then begin
      Result:=NativeInt(@kv);
      DataType:=dtDouble;
      exit;
    end;

  end
end;

function TGD_c.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
begin
  Result:=0;
  case Action of
    i_GetCount:     begin
                     CY.arr^[1]:=1;
                     CY.arr^[0]:=2;
                     CU.arr^[0]:=1;
                     CU.arr^[1]:=2;
                    end;
  else
    Result:=inherited InfoFunc(Action,aParameter);
  end
end;

function   TGD_c.RunFunc;
begin
 Result:=0;
 case Action of
   f_UpdateOuts,
   f_InitState,
   f_GoodStep : GD_c(Y[0].arr^[0], Y[0].arr^[1], Y[1].arr^[0],
                     U[0].arr^[0], U[1].arr^[0], U[1].arr^[1],
                     wd, Ly, Lp, Eg, kv);
 end
end;

{*******************************************************************************
                              TDR
*******************************************************************************}
function    TDR.GetParamID;
begin
  Result:=inherited GetParamId(ParamName,DataType,IsConst);
  if Result = -1 then begin
    if StrEqu(ParamName,'pc') then begin
      Result:=NativeInt(@pc);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'y0') then begin
      Result:=NativeInt(@y0);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'my') then begin
      Result:=NativeInt(@my);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'ro') then begin
      Result:=NativeInt(@ro);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'d') then begin
      Result:=NativeInt(@d);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'dtd') then begin
      Result:=NativeInt(@dtd);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'kisp') then begin
      Result:=NativeInt(@kisp);
      DataType:=dtDouble;
    end;
  end
end;

function TDR.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
begin
  Result:=0;
  case Action of
    i_GetCount:begin
                 CY.arr^[0]:=2;
                 CY.arr^[1]:=1;
                 CU.arr^[0]:=1;
                 CU.arr^[1]:=2;
                 CU.arr^[2]:=1;
               end;
  else
    Result:=inherited InfoFunc(Action,aParameter);
  end
end;

function   TDR.RunFunc;
begin
 Result:=0;
 case Action of
   f_UpdateOuts,
   f_InitState,
   f_GoodStep :  DR(Y[0].arr^[0], Y[0].arr^[1], Y[1].arr^[0],
                    U[2].arr^[0], pc, U[1].arr^[0], U[1].arr^[1], U[0].arr^[0],
                    y0, my, ro, d, dtd, kisp);
 end
end;

{*******************************************************************************
                              TDR_idd
*******************************************************************************}
function    TDR_idd.GetParamID;
begin
  Result:=inherited GetParamId(ParamName,DataType,IsConst);
  if Result = -1 then begin
    if StrEqu(ParamName,'ps') then begin
      Result:=NativeInt(@ps);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'yn0') then begin
      Result:=NativeInt(@yn0);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'ys0') then begin
      Result:=NativeInt(@ys0);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'my') then begin
      Result:=NativeInt(@my);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'ro') then begin
      Result:=NativeInt(@ro);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'d') then begin
      Result:=NativeInt(@d);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'kisp') then begin
      Result:=NativeInt(@kisp);
      DataType:=dtDouble;
    end;
  end
end;

function TDR_idd.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
begin
  Result:=0;
  case Action of
    i_GetCount:begin
                 CY.arr^[0]:=2;
                 CY.arr^[1]:=1;
                 CU.arr^[0]:=1;
                 CU.arr^[1]:=2;
                 CU.arr^[2]:=1;
               end;
  else
    Result:=inherited InfoFunc(Action,aParameter);
  end
end;

function   TDR_idd.RunFunc;
begin
 Result:=0;
 case Action of
   f_UpdateOuts,
   f_InitState,
   f_GoodStep : DR_id(Y[0].arr^[0], Y[0].arr^[1], Y[1].arr^[0],
                      U[2].Arr^[0], ps, U[1].arr^[0], U[1].arr^[1], U[0].arr^[0],
                      yn0, ys0, my, ro, d, kisp);
 end
end;

{*******************************************************************************
                              TREG_n
*******************************************************************************}
function    TREG_n.GetParamID;
begin
  Result:=inherited GetParamId(ParamName,DataType,IsConst);
  if Result = -1 then begin
    if StrEqu(ParamName,'gnmax') then begin
      Result:=NativeInt(@gnmax);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'gnmin') then begin
      Result:=NativeInt(@gnmin);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'Vgnmax') then begin
      Result:=NativeInt(@Vgnmax);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'kreg') then begin
      Result:=NativeInt(@kreg);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'kn') then begin
      Result:=NativeInt(@kn);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'kdin') then begin
      Result:=NativeInt(@kdin);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'nu') then begin
      Result:=NativeInt(@nu);
      DataType:=dtDouble;
    end;
  end
end;

function TREG_n.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
begin
  Result:=0;
  case Action of
    i_GetInit:      Result:=1;
    i_GetDifCount:  Result:=1;
  else
    Result:=inherited InfoFunc(Action,aParameter);
  end
end;

function   TREG_n.RunFunc;
begin
 Result:=0;
 case Action of
   f_InitState : begin
                   Xdif[0]:=nu;
                   REG_n(Fdif[0], Xdif[0], Y[0].arr^[0], U[1].arr^[0],
                         U[0].arr^[0], gnmax, gnmin, Vgnmax, kn, kreg, kdin);
                   Y[1].arr^[0]:=Xdif[0];
                 end;
   f_UpdateJacoby,
   f_GoodStep,
   f_UpdateOuts,
   f_RestoreOuts,
   f_GetDeri :  begin
                 REG_n(Fdif[0], Xdif[0], Y[0].arr^[0], U[1].arr^[0],
                       U[0].arr^[0], gnmax, gnmin, Vgnmax, kn, kreg, kdin);
                 Y[1].arr^[0]:=Xdif[0];
                end;
 end
end;

{*******************************************************************************
                              TRED
*******************************************************************************}
function    TRED.GetParamID;
begin
  Result:=inherited GetParamId(ParamName,DataType,IsConst);
  if Result = -1 then begin
    if StrEqu(ParamName,'ir') then begin
      Result:=NativeInt(@ir);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'lft') then begin
      Result:=NativeInt(@lft);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'fy') then begin
      Result:=NativeInt(@fy);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'cy') then begin
      Result:=NativeInt(@cy);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'m0') then begin
      Result:=NativeInt(@m0);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'nu') then begin
      Result:=NativeInt(@nu);
      DataType:=dtDouble;
    end;
  end
end;

function TRED.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
begin
  Result:=0;
  case Action of
    i_GetInit:      Result:=1;
    i_GetDifCount:  Result:=1;
  else
    Result:=inherited InfoFunc(Action,aParameter);
  end
end;

function   TRED.RunFunc;
begin
 Result:=0;
 case Action of
   f_InitState : begin
                   Xdif[0]:=nu;
                   RED(Fdif[0], Y[1].arr^[0], Y[2].arr^[0],
                       U[0].arr^[0], U[1].arr^[0], Xdif[0],
                       ir, lft, fy, cy, M0);
                   Y[0].arr^[0]:=Xdif[0];
                 end;
   f_UpdateJacoby,
   f_GoodStep,
   f_UpdateOuts,
   f_RestoreOuts,
   f_GetDeri :  begin
                  RED(Fdif[0], Y[1].arr^[0], Y[2].arr^[0],
                      U[0].arr^[0], U[1].arr^[0], Xdif[0],
                      ir, lft, fy, cy, M0);
                  Y[0].arr^[0]:=Xdif[0];
                end;
 end
end;

{*******************************************************************************
                              TOR_tv
*******************************************************************************}
function    TOR_tv.GetParamID;
begin
  Result:=inherited GetParamId(ParamName,DataType,IsConst);
  if Result = -1 then begin
    if StrEqu(ParamName,'J') then begin
      Result:=NativeInt(@J);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'f') then begin
      Result:=NativeInt(@f);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'c') then begin
      Result:=NativeInt(@c);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'Mtost') then begin
      Result:=NativeInt(@Mtost);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'mtdwg') then begin
      Result:=NativeInt(@Mtdwg);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'Om0') then begin
      Result:=NativeInt(@Om0);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'nu1') then begin
      Result:=NativeInt(@nu1);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'nu2') then begin
      Result:=NativeInt(@nu2);
      DataType:=dtDouble;
    end;
  end
end;

function TOR_tv.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
begin
  Result:=0;
  case Action of
    i_GetInit:      Result:=1;
    i_GetDifCount:  Result:=2;
  else
    Result:=inherited InfoFunc(Action,aParameter);
  end
end;

function   TOR_tv.RunFunc;
begin
 Result:=0;
 case Action of
   f_InitState : begin
                  Xdif[0]:=nu1;
                  Xdif[1]:=nu2;
                  OR_tv(Fdif[0], Fdif[1], Xdif[0], U[2].arr^[0], Xdif[1],
                        Y[2].arr^[0], U[0].arr^[0],
                        U[1].arr^[0], J, f, c,
                        Mtost, Mtdwg, Om0);
                  Y[0].arr^[0]:=Xdif[0];
                  Y[1].arr^[0]:=Xdif[1];
                 end;
   f_UpdateJacoby,
   f_GoodStep,
   f_UpdateOuts,
   f_RestoreOuts,
   f_GetDeri :   begin
                  OR_tv(Fdif[0], Fdif[1], Xdif[0], U[2].arr^[0], Xdif[1],
                        Y[2].arr^[0], U[0].arr^[0],
                        U[1].arr^[0], J, f, c,
                        Mtost, Mtdwg, Om0);
                  Y[0].arr^[0]:=Xdif[0];
                  Y[1].arr^[0]:=Xdif[1];
                 end;
 end
end;

{*******************************************************************************
                              TKLpr
*******************************************************************************}
function    TKLpr.GetParamID;
begin
  Result:=inherited GetParamId(ParamName,DataType,IsConst);
  if Result = -1 then begin
    if StrEqu(ParamName,'pn') then begin
      Result:=NativeInt(@pn);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'pk') then begin
      Result:=NativeInt(@pk);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'pm') then begin
      Result:=NativeInt(@pm);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'Qk') then begin
      Result:=NativeInt(@Qk);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'Qm') then begin
      Result:=NativeInt(@Qm);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'Tkl') then begin
      Result:=NativeInt(@Tkl);
      DataType:=dtDouble;
    end;
  end
end;

function TKLpr.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
begin
  Result:=0;
  case Action of
    i_GetInit:      Result:=1;
    i_GetDifCount:  Result:=1;
  else
    Result:=inherited InfoFunc(Action,aParameter);
  end
end;

function   TKLpr.RunFunc;
begin
 Result:=0;
 case Action of
  f_InitState :  begin
                   Xdif[0]:=0;
                   KLpr(Fdif[0], Xdif[0], Y[1].arr^[0], U[0].arr^[0],
                        pm, pk, pn, Qk, Qm, Tkl);
                   Y[0].Arr^[0]:=Xdif[0];
                 end;
  f_UpdateJacoby,
  f_GoodStep,
  f_UpdateOuts,
  f_RestoreOuts,
  f_GetDeri :    begin
                   KLpr(Fdif[0], Xdif[0], Y[1].arr^[0], U[0].arr^[0],
                        pm, pk, pn, Qk, Qm, Tkl);
                   Y[0].Arr^[0]:=Xdif[0];
                 end;
 end
end;

{*******************************************************************************
                              TKLpp
*******************************************************************************}
function    TKLpp.GetParamID;
begin
  Result:=inherited GetParamId(ParamName,DataType,IsConst);
  if Result = -1 then begin
    if StrEqu(ParamName,'pn') then begin
      Result:=NativeInt(@pn);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'pk') then begin
      Result:=NativeInt(@pk);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'Qk') then begin
      Result:=NativeInt(@Qk);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'Qm') then begin
      Result:=NativeInt(@Qm);
      DataType:=dtDouble;
      exit;
    end;
    if StrEqu(ParamName,'Tkl') then begin
      Result:=NativeInt(@Tkl);
      DataType:=dtDouble;
    end;
  end
end;

function TKLpp.InfoFunc(Action: integer;aParameter: NativeInt):NativeInt;
begin
  Result:=0;
  case Action of
    i_GetInit:      Result:=1;
    i_GetDifCount:  Result:=1;
  else
    Result:=inherited InfoFunc(Action,aParameter);
  end
end;

function   TKLpp.RunFunc;
begin
 Result:=0;
 case Action of
   f_InitState: begin
                 Xdif[0]:=Qm;
                 KLpp(Fdif[0], Xdif[0], Y[1].arr^[0], U[0].arr^[0],
                      pn, pk, Qk, Qm, Tkl);
                 Y[0].Arr^[0]:=Xdif[0];
                end;
   f_UpdateJacoby,
   f_GoodStep,
   f_UpdateOuts,
   f_RestoreOuts,
   f_GetDeri :  begin
                 KLpp(Fdif[0], Xdif[0], Y[1].arr^[0], U[0].arr^[0],
                      pn, pk, Qk, Qm, Tkl);
                 Y[0].Arr^[0]:=Xdif[0];
                end;
 end
end;


end.
