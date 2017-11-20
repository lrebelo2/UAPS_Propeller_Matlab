function [alpha,CL,CD]=ler_aerof2(filename)
%% funcao que le o arquivo txt (do airfoiltools.com) e gera tabela com os valores
alp=zeros(121,1);
res=zeros(121,3);
AERODATA=importdata(filename,' ',11);
alpha=AERODATA.data(:,1);
CL=AERODATA.data(:,2);
CD=AERODATA.data(:,3);
%% normalizar vetores

d=-15;
for i=1:1:120
    
    alp(i)=d;
    d=d+0.25;
end
alp(end)=15;
jj=[];
for i=1:1:length(alp)
    ii=find(alp(i)==alpha);%tem dado?
    if(~isempty(ii))
        jj=i;
        res(i,1)=alp(i);
        res(i,2)=CL(ii);
        res(i,3)=CD(ii);
    else
       %interpola
       if(isempty(jj))
         alphal1=-15;
         Cll1=0;
         Cdl1=0;
       else
       alphal1=alp(jj);
       pp=find(alpha==alp(jj));
       Cll1=CL(pp);%pega do ultimo encontrado
       Cdl1=CD(pp);
       end
       kk=i;%indice em que nao tem dado
       aux=[];
       while(isempty(aux))
           kk=kk+1;
           aux=find(alpha==alp(kk));
           if(~isempty(aux))
              
               Cll2=CL(aux);%pega do proximo conehcido
               Cdl2=CD(aux);
               alphal2=alpha(aux);
           end
       end
       Cl_inter=Cll2-(Cll2-Cll1)*((alphal2-alp(i))/(alphal2-alphal1));
       Cd_inter=Cdl2-(Cdl2-Cdl1)*((alphal2-alp(i))/(alphal2-alphal1));
        res(i,1)=alp(i);
        res(i,2)=Cl_inter;
        res(i,3)=Cd_inter;
    end
    
end
% res2=zeros(121,3);
% for i=1:1:length(alp)
%     ii=find(alpha==alp(i));%tem dado?
%     if(~isempty(ii))
%         jj=ii;
%         res2(i,1)=alp(i);
%         res2(i,2)=CL(ii);
%         res2(i,3)=CD(ii);
%     end
% end
% plot(alp,res(:,2),'r',alp,res2(:,2)-1)
alpha=res(:,1);
CL=res(:,2);
CD=res(:,3);

end%fim da funcao