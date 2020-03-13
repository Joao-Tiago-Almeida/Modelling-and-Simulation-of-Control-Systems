%delete all variables
clear

massa = 30;
beta = 5;
Vo_ = 3;
Yo_ = 5;
Yo = timeseries(5);
stop_time = 40;


figure(1); clf; grid on; hold on;
figure(2); clf; grid on; hold on;

v_legend_1=['Vo = ' num2str(-Vo_)];
v_legend_2=['Vo = ' num2str(Vo_)];
y_legend_1=['Vo = ' num2str(-Yo_)];
y_legend_2=['Vo = ' num2str(Yo_)];

    
for Vo = [timeseries(-Vo_), timeseries(Vo_)]
    sim_out = sim('movimento');
    figure(1)
    plot(sim_out.tout, sim_out.velocity);
    figure(2)
    plot(sim_out.position.Time, sim_out.position.Data);
end

figure(1);
legend(v_legend_1, v_legend_2, 'Location', 'best'); hold off;
title('Velocity');xlabel('t [s]');ylabel('v(t) [m/s]');
figure(2);
legend(y_legend_1, y_legend_2, 'Location', 'best'); hold off;
title('Position');xlabel('t [s]');ylabel('y(t) [m]')

%Porque é que a v(y), não é linear
figure(3);
plot(sim_out.position.Data, sim_out.velocity);
title('velocity(position)');xlabel('y(t) [m]');ylabel('v(t) [m/s]')
grid on;
%https://www.mathworks.com/help/deeplearning/ref/regression.html
[r,m,b] = regression(sim_out.position.Data', sim_out.velocity');
legend_vy = ['v = ' num2str(m) '*y + ' num2str(b)];
legend(legend_vy, 'Location', 'best'); hold off;
