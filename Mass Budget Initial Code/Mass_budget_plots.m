clc;clear;close all
deltaV= [590, 85, 835, 95, 760, 20, 100, 560]';
%Data of every configuration
Isp=[310,302,305]';                            %Specific impulse of the choosen propulsion system.
rho_prop=[871,1121,1152]';                    %Density of the choosen propellant.
Mass_tank=[25,25,25]';                         %Mass of the single tank choosed from the shelf. 
Volume_tanks=[0.5,0.5,0.5]';                   %Volume of the single tank choosed from the shelf. 
PROP=[0.77,0.64,0.96];                            %Mass of the propulsion system without tanks.
Adapter=85; Max_launch_Mass=2000;
Wet_Mass=zeros(9,length(Isp));
Prop_Mass=zeros(8,length(Isp));
Dry_Mass=zeros(length(Isp),1);
for i=1:length(Isp)
    [Wet_Mass(:,i),Prop_Mass(:,i),Dry_Mass(i)]=Mass_budget_function(Isp(i),rho_prop(i),...
        Mass_tank(i),Volume_tanks(i),PROP(i),deltaV);
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
lgd=legend([lgd]); title(lgd,'Configuration number:')

%Graphs 1
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
lgd2=legend(lgd2); title(lgd2,'Configuration number:')

%Graph3
figure(3)
y=zeros(length(Isp),2);
for i=1:length(Isp)
    y(i,:)=[Dry_Mass(i) sum(Prop_Mass(:,i))]; 
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
title(lgd,'Mass Type:'); ylim([0,2300]);
xlabel("Configuration/Type of propellant Number"); ylabel("Mass [Kg]")
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(b(1).YData);
text(xtips1,ytips1,labels1,'VerticalAlignment','baseline')
xtips1 = b(2).XEndPoints;
ytips1 = b(2).YEndPoints;
labels1 = string(b(2).YData);
text(xtips1,ytips1,labels1,'VerticalAlignment','baseline')
