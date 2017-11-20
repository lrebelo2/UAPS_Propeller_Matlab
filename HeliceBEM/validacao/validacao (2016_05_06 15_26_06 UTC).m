function validacao()
Vo=161.33;
D=5.75;%1.7526;
R=D/2;
A=pi*R^2;
W=2400/9.549;
R_hub=1/2;
T=207.44;
Cle=0.7;
r=[0.5 0.62 0.74 0.86 0.97 1.09 1.21 1.33 1.45 1.57 1.69 1.81 1.92 2.04 2.16 2.28 2.40 2.52 2.64 2.76 2.87];
ro=1.2922;
[alpha,CL,CD]=dados_aerof(Re,3);
Z=2;
ii=find(CL>=Cle,1);
Cde=CD(ii);
alpe=alpha(ii);
ee=Cde/Cle;
Tc=(2*T)/(ro*(Vo^2)*A);
visc=1.5111e-5;%visc.cinematica
vsom=1450;
lambda=Vo/(W*R);
epse=1-1.386*lambda/Z;
epso=R_hub/R;
zeta=(0.5*Tc)/(epse^2-epso^2);
%zeta=0;
vI1=[];
vI2=[];
erro_zeta=10;
res=zeros(length(r),12);
der=zeros(length(r),4);
while(erro_zeta>1e-3)
    for i=1:1:length(r)
        eps=r(i)/R;
        tg_fi_t=(lambda*(1+zeta/2));%flow angle at the tip
        fi_t=atan(tg_fi_t);
        tg_fi=tg_fi_t/eps;%flow angle at section
        fi=atan(tg_fi);
        f=((Z/2)*(1-eps))/sin(fi_t);
        F=(2/pi)*atan((exp(2*f)-1)^0.5);
        x=eps/lambda;
        G=F*x*cos(fi)*sin(fi);
        Wc=(4*pi*lambda*G*Vo*R*zeta)./(Cl.*Z);
        Re=Wc./visc;
        a=(zeta/2)*cos(1-ee*tan(fi))^2;
        a_l=(zeta/(2*x))*cos(fi)*sin(fi)*(1+ee/tan(fi));
        Vrel=Vo*(1+a)/sin(fi);%Vrel
        c=Wc/Vrel;
        twist=alpe+fi*180/pi;
        L_D=Cle/Cde;
        Ma=Vrel/vsom;
        I1_l=4*eps*G*(1-ee*tan(fi));
        I2_l=lambda*(I1_l/(2*eps))*(1+ee/tan(fi))*sin(fi)*cos(fi);
        J1_l=4*eps*G*(1+ee/tan(fi));
        J2_l=(J1_l/2)*(1-ee*tan(fi))*cos(fi)^2;
        res(i,:)=[i r(i) c twist fi Cle L_D Re Ma a a_l Vrel];
        der(i,:)=[I1_l I2_l J1_l J2_l];
        vI1=[vI1 I1_l];
       % vI2=[vI2 I2_l];
    end
    data=dataset({res 'i','r','corda','twist','fi','Cl','L_D','Re','Ma','a','a_l','Vrel'});
    I1=0;
    I2=0;
    J1=0;
    J2=0;
    %from eps0 to eps1
%     plot(vI1)
%     hold on;
%     plot(r./R,vI2)
    for i=1:1:length(r)-1
        %I1
        AAI1=(der(i+1,1)-der(i,1))/(r(i+1)-r(i));
        BBI1=(der(i,1)*r(i+1)-der(i+1,1)*r(i))/(r(i+1)-r(i));
        auxI1=0.5*AAI1*(r(i+1)^2-r(i)^2)+BBI1*(r(i+1)-r(i));
        I1=I1+auxI1;
        %I2
        AAI2=(der(i+1,2)-der(i,2))/(r(i+1)-r(i));
        BBI2=(der(i,2)*r(i+1)-der(i+1,2)*r(i))/(r(i+1)-r(i));
        auxI2=0.5*AAI2*(r(i+1)^2-r(i)^2)+BBI2*(r(i+1)-r(i));
        I2=I2+auxI2;
        %J1
        AAJ1=(der(i+1,3)-der(i,3))/(r(i+1)-r(i));
        BBJ1=(der(i,3)*r(i+1)-der(i+1,3)*r(i))/(r(i+1)-r(i));
        auxJ1=0.5*AAJ1*(r(i+1)^2-r(i)^2)+BBJ1*(r(i+1)-r(i));
        J1=J1+auxJ1;
        %J2
        AAJ2=(der(i+1,4)-der(i,4))/(r(i+1)-r(i));
        BBJ2=(der(i,4)*r(i+1)-der(i+1,4)*r(i))/(r(i+1)-r(i));
        auxJ2=0.5*AAJ2*(r(i+1)^2-r(i)^2)+BBJ2*(r(i+1)-r(i));
        J2=J2+auxJ2;
    end
    
    zeta_ant=zeta;
%     aux=(I1/(2*I2))^2
%     Tc/I2
    zeta=(I1/(2*I2))-((I1/(2*I2))^2-Tc/I2)^0.5;
    Pc=J1*zeta+J2*zeta^2;
%     zeta=-(J1/(2*J2))+((J1/(2*J2))^2+Pc/J2)^0.5;
%     Tc=I1*zeta-I2*zeta^2;
    erro_zeta=zeta-zeta_ant;
    Tr=Tc*(ro*(Vo^2)*A)*0.5;
 
end
data
end