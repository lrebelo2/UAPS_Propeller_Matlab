function Dim(f) %f=0 diametro especifico, f=1 varios diametros
clc;
%% constantes globais
global c1 c2 c3 c4 c5 c6 c7 c8 D V PI ro Cd Af 
%densidade do fluido em kg/m3 (agua)
ro=998.2;
%coeficiente de arrasto
Cd=0.6;
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
%% 
if(f)
Pff=[];
Vff=[];
etaff=[];
Fff=[];
nff=[];
for D=0.02:0.01:0.08
aux2ant=zeros(1,10);
Pf=[];
Vf=[];
etaf=[];
Ff=[];
nf=[];
rend=[];

for Vteste=1.6:0.05:3
  
aux2=helice(Vteste);
if(isempty(aux2))
    aux2=aux2ant;
end
Pf=[Pf aux2(7)];
Vf=[Vf aux2(1)];
etaf=[etaf aux2(2)];
Ff=[Ff aux2(6)];
nf=[nf aux2(end)];
aux2ant=aux2;
end

Pff=[Pff,Pf'];
Vff=[Vff,Vf'];
etaff=[etaff,etaf'];
Fff=[Fff,Ff'];
nff=[nff,nf'];

end
for i=1:1:7
    rend=[rend median(etaff(:,i))];
end
close all;
figure(1);
grid on;
plot(nff(:,1),Pff(:,1),nff(:,2),Pff(:,2),nff(:,3),Pff(:,3),nff(:,4),Pff(:,4),nff(:,5),Pff(:,5),nff(:,6),Pff(:,6),nff(:,7),Pff(:,7));
title('Potência x rotacao');
xlabel('Rotacao(rps)');
ylabel('Potencia(W)');
legend(strcat('D=20mm,eta=',num2str(rend(1))),strcat('D=30mm,eta=',num2str(rend(2))),strcat('D=40mm,eta=',num2str(rend(3))),strcat('D=50mm,eta=',num2str(rend(4))),strcat('D=60mm,eta=',num2str(rend(5))),strcat('D=70mm,eta=',num2str(rend(6))),strcat('D=80mm,eta=',num2str(rend(7))));
grid on;
figure(2);
plot(nff(:,1),etaff(:,1),nff(:,2),etaff(:,2),nff(:,3),etaff(:,3),nff(:,4),etaff(:,4),nff(:,5),etaff(:,5),nff(:,6),etaff(:,6),nff(:,7),etaff(:,7));
title('eficiencia x Velocidade');
xlabel('Rotacao(rps)');
ylabel('eficiencia');
legend(strcat('D=20mm,eta=',num2str(rend(1))),strcat('D=30mm,eta=',num2str(rend(2))),strcat('D=40mm,eta=',num2str(rend(3))),strcat('D=50mm,eta=',num2str(rend(4))),strcat('D=60mm,eta=',num2str(rend(5))),strcat('D=70mm,eta=',num2str(rend(6))),strcat('D=80mm,eta=',num2str(rend(7))));
grid on;
figure(3);
plot(nff(:,1),Vff(:,1),nff(:,2),Vff(:,2),nff(:,3),Vff(:,3),nff(:,4),Vff(:,4),nff(:,5),Vff(:,5),nff(:,6),Vff(:,6),nff(:,7),Vff(:,7));
title('rotacao x Velocidade');
xlabel('Rotacao(rps)');
ylabel('Velocidade(m/s)');
legend(strcat('D=20mm,eta=',num2str(rend(1))),strcat('D=30mm,eta=',num2str(rend(2))),strcat('D=40mm,eta=',num2str(rend(3))),strcat('D=50mm,eta=',num2str(rend(4))),strcat('D=60mm,eta=',num2str(rend(5))),strcat('D=70mm,eta=',num2str(rend(6))),strcat('D=80mm,eta=',num2str(rend(7))));
grid on;
figure(4);

plot3(Pff(:,4),Vff(:,4),nff(:,4));
grid on;
figure(5);
plot(Vff(:,1),Pff(:,1),Vff(:,2),Pff(:,2),Vff(:,3),Pff(:,3),Vff(:,4),Pff(:,4),Vff(:,5),Pff(:,5),Vff(:,6),Pff(:,6),Vff(:,7),Pff(:,7));
title('Potencia x Velocidade');
xlabel('Velocidade(m/s)');
ylabel('Potencia(W)');
legend(strcat('D=20mm,eta=',num2str(rend(1))),strcat('D=30mm,eta=',num2str(rend(2))),strcat('D=40mm,eta=',num2str(rend(3))),strcat('D=50mm,eta=',num2str(rend(4))),strcat('D=60mm,eta=',num2str(rend(5))),strcat('D=70mm,eta=',num2str(rend(6))),strcat('D=80mm,eta=',num2str(rend(7))));

else
%% 
aux2=[];
Pf=[];
Vf=[];
etaf=[];
Ff=[];
nf=[];

for Vteste=1.6:0.05:3
  
aux2=helice(Vteste);

Pf=[Pf aux2(7)];
Vf=[Vf aux2(1)];
etaf=[etaf aux2(2)];
Ff=[Ff aux2(6)];
nf=[nf aux2(end)];

end
rend=median(etaf);
close all;
grid on;
figure(1);
plot(nf,Pf);
title('Potência x rotacao');
xlabel('Rotacao(rps)');
ylabel('Potencia(W)');
legend(strcat('eta=',num2str(rend)));
figure(2);
plot(nf,Vf);
title('Velocidade x rotacao');
xlabel('Rotacao(rps)');
ylabel('Velocidade(m/s)');
legend(strcat('eta=',num2str(rend)));
figure(3);
plot(nf,Vf);
title('Potencia x Velocidade');
xlabel('Velocidade(m/s)');
ylabel('Potencia(W)');
legend(strcat('eta=',num2str(rend)));

end

end

%result=[Vfinal eta*100 J Kt Kq F P T Pm/1000 n];





