clc;clear;close all
deltaV= [590, 85, 835, 95, 760, 20, 100, 560]';
%Data of every configuration
%1-MMH/NTO; 2-C2H6O/H2O2(95%); 3-C3H6/N2O;
Isp=[321, 311.4, 278.6; 
     294, 310, 285];                           
rho_fuel=[878,789,611]';                     
rho_ox=[1448,1390,1220];                         
mix_ratio=[1.65, 4.5, 8.85;
           1.65, 4.5, 8.85];                          
Thrust=[425*4, 482*4, 450*4;
        22*20, 22*20, 16.7*20];
Mass_tank=[50, 50, 50]';                        
Volume_tanks=[1.5, 1.5, 1.5]';                  %Mass of the propulsion system without tanks.
PROP=[  4.3*4,      4.3*4,    4.3*4;
       0.45*20,     0.60*20,   0.60*20];                      
Adapter=85; Max_launch_Mass=2600-Adapter;       %Max limit launch mass
Wet_Mass=zeros(9,length(Isp));
Prop_Mass_remain=zeros(9,length(Isp));
Prop_Mass=zeros(8,length(Isp));
Dry_Mass=zeros(length(Isp),1);
Volume_propellant=zeros(1,length(Isp));
DeltaV_sequence=[1 0 1 1 1 0 0 1];
for i=1:length(Isp)
    [Wet_Mass(:,i),Prop_Mass(:,i),Dry_Mass(i),Prop_Mass_remain(:,i),Volume_fuel(i),Volume_ox(i)]=...
        Mass_budget_function_First_Trade_Off(Isp(:,i),rho_fuel(i),rho_ox(i),mix_ratio(:,i),Mass_tank(i),Volume_tanks(i),...
        PROP(:,i),deltaV,Thrust(:,i),DeltaV_sequence);
    Volume_propellant(i)=Volume_ox(i)+Volume_fuel(i);
end

%Graph1
figure(1)
y=zeros(length(Isp),2);
for i=1:length(Isp)
    y(i,:)=[Dry_Mass(i) sum(Prop_Mass(:,i))+Prop_Mass_remain(end,i)]; %adding the prop mass remain at the end of the mission to obtain the total amount of propellant carried.
end 
Index=1:length(Isp);
b=bar(Index,ceil(Wet_Mass(1,:)),0.25); title("Mass comparison of different configurations")
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(b(1).YData);
text(xtips1,ytips1,labels1,'VerticalAlignment','baseline')
hold on
b=bar(Index,ceil(y),1); grid on; yline(Max_launch_Mass,'r',LineWidth=2);
lgd=legend("Wet Mass","Dry Mass","Prop Mass","Max Launch Mass",'Location','eastoutside'); 
title(lgd,'Mass Type:'); ylim([0,3000]);
xlabel("Configuration/Type of propellant Number"); ylabel("Mass [Kg]")
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(b(1).YData);
text(xtips1,ytips1,labels1,'VerticalAlignment','baseline')
xtips1 = b(2).XEndPoints;
ytips1 = b(2).YEndPoints;
labels1 = string(b(2).YData);
text(xtips1,ytips1,labels1,'VerticalAlignment','baseline')
saveas(1,"Propellant_used_each_mission.eps",eps)

%Graph2
figure(2)
y=[Volume_ox',Volume_fuel'];
c=bar(Index,round(Volume_propellant,2),0.25); title("Volume comparison of different configurations")
xtips1 = c(1).XEndPoints;
ytips1 = c(1).YEndPoints;
labels1 = string(c(1).YData);
text(xtips1,ytips1,labels1,'VerticalAlignment','baseline')
hold on
c=bar(Index,round(y,2),1); grid on;
lgd=legend("Volume propellant","Volume oxidizer","Volume fuel",'Location','eastoutside'); 
title(lgd,'Volume Type:'); ylim([0,1.6]);
xlabel("Configuration/Type of propellant Number"); ylabel("Volume [m^3]")
xtips1 = c(1).XEndPoints;
ytips1 = c(1).YEndPoints;
labels1 = string(c(1).YData);
text(xtips1,ytips1,labels1,'VerticalAlignment','baseline')
xtips1 = c(2).XEndPoints;
ytips1 = c(2).YEndPoints;
labels1 = string(c(2).YData);
text(xtips1,ytips1,labels1,'VerticalAlignment','baseline')
saveas(2,"Volume_propellant_each_mission.eps",eps)

%Delete unuseful variables
clear b c i Index j labels1 lgd lgd1 lgd2 PROP xtips1 xtips2 y ytips1