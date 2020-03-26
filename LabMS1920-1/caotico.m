% delete all variables
clear

%constantes
g = 9.8;
m = 1;
l = 0.5;

%cond iniciais
theta1_0 = timeseries(0.1);
theta2_0 = timeseries(0.005);
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

% pendulo duplo plot

for i = 1:length(sim_out.tout)
    arm_x = [0 l*sin(sim_out.theta1.Data(i))+[0 l*sin(sim_out.theta2.Data(i))]];
    arm_y = [0 -l*cos(sim_out.theta1.Data(i))+[0 -l*cos(sim_out.theta2.Data(i))]];
    plot(arm_x, arm_y, '-ob', 'LineWidth', 2);
    axis([-1 1 -1 1]);
    pause(0.01);
end

