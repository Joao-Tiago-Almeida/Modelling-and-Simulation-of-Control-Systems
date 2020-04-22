%limpeza de variáveis
clear; close all;

s = struct('Name', 'Disco Rígido');
s.alfa = 0.5;
s.beta = 0.5;
s.U = [2 4];
s.N = [6e3 1e3];

% $T_{minimo}$ calculado através das expressões da alínea 6
s.T = max([sqrt(2*(1+s.beta)*(1+s.alfa)), sqrt(2*(1+s.beta)*(1+s.alfa)/s.alfa)]);

v_t = linspace(-2,2,10001);
v_y = u_impulse(v_t, 1);

figure(1);clf; 
plot(v_t,v_y);
axis([-1.1 1.1 0 1.1]);

[t_ger, u_ger]= u_generator(s,[]);

figure(2);clf; 
plot(t_ger, u_ger);

close all

%atrito
b = 0.025;

%sys = sistema(b,t_ger,u_ger);

%ausência de atrito

[t_ger,u_ger] = u_generator(s,'o'); %sistena equilibrado em termos de pontos

sys = sistema(0, t_ger,u_ger);


%atrito máximo
%sistema(1,t_ger,u_ger);