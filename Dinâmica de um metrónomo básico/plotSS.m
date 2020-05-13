function f = plotSS(y,t)
    % plots Steady-Space: y2(y1)
    % creats new figure if nargin>1

    f = 'none'; % default: no figure 
    
    if nargin > 1
        f = figure(); clf; hold on; grid on;
        title(t,'FontName','Arial','FontSize',14,'interpreter','latex');
        xlabel('$\theta$ [rad]','interpreter', 'latex','FontName','Arial','FontSize',13);
        ylabel('$\dot{\theta}$ [rad/s]','interpreter','latex','FontName','Arial','FontSize',13);
    end
    plot(y.simout.Data(:,1), y.simout.Data(:,2));
    

end