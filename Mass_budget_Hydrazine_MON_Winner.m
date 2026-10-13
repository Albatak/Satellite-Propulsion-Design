clc;clear;close all
deltaV= [590, 85, 835, 95, 760, 20, 100, 560]';
%Data of second trade-off winner configuration, 450N Thruster/22N Thruster;
Isp=[329; 295];
rho_fuel=1004; rho_ox=1430;
mix_ratio=[0.94; 0.94];
Thrust=[450*2; 22*20];
Mass_tank=22.7; Volume_tanks=0.331;
PROP=[5*2; 0.77*20];
Adapter=85; Max_launch_Mass=2600-Adapter;
DeltaV_sequence=[1 0 1 1 1 0 0 1];

%Funtion
[Wet_Mass,Prop_Mass,Dry_Mass,Prop_Mass_remain,Volume_fuel,Volume_ox,time,...
    Mass_flow_total_eng,Mass_flow_total_thr,Mass_flow_fuel_eng,Mass_flow_ox_eng,...
    Mass_flow_fuel_thr,Mass_flow_ox_thr]=...
    Mass_budget_function_Hydrazine_MON_Winner(Isp,rho_fuel,rho_ox,mix_ratio,...
    Mass_tank,Volume_tanks,PROP,deltaV,Thrust,DeltaV_sequence);
Volume_propellant=Volume_ox+Volume_fuel;

%Graphs 1
figure(1)
plot(0:8,Wet_Mass,LineWidth=1.5);
grid on; xlim([0 length(deltaV)+1]); title('Wet Mass reduction during the mission');
xlabel('Phase of the mission'); ylabel('Wet Mass reduction [Kg]');
saveas(1,"Wet_Mass.eps",eps)

%Graphs 2
figure(2)
Index=1:length(deltaV);
b=bar(Index,ceil(Prop_Mass),0.75); grid on;
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(b(1).YData);
text(xtips1,ytips1,labels1,'VerticalAlignment','baseline')
title('Propellant consumed for each phase of the mission');
xlabel('Phase of the mission'); ylabel('Propellant consumed [Kg]');
saveas(2,"Propellant_consumed.eps",eps)

%Graf 3
figure(3)
time_flow=zeros(length(deltaV)+1,1);
for j=1:length(deltaV)
    time_flow(1)=0;
    time_flow(j+1)=sum(time(1:j));
end
plot(time_flow/60,Prop_Mass_remain,LineWidth=1.5);
hold on
grid on; title('Propellant mass reduction during the mission');
xlabel('Time of the mission [min]'); ylabel('Propellant mass remained [Kg]');
saveas(3,"Propellant_Mass_reduction.eps",eps)

%Graf 4
figure(4)
    plot(0:8,time_flow/60,LineWidth=1.5); 
grid on; title('Time spent during the mission');
xlabel('Phase of the mission'); ylabel('Time of the mission [min]');
xlim([0 length(deltaV)+1]);
saveas(4,"Mission_Time.eps",eps) 

%Delete unuseful variables
clear b c j Index labels1 lgd PROP xtips1 y ytips1 Adapter deltaV Isp...
    Mass_tank Max_launch_Mass rho_ox rho_fuel