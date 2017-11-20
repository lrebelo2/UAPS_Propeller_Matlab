function data=Calculo3(f)


%inicializar matriz resposta
final=[];
V=linspace(1.0,2.5,1000);
red=26;
n=((3000*11.1)/60)/red;
%densidade do fluido em kg/m3 (agua)
ro=998.2;
%coeficiente de arrasto
Cd=0.6;
% pi
D=0.1143;
PI=3.141592;
%area  forntal do ser  humano em m2
m=75;
H=174;
%Clarys
Af=6.9256*m+3.5043*H-377.156;
Af=Af*0.0001;
% vetor velocidade  do  conjunto
%Area da helice em m2
D=114.3*0.001;
A=PI*0.25*D^2;
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

for i=1:1:length(V)
%% primeira iteracao
%coeficiente de avanco
J=V(i)/(n*D);
%coeficientes de tracao e torque
Kt=c1*J^3+c2*J^2+c3*J+c4;
Kq=(c5*J^3+c6*J^2+c7*J+c8)/10;
F=Kt*ro*n^2*D^4;
% %velocidade de saida da helice
% Vs=((2*F)/(ro*A)+V(i)^2)^0.5;
% %velocidade na  helice
% Vh=0.5*(Vs+V(i));
%% com os calculos de velocidades e forcas e coeficientes, calcular restantes
%eficiencia
eta=(Kt*J)/(Kq*2*PI);
%torque atraves do Kq
T=Kq*ro*n^2*D^5;
%potencia na helice
P=F*V(i);
%potencia encesaria no motor
Pm=P/eta;
%forca  necessaria para manter velocidade  contante
Fn=0.5*ro*Af*Cd*V(i)^2;
final(i,:)=[V(i) eta*100 J Kt Kq F P T Pm];
end  
va=final(:,1);
pa=final(:,7);
pn=0.5.*ro.*Af.*Cd.*V.^3;
fn=0.5.*ro.*Af.*Cd.*V.^2;
if(f)
%% criar grafico de potencia x velocidade do conjunto
close all;
figure(1);
plot(va,pa,va,pn);
title('Potência x Velocidade');
xlabel('Velocidade(m/s)');
ylabel('Potencia(W)');
legend('Potencia Helice','Potencia Requerida');
figure(2);
fa=final(:,6);
plot(va,fa,va,fn,'r');
title('Forca x Velocidade');
xlabel('Velocidade(m/s)');
ylabel('Forca(N)');
legend('Forca tração','Forca arrasto');
% etaa=final(:,2);
% figure(3);
% plot(va,etaa);
end

ind=find((pa-pn')<=0.01,1);
if(isempty(ind))
    data=final(end,:);
else
vfinal=V(ind);
data=final(ind,:)
end
end




