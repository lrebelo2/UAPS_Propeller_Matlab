function resg=analise_opt(Vo,res)

R=0.065;
D=2*R;
W=101.7090;
n=16.18748935;
ro=998.2;
Z=4;
r=res.r;
corda=res.corda;
visc=9.7937e-7;
twist=res.twist;
twist=twist.*pi./180;
lambda=Vo./(W.*r);
 [alpha,CL,CD]=dados_aerof(200000,2);
     %truncar em valores positivos
            jj=find(alpha>=0,1);
            CL=CL(jj:end);
            alpha=alpha(jj:end);
            CD=CD(jj:end);
     
    Ct=zeros(length(r),1);
    Cp=zeros(length(r),1);
for i=1:1:length(r)
    eps=r(i)/R;%raio adimensional
    qsi=0; 
    tan_fi=((1+qsi/2)*lambda(i))/eps;
    fi=atan(tan_fi);
    erro_fi=10;
    while(erro_fi>1e-3)
    alp=twist(i)-fi;
    kk=find(alpha>=alp,1);
    Cl=CL(kk);
    Cd=CD(kk);
    Cy=Cl*cos(fi)-Cd*sin(fi);
    Cx=Cl*sin(fi)+Cd*cos(fi);
    K=Cy/(4*sin(fi)^2);
    K_l=Cx/(4*sin(fi)*cos(fi));
    sig=Z*corda(i)/(2*pi*r(i));%solidez local   
    tan_fi_t=tan(fi)*eps;
    fi_t=atan(tan_fi_t);
    f=(Z/2)*(1-eps)/sin(fi_t);
    F=(2/pi)*atan((exp(2*f)-1)^0.5);
    a=(sig*K)/(F-sig*K);
    a_l=(sig*K_l)/(F+sig*K_l);
    if(a>0.7) 
        a=0.7;
    end
    if(a_l>0.7)
        a_l=0.7; 
    end
    if(a<-0.7) 
        a=-0.7 ;
    end
    if(a_l<-0.7) 
        a_l=-0.7; 
    end
    Vrel=(Vo*(1+a))/sin(fi);
    Re=Vrel*corda(i)/visc;
    
    fi_ant=fi;
    fi=atan((Vo*(1+a))/(W*r(i)*(1-a_l)));
    erro_fi=abs(fi_ant-fi);
    end
  
    Ct(i)=(((pi^3)/4)*sig*Cy*eps^3*F^2)/(((F+sig*K_l)*cos(fi))^2);
    Cp(i)=Ct(i)*pi*eps*Cx/Cy;
    
end
%integracao
CT=0;
CP=0;
epsilon=r./R;
for i=1:1:length(epsilon)-1 %para cada intervalo de secao ....
   %aqui se calcula a equacao de reta entre cada intervalo, a integral
   %e se acumula em soma  
   %coeficiente angular tracao
   AAt=(Ct(i+1)-Ct(i))/(epsilon(i+1)-epsilon(i)); 
   %coeficiente linear da tracao
   BBt=(Ct(i)*epsilon(i+1)-Ct(i+1)*epsilon(i))/(epsilon(i+1)-epsilon(i));
   %coeficiente angular do momento
   AAm=(Cp(i+1)-Cp(i))/(epsilon(i+1)-epsilon(i));
   %coeficiente linear do momento
   BBm=(Cp(i)*epsilon(i+1)-Cp(i+1)*epsilon(i))/(epsilon(i+1)-epsilon(i));
   %integral da tracao
   auxt=0.5*AAt*(epsilon(i+1)^2-epsilon(i)^2)+BBt*(epsilon(i+1)-epsilon(i));
   CT=CT+auxt;%acumular soma
   %integral do momento
   auxm=0.5*AAm*(epsilon(i+1)^2-epsilon(i)^2)+BBm*(epsilon(i+1)-epsilon(i));
   CP=CP+auxm;%acumular soma
end%fim da integracao

J=Vo/(n*D);
T=CT*ro*n^2*D^4;
P=CP*ro*n^3*D^5;
eta=CT*J/CP;
data=[Vo T P eta];
%data=dataset({res 'i','r','corda','twist','fi','Cl','L_D','Re','Ma','a','a_l','Vrel'});
resg=dataset({data 'Velocidade','Tracao','Potencia','eta'});
end