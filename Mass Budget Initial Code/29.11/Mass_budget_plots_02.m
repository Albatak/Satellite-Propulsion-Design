clc;clear;close all
deltaV= [590, 85, 835, 95, 760, 20, 100, 560]';
%Data of every configuration
Isp=[350,350,350,350]';                            %Specific impulse of the chosen propulsion system.
rho_fuel=[871,871,871,871]';                       %Density of the chosen propellant.
rho_ox=[1371,1371,1371,1371];                      %Density of the chosen oxidizer, =0 if none.
mix_ratio=[1.65,1.65,1.65,1.65];                   %Mixture ratio of the engine, =1 if monoprop

Mass_tank=[21,17.5,17.5,17.5]';                    %Mass of the single tank choosed from the shelf. 
Volume_tanks=[0.4,0.198,0.331,0.15]';              %Volume of the single tank choosed from the shelf. 
PROP=[3.6,3.6,3.6,3.6];                        %Mass of the propulsion system without tanks.
Thrust=[425,425,425,425];                              %Thrust of main engine or AC thrusters
Adapter=85; Max_launch_Mass=2600-Adapter;          %Max limit launch mass
Wet_Mass=zeros(9,length(Isp));
Prop_Mass_remain=zeros(9,length(Isp));
Prop_Mass=zeros(8,length(Isp));
Dry_Mass=zeros(length(Isp),1);
Mass_flow_total=zeros(1,length(Isp));
Mass_flow_fuel=zeros(1,length(Isp));
Mass_flow_ox=zeros(1,length(Isp));

for i=1:length(Isp)
    [Wet_Mass(:,i),Prop_Mass(:,i),Dry_Mass(i),Prop_Mass_remain(:,i),time(:,i),Mass_flow_total(:,i),Mass_flow_fuel(:,i),Mass_flow_ox(:,i)]=Mass_budget_function_02(Isp(i),rho_fuel(i),...
        rho_ox(i),mix_ratio(i),Mass_tank(i),Volume_tanks(i),PROP(i),deltaV,Thrust(i));
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

%Graphs 2
figure(2)
y=zeros(length(Isp),4);
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
grid on; title('Fuel mass reduction during the mission');
xlabel('Time of the mission [sec]'); ylabel('Fuel mass remained [Kg]');
lgd=legend(lgd1); title(lgd,'Configuration number:')

%Graf 5
figure(5)
for i=1:length(Isp)
    plot(0:8,time_flow(:,i),LineWidth=1.2); 
    lgd1{i}=sprintf(('%d'),i);
    hold on 
end 
grid on; title('Time spent during the mission');
xlabel('Phase of the mission'); ylabel('Time of the mission [sec]');
lgd=legend(lgd1,"Location","southeast"); title(lgd,'Configuration number:'); xlim([0 length(deltaV)+1]);