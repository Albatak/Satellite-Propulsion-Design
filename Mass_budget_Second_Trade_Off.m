clc;clear;close all
deltaV= [590, 85, 835, 95, 760, 20, 100, 560]';
%Data of every configuration
%1-S400-15/R-6D; 2-R-42/R-6D; 3-R-4D-15 HiPAT/DST-12 
% 4- LEROS 4/DST-12; 5- LEROS 2b/DST-12; 6- 450N Thruster/22N Thruster; 
Isp=[321, 305, 320.6, 321, 319.5, 329; 
     294, 294, 302,   302, 302,   295];                           
rho_fuel=[878,  878,  878,  878,  878, 1004]';                     
rho_ox=  [1448, 1448, 1430, 1430, 1430, 1430];                         
mix_ratio=[1.65, 1.65, 1.65, 1.65, 1.65, 0.94;
           1.61, 1.61, 1.61, 1.61, 1.61, 0.94];                          
Thrust=[425*2, 890, 445*2, 1000, 420*2,  450*2;
        22*20, 22*20,  22*20, 22*20, 22*20,  22*20];
Mass_tank=ones(6,1)*22.7;                        
Volume_tanks=ones(6,1)*0.331;                 
PROP=[4.3*2,    4.53,   5.44*2,  8.41,  5*2,     5*2;
      0.454*20, 0.454*20, 0.64*20, 0.64*20, 0.64*20, 0.77*20];                      
Adapter=85; Max_launch_Mass=2600-Adapter;     %Max limit launch mass
Wet_Mass=zeros(9,length(Isp));
Prop_Mass_remain=zeros(9,length(Isp));
Prop_Mass=zeros(8,length(Isp));
Dry_Mass=zeros(length(Isp),1);
Volume_propellant=zeros(1,length(Isp));
Volume_fuel=zeros(1,length(Isp));
Volume_ox=zeros(1,length(Isp));
time=zeros(8,length(Isp));
DeltaV_sequence=[1 0 1 1 1 0 0 1];
for i=1:length(Isp)
    [Wet_Mass(:,i),Prop_Mass(:,i),Dry_Mass(i),Prop_Mass_remain(:,i),Volume_fuel(i),Volume_ox(i),time(:,i)]=...
        Mass_budget_function_Second_Trade_Off(Isp(:,i),rho_fuel(i),rho_ox(i),mix_ratio(:,i),...
        Mass_tank(i),Volume_tanks(i),PROP(:,i),deltaV,Thrust(:,i),DeltaV_sequence);
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
saveas(1,"Propellant_used_each_mission_2nd.eps",eps)

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
saveas(2,"Volume_propellant_each_mission_2nd.eps",eps)
    
%Graph 3
figure(3)
c=bar(Index,round(time(3,:)/60,0),0.25); title("Time taken for the Mars orbit Insertion phase")
xtips1 = c(1).XEndPoints;
ytips1 = c(1).YEndPoints;
labels1 = string(c(1).YData);
ylim([0,40]);
yline(30,'r',LineWidth=2); 
legend("Time taken","Time constraint",'Location','northeast');
text(xtips1,ytips1,labels1,'VerticalAlignment','baseline')
xlabel("Configuration/Type of propellant Number"); ylabel("Time [min]")
saveas(3,"Mission_Time_Third_Phase.eps",eps)

%Delete unuseful variables
clear b c i Index labels1 lgd PROP xtips1 y ytips1