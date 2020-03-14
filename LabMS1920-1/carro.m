%delete all variables
clear

massa_ = [30 25 30];
beta_ = [5 5 4];
Vo_ = [-3, 3];
Yo_ = 5;
Yo = timeseries(5);
stop_time = 25;

figure(1);clf; grid on; hold on;
title('Velocity');xlabel('t [s]');ylabel('v(t) [m/s]');
figure(2);clf; grid on; hold on;
title('Position');xlabel('t [s]');ylabel('y(t) [m]')

plotHandlesV = zeros(1,6);
plotLabelsV = cell(1,6);
plotHandlesY = zeros(1,6);
plotLabelsY = cell(1,6);

for i = 1:3
    
    massa = massa_(i);
    beta = beta_(i);

    for j = [1 2]
        Vo = timeseries(Vo_(j));
        sim_out = sim('movimento');
        figure(1)
        plotHandlesV(i+(j-1)*3) = plot(sim_out.tout, sim_out.velocity);
        plotLabelsV{i+(j-1)*3}=['Vo = ' num2str(Vo_(j)) 'm/s; massa = ' num2str(massa) 'Kg; coef. atrito = ' num2str(beta) 'Nm/s'];
        figure(2)
        plotHandlesY(i+(j-1)*3) = plot(sim_out.position.Time, sim_out.position.Data);
        plotLabelsY{i+(j-1)*3}=['massa = ' num2str(massa) 'Kg; coef. atrito = ' num2str(beta) 'Nm/s'];
    end
end

figure(1);
lgdv = legend(plotHandlesV, plotLabelsV, 'Location', 'best');
figure(2);
lgdy = legend(plotHandlesY, plotLabelsY, 'Location', 'best');
lgdy.NumColumns = 2;