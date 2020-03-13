%delete all variables
clear

alfa1 = 1;
alfa2 = 1;
delta1 = 1;
delta2 = -1;
N1o = timeseries(2);
N2o = timeseries(2);
stop_time = 20;

sim_out = sim('modelo','StartTime','0','StopTime',num2str(stop_time), ...
    'FixedStep',num2str(stop_time/1000));

figure(1)
hold on
plot(sim_out.tout,sim_out.N1,sim_out.tout,sim_out.N2);

a=sim_out.N;

