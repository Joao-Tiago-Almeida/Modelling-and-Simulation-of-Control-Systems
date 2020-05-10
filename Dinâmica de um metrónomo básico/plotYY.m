function f = plotYY(y,t)
    % plots Time Response: y1(t) and y2(t)

    f = figure(); clf; hold on; grid on;
    plot(y.simout);
    title(t,'FontName','Arial','FontSize',14,'interpreter','latex');
    xlabel('Time [s]','FontName','Arial','FontSize',13,'interpreter','latex');
    ylabel('State vector','FontName','Arial','FontSize',13,'interpreter','latex');
    fLegend({'$x_1 = \theta$ [rad]','$x_2 = \dot{\theta}$ [rad/s]'});
end