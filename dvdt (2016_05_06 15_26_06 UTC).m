function  dv=dvdt(v,t)
global P m ro A Cd


dv=(P./m).*(v.^-1)-(0.5*ro*A*Cd/m).*v.^2;

end
