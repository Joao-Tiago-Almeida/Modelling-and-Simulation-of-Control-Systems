function plotSS(y,t)
% plot Steady-Space: y2(y1)

figure(); clf; hold on; grid on;
plot(y.simout.Data(:,1), y.simout.Data(:,2));
title(t,'FontName','Arial','FontSize',14,'interpreter','latex');
xlabel('$\theta$ [rad]','interpreter', 'latex','FontName','Arial','FontSize',13);
ylabel('$\dot{\theta}$ [rad/s]','interpreter','latex','FontName','Arial','FontSize',13);

end