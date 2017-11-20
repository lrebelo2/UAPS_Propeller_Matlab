[x,y,z,t,p]=dados_aerof(500000,1);
plot(t)
hold on
plot(p,'r')
plot(y,'gr')

%%

[resgA,resA]=optimum(1);
[resgB,resB]=optimum(2);