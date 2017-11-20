function ret=helice(Vdsj)
%
global c1 c2 c3 c4 c5 c6 c7 c8 D V PI ro Cd Af 
%densidade do fluido em kg/m3 (agua)
ro=998.2;
%coeficiente de arrasto
Cd=0.6;
D=0.067;
% pi
PI=3.141592;
%area  forntal do ser  humano em m2
Af=0.09;
% vetor velocidade  do  conjunto
V=linspace(1.0,2.5,1000);
%% dados da helice
%diametro da helice em m
%D=0.0533;
%coeficientes da equacao caracteristica da helice Kt(J)
% Kt=c1*J^3+c2*J^2+c3*J+c4;
c1=0.1152;
c2=-0.4397;
c3=0.0464;
c4=0.697;
%coeficientes da equacao caracteristica da helice Kq(J)
% Kq=(c5*J^3+c6*J^2+c7*J+c8)/10;
c5=0.4168;
c6=-1.7006;
c7=0.9717;
c8=1.6318;
%disp('[Vfinal eta*100 J Kt Kq F P T P(kW)/eta n]');
%
result=[];
for n=5:5:600
    data=Calculo(n,0);
    if(abs(data(1)-Vdsj)<=0.1)
     data=[data n];
    result=[result,data'];
    end
end

ret=result;

end
%data=[Vfinal eta*100 J Kt Kq F P T Pm/1000];
%result=[Vfinal eta*100 J Kt Kq F P T Pm/1000 n];