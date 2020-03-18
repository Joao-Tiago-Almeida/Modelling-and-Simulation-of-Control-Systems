% delete all variables
clear

%constantes
g = 9.8;
m = 1;
l = 0.5;

%cond iniciais
theta1_0 = timeseries(2.5);
theta2_0 = timeseries(1.5);
p1_0 = timeseries(0);
p2_0 = timeseries(0);
%tempo de sim
stop_time = 10;

%sim
sim_out = sim('pendulo');

% settings da figura 1 - theta1/theta2
figure(1);clf; grid on; hold on;
title('Lissajous');xlabel('\theta 1');ylabel('\theta 2');

% theta1/theta 2 plot
plot(sim_out.theta1.Data, sim_out.theta2.Data);

% settings da figura 2 - pendulo duplo
figure(2);clf; grid on;
title('Pendulo Duplo');xlabel('x');ylabel('y');

% pontos característicos do pendulo duplo (a ser [muito] melhorado)
for i = 1:length(sim_out.tout)
    plot(l*sin(sim_out.theta1.Data(i)), -l*cos(sim_out.theta1.Data(i)), '*');
    hold on;
    plot(l*sin(sim_out.theta1.Data(i))+l*sin(sim_out.theta2.Data(i)), -l*cos(sim_out.theta1.Data(i))-l*cos(sim_out.theta2.Data(i)), '*');
    hold off;
    axis([-1 1 -1 1]);
    pause(0.1);
end

    
