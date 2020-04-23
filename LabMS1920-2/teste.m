%limpeza de variáveis
clear; close all;

s = set_s();

sample_time = 0.001; %1ms

v_t = linspace(-2,2,10001);
v_y = u_impulse(v_t, 1);

figure(1);clf; 
plot(v_t,v_y);
axis([-1.1 1.1 0 1.1]);

[t_ger,u_ger]= u_generator(s,[]);
signal.u = [];

figure(2);clf; 
plot(t_ger,u_ger);

close all


signal.u = timeseries(u_ger',t_ger');

plot(signal.u)

signal.y = sim('disco_rigido','Stoptime', 's.T');

plot(signal.u)
figure(3);clf;
plot(signal.y.tout,signal.y.sim)




%sys = sistema(0,s);

%ausência de atrito


%sys = sistema(0, signal.t, signal.u);


%atrito máximo
%sistema(1,t_ger,u_ger);