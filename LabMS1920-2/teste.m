%limpeza de variáveis
clear; close all;

s = set_system();
signal = set_signal(8, 1/3, 0.6, 2, 3, 3000, 1000, 0);
c = set_controller();

v_t = linspace(-2,2,10001);
v_y = u_impulse(v_t, 1);

figure(1);clf; 
plot(v_t,v_y);
axis([-1.1 1.1 0 1.1]);

[t_ger,u_ger]= u_generator(signal);

figure(2);clf; 
plot(t_ger,u_ger);

close all


signal.u = timeseries(u_ger',t_ger');

%signal.y = sim('disco_rigido','Stoptime', 'signal.T');

%signal.ref = steady_signal([2 3 4],[2 -3 4], s.X0(1));

%signal.y = sim('disco_rigido','Stoptime', 's.T');


%% impulsos_sequenciais()

u2_vect = [0.554 1 1 ];
alpha_vect = [1.8 1 0.2];
label_vect = strings(1,3);
signal = set_signal(-1, 0, 0.5, -1, -1, 50, 60, 0);    % set signal \beta and Ns
u_ger = zeros(3,sum(signal.N)-1);
t_ger = zeros(3,sum(signal.N)-1);
t_min = zeros(3,1);

figure();clf; grid on; hold on;

for i = 1:3
    signal = set_signal(-1, alpha_vect(i), 0.5, -1, u2_vect(i), 50, 60, 1);
    t_min(i) = signal.T; % min T , according question 6 
    [t_ger(i,:),u_ger(i,:)] = u_generator(signal);
    label_vect(i) = ['\alpha = ' num2str(alpha_vect(i), '%.2f') '\newline U_1 = ' ...
        num2str(alpha_vect(i)*u2_vect(i), '%.2f') '\newline U_2 = ' num2str(u2_vect(i), '%.2f')];
    plot(t_ger(i,:),u_ger(i,:));
end

axis([0 signal.T -1 1]);
xlabel('tempo [s]');
ylabel('amplitude [.]');
legend(label_vect,'NumColumns', 3, 'Location', 'best');
title('Múltiplos sinais u(t) para \beta contanste (\beta = 0.5) e \alpha variável');

disp(t_min)
%%
close all
figure(1);clf; grid on; hold on;
figure(2);clf; grid on; hold on;

s = set_system(0);
c = set_controller();
c.q = 7; % question
coord = zeros(2,6);
p = zeros(2,3);

for i = 1:3
    signal.u = timeseries(u_ger(i,:)',t_ger(i,:)');
    signal.y = sim('disco_rigido','Stoptime','t_min(i)');
    figure(1)
    p(1,i) = plot(signal.y.y.Time,signal.y.y.Data(:,1));
    coord(1,i) = signal.y.y.Time(end); coord(2,i)=signal.y.y.Data(end,1); % save end point position
    figure(2)
    p(2,i) = plot(signal.y.y.Time,signal.y.y.Data(:,2));
    coord(1,i+3) = signal.y.y.Time(end); coord(2,i+3)=signal.y.y.Data(end,2); % save end point velocity
end

% figure(y1) graph
figure(1);
xlabel('tempo [s]');
ylabel('$y(t) [\mu m]$','interpreter', 'latex');
title('Posição da cabeça de leitura, para diferentes (\alpha ,\beta = 0.5), com atrito b = 0.025');
pp = plot(coord(1,1:3), coord(2,1:3),'k*');
lpp = ['T_{min} = ' num2str(coord(1,1), '%.2f') '\newline T_{min} = ' num2str(coord(1,2), '%.2f') '\newline T_{min} = ' num2str(coord(1,3), '%.2f')];
l = legend([p(1,1:3) pp], [label_vect lpp]);
l.NumColumns =3; l.Location = 'best';

% figure(t2) graph
figure(2);
xlabel('tempo [s]');
ylabel('$\dot{y}(t) [\mu ms^{-1}]$','interpreter', 'latex');
title('Velocidade do braço, para diferentes (\alpha ,\beta = 0.5), com atrito b = 0.025');
pp = plot(coord(1,4:6), coord(2,4:6),'k*');
lpp = ['T_{min} = ' num2str(coord(1,4), '%.2f') '\newline T_{min} = ' num2str(coord(1,5), '%.2f') '\newline T_{min} = ' num2str(coord(1,6), '%.2f')];
l = legend([p(2,1:3) pp], [label_vect lpp]);
l.NumColumns =2; l.Location = 'best';

%%
% simulate ±1 impulses with open loop
s = set_system(0);
c = set_controller();
c.q = 7;    % question
signal = set_signal(-1, 1, 0, 0, 1, 100, 100, 1); % u(t)±1
[t_ger,u_ger] = u_generator(signal);
signal.u=timeseries(u_ger',t_ger');
signal.y = sim('disco_rigido');
u_7 = signal.u;
y1_7 = timeseries(signal.y.y.Data(:,1), signal.y.y.Time);
y2_7 = timeseries(signal.y.y.Data(:,2), signal.y.y.Time);

% close lopp
signal.u=timeseries(0);
c.q = 8; % question
q.ref = timeseries(0);
signal.y = sim('disco_rigido');
u_8 = signal.y.u8;
y1_8 = timeseries(signal.y.y.Data(:,1), signal.y.y.Time);
y2_8 = timeseries(signal.y.y.Data(:,2), signal.y.y.Time);

figure();clf;
p7 = plot(u_7,'--.', 'LineWidth', 2); hold on;
p8 = plot(u_8); grid on;
title('Sinal de controlo com atrito b = 0');
ylabel('$u(t)$','interpreter', 'latex');
xlabel('tempo [s]');
legend([p7 p8],{'Malha aberta','Malha fechada'},'Location', 'best')

figure();clf;
p7 = plot(y1_7,'--', 'LineWidth', 1); hold on;
p8 = plot(y1_8); grid on;
title('Posição da cabeça de leitura com atrito b = 0')
ylabel('$y_1(t) [\mu m]$','interpreter', 'latex');
xlabel('tempo [s]');
legend([p7 p8],{'Malha aberta','Malha fechada'},'Location', 'best')

figure();clf;
p7 = plot(y2_7,'--', 'LineWidth', 1); hold on;
p8 = plot(y2_8); grid on;
title('Velocidade do braço com atrito b = 0')
ylabel('$y_2(t) [\mu ms^{-1}]$','interpreter', 'latex');
xlabel('tempo [s]');
legend([p7 p8],{'Malha aberta','Malha fechada'},'Location', 'best')

%close all
%%
c.q = 10; % question
signal.y = sim('disco_rigido');
u_10 = signal.y.u10;
y1_10 = timeseries(signal.y.y.Data(:,1), signal.y.y.Time);
y2_10 = timeseries(signal.y.y.Data(:,2), signal.y.y.Time);

c.lz = 1; % linear zone only 
signal.y = sim('disco_rigido');
u_10_lzo = signal.y.u10;
y1_10_lzo = timeseries(signal.y.y.Data(:,1), signal.y.y.Time);
y2_10_lzo = timeseries(signal.y.y.Data(:,2), signal.y.y.Time);

figure();clf; hold on; 
plot(u_8);
plot(u_10);
plot(u_10_lzo, '--', 'LineWidth', 0.3); grid on;
title('Sinais de controlo com abordagens diferentes com atrito b = 0')
ylabel('$u(t)$','interpreter', 'latex');
xlabel('tempo [s]');
legend('com chattering','sem chattering', 'ramo superior', 'Location', 'best');

figure();clf; hold on;
plot(y1_8); 
plot(y1_10);
plot(y1_10_lzo, '--', 'LineWidth', 0.3); grid on;
title('Posição da cabeca de leitura com atrito b = 0')
ylabel('$y_1(t) [\mu m]$','interpreter', 'latex');
xlabel('tempo [s]');
legend('com chattering','sem chattering', 'ramo superior', 'Location', 'best');

figure();clf; hold on;
plot(y2_8);
plot(y2_10);
plot(y2_10_lzo, '--', 'LineWidth', 0.3); grid on;
title('Velocidade do braço com atrito b = 0')
ylabel('$y_2(t) [\mu ms^{-1}]$','interpreter', 'latex');
xlabel('tempo [s]');
legend('com chattering','sem chattering', 'ramo superior', 'Location', 'best');
%close all
%%

%%
s = set_system(0.025);
s.T = 8;

c.q = 8; % question
signal.y = sim('disco_rigido');
u_8a = signal.y.u8;
y1_8a = timeseries(signal.y.y.Data(:,1), signal.y.y.Time);
y2_8a = timeseries(signal.y.y.Data(:,2), signal.y.y.Time);

c.q = 10; % question
signal.y = sim('disco_rigido');
u_10a = signal.y.u10;
y1_10a = timeseries(signal.y.y.Data(:,1), signal.y.y.Time);
y2_10a = timeseries(signal.y.y.Data(:,2), signal.y.y.Time);

figure();clf; hold on;
plot(u_8); plot(u_10); plot(u_8a,'--'); plot(u_10a, '--'); grid on;
title('Sinais de controlo com abordagens diferentes com atrito b = 0.025')
ylabel('$u(t)$','interpreter', 'latex');
xlabel('tempo [s]');
legend('com chattering e b = 0','sem chattering e b = 0','com chattering e b = 0.025','sem chattering e b = 0.025','Location', 'best');

figure();clf; hold on;
plot(y1_8); plot(y1_10); plot(y1_8a,'--'); plot(y1_10,'--'); grid on;
title('Posição da cabeça de leitura com atrito b = 0.025')
ylabel('$y_1(t) [\mu m]$','interpreter', 'latex');
xlabel('tempo [s]');
legend('com chattering e b = 0','sem chattering e b = 0','com chattering e b = 0.025','sem chattering e b = 0.025','Location', 'best');

figure();clf;  hold on;
plot(y2_8); plot(y2_10);plot(y2_8a,'--'); plot(y2_10,'--'); grid on;
title('Velocidade do braço com atrito b = 0.025')
ylabel('$y_2(t) [\mu ms^{-1}]$','interpreter', 'latex');
xlabel('tempo [s]');
legend('com chattering e b = 0','sem chattering e b = 0','com chattering e b = 0.025','sem chattering e b = 0.025','Location', 'best');

%%

c.q = 10; % question
c.lz = 0;
c.ref = steady_signal([1 6 7 7],[1.1 -1 2 0], s.X0(1));
signal.y = sim('disco_rigido', 'Stoptime', 'c.ref.Time(end)');
u_10s = signal.y.u10;
y1_10s = timeseries(signal.y.y.Data(:,1), signal.y.y.Time);
y2_10s = timeseries(signal.y.y.Data(:,2), signal.y.y.Time);


figure();clf;
plot(u_10s); grid on;
title('Sinal de controlo com atrito b = 0')
ylabel('$u(t)$','interpreter', 'latex');
xlabel('tempo [s]');
xlim([0 c.ref.Time(end)])

figure();clf;
p1 = plot(y1_10s); hold on;
p2 = plot(c.ref); grid on;
title('Posição da cabeça de leitura com atrito b = 0')
ylabel('$y_1(t) [\mu m]$','interpreter', 'latex');
xlabel('tempo [s]');
legend([p1 p2] , {'Localização da cabeça','sinal de referência'},'Location', 'best');
xlim([0 c.ref.Time(end)])

figure();clf;
plot(y2_10s);  grid on;
title('Velocidade do braço com atrito b = 0')
ylabel('$y_2(t) [\mu ms^{-1}]$','interpreter', 'latex');
xlabel('tempo [s]');
xlim([0 c.ref.Time(end)])
%%
c.q = 10; % question
c.lz = 0;
c.ref = ramps_signal([3 5 8 6],[0.8 -1 0.5 0], s.X0(1));
signal.y = sim('disco_rigido', 'Stoptime', 'c.ref.Time(end)');
u_10r = signal.y.u10;
y1_10r = timeseries(signal.y.y.Data(:,1), signal.y.y.Time);
y2_10r = timeseries(signal.y.y.Data(:,2), signal.y.y.Time);


figure();clf;
plot(u_10r); grid on;
title('Sinal de controlo com atrito b = 0')
ylabel('$u(t)$','interpreter', 'latex');
xlabel('tempo [s]');
xlim([0 c.ref.Time(end)])

figure();clf;
p1 = plot(y1_10r); hold on;
p2 = plot(c.ref); grid on;
title('Posição da cabeça de leitura com atrito b = 0')
ylabel('$y_1(t) [\mu m]$','interpreter', 'latex');
xlabel('tempo [s]');
legend([p1 p2] , {'Localização da cabeça','sinal de referência'},'Location', 'best');
xlim([0 c.ref.Time(end)])

figure();clf;
plot(y2_10r);  grid on;
title('Velocidade do braço com atrito b = 0')
ylabel('$y_2(t) [\mu ms^{-1}]$','interpreter', 'latex');
xlabel('tempo [s]');
xlim([0 c.ref.Time(end)])

%%
% Numa última instância durante a realização do trabalho, sujietou-se o
% último sistema estudado a uma referência não nula. Por outras palavras,
% introduziu-se como referência sinais constantes por troços ou rampas.
% Primeiramente, a aplicação de um sinal constante por troços permite
% destacar a evolução do sistema consoante a distância a que a cabeça de
% leitura se encontra da referência, tendo uma aproximação mais cautelosa à
% medida que esta diminui. Por outro lado, a aplicação de um sinal
% constante por rampas permite concluir facilmente que o braço está sempre
% em movimento e está menos tempo coincidente com o sinal de referência.
% Numa comparação mais direta entre as duas situações, o sinal de entrada
% u(t), é menos atribulado quando a referência é por rampas, visto que à
% uma maior contiudidade face a um sinal de refência em que a derivada no
% tempo entre transições tende para infinito. Relativamente à posição da
% cabeça de leitura, a vantagem de um sinal constante por troços prende-se
% num paragem momentânea da referência, o que permite ao sistema
% aproximar-se muito próximo do pretendido mais rapidamente. No caso de um
% sinal contínuo por rampas, a posição da cabeça de leitura vai variar de
% uma maneira linear para distânicas à referência pequenas, ou seja a sua
% evolução temporal aproxima- -se da evolução do sinal de referência
% deslocada no tempo. Por último, através da comparação dos gráficos de
% velocidade do braço, o sistema submetido a sinais por troços pode ter
% descanso em alguns momentos, situação que não acontece numa situação de
% variação de posição em regime linear. Desta forma é possível concluir que
% para rápidas trasnsições é mais fiável um uso de sinais por troços, porém
% um sistema de variação linear é preferível numa utilização base visto ser
% mais suave. Nota que o sistema com chattering, tornarse-ia melhor num
% seguimento a sinais compostos por rampas, pois permitiria uma deslocação
% temporal entre o sinal de referência e a posição de braço menores.
