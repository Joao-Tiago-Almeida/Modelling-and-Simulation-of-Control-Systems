%limpeza de variáveis
clear; close all;

v_t = linspace(-2,2,10001);
v_y = u_impulse(v_t, 0.25);

figure(1);clf; 
plot(v_t,v_y);
axis([-3 3 0 2]);

[t_ger, u_ger]= u_generator(6, 0.25, 0.5, 2, 3, 3000, 1000);

figure(2);clf; 
plot(t_ger,u_ger);
