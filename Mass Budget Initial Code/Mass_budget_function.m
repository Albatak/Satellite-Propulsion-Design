function [Wet_Mass,Prop_Mass,Dry_Mass]=Mass_budget_function(Isp,rho_prop,Mass_tank,Volume_tanks,PROP,deltaV)
%FIXED DATA
INS=50; AOGNC=40; COM=25; DH=15; MEC=55; TC=15;
DEP_SUR=20; g0=9.81;
%Guessed data
Ppropreq=0;                       %Power needed for the propulsion system.
Wet_Mass_guess=1000;              %Just a guess to start the cycle.
Prop_Mass = zeros(length(deltaV),1);          %vector of propellant mass used during each maneuver.
Prop_Mass_total=sum(Prop_Mass);
Prop_Mass_remain = zeros(length(deltaV)+1,1); %vector of propellant mass left after each maneuver.
Prop_Mass_remain(1) = Prop_Mass_total;
Wet_Mass = zeros(length(deltaV)+1,1);         %vector of wet mass left after each maneuver.
Wet_Mass(1) = Wet_Mass_guess;
Wet_Mass_total=Wet_Mass(1);

flag = 2;       %to start the while cycle
n = 0;          %interations counter
while flag>0.1
    PWR=@(Ppropreq) 0.0758*(Ppropreq+500)+37.741;
    STR=@(Wet_Mass_total) 0.0224*Wet_Mass_total+27.823;
    Dry_Mass1=INS+AOGNC+COM+PROP+DH+MEC+PWR(Ppropreq)+STR(Wet_Mass_total)+TC+DEP_SUR; %without harness
    Dry_Mass2=Dry_Mass1+0.1*Dry_Mass1;                                          %with harness
    Dry_Mass3=Dry_Mass2+0.2*Dry_Mass2;                                          %with System Margin

    Volume=Prop_Mass_total/rho_prop; %We have maybe to consider some margin (1.05 and 1.2 are just examples)
    tanks_Mass=1.05*1.2*ceil(Volume/Volume_tanks)*Mass_tank;
    Dry_Mass4=Dry_Mass3+tanks_Mass;  %without any propellant
    %With the cycle we are calculating the propellant mass used during each maneuver.
    %Dry_Mass_prop is the dry mass plus the amount of fuel carried and not
    %used during a certain maneuvres because needed for the rest of the
    %incoming maneuvres.
    for i=1:length(deltaV)
        if i==1                      %first maneuver
            Dry_Mass_prop=Dry_Mass4+Prop_Mass_total-Prop_Mass(1);
        elseif i==length(deltaV)     %last maneuver
            Dry_Mass_prop=Dry_Mass4;
        else                         %every other maneuvers
            Dry_Mass_prop=Dry_Mass4+Prop_Mass_total-sum(Prop_Mass(1:i));
        end
        Prop_Mass(i)=Dry_Mass_prop*(exp(deltaV(i)/(Isp*g0))-1);
        Prop_Mass_remain(i+1) = Prop_Mass_remain(i) - Prop_Mass(i);
        Wet_Mass(i+1)=Wet_Mass(i)-Prop_Mass(i); % Wet mass left after each maneuver
    end
    %At the end of the whole mission:
    Prop_Mass_total=sum(Prop_Mass);
    Wet_Mass_total_new=Dry_Mass4+Prop_Mass_total;
    Wet_Mass(1)=Wet_Mass_total;            %The first element of the vector is the total wet mass at the beginning of the mission
    Prop_Mass_remain(1)=Prop_Mass_total;   %The first element of the vector is the total propellant mass at the beginning of the mission
    flag=abs(Wet_Mass_total-Wet_Mass_total_new);
    Wet_Mass_total=Wet_Mass_total_new;     %to repeat the cycle until it converges.
    n = n+1;                               %interations counter
end
Dry_Mass=Dry_Mass4;

