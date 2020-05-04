% clear workspace and close all figures
clear; close all

sig = set_signal();
s = set_system();
c = set_controller(5);

sig.y=sim('metron');

%% Schematic system whit multiple blocks
figure(1); clf; hold on; grid on;
plot(sig.y.simout.Time,sig.y.simout.Data(:,1));
xlabel('tempo [s]');
ylabel('$\theta$ [rad]','interpreter', 'latex');
title('Ângulo de movimento do braço do metrónomo');

figure(2); clf; hold on; grid on;
plot(sig.y.simout.Time,sig.y.simout.Data(:,2));
xlabel('tempo [s]');
ylabel('$\dot{\theta}$ [rad]','interpreter', 'latex');
title('Velocidade ângular do braço do metrónomo');



%% Schematic system state-system block
c = set_controller();
sig.y=sim('metron');

figure(3); clf; hold on; grid on;
plot(sig.y.simout.Time,sig.y.simout.Data(:,1));
xlabel('tempo [s]');
ylabel('$\theta$ [rad]','interpreter', 'latex');
title('Ângulo de movimento do braço do metrónomo');

figure(4); clf; hold on; grid on;
plot(sig.y.simout.Time,sig.y.simout.Data(:,2));
xlabel('tempo [s]');
ylabel('$\dot{\theta}$ [rad]','interpreter', 'latex');
title('Velocidade ângular do braço do metrónomo');