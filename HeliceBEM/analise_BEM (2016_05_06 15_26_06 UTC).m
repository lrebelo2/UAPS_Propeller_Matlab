function [resglobal,data]=analise_BEM(Vo,res)

cr=res.corda;
twist=res.twist;
r=res.r;


%% funcao que pega os dados do aerofolio e uma distribuicao de corda
%  e aplica o metodo BEM

%% chamada de variaveis globais
global ro visc vsom A 
%inicializacao de matrizes
res=zeros(length(r),12);%armazenagem de resultados das secoes
pitch=zeros(length(r),1);%armazenagem da torcao
pn=zeros(length(r),1);%armazenagem das cargas normais locais
pt=zeros(length(r),1);%armazenagem das cargas tangenciais locais
W=101.7090;
R=0.0650;
Z=4;
ac=0.2;%fator de inducao critico (correcao de Glauert)
[alpha,CL,CD]=dados_aerof(200000,2);
 %truncar em valores positivos
            jj=find(alpha>=0,1);
            CL=CL(jj:end);
            alpha=alpha(jj:end);
            CD=CD(jj:end);
            E=CL./CD;
            %achar o minimo Cd/Cl e colher os dados correspondentes
            opt=find(E==max(E));
            CL_local=CL(opt);
            CD_local=CD(opt);
            alpha_opt=alpha(opt);
            EE=CD_local/CL_local;
            
%% 
for i=1:1:length(r) %% para cada secao...
a=0;%iniciar fator de inducao axial
a_l=0;%iniciar fator de inducao tangencial
erro_a=1;% iniciar erro do fator de inducao axial
erro_a_l=1;% iniciar erro do fator de inducao tangencial

   while((erro_a>1e-9)&&(erro_a_l>1e-9))%enquanto erro de ambos os fatores for maior do que a tolerancia
       fi=atan(((1+a)*Vo)/((1-a_l)*W*r(i)));%angulo do escoamento relativo a pa
       x=Vo/(W*r(i));%avanco local
       
       %fator f de Prandtl(resulta em valores imaginarios no matlab)
       %f=(Z/2).*((R-r(i))./(r(i).*sin(fi)));
       
       %fator f corrigo por Goldstein (resulta em valores reais)
       f=(Z/2)*(((x^2+1)^0.5)/x)*(1-r(i)/R);
       F=(2/pi).*acos(exp(-f));%fator F da correcao de Prandtl
       %f=((Z/2)*(1-eps))/sin(fi);%fator f da correcao de Prandtl de acordo com o artigo
       %F=(2/pi)*atan((exp(2*f)-1)^0.5);%fator F de Prandtl recomendado pelo artigo
       %torcao para manter angulo de ataque local no angulo ótimo do aerofolio
       
       %calculo dos Coeficientes normal e tangencial
       alpha_local=radtodeg(fi)-twist(i);
       kk=find(alpha>=alpha_local,1);
       CL_local=CL(kk);
       CD_local=CD(kk);
       Cn=CL_local*cos(fi)+CD_local*sin(fi);
       Ct=CL_local*sin(fi)-CD_local*cos(fi);
       %solidez local
       sig=(cr(i)*Z)/(2*pi*r(i));
       %guardar valores antigos dos fatores
       a_ant=a;
       a_l_ant=a_l;
       %calcular novo fator de inducao axial aplicando correcao de Glauert
       a=1/(((4*F*sin(fi)^2)/(sig*Cn))-1);
           if(abs(a)>ac)
               K=(4*F*sin(fi)^2)/(sig*Cn);
               a=0.5*(2+K*(1-2*ac)-((K*(1-2*ac)+2)^2+4*(K*ac^2-1))^0.5);
           end
       %calcular novo fator de inducao tangencial
       a_l=1/(((4*F*sin(fi)*cos(fi))/(sig*Ct))+1);
       %calcular erros
       erro_a=abs(a-a_ant);
       erro_a_l=abs(a_l-a_l_ant);
   end %fim do laço while (iteracao dos fatores de inducao)
  
   Vrel=((Vo*(1+a))/sin(fi));%velocidade relativa a pa
   pn(i)=Cn*cr(i)*0.5*ro*Vrel^2;%carga normal local
   pt(i)=Ct*cr(i)*0.5*ro*Vrel^2;%carga tangencial local
   Re=(Vrel*cr(i))/visc;%numero de Reynolds
   Ma=Vrel/vsom;%numero de Mach
   L_D=CL_local/CD_local;
   %armazenar resultados de cada secao
   res(i,:)=[i r(i) cr(i) pitch(i) fi CL_local L_D Re/1000 Ma a a_l Vrel];
   
end% fim do calculo para cada secao
%% integracao
% iniciar tracao e momento
T=0;
M=0;

for i=1:1:length(r)-1 %para cada intervalo de secao ....
   %aqui se calcula a equacao de reta entre cada intervalo, a integral
   %e se acumula em soma  
   %coeficiente angular tracao
   AAt=(pn(i+1)-pn(i))/(r(i+1)-r(i)); 
   %coeficiente linear da tracao
   BBt=(pn(i)*r(i+1)-pn(i+1)*r(i))/(r(i+1)-r(i));
   %coeficiente angular do momento
   AAm=(pt(i+1)-pt(i))/(r(i+1)-r(i));
   %coeficiente linear do momento
   BBm=(pt(i)*r(i+1)-pt(i+1)*r(i))/(r(i+1)-r(i));
   %integral da tracao
   auxt=0.5*AAt*(r(i+1)^2-r(i)^2)+BBt*(r(i+1)-r(i));
   T=T+auxt;%acumular soma
   %integral do momento
   auxm=(1/3)*AAm*(r(i+1)^3-r(i)^3)+BBm*0.5*(r(i+1)^2-r(i)^2);
   M=M+auxm;%acumular soma
end%fim da integracao
%% parametros globais
T=Z*T;%tracao total
M=Z*M;%momento total
P=M*W;%potencia requerida
Pc=P/((ro*(Vo^3)*A)*0.5);%potencia requerida
Tc=T/((ro*(Vo^2)*A)*0.5);%tracao desenvolvida pela helice
u1=((2*T/(ro*A))+Vo^2)^0.5;%velocidade de saida (disco atuador)
u=0.5*(Vo+u1);%veloidade na helice (disco atuador)
eta_t=1/(1+(u1-Vo)/(2*Vo));%eficiencia teorica (disco atuador)
eta=Tc/Pc;%efficiencia real
dltP=T/A;%diferenca de pressao entre a helice

%armazenar resultados globais
auto=(3.6/(P/11.1)*120);
res1=[T M P eta_t eta Vo u u1 dltP auto];
resglobal=dataset({res1 'Tracao','Torque','Potencia','eta_t','eta','V','u','u1','dltP','Autnm'});
data=dataset({res 'i','r','corda','twist','fi','Cl','L_D','Re','Ma','a','a_l','Vrel'});

end%fim da funcao (retorno é automatico)

