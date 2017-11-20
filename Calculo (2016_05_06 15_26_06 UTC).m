function data=Calculo(n,f)
global V PI ro Cd Af D c1 c2 c3 c4 c5 c6 c7 c8
%Area da helice em m2

A=PI*0.25*D^2;
%inicializar matriz resposta
final=[];

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
final(i,:)=[V(i) eta*100 J Kt Kq F P T Pm/1000];
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
data=final(ind,:);
end
end




