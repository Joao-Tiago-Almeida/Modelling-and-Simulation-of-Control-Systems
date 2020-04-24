%limpeza de variáveis
clear; close all;

s = set_s();
signal = set_signal();

v_t = linspace(-2,2,10001);
v_y = u_impulse(v_t, 1);

figure(1);clf; 
plot(v_t,v_y);
axis([-1.1 1.1 0 1.1]);

[t_ger,u_ger]= u_generator(s,[]);


figure(2);clf; 
plot(t_ger,u_ger);

close all


signal.u = timeseries(u_ger',t_ger');

signal.y = sim('disco_rigido','Stoptime', 's.T');

signal.ref = steady_signal([2 3 4],[2 -3 4], s.X0(1));

%signal.y = sim('disco_rigido','Stoptime', 's.T');
