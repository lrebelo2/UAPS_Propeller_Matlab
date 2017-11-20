function cr=corda_pitch()
%% funcao que calcula distribuicao de corda otima (Hansen,2008)
%  com equacoes deduzidas para helice (sinal invertido para fatores de
%  inducao)
%  Obs:resultados estranhos para helices maritimas, porem extremamente
%  similares aos resultados do livro

%% chamada de variaveis globais

global  alpha_opt r CL_opt CD_opt Z R Vo W
syms s %criacao de um simbolo para escrever equacao (alias do fator de inducao axial)
x=Vo./(W.*r);%avanco local
% equacoes para x(a),para cada secao de raio(cada secao tem um x)
% aqui s é simbolo para a (afim de nao misturar variaveis sem querer)
eqn= x.^2==(((2-3*s)/(s-1))*(1+((2-3*s)/(s-1))))/(s*(1-s));
a_l=zeros(length(eqn),1);%inicializar

%soluciona todas as equacoes
for i=1:1:length(eqn)
    aux=solve(eqn(i));%a equacao da 4 raizes
    a_l(i)=aux(2);%raiz que nao é imaginario e nao excessivamente alto
end
a=((2-3.*a_l)./(a_l-1));%fator de inducao axial correspondete ao fator de inducao tangencial da equacao

fi=atan((1+a)./((1-a_l).*x));%angulo do escoamento
pitch=fi-degtorad(alpha_opt);%torcao otima
Cn=CL_opt.*cos(fi)+CD_opt.*sin(fi);%Cn com Cl e Cd otimos
f=(Z/2).*((R-r)./(r.*sin(fi)));%fator da correcao de Prandlt (Goldstein)
F=(2/pi).*acos(exp(-f));%fator F da correcao de Prandtl
lmd=1./x;% avanco
cx_R=(8*pi.*a.*x.*sin(fi).^2)./((1+a).*Z.*Cn.*lmd);%corda admensional para todas as secoes
cr=(8*pi.*a.*r.*sin(fi).^2)./((1+a).*Z.*Cn);%corda para todas as secoes

%plota o grafico do resultado da corda
% figure(1);
% title('corda x raio');
% xlabel('r');
% ylabel('c');
% plot(r/R,cr*1000);
% grid on;

end% fima da funcao (retorno é automatico)