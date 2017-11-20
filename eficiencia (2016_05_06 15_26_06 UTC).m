clear;
clc;
global c1 c2 c3 c4 c5 c6 c7 c8 V PI ro Cd Af 

eficv=[];
% vetor velocidade  do  conjunto
V=2.5;
%% dados da helice
%diametro da helice em m
D=0.0533;
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
for D=0.02:0.01:0.08
    efic=[];
    for n=100:5:600
    J=V./(n*D);
      %coeficientes de tracao e torque
Kt=c1.*J.^3+c2.*J.^2+c3.*J+c4;
Kq=(c5.*J.^3+c6.*J.^2+c7.*J+c8)./10;
eta=(Kt.*J)./(Kq.*2*PI);
efic=[efic eta];

    end
    length(efic)
    eficv=[eficv,efic'];
end
    n=100:5:600;
plot(n,eficv(:,1).*100,n,eficv(:,2).*100,n,eficv(:,3).*100,n,eficv(:,4).*100,n,eficv(:,5).*100,n,eficv(:,6).*100,n,eficv(:,7).*100);
legend('D=20mm','D=30mm');