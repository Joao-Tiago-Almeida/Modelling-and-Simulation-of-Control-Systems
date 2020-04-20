%limpeza de variáveis
clear; close all;

Ts = 6;
alfa = 0.5;
beta = 0.5;
U = [2 4];
N = [3e3 1e3];

v_t = linspace(-2,2,10001);
v_y = u_impulse(v_t, 1);

figure(1);clf; 
plot(v_t,v_y);
axis([-1.1 1.1 0 1.1]);

[t_ger, u_ger]= u_generator(Ts, alfa, beta, U(1), U(2), N(1), N(2));

figure(2);clf; 
plot(t_ger, u_ger);

close all

%atrito
b = 0.025;

sistema(b,t_ger,u_ger);
%ausência de atrito
sistema(0,t_ger,u_ger);
%atrito máximo
sistema(1,t_ger,u_ger);