clear all
clc

p0=10^-10;     % ambient pressure (bar)
%p0=0; 
g=1.1352;      % small gamma
pc=15;         % chamber pressure (bar)
c=1581.86;     % c_star
G=sqrt(g)*(2/(g+1))^((g+1)/(2*(g-1)));        % big gamma
f=@(Pe) (G./sqrt( (2*g/(g-1)).*( (Pe./pc).^(2/g)-(Pe./pc).^((g+1)/g))))-330;
pe=fzero(f,0.002) % exit pressure (bar)

Cf=@(pe) sqrt((2*g/(g-1))*(1-(pe/pc)^((g-1)/g)))*G+330*(pe/pc-p0/pc);
Cf=Cf(pe)
Isp=c*Cf/9.81