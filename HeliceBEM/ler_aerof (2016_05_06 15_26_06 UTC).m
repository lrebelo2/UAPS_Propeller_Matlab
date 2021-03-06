function [alpha,CL,CD,max_CL_CD,alpha_opt,CL_opt,CD_opt]=ler_aerof(filename)
%% funcao que le o arquivo txt (do airfoiltools.com) e gera tabela com os valores
% e calcula maior razao Cl/Cd e coeficientes correspondentes
AERODATA=importdata(filename,' ',12);
alpha=AERODATA.data(:,1);
CL=AERODATA.data(:,2);
CD=AERODATA.data(:,3);
CL_CD=CL./CD;
max_CL_CD=max(CL_CD);
alpha_opt=alpha(CL_CD==max(CL_CD));
CL_opt=CL(CL_CD==max(CL_CD));
CD_opt=CD(CL_CD==max(CL_CD));
end%fim da funcao (retorno automatico)