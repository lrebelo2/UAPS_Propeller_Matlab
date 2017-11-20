function Principal
global P m ro A Cd

P=600;
m=90;
ro=998.2;
A=0.09;
Cd=0.86;

srange=0.01:0.01:10;
% trange=[0.001 10];


[s,v]=ode45(@der,srange,0)
figure(1);
plot(s,v);


    function dvds=der(s,v)
        dvds=P/(m.*v.^2)-((0.5*ro*A*Cd)/m).*v;
    end

end