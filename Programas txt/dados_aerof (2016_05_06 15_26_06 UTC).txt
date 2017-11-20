function [alpha,CL,CD,CL1,CL2]=dados_aerof(Re,aerofolio)
%1-MH114
%2-HS1712
%3-NACA4415

if(aerofolio==1)
    if((Re>=0) && (Re<100000))
        [alpha2,CL2,CD2]=ler_aerof2('aerof/MH114-100.txt');
        alpha=alpha2;
        CL=CL2.*Re./100000;
        CD=CD2.*Re./100000;
        CL1=zeros(length(CL2),1);
    end
    if((Re>=100000) && (Re<=150000))
        [alpha1,CL1,CD1]=ler_aerof2('aerof/MH114-100.txt');
        [alpha2,CL2,CD2]=ler_aerof2('aerof/MH114-150.txt');
        alpha=alpha2;
        CL=CL2-(CL2-CL1).*((150000-Re)./50000);
        CD=CD2-(CD2-CD1).*((150000-Re)./50000);
    end
    if((Re>150000) && (Re<=200000))
        
        [alpha1,CL1,CD1]=ler_aerof2('aerof/MH114-150.txt');
        [alpha2,CL2,CD2]=ler_aerof2('aerof/MH114-200.txt');
        alpha=alpha2;
        CL=CL2-(CL2-CL1).*((200000-Re)./50000);
        CD=CD2-(CD2-CD1).*((200000-Re)./50000);
    end
    if((Re>200000) && (Re<=250000))
        
        [alpha1,CL1,CD1]=ler_aerof2('aerof/MH114-200.txt');
        [alpha2,CL2,CD2]=ler_aerof2('aerof/MH114-250.txt');
        alpha=alpha2;
        CL=CL2-(CL2-CL1).*((250000-Re)./50000);
        CD=CD2-(CD2-CD1).*((250000-Re)./50000);
    end
    if((Re>250000) && (Re<=300000))
        
        [alpha1,CL1,CD1]=ler_aerof2('aerof/MH114-250.txt');
        [alpha2,CL2,CD2]=ler_aerof2('aerof/MH114-300.txt');
        alpha=alpha2;
        CL=CL2-(CL2-CL1).*((300000-Re)./50000);
        CD=CD2-(CD2-CD1).*((300000-Re)./50000);
    end
    if((Re>300000) && (Re<=350000))
      
        [alpha1,CL1,CD1]=ler_aerof2('aerof/MH114-300.txt');
        [alpha2,CL2,CD2]=ler_aerof2('aerof/MH114-350.txt');
        alpha=alpha2;
        CL=CL2-(CL2-CL1).*((350000-Re)./50000);
        CD=CD2-(CD2-CD1).*((350000-Re)./50000);
    end
    if(Re>350000)
         [alpha1,CL1,CD1]=ler_aerof2('aerof/MH114-300.txt');
        [alpha2,CL2,CD2]=ler_aerof2('aerof/MH114-350.txt');
        alpha=alpha2;
        CL=CL2+(CL2-CL1).*((Re-350000)./50000);
        CD=CD2+(CD2-CD1).*((Re-350000)./50000);
    end
end
if(aerofolio==2)
    if((Re>=0) && (Re<=100000))
        [alpha2,CL2,CD2]=ler_aerof2('aerof/HS1712-100.txt');
        alpha=alpha2;
        CL=CL2.*Re./100000;
        CD=CD2.*Re./100000;
        CL1=zeros(length(CL2),1);
    end
    if((Re>100000) && (Re<=150000))
        [alpha1,CL1,CD1]=ler_aerof2('aerof/HS1712-100.txt');
        [alpha2,CL2,CD2]=ler_aerof2('aerof/HS1712-150.txt');
        alpha=alpha2;
        CL=CL2-(CL2-CL1).*((150000-Re)./50000);
        CD=CD2-(CD2-CD1).*((150000-Re)./50000);
    end
    if((Re>150000) && (Re<=200000))
        
        [alpha1,CL1,CD1]=ler_aerof2('aerof/HS1712-150.txt');
        [alpha2,CL2,CD2]=ler_aerof2('aerof/HS1712-200.txt');
        alpha=alpha2;
        CL=CL2-(CL2-CL1).*((200000-Re)./50000);
        CD=CD2-(CD2-CD1).*((200000-Re)./50000);
    end
    if((Re>200000) && (Re<=250000))
        
        [alpha1,CL1,CD1]=ler_aerof2('aerof/HS1712-200.txt');
        [alpha2,CL2,CD2]=ler_aerof2('aerof/HS1712-250.txt');
        alpha=alpha2;
        CL=CL2-(CL2-CL1).*((250000-Re)./50000);
        CD=CD2-(CD2-CD1).*((250000-Re)./50000);
    end
    if((Re>250000) && (Re<=300000))
        
        [alpha1,CL1,CD1]=ler_aerof2('aerof/HS1712-250.txt');
        [alpha2,CL2,CD2]=ler_aerof2('aerof/HS1712-300.txt');
        alpha=alpha2;
        CL=CL2-(CL2-CL1).*((300000-Re)./50000);
        CD=CD2-(CD2-CD1).*((300000-Re)./50000);
    end
    if((Re>300000) && (Re<=350000))
      
        [alpha1,CL1,CD1]=ler_aerof2('aerof/HS1712-300.txt');
        [alpha2,CL2,CD2]=ler_aerof2('aerof/HS1712-350.txt');
        alpha=alpha2;
        CL=CL2-(CL2-CL1).*((350000-Re)./50000);
        CD=CD2-(CD2-CD1).*((350000-Re)./50000);
    end
    if(Re>350000)
         [alpha1,CL1,CD1]=ler_aerof2('aerof/HS1712-300.txt');
        [alpha2,CL2,CD2]=ler_aerof2('aerof/HS1712-350.txt');
        alpha=alpha2;
        CL=CL2+(CL2-CL1).*((Re-350000)./50000);
        CD=CD2+(CD2-CD1).*((Re-350000)./50000);
    end
end
if(aerofolio==3)
    if((Re>=0) && (Re<=100000))
        [alpha2,CL2,CD2]=ler_aerof2('aerof/NACA 4415-100.txt');
        alpha=alpha2;
        CL=CL2.*Re./100000;
        CD=CD2.*Re./100000;
        CL1=zeros(length(CL2),1);
    end
    if((Re>100000) && (Re<=150000))
        [alpha1,CL1,CD1]=ler_aerof2('aerof/NACA 4415-100.txt');
        [alpha2,CL2,CD2]=ler_aerof2('aerof/NACA 4415-150.txt');
        alpha=alpha2;
        CL=CL2-(CL2-CL1).*((150000-Re)./50000);
        CD=CD2-(CD2-CD1).*((150000-Re)./50000);
    end
    if((Re>150000) && (Re<=200000))
        
        [alpha1,CL1,CD1]=ler_aerof2('aerof/NACA 4415-150.txt');
        [alpha2,CL2,CD2]=ler_aerof2('aerof/NACA 4415-200.txt');
        alpha=alpha2;
        CL=CL2-(CL2-CL1).*((200000-Re)./50000);
        CD=CD2-(CD2-CD1).*((200000-Re)./50000);
    end
    if((Re>200000) && (Re<=250000))
        
        [alpha1,CL1,CD1]=ler_aerof2('aerof/NACA 4415-200.txt');
        [alpha2,CL2,CD2]=ler_aerof2('aerof/NACA 4415-250.txt');
        alpha=alpha2;
        CL=CL2-(CL2-CL1).*((250000-Re)./50000);
        CD=CD2-(CD2-CD1).*((250000-Re)./50000);
    end
    if((Re>250000) && (Re<=300000))
        
        [alpha1,CL1,CD1]=ler_aerof2('aerof/NACA 4415-250.txt');
        [alpha2,CL2,CD2]=ler_aerof2('aerof/NACA 4415-300.txt');
        alpha=alpha2;
        CL=CL2-(CL2-CL1).*((300000-Re)./50000);
        CD=CD2-(CD2-CD1).*((300000-Re)./50000);
    end
    if((Re>300000) && (Re<=350000))
      
        [alpha1,CL1,CD1]=ler_aerof2('aerof/NACA 4415-300.txt');
        [alpha2,CL2,CD2]=ler_aerof2('aerof/NACA 4415-350.txt');
        alpha=alpha2;
        CL=CL2-(CL2-CL1).*((350000-Re)./50000);
        CD=CD2-(CD2-CD1).*((350000-Re)./50000);
    end
    if(Re>350000)
         [alpha1,CL1,CD1]=ler_aerof2('aerof/NACA 4415-300.txt');
        [alpha2,CL2,CD2]=ler_aerof2('aerof/NACA 4415-350.txt');
        alpha=alpha2;
        CL=CL2+(CL2-CL1).*((Re-350000)./50000);
        CD=CD2+(CD2-CD1).*((Re-350000)./50000);
    end
end

end
