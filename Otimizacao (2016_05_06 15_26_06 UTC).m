clear;
clc;
global V ro PI Cd Af 
%densidade do fluido em kg/m3 (agua)
ro=998.2;
%coeficiente de arrasto
Cd=0.86;
% pi
PI=3.151492;
cnddts=[];
%area  forntal do   sser  humano em   m2
Af=0.09;
%1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0
V=[1.5:0.1:3.0];   
for D=0.01:0.001:0.1
    for n=0:5:600
        final=Calculo(n,D,0);
        eta=final(:,2);
        J=final(:,3);
        Kt=final(:,4);
        Kq=final(:,5);
        T=final(:,8);
        F=final(:,6);
        Pm=final(:,9);
%         for i=1:1:length(V)
            i=6;%2.5 m/s
            Fn=0.5.*ro.*Af.*Cd.*V(i).^2;
            Pn=0.5.*ro.*Af.*Cd.*V(i).^3;
            if((F(i)>Fn)&& (Pm(i)>Pn))
               cnddt=[V(i) eta(i) J(i) Kt(i) Kq(i) T(i) F(i) Pm(i) n D];
               cnddts=[cnddts,cnddt'];
            end
%         end
    end
end
cnddts

% final(i,:)=[V(i) eta Vh Vs J Kt Kq F P T Pm];