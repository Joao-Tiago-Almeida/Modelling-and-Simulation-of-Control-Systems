function plotYY(y,t)
% plot Time Response: y1(t) and y2(t)

figure(); clf; hold on; grid on;
plot(y.simout);
title(t,'FontName','Arial','FontSize',14,'interpreter','latex');
xlabel('Time [s]','FontName','Arial','FontSize',13,'interpreter','latex');
ylabel('State vector','FontName','Arial','FontSize',13,'interpreter','latex');
l = legend('$x_1 = \theta$ [rad]','$x_2 = \dot{\theta}$ [rad/s]','interpreter','latex');
l.FontName = 'Arial';
l.FontSize = 13;
l.Location = 'best';
end