
%IT WORKS WITH "Mass_budget_function_Hydrazine_MON_Winner"
%FUNCTION!!!!!!!!!!!

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
%Assumption for modelling
VpropTank=0.5;

%Funtion
[Wet_Mass,Prop_Mass,Dry_Mass,Prop_Mass_remain,Vol_total_fuel,Volume_ox,time,...
    Mass_flow_total_eng,Mass_flow_total_thr,Mass_flow_fuel_eng,Mass_flow_ox_eng,...
    Mass_flow_fuel_thr,Mass_flow_ox_thr]=Mass_budget_function_Hydrazine_MON_Winner(...
    Isp,rho_fuel,rho_ox,mix_ratio,Mass_tank,Volume_tanks,PROP,deltaV,Thrust,DeltaV_sequence);

%%%%%%%%%%%%
%Guessed
Vol_fuel_tank=0.6;  %volume of total fuel tank
Vol_He_press_tank=0.1;
R=2077.1;
Ppr=20*101325; %Pressure of the regulator
Vol_fuel=Vol_total_fuel;
Vol_He_fuel_tank=Vol_fuel_tank-Vol_total_fuel;
Temp_He_fuel_tank=20+273.15;
Temp_He_tank=20+273.15;
Temp_He_pr_out=35+273.15;
Pres_fuel_tank=Ppr;
Pres_He_tank=310*101325;
Mass_fuel=rho_fuel*Vol_total_fuel;
Mass_He_fuel_tank=Ppr*Vol_He_fuel_tank(1)/(R*Temp_He_fuel_tank(1));
Mass_He_press_tank=(Vol_He_press_tank*Pres_He_tank)/(R*Temp_He_tank);

%Preallocations
Mass_fuel_step=zeros(1,1000);
Mass_He_fuel_tank_step=zeros(1,1000);
Mass_He_press_tank_step=zeros(1,1000);
Vol_fuel_step=zeros(1,1000);
Vol_He_fuel_tank_step=zeros(1,1000);
Temp_He_pr_out_step=zeros(1,1000);
Temp_He_fuel_tank_step=zeros(1,1000);
Temp_He_tank_step=zeros(1,1000);
Pres_fuel_tank_step=zeros(1,1000);
Pres_He_tank_step=zeros(1,1000);

for i=1:length(deltaV)
    if DeltaV_sequence(i)==1
        Mass_flow_fuel=Mass_flow_fuel_eng;
    else
        Mass_flow_fuel=Mass_flow_fuel_thr;
    end
    timesteps=(time(i)/1000)*ones(1,1000);
    Mass_fuel_step(1)=Mass_fuel(end);
    Mass_He_fuel_tank_step(1)=Mass_He_fuel_tank(end);
    Mass_He_press_tank_step(1)=Mass_He_press_tank(end);
    Vol_fuel_step(1)=Vol_fuel(end);
    Vol_He_fuel_tank_step(1)=Vol_He_fuel_tank(end);
    Temp_He_fuel_tank_step(1)=35+273.15;
    Temp_He_tank_step(1)=20+273.15; %Assumption given by the professor
    Temp_He_pr_out_step(1)=Temp_He_pr_out(end);
    Pres_fuel_tank_step(1)=Ppr; 
    Pres_He_tank_step(1)=Pres_He_tank(end);  

    for j=2:length(timesteps)+1
        Mass_fuel_out=timesteps(j-1)*Mass_flow_fuel;  %fuel used for the phase
        Mass_fuel_step(j)=Mass_fuel_step(j-1)-Mass_fuel_out;  %remaining fuel mass in fuel tank after the maneuvre
        Vol_fuel_step(j)=Mass_fuel_step(j)/rho_fuel;
        Vol_He_fuel_tank_step(j)=Vol_fuel_tank-Vol_fuel_step(j);

        Pres_fuel_tank_intermediate=Mass_He_fuel_tank_step(j-1)*R*Temp_He_fuel_tank_step(j-1)/Vol_He_fuel_tank_step(j);
        if  Pres_fuel_tank_intermediate<Ppr
            DeltaVol_He=Vol_He_fuel_tank_step(j)-Vol_He_fuel_tank_step(j-1);  %Added helium volume in fuel tank
            Vol_He_fuel_tank_step(j-1)=Mass_He_fuel_tank_step(j-1)*R*Temp_He_fuel_tank_step(j-1)/Ppr;
            Temp_He_pr_out_step(j)=Temp_He_tank_step(j-1)-(-6.2*10^-7)*(Pres_He_tank_step(j-1)-Pres_fuel_tank_intermediate);
            DeltaMass_He_fuel_tank=Ppr*DeltaVol_He/(R*Temp_He_pr_out_step(j));
            Mass_He_fuel_tank_step(j)=Mass_He_fuel_tank_step(j-1)+DeltaMass_He_fuel_tank;

            Temp_He_fuel_tank_step(j)=(Temp_He_pr_out_step(j)*DeltaMass_He_fuel_tank+...
                Temp_He_fuel_tank_step(j-1)*Mass_He_fuel_tank_step(j-1))/(Mass_He_fuel_tank_step(j));
            Pres_fuel_tank_step(j)=Mass_He_fuel_tank_step(j)*R*Temp_He_fuel_tank_step(j)/Vol_He_fuel_tank_step(j);

            Mass_He_press_tank_step(j)=Mass_He_press_tank_step(j-1)-DeltaMass_He_fuel_tank;
            v1=Vol_He_press_tank/Mass_He_press_tank_step(j-1);
            v2=Vol_He_press_tank/Mass_He_press_tank_step(j);

            Temp_He_tank_step(j)=Temp_He_tank_step(j-1)*(v1^(1.66-1))/(v2^(1.66-1));
            Pres_He_tank_step(j)=Pres_He_tank_step(j-1)*(v1^(1.66))/(v2^(1.66));
        else
            DeltaMass_He_fuel_tank=0;
            Temp_He_pr_out_step(j)=20+273.15;
            Mass_He_fuel_tank_step(j)=Mass_He_fuel_tank_step(j-1);
            Temp_He_fuel_tank_step(j)=(Temp_He_pr_out_step(j)*DeltaMass_He_fuel_tank+...
                Temp_He_fuel_tank_step(j-1)*Mass_He_fuel_tank_step(j-1))/(Mass_He_fuel_tank_step(j));            
            Pres_fuel_tank_step(j)=Mass_He_fuel_tank_step(j)*R*Temp_He_fuel_tank_step(j)/Vol_He_fuel_tank_step(j-1);
            Mass_He_press_tank_step(j)=Mass_He_press_tank_step(j-1);
            v1=Vol_He_press_tank/Mass_He_press_tank_step(j-1);
            v2=Vol_He_press_tank/Mass_He_press_tank_step(j);
            Temp_He_tank_step(j)=Temp_He_tank_step(j-1);
            Pres_He_tank_step(j)=Mass_He_press_tank_step(j)*R*Temp_He_tank_step(j)/Vol_He_press_tank;
        end
    end
    Mass_fuel=[Mass_fuel, Mass_fuel_step(2:end)];
    Vol_fuel=[Vol_fuel, Vol_fuel_step(2:end)];
    Vol_He_fuel_tank=[Vol_He_fuel_tank, Vol_He_fuel_tank_step(2:end)];
    Temp_He_pr_out=[Temp_He_pr_out, Temp_He_pr_out_step(2:end)];
    Mass_He_fuel_tank=[Mass_He_fuel_tank, Mass_He_fuel_tank_step(2:end)];
    Mass_He_press_tank=[Mass_He_press_tank, Mass_He_press_tank_step(2:end)];
    Pres_fuel_tank=[Pres_fuel_tank, Pres_fuel_tank_step(2:end)];
    Temp_He_tank=[Temp_He_tank, Temp_He_tank_step(2:end)];
    Pres_He_tank=[Pres_He_tank, Pres_He_tank_step(2:end)];
    Temp_He_fuel_tank=[Temp_He_fuel_tank, Temp_He_fuel_tank_step(2:end)];
end
%%RESULTS
time_flow=zeros(1,length(deltaV)+1);
time_plot=0;
time_flow(1)=0;
for j=1:length(deltaV)
    time_flow(j+1)=sum(time(1:j));
    time_plot_new=linspace(time_flow(j),time_flow(j+1),1000);
    time_plot=[time_plot, time_plot_new];
end

figure(1)
yyaxis left
plot(time_plot,Pres_He_tank/101325,'b')
xlim([0, time_plot(end)]);
ylabel('P He tank [bar]')
xlabel('Time [sec]');
yyaxis right
plot(time_plot,Pres_fuel_tank/101325);
ylim([19, 21.5]);
ylabel('P Fuel tank [bar]')
title('Pressure')

figure(2)
plot(time_plot,Temp_He_tank-273.15,...
    time_plot,Temp_He_pr_out-273.15,...
    time_plot, Temp_He_fuel_tank-273.15);
legend('T He Tank','T PR,Out','T He in Fuel Tank','location','southeast');
xlim([0, time_plot(end)]);
xlabel('Time [sec]');
ylabel('T [°C]')
title('Temperature');

figure(3)
yyaxis left
plot(time_plot,Vol_He_fuel_tank*1000);
ylabel('Volume He in Fuel Tank [l]')
xlabel('Time [sec]');
yyaxis right
plot(time_plot,Vol_fuel*1000);
ylabel('Volume Fuel in Fuel Tank [l]')
xlim([0, time_plot(end)]);
title('Volume')

figure(4)
yyaxis left
plot(time_plot,Mass_He_fuel_tank);
ylabel('Mass He in Fuel Tank [Kg]')
xlabel('Time [sec]');
yyaxis right
plot(time_plot,Mass_fuel);
ylabel('Mass Fuel in Fuel Tank [Kg]')
xlim([0, time_plot(end)]);
title('Mass')