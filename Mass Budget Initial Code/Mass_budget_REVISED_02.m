% THE CODE IS PARTIALLY WRONG: 

% PROBLEM: THE CODE IS RIGHT BUT THE PROBLEM IS THAT WE ARE NOT CONSIDERING
% DURING EACH MANOUVRE THE PROP MASS NEEDED IN THE UPCOMING MANOUVRES WHICH
% SHOULD BE PART OF THE DRY MASS.

% SOLUTION: DEREGISTER FROM THE COURSE. 

clear all
clc

%FIXED DATA
INS=50; AOGNC=40; COM=25; DH=15; MEC=55; TC=15;
DEP_SUR=20; Adapter=85; g0=9.81;

%Guessed data at first iteration (This data are just to prove that the cycle works):
%%%          "list"          %%%
Isp=300;                          %Specific impulse of the choosen propulsion system.
rho_prop=1165;                    %Density of the choosen propellant.
Mass_tank=25; Volume_tanks=0.5;   %Mass and volume of the single tank choosed.
Ppropreq=0;                    %Power needed for the propulsion system.
PROP=100;                         %Mass of the propulsion system without tanks.
Wet_Mass=1000;                    %Just a guess to start the cycle.
deltaV= [590;
85;
835;
95;
760;
20;
100;
560];
deltaV_total = sum(deltaV);

Prop_Mass = zeros(length(deltaV),1);
flag = 2;
n = 0;
while flag>0.01
    PWR=@(Ppropreq) 0.0758*(Ppropreq+500)+37.741;
    STR=@(Wet_Mass) 0.0224*Wet_Mass+27.823;

    Dry_Mass1=INS+AOGNC+COM+PROP+DH+MEC+PWR(Ppropreq)+STR(Wet_Mass)+TC+DEP_SUR; %without harness
    Dry_Mass2=Dry_Mass1+0.1*Dry_Mass1;                                          %with harness
    Dry_Mass3=Dry_Mass2+0.2*Dry_Mass2;                                          %with System Margin

    %DeltaV equation to obtain the Propellant Mass(Prop_Mass), 
    % the Pressurant Mass (Press_Mass) and the tanks Mass:
    for i=1:length(deltaV)
        %%%   CYCLE OPENED   %%% 
        %DeltaV equation to obtain the Propellant Mass(Prop_Mass), 
        Prop_Mass(i)=Dry_Mass3*(exp(deltaV(i)/(Isp*g0))-1); % recalculate wet mass with tank mass
    end
    Prop_Mass_total=sum(Prop_Mass);
    Volume=Prop_Mass_total/rho_prop; %We have maybe to consider some margin (1.05 and 1.2 are just examples)
    tanks_Mass=1.05*1.2*ceil(Volume/Volume_tanks)*Mass_tank;
    Dry_Mass4=Dry_Mass3+tanks_Mass;    
    for i=1:length(deltaV)
        %%%   CYCLE OPENED   %%% 
        %DeltaV equation to obtain the Propellant Mass(Prop_Mass), 
        Prop_Mass(i)=Dry_Mass4*(exp(deltaV(i)/(Isp*g0))-1); % recalculate wet mass with tank mass
    end
    Prop_Mass_total=sum(Prop_Mass);
    Wet_Mass_new=Dry_Mass4+Prop_Mass_total;
    flag=abs(Wet_Mass-Wet_Mass_new);    
    Wet_Mass=Wet_Mass_new;
    n = n+1;
end

Wet_Mass_total = Wet_Mass; % Total wet mass of the spacecraft before any maneuver
Wet_Mass = zeros(length(deltaV)+1,1);
Prop_Mass_remain = zeros(length(deltaV)+1,1);
Prop_Mass_remain(1) = Prop_Mass_total;
Wet_Mass(1) = Wet_Mass_total;
Dry_Mass_total = Dry_Mass4;
%% 
flag=2;
while flag>0.01
    for i=1:length(deltaV)
        %%%   CYCLE OPENED   %%% 
        %DeltaV equation to obtain the Propellant Mass(Prop_Mass), 
        Prop_Mass(i)=Dry_Mass_total*(exp(deltaV(i)/(Isp*g0))-1); % recalculate wet mass with tank mass
        Prop_Mass_remain(i+1) = Prop_Mass_remain(i) - Prop_Mass(i);
        Wet_Mass(i+1)=Wet_Mass(i)-Prop_Mass(i); % Wet mass after the ith maneuver
    end
Prop_Mass_remain(1)=Prop_Mass_remain(1)-Prop_Mass_remain(end);

flag=abs(Prop_Mass_remain(end));
end