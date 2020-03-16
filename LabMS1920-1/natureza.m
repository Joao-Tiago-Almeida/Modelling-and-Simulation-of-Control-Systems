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

%modo (N1, N2)
figure(2); hold on; axis([-1 12 -1 12])
for i = [3]
    for j = [2]
        N1o = timeseries(i);
        N2o = timeseries(j);
        sim_out = sim('modelo','StartTime','0','StopTime', ...
            num2str(stop_time),'FixedStep',num2str(stop_time/1000));
        plot(sim_out.N1, sim_out.N2);
    end
end

%2.4-resultados próximos dos reais
delta1 = 3.1;
alfa1 = 1.4;
N1o = timeseries(4);
load('presas.mat')
%parâmetros da formula dos predadores
delta2 = -1.5;
alfa2 = 0.7;
N2o = timeseries(1.6);

sim_out = sim('modelo','StartTime','0','StopTime',num2str(stop_time), ...
    'FixedStep',num2str(0.1));

figure(3); hold on;
plot(tr, yr, '*');
plot(sim_out.tout,sim_out.N1);
legend('pressas.mat','aproximação');

axis([0 4 0 5])

close all

%é suposto mandar o yr?
erro([5 6], yr)

