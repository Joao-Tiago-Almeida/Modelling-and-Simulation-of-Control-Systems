%delete all variables
clear

massa_ = [30 25 30];
beta_ = [5 5 4];
Vo_ = [-3, 3];
Yo_ = 5;
Yo = timeseries(Yo_);
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
        % i+(j-1)*3 -- increase 1:6 trought i and j
        plotHandlesV(i+(j-1)*3) = plot(sim_out.tout, sim_out.velocity);
        plotLabelsV{i+(j-1)*3}=['massa = ' num2str(massa) 'Kg; coef. atrito = ' num2str(beta) 'Nm/s'];
        figure(2)
        plotHandlesY(i+(j-1)*3) = plot(sim_out.position.Time, sim_out.position.Data);
        plotLabelsY{i+(j-1)*3}=['massa = ' num2str(massa) 'Kg; coef. atrito = ' num2str(beta) 'Nm/s'];
    end
end

%write plot legend
figure(1);
lgdv = legend(plotHandlesV, plotLabelsV, 'Location', 'northeast');
figure(2);
lgdy = legend(plotHandlesY, plotLabelsY, 'Location', 'best');
lgdy.NumColumns = 2;


%draw elips in steady points
figure(1);
elpsv1 = annotation('ellipse',[0.1 .9 .05 .05]);
tav1 = annotation('textarrow', [0.25 0.15], [0.83 0.91]);
tav1.String = 'Vo';
elpsv2 = annotation('ellipse',[0.1 .09 .05 .05]);
tav2 = annotation('textarrow', [0.25 0.15], [0.19 0.13]);
tav2.String = '-Vo';


figure(2);
elpsy = annotation('ellipse',[0.1 .49 .05 .05]);
tay = annotation('textarrow', [0.25 0.15], [0.42 0.5]);
tay.String = 'yo';