clc;clear;close all
deltaV= [590, 85, 835, 95, 760, 20, 100, 560]';
%Data of every configuration
%1-MMH/NTO; 2-C2H6O/H2O2(95%); 3-C3H6/N2O;
Isp=[321, 269, 292;
     294, 290, 285];                           
rho_fuel=[871,785,613.9]';                     
rho_ox=[1433,1450,1220];                         
mix_ratio=[1.65, 4.5, 9;
           1.65, 4.5, 8.5];                          
Thrust=[425*4, 482*4, 450*4;
        22*20, 22*20, 19.3*20];
Mass_tank=[50, 50, 50]';                        
Volume_tanks=[1.5, 1.5, 1.5]';                  %Mass of the propulsion system without tanks.
PROP=[  4.3,      4.3,    4.3;
      0.454,   0.532, 0.610]*4;                      
Adapter=85; Max_launch_Mass=2600-Adapter;       %Max limit launch mass
Wet_Mass=zeros(9,length(Isp));
Prop_Mass_remain=zeros(9,length(Isp));
Prop_Mass=zeros(8,length(Isp));
Dry_Mass=zeros(length(Isp),1);
Volume_propellant=zeros(1,length(Isp));
DeltaV_sequence=[1 0 1 1 1 0 0 1];
for i=1:length(Isp)
    [Wet_Mass(:,i),Prop_Mass(:,i),Dry_Mass(i),Prop_Mass_remain(:,i),time(:,i),Mass_flow_total(i),Mass_flow_fuel(i),Mass_flow_ox(i),Volume_fuel(i),Volume_ox(i)]=...
        Mass_budget_function_02(Isp(:,i),rho_fuel(i),rho_ox(i),mix_ratio(:,i),Mass_tank(i),Volume_tanks(i),PROP(:,i),deltaV,Thrust(:,i),DeltaV_sequence);
    Volume_propellant(i)=Volume_ox(i)+Volume_fuel(i);
end

%Graphs 1
figure(1)
for i=1:length(Isp)
    plot(0:8,Wet_Mass(:,i),LineWidth=1.2); 
    lgd{i}=sprintf(('%d'),i);
    hold on 
end 
grid on; xlim([0 length(deltaV)+1]); title('Wet Mass reduction during the mission');
xlabel('Phase of the mission'); ylabel('Wet Mass remained [Kg]');
lgd=legend(lgd); title(lgd,'Configuration number:')
saveas(1,"Wet_Mass.jpg")

%Graphs 2
figure(2)
y=zeros(length(Isp),3);
for i=1:length(deltaV)
    y(i,:)=[Prop_Mass(i,:)];
end
for i=1:length(Isp)
    lgd2{i}=sprintf(('%d'),i);
end 
Index=1:length(deltaV);
bar(Index,ceil(y),1); grid on;
title('Propellant consumed for each phase of the mission');
xlabel('Phase of the mission'); ylabel('Propellant consumed [Kg]');
lgd2=legend(lgd2); title(lgd2,'Configuration number:');
saveas(2,"Propellant_consumed.jpg")

%Graph3
figure(3)
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
saveas(3,"Propellant_used_each_mission.jpg")

%Graf 4
figure(4)    
time_flow=zeros(length(deltaV)+1,length(Isp));
for i=1:length(Isp)
    for j=1:length(deltaV)
        time_flow(1,i)=0;
        time_flow(j+1,i)=sum(time(1:j,i));
    end
    plot(time_flow(:,i),Prop_Mass_remain(:,i),LineWidth=1.2); 
    lgd1{i}=sprintf(('%d'),i);
    hold on 
end 
grid on; title('Propellant mass reduction during the mission');
xlabel('Time of the mission [sec]'); ylabel('Propellant mass remained [Kg]');
lgd=legend(lgd1); title(lgd,'Configuration number:')
saveas(4,"Propellant_Mass_reduction.jpg")

%Graf 5
figure(5)
for i=1:length(Isp)
    plot(0:8,time_flow(:,i),LineWidth=1.2); 
    lgd1{i}=sprintf(('%d'),i);
    hold on 
end 
grid on; title('Time spent during the mission');
xlabel('Phase of the mission'); ylabel('Time of the mission [sec]');
lgd=legend(lgd1,"Location","southeast"); title(lgd,'Configuration number:'); 
xlim([0 length(deltaV)+1]);
saveas(5,"Mission_Time.jpg") 

%Graph6
figure(6)
y=[Volume_ox',Volume_fuel'];
c=bar(Index,round(Volume_propellant,2),0.25); title("Volume comparison of different configurations")
xtips1 = c(1).XEndPoints;
ytips1 = c(1).YEndPoints;
labels1 = string(c(1).YData);
text(xtips1,ytips1,labels1,'VerticalAlignment','baseline')
hold on
c=bar(Index,round(y,2),1); grid on;
lgd=legend("Volume propellant","Volume oxidizer","Volume fuel",'Location','eastoutside'); 
title(lgd,'Volume Type:'); ylim([0,1.5]);
xlabel("Configuration/Type of propellant Number"); ylabel("Volume [m^3]")
xtips1 = c(1).XEndPoints;
ytips1 = c(1).YEndPoints;
labels1 = string(c(1).YData);
text(xtips1,ytips1,labels1,'VerticalAlignment','baseline')
xtips1 = c(2).XEndPoints;
ytips1 = c(2).YEndPoints;
labels1 = string(c(2).YData);
text(xtips1,ytips1,labels1,'VerticalAlignment','baseline')
saveas(6,"Volume_propellant_each_mission.jpg")

%Delete unuseful variables
clear b c i Index j labels1 lgd lgd1 lgd2 PROP xtips1 xtips2 y ytips1
