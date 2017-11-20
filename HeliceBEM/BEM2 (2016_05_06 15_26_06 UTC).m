function BEM2(G)%sem fatores de inducao
global Vo W R  r  alpha CL CD  alpha_opt  Z ro 

pitch=zeros(length(r),1);
pn=zeros(length(r),1);
pt=zeros(length(r),1);
for i=1:1:length(r)
       fi=atan((Vo)/(W*r(i)));
       %f=(Z/2).*((R-r(i))./(r(i).*sin(fi)));
       lmd=Vo/(W*r(i));
       f=(Z/2)*(((lmd^2+1)^0.5)/lmd)*(1-r(i)/R);
       F=(2/pi).*acos(exp(-f));
       pitch(i)=radtodeg(fi)-alpha_opt;
%        alpha_local=radtodeg(fi)-G(i,2);
       alpha_local=radtodeg(fi)-pitch(i);
       ind=find(alpha==alpha_local);
           if(isempty(ind))
               ind=find(alpha==alpha_opt);
           end
       CL_local=CL(ind);
       CD_local=CD(ind);
       Cn=CL_local*cos(fi)+CD_local*sin(fi);
       Ct=CL_local*sin(fi)-CD_local*cos(fi);
       sig=(G(i,3)*Z)/(2*pi*r(i));
   
   Vrel=((Vo)/sin(fi));
   pn(i)=Cn*G(i,3)*0.5*ro*Vrel^2;
   pt(i)=Ct*G(i,3)*0.5*ro*Vrel^2;
end
%% integracao
T=0;
M=0;
for i=1:1:length(r)-1
   AAt=(pn(i+1)-pn(i))/(r(i+1)-r(i)); 
   BBt=(pn(i)*r(i+1)-pn(i+1)*r(i))/(r(i+1)-r(i));
   AAm=(pt(i+1)-pt(i))/(r(i+1)-r(i)); 
   BBm=(pt(i)*r(i+1)-pt(i+1)*r(i))/(r(i+1)-r(i));
   auxt=0.5*AAt*(r(i+1)^2-r(i)^2)+BBt*(r(i+1)-r(i));
   T=T+auxt;
   auxm=(1/3)*AAm*(r(i+1)^3-r(i)^3)+BBm*0.5*(r(i+1)^2-r(i)^2);
   M=M+auxm;
end
T=Z*T
M=Z*M
P=M*W
[r pitch G(:,3)]
end