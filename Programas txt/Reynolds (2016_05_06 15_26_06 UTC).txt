function [Wc,Re,Cl,Cd,alp,EE]=Reynolds(G,qsi,aerofolio)
global Vo R Z visc lambda

erro=1000000;
Re=100000;
it=0;
%close(figure(2));
while(erro>10000 && it<=5)
    it=it+1;
    [alpha,CL,CD]=dados_aerof(Re,aerofolio);
    jj=find(alpha>=0,1);
    CL=CL(jj:end);
    alpha=alpha(jj:end);
    CD=CD(jj:end); 
    E=CD./CL;
    i=find(E==min(E));
    Cl=CL(i);
    Cd=CD(i);
    alp=alpha(i);
    EE=Cd/Cl;
    Wc=(4*pi*lambda*G*Vo*R*qsi)./(Cl.*Z);%velocidade relativa vezes a corda
    Re_ant=Re;
    Re=Wc/visc;%numero de Reynolds
    erro=abs(Re-Re_ant);
%     figure(2);
%     plot(it,erro,'bo');
%     hold on;
   
end
end