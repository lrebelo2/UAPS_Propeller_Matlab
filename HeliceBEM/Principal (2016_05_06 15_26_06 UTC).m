%% arquivo principal que declara as constantes e chama as fun��es
% para pegar os parametros dos aerofolios e chama as funcoes para
% calcular os paramtros da helice (BEM ou Optimum (do artigo)
% variaveis globais utilizadas em todas as funcoes:
%Vo- velocidade do escoamento (1.5 m/s)
%W-velocidade angular da helice
%D,R,D_hu,R_hub-diametro e raio da helice,diametro e raio do cubo
%r vetor de raio ( cada elemento � uma secao da pa da helice)
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
%% 

%% usar o optimum como analise para fazer curva T(v) e comparar com arrasto/equilibrio
clear;%clear das variaveis
clc;%limpa a tela
global Vo W D R D_hub R_hub r Z ro visc vsom A lambda T P
%% valores constantes
D=130*0.001;%diametro da helice
R=D/2;%raio da helice
D_hub=0.3*D;%diametro do cubo
R_hub=D_hub/2;%raio do cubo
A=pi*R^2;%area da helice
Z=4;%numero de pas
Vo=1.5;%velocidade do fluido
Kv=1400;
red=16;
%W=(11.1*Kv)/(9.549304651*red);%velocidade angular da helice
W=1000/9.549;
ro=998.2;%densidade da agua
visc=9.7937e-7;%visc.cinematica
vsom=1450;%velocidade do som na agua
lambda=Vo/(W*R);%avanco da helice
J=Vo/(W*2*pi*D);%coeficiente de avanco
T=60;%forca necessaria (75kg;174cm;1.5m/s;Cd=0.7)
ef_red=0.95;
Pmotor=500;
P=Pmotor*ef_red;%potencia disponivel
%numero de raios
N=10;%numero de divisoes do raio da helice
m=78;
H=175.5;
Af=6.9256*m+3.5043*H-377.156;
Af=Af*0.0001
Fn=0.5*ro*Af*0.675;
Veq=((60*2)/(ro*Af*0.675))^0.5;
%% distribuicao das secoes da helice
r=zeros(N,1);%inicializacao do vetor de raios
for i=1:1:N+1 
    %iniciar com o raio do cubo
    if(i==1)
        r(i)=R_hub;
    else
        %gerar vetor de N divisoes
    r(i)=r(i-1)+(R-r(1))/N;
    end
end

[resgA,resA]=optimum(2,1,'T');
cr=resA.corda;
%BEM(vetor_corda,aerofolio)
[resgB,resB]=BEM(cr,2);

%[resgB,resB]=optimum(2,1,'T');


%%Graficos para plotar os resultados de cada aerofolio
%cada aerofolio teve as respostas guardadas em variaveis res (resposta local) e
%resg(resposta global).Aqui simplesmente sao plotados em funcao do raio
%adimensional
figure(1);%nova figure
%plot do twist de cada resultado
%plot(r./R,resA.corda./R);
plot(r./R,resA.twist,r./R,resB.twist);
grid on;%tracos pontilhados
title('Pitch x raio');%titulo
xlabel('r/R');%titulo eixo x
ylabel('twist(deg)');%titulo eixo y
%legenda do grafico
legend('optimum','BEM');

% figure(2);
% %plot do fator de inducao tangencial
% plot(r./R,resA.a_l);
% grid on;
% title('fator de inducao tangencial');
% xlabel('r/R');
% ylabel('a_l');
% legend('HS1712');
% 
% figure(3);
% %plot do fator de inducao axial
% plot(r./R,resA.a);
% grid on;
% title('fator de inducao axial');
% xlabel('r/R');
% ylabel('a');
% legend('HS1712');


figure(4);
%plot do numero de Reynolds
plot(r./R,resA.Re,r./R,resB.Re);
grid on;
title('Numero de Reynolds x raio');
xlabel('r/R');
ylabel('Numero de Reynolds*1000');
legend('optimum','BEM');

% 
% figure(5);
% %plot do numero de Mach
% plot(r./R,resA.Ma);
% grid on;
% title('Numero de Mach x raio');
% xlabel('r/R');
% ylabel('Numero de Mach');
% legend('HS1712');

figure(8);
%plot da distribuicao de corda
plot(r./R,resA.corda./R,r./R,resB.corda./R);
title('corda x raio');
xlabel('r/R');
ylabel('c/R');
grid on;
legend('optimum','BEM');


%mostrando os resultados globais de cada aerofolio na tela

disp('Optimum:');
resgA
disp('BEM:');
resgB

% %% teste de perfis
% %chamada da funcao ler_aerof que le a tabela dos dados do aerofolio e
% %extrai os dados
% [alpha,CL,CD,max_CL_CD,alpha_opt,CL_opt,CD_opt]=ler_aerof('xf-naca0015-il-200000.txt');
% % cr=corda_pitch();% chamada da funcao que calcula corda otima (Hansen,2008)
% % [resgA,resA]=BEM(cr);% chamada da funcao que usa o metodo BEM
% [resgA,resA]=optimum()% chamada da funcao que usa o metodo otimo do artigo
% %idem para outro aerofolios
%  [alpha,CL,CD,max_CL_CD,alpha_opt,CL_opt,CD_opt]=ler_aerof('xf-mh114-il-200000.txt');
% % cr=corda_pitch();
% % [resgB,resB]=BEM(cr);
% 
%  [alpha,CL,CD,max_CL_CD,alpha_opt,CL_opt,CD_opt]=ler_aerof('xf-hs1712-il-200000.txt');
% % cr=corda_pitch();
% % [resgC,resC]=BEM(cr);
%  
%  [alpha,CL,CD,max_CL_CD,alpha_opt,CL_opt,CD_opt]=ler_aerof('xf-e854-il-200000.txt');
% % cr=corda_pitch();
% % [resgD,resD]=BEM(cr);
% [resgD,resD]=optimum();
%  [alpha,CL,CD,max_CL_CD,alpha_opt,CL_opt,CD_opt]=ler_aerof('xf-clarky-il-200000.txt');
% % cr=corda_pitch();
% % [resgE,resE]=BEM(cr);
%  [resgE,resE]=optimum();
%  [alpha,CL,CD,max_CL_CD,alpha_opt,CL_opt,CD_opt]=ler_aerof('xf-arad13-il-200000.txt');
% % cr=corda_pitch();
% % [resgF,resF]=BEM(cr);
%  [resgF,resF]=optimum();
%  [alpha,CL,CD,max_CL_CD,alpha_opt,CL_opt,CD_opt]=ler_aerof('xf-naca4415-il-200000.txt');
% % cr=corda_pitch();
% % [resgF,resF]=BEM(cr);
%     
% 
% ir=linspace(3,20,18) ;
% etair=zeros(length(ir),1);
% Tir=zeros(length(ir),1);
% for i=1:1:length(ir)
%    
%         W=(11.1*Kv)/(9.549*ir(i));%velocidade angular da helice
%     lambda=Vo/(W*R);%avanco da helice
%     J=Vo/(W*2*pi*D);%coeficiente de avanco
%     [resgA,resA]=optimum(2,1,'T');
%     etair(i)=resgA.eta;
%     Tir(i)=resgA.Torque;
% end
%     figure(9);
%     plot(etair);
%     figure(10);
%     plot(Tir);
    
%1-MH114
%2-HS1712
%3-NACA4415
%optimum(aerofolio,cte=1 para Re constante/cte=0 para Re iteracao,'T'para
%design na tracao/'P'para desgn na potencia