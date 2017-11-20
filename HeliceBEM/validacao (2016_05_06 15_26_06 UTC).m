%% arquivo principal que declara as constantes e chama as funções
% para pegar os parametros dos aerofolios e chama as funcoes para
% calcular os paramtros da helice (BEM ou Optimum (do artigo)
clear;%clear das variaveis
clc;%limpa a tela
%% variaveis globais utilizadas em todas as funcoes:
%Vo- velocidade do escoamento (1.5 m/s)
%W-velocidade angular da helice
%D,R,D_hu,R_hub-diametro e raio da helice,diametro e raio do cubo
%r vetor de raio ( cada elemento é uma secao da pa da helice)
%alpha,CL,CD- ang.ataque,Cl e Cd provenientes dos dados do aerofolio
%max_CL_CD,alpha_opt,CL_opt,CD_opt-
%   Razao CL/CD maxima do aerofolio e respectivo alpha,Cl e Cd
%Z- numero de pas
%ro- densisdade da agua (20 C)
% visc - viscosidade cinematica da agua (20 C)
%vsom- velocidade do som na agua
%A- area da helice ( pi*R^2)
%lambda- avanco da helice
%T- tracao necessaria
%P- potencia necessaria

global Vo W D R D_hub R_hub r Z ro visc vsom A lambda T P Rex
%% valores constantes
%[alpha,CL,CD,max_CL_CD,alpha_opt,CL_opt,CD_opt]=ler_aerof('xf-a18sm-il-50000.txt');
D=5.75;%diametro da helice
R=D/2;%raio da helice
D_hub=1;%diaetro do cubo
R_hub=D_hub/2;%raio do cubo
A=pi*R^2;%area da helice
Z=2;%numero de pas
Vo=161.33;%velocidade do fluido
W=2400/9.549;%velocidade angular da helice
ro=1.2754;%densidade do ar
visc=1.5111e-5;%visc.cinematica
vsom=1450;%velocidade do som na agua
lambda=Vo/(W*R);%avanco da helice
J=Vo/(W*2*pi*D);%coeficiente de avanco
T=207.44;%forca necessaria (75kg;174cm;1.5m/s;Cd=0.7)

%numero de raios
N=20;%numero de divisoes do raio
% Rex=[83.4995 94.0995 103.6328 112.0761 119.4468 125.7806 131.1162 135.4842 138.8994 141.3545 142.8145 143.2107 142.4322 140.3138 136.6166 130.9939 122.9246 111.5669 95.3629 70.5119 10000]';
% Rex=Rex.*1000;
%% distribuicao das secoes da helice
r=[0.5 0.62 0.74 0.86 0.97 1.09 .21 1.33 1.45 1.57 1.69 1.81 1.92 2.04 2.16 2.28 2.40 2.52 2.64 2.76 2.87]';

%1-MH114
%2-HS1712
%3-NACA4415
[resgA,resA]=optimum(3,1);
[resgB,resB]=optimum(3,1);
[resgC,resC]=optimum(3,1);

%%Graficos para plotar os resultados de cada aerofolio
%cada aerofolio teve as respostas guardadas em variaveis res (resposta local) e
%resg(resposta global).Aqui simplesmente sao plotados em funcao do raio
%adimensional
figure(1);%nova figure
%plot do twist de cada resultado
%plot(r./R,resA.corda./R);
plot(r./R,resA.twist,r./R,resB.twist,r./R,resC.twist);
grid on;%tracos pontilhados
title('Pitch x raio');%titulo
xlabel('r/R');%titulo eixo x
ylabel('twist(deg)');%titulo eixo y
%legenda do grafico
legend('MH114','H1712','NACA4415');

figure(2);
%plot do fator de inducao tangencial
plot(r./R,resA.a_l,r./R,resB.a_l,r./R,resC.a_l);
grid on;
title('fator de inducao tangencial');
xlabel('r/R');
ylabel('a_l');
legend('MH114','H1712','NACA4415');

figure(3);
%plot do fator de inducao axial
plot(r./R,resA.a,r./R,resB.a,r./R,resC.a);
grid on;
title('fator de inducao axial');
xlabel('r/R');
ylabel('a');
legend('MH114','H1712','NACA4415');

figure(4);
%plot do numero de Reynolds
plot(r./R,resA.Re,r./R,resB.Re,r./R,resC.Re);
grid on;
title('Numero de Reynolds x raio');
xlabel('r/R');
ylabel('Numero de Reynolds*1000');
legend('MH114','H1712','NACA4415');

figure(5);
%plot do numero de Mach
plot(r./R,resA.Ma,r./R,resB.Ma,r./R,resC.Ma);
grid on;
title('Numero de Mach x raio');
xlabel('r/R');
ylabel('Numero de Mach');
legend('MH114','H1712','NACA4415');

figure(8);
%plot da distribuicao de corda
plot(r./R,resA.corda./R,r./R,resB.corda./R,r./R,resC.corda./R);
title('corda x raio');
xlabel('r/R');
ylabel('c');
grid on;
legend('MH114','H1712','NACA4415');

%mostrando os resultados globais de cada aerofolio na tela
disp('MH114:');
resgA
disp('HS1712:');
resgB
disp('NACA4415:');
resgC


    