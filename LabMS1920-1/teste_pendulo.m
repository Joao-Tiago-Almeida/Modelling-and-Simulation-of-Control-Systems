clear; close all;

%constantes físicas
g = 9.8;
m = 1;
l = 0.5;

%constantes
theta1_0 = 3.00;
theta2_0 = -2.5;
p1_0 = 0;
p2_0 = 0;
%tempo de sim
stop_time = 10;
reltol = 1e-6;
figure(7);clf; grid on;
title('Pendulo Duplo');xlabel('x');ylabel('y');

%sim
sim_out = sim('pendulo');

% pendulo duplo plot
for i = 1:length(sim_out.tout)
    % coordenadas x e y dos troços do pendulo
    arm_x = [0 l*sin(sim_out.theta1(i))+[0 l*sin(sim_out.theta2(i))]];
    arm_y = [0 -l*cos(sim_out.theta1(i))+[0 -l*cos(sim_out.theta2(i))]];
    % plot com pausa forçada de 10ms entre posições
    plot(arm_x, arm_y, '-ob', 'LineWidth', 2);
    axis([-1 1 -1 1]);
    pause(0.02);
end