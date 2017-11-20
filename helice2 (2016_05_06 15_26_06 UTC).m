function ret=helice2(Pdsj)

%disp('[Vfinal eta*100 J Kt Kq F P T P(kW)/eta n]');
global c1 c2 c3 c4 c5 c6 c7 c8 D V PI ro Cd Af A

%densidade do fluido em kg/m3 (agua)
ro=998.2;
%coeficiente de arrasto
Cd=0.675;
% pi
D=0.117;
PI=3.141592;
%area  forntal do ser  humano em m2
m=74;
H=173;
Af=6.9256*m+3.5043*H-377.156;
Af=Af*0.0001
% vetor velocidade  do  conjunto
V=linspace(1.0,2.5,1000);
% %% dados da helice experimentais 53,3mm de diametro
% %diametro da helice em m
% %D=0.0533;
% %coeficientes da equacao caracteristica da helice Kt(J)
% % Kt=c1*J^3+c2*J^2+c3*J+c4;
% c1=0.1152;
% c2=-0.4397;
% c3=0.0464;
% c4=0.697;
% %coeficientes da equacao caracteristica da helice Kq(J)
% % Kq=(c5*J^3+c6*J^2+c7*J+c8)/10;
% c5=0.4168;
% c6=-1.7006;
% c7=0.9717;
% c8=1.6318;
%% dados da helice teoricos 114,3mm de diametro e 4 pas
%diametro da helice em m
%coeficientes da equacao caracteristica da helice Kt(J)
% Kt=c1*J^3+c2*J^2+c3*J+c4;
c1=0.164;
c2=-0.3549;
c3=0.1183;
c4=0.4007;
%coeficientes da equacao caracteristica da helice Kq(J)
% Kq=(c5*J^3+c6*J^2+c7*J+c8)/10;
c5=0.3281;
c6=-0.7098;
c7=-0.2365;
c8=0.8014;
%% 
result=[];

for n=5:0.01:30

  if(n==27.75)
    data=Calculo2(n,D,1);
    if(data(1,2)<100)
     Vs=((2*data(6)/(ro*A))+data(1)^2)^0.5;
 %if((abs(data(end)-Pdsj)<=1)&& (data(end)-Pdsj<=0))      
     data=[data Vs];
     data=[data n];
     result=[result,data'];
    end
end

ret=result;

end
%data=[Vfinal eta*100 J Kt Kq F P T Pm/1000];
%result=[Vfinal eta*100 J Kt Kq F P T Pm/1000 n];