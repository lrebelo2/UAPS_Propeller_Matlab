function  dvds=dvds(v,s)
global P m ro A Cd

dvds=(P/m)/v^2-((0.5*ro*A*Cd)/m)*v;
end
