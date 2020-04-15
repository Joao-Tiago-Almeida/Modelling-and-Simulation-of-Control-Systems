%% 3. Sistema Caótico

% workspace do SIMULINK
pendulo

% clear workspace and close all figures
clear; close all;

% constantes físicas
g = 9.8;
m = 1;
l = 0.5;

%% Questão 3.2 - Curva de Lissajous para ângulos pequenos

%%
% Nesta alínea, procura-se provar que para ângulos iniciais pequenos em módulo, a
% curva definida pelo gráfico ($\theta_1,\theta_2$) exibe um padrão
% bastante peculiar conhecido como curva de Lissajous. Verificaremos não só
% a ocorrência deste padrão, como a sua degeneração à medida que os
% ângulos iniciais aumentam em módulo.
%%
% Código MATLAB

% constantes
theta1_0 = 0;
theta2_0 = 0;
p1_0 = 0;
p2_0 = 0;

% tempo de sim
stop_time = 10;
% tolerancia relativa
reltol = 1e-6;

% array de angulos iniciais
small_th1 = [0.001 -0.006 -0.02 0.5 -0.8 2];
small_th2 = [0.001 0.003 -0.06 0.5 1 4];

for i = 1:6
    % selecao dos angulos iniciais
    theta1_0 = small_th1(i);
    theta2_0 = small_th2(i);
    % sim
    sim_out = sim('pendulo');
    % settings da figura - theta1/theta2
    figure(i);clf; grid on; hold on;
    title(sprintf('Curva para theta1 = %.3f e theta2 = %.3f', theta1_0, theta2_0));
    xlabel('\theta_1 [rad]');ylabel('\theta_2 [rad]');
    % theta1/theta2 plot
    plot(sim_out.theta1, sim_out.theta2);
end

%%
% Apresentam-se seis figuras correspondentes a seis combinações de ângulos cujo
% módulo vai progressivamente aumentando de modo a verificar a degeneração
% da curva de Lissajous. O padrão é bastante nítido nos primeiros quatro casos, onde
% os ângulos iniciais são pequenos. O último caso corresponde à degeneração
% completa, para ângulos iniciais maiores, onde já não é possível identificar um padrão claro como os casos
% anteriores. Verifica-se portanto que a curva de Lissajous só é visível
% se os ângulos iniciais sejam efectivamente pequenos em módulo.

%% Código de Visualização do Pêndulo (extra)

%%
% Para visualização e debug do pêndulo, empregou-se o seguinte código:

type('teste_pendulo.m');

%% Questão 3.4 - Visualização dos tempos de looping por posição - Primeira Parte

%%
% Nesta alínea, o objectivo é fazer uma análise qualitativa dos tempos de
% looping de uma das barras (em relação à posição inicial), por posição.
% Para tal define-se uma grelha de posições (neste caso distam 0.1 unidades uns dos outros na
% direção x e na direção y) e simula-se o sistema por posição caso seja permitido que
% a ponta do pêndulo se situe inicialmente nesse local. Posto isso,
% verifica-se a ocorrência de loop num dos dois ângulos e a primeira
% ocorrência do fenómeno é assinalada, com o seu tempo a ser armazenado para análise
% posterior. Esta análise é efectuada recorrendo a um mapa de cor.
%%
% Código MATLAB

% posicoes possiveis, incrementos de 0.1, meshgrid.
x = linspace(-1,1,21); 
y = linspace(-1,1,21);
[X,Y] = meshgrid(x,y);

% matriz que contera os tempos, inicializada a NaN, alterada mediante
% existencia dos tempos de looping associados a posicao.
T = NaN(length(y),length(x));

d_th1_0 = 0; d_th2_0 = -pi/6; % cond inicial derivadas theta

% tempo de simulacao
stop_time = 250;
% tolerancia relativa
reltol = 1e-4;

for i = 1:numel(T)
    if (X(i)^2 + Y(i)^2 > 1) || (X(i) == 0 && Y(i) == 0)
        continue; % nao se processa casos impossiveis/nao interessantes
    end
    % obter os angulos
    [theta1_0, theta2_0] = pos_to_angles(X(i), Y(i), l);
    % calculo de p1 e p2
    p1_0 = (1/6)*m*(l^2)*(8*d_th1_0+3*d_th2_0*cos(theta1_0-theta2_0));
    p2_0 = (1/6)*m*(l^2)*(2*d_th2_0+3*d_th1_0*cos(theta1_0-theta2_0));
    % simulacao
    sim_out = sim('pendulo');
    for j = 1:length(sim_out.tout) % percorre os dados simulados
        if abs(theta1_0 - sim_out.theta1(j)) > 2*pi || abs(theta2_0 - sim_out.theta2(j)) > 2*pi
            T(i) = sim_out.tout(j); % se encontrar loop, armazena tempo
            break;
        end
    end
end
% settings figura
figure(8);clf; grid on;
% mapa de cor
pcolor(X,Y,log(T));
% barra de cor
colorbar;
% labels
xlabel("Posição x");
ylabel("Posição y");

%%
% Nesta imagem, que exibe o logaritmo dos tempos de loop na forma de escala de cor por posição
% (tons frios - pouco tempo, tons quentes - muito tempo, branco - não ocorrência), é
% possível retirar conclusões importantes quanto à localização inicial da
% ponta do pêndulo e o tempo demorado até uma das barras efectuar um loop
% em torno do ponto inicial. É importante reparar que não ocorre simetria
% perfeita em termos de cor, facto que se deve à imposição de uma
% velocidade angular inicial igual para $\theta_2$ a todos os pontos de partida. Não obstante, verifica-se um
% padrão interessante: para y iniciais muito grandes (suponde que é possível o
% pêndulo partir dessa localização) verifica-se que não ocorre loop, o que é expectável, pois
% nesse caso a energia potencial é mínima. O inverso ocorre para valores de
% y negativos, onde a energia potencial inicial é maior e como tal verifica-se que o tempo
% de loop é bastante pequeno (cor azul escura). Nas pontas, onde se
% extremam os valores de x possíveis para a partida do pêndulo, verifica-se
% que o loop ocorre em instantes mais tardios (tons que fogem do frio), o que se traduz num
% intermédio entre os dois casos referidos anteriormente.
%% Questão 3.4 - Visualização dos tempos de looping por posição - Segunda Parte

%%
% A segunda parte da alínea consiste em demonstrar 3 casos cujos tempos de
% looping se situem em três intervalos distintos, são estes 0-30s, 30-100s
% e 100-250s. Os gráficos assinalam não só o ângulo inicial, mas também o
% instante de cruzamento (rotação de $2\pi$ em qualquer sentido)

d_th1_0 = 0; d_th2_0 = -pi/6; % cond inicial derivadas theta

% tempo de simulacao
stop_time = 250;
% tolerancia relativa
reltol = 1e-6;

% arrays que contem 3 casos
x_test = [-0.8 0.8 0.2];
y_test = [-0.2 0.2 0];

% primeiro caso - x:-0.8 y:-0.2
% loop contido em [0,30]s
%
[theta1_0, theta2_0] = pos_to_angles(x_test(1), y_test(1), l); % obter os angulos
% calculo de p1 e p2
p1_0 = (1/6)*m*(l^2)*(8*d_th1_0+3*d_th2_0*cos(theta1_0-theta2_0));
p2_0 = (1/6)*m*(l^2)*(2*d_th2_0+3*d_th1_0*cos(theta1_0-theta2_0));
% simulacao
sim_out = sim('pendulo');
loop_idx = NaN; % variavel para a posicao do array onde ocorre o loop
loop_theta = NaN; % indicacao para qual angulo o loop ocorreu
for j = 1:length(sim_out.tout) % percorre os dados simulados
    if abs(theta1_0 - sim_out.theta1(j)) > 2*pi % verifica loop theta1
        loop_idx = j; % store do index
        loop_theta = 1; 
        break
    elseif abs(theta2_0 - sim_out.theta2(j)) > 2*pi % verifica loop theta2
        loop_idx = j; % store do index
        loop_theta = 2;
        break
    end
end
figure(9);clf; grid on; hold on;
title('Caso contido em [0, 30]s, x=-0.8 y=-0.2');xlabel('Tempo [s]');ylabel('Ângulo [rad]');
plot_t1 = plot(sim_out.tout, sim_out.theta1);
plot_t2 = plot(sim_out.tout, sim_out.theta2);
if loop_theta == 1 %% dependendo do theta que efectuou o loop, traça linhas
    plot(sim_out.tout(loop_idx), sim_out.theta1(loop_idx), '*r', 'LineWidth', 2);
    yline(theta1_0, '-r', 'LineWidth', 1.5); %% linha y pos inicial 
    yline(theta1_0-2*pi); %% linha y pos inicial -2pi
    yline(theta1_0+2*pi); %% linha y pos inicial +2pi
elseif loop_theta == 2
    plot(sim_out.tout(loop_idx), sim_out.theta2(loop_idx), '*r', 'LineWidth', 2);
    yline(theta2_0, '-r', 'LineWidth', 1.5); 
    yline(theta2_0-2*pi);
    yline(theta2_0+2*pi);
end
legend([plot_t1 plot_t2],{'\theta_1','\theta_2'})
axis([0 30 -15 15]); 
% texto para incluir tempo de loop
dim = [.15 .4 .5 .5]; 
txtbox = annotation('textbox',dim,'String',['t_{loop} = ' num2str(sim_out.tout(loop_idx)) 's'],'FitBoxToText','on');

%%
% Este é o caso (x:-0.8 y:-0.2) em que o primeiro loop em relação aos ângulos iniciais se
% encontra no intervalo 0-30s. As retas pretas
% marcam a distância de $2\pi$ em relação à posição inicial do primeiro
% ângulo, e é a barreira a transpor caso ocorra loop. O cruzamento do gráfico de $\theta_2$
% no local assinalado a vermelho mostra a ocorrência do primeiro loop, que
% é possível verificar que se encontra no intervalo em questão.

% segundo caso - x:0.8 y:0.2
% loop contido em [30,100]s
%
[theta1_0, theta2_0] = pos_to_angles(x_test(2), y_test(2), l); % obter os angulos
% calculo de p1 e p2
p1_0 = (1/6)*m*(l^2)*(8*d_th1_0+3*d_th2_0*cos(theta1_0-theta2_0));
p2_0 = (1/6)*m*(l^2)*(2*d_th2_0+3*d_th1_0*cos(theta1_0-theta2_0));
% simulacao
sim_out = sim('pendulo');
loop_idx = NaN; % variavel para a posicao do array onde ocorre o loop
loop_theta = NaN; % indicacao para qual angulo o loop ocorreu
for j = 1:length(sim_out.tout) % percorre os dados simulados
    if abs(theta1_0 - sim_out.theta1(j)) > 2*pi % verifica loop theta1
        loop_idx = j; % store do index
        loop_theta = 1; 
        break
    elseif abs(theta2_0 - sim_out.theta2(j)) > 2*pi % verifica loop theta2
        loop_idx = j; % store do index
        loop_theta = 2;
        break
    end
end
figure(10);clf; grid on; hold on;
title('Caso contido em [30, 100]s, x=0.8 y=0.2');xlabel('Tempo [s]');ylabel('Ângulo [rad]');
plot_t1 = plot(sim_out.tout, sim_out.theta1);
plot_t2 = plot(sim_out.tout, sim_out.theta2);
if loop_theta == 1 %% dependendo do theta que efectuou o loop, traça linhas
    plot(sim_out.tout(loop_idx), sim_out.theta1(loop_idx), '*r', 'LineWidth', 2);
    yline(theta1_0, '-r', 'LineWidth', 1.5); %% linha y pos inicial 
    yline(theta1_0-2*pi); %% linha y pos inicial -2pi
    yline(theta1_0+2*pi); %% linha y pos inicial +2pi
elseif loop_theta == 2
    plot(sim_out.tout(loop_idx), sim_out.theta2(loop_idx), '*r', 'LineWidth', 2);
    yline(theta2_0, '-r', 'LineWidth', 1.5); 
    yline(theta2_0-2*pi);
    yline(theta2_0+2*pi);
end
legend([plot_t1 plot_t2],{'\theta_1','\theta_2'})
axis([0 100 -15 15]);
% texto para incluir tempo de loop
dim = [.15 .4 .5 .5]; 
txtbox = annotation('textbox',dim,'String',['t_{loop} = ' num2str(sim_out.tout(loop_idx)) 's'],'FitBoxToText','on');

%%
% Neste caso (x:0.8 y:0.2), o primeiro loop ocorre no intervalo 30-100s. Marca-se da
% mesma forma os limites que distam $2\pi$ do ângulo inicial sobre o qual o loop
% é referenciado. No ponto de cruzamento marcado a vermelho, o loop é assinalado.
% É possível portanto, verificar que esse mesmo instante está no intervalo
% referido.

% terceiro caso - x:0.2 y:0
% loop contido em [100,250]s
%
[theta1_0, theta2_0] = pos_to_angles(x_test(3), y_test(3), l); % obter os angulos
% calculo de p1 e p2
p1_0 = (1/6)*m*(l^2)*(8*d_th1_0+3*d_th2_0*cos(theta1_0-theta2_0));
p2_0 = (1/6)*m*(l^2)*(2*d_th2_0+3*d_th1_0*cos(theta1_0-theta2_0));
% simulacao
sim_out = sim('pendulo');
loop_idx = NaN; % variavel para a posicao do array onde ocorre o loop
loop_theta = NaN; % indicacao para qual angulo o loop ocorreu
for j = 1:length(sim_out.tout) % percorre os dados simulados
    if abs(theta1_0 - sim_out.theta1(j)) > 2*pi % verifica loop theta1
        loop_idx = j; % store do index
        loop_theta = 1; 
        break
    elseif abs(theta2_0 - sim_out.theta2(j)) > 2*pi % verifica loop theta2
        loop_idx = j; % store do index
        loop_theta = 2;
        break
    end
end
figure(11);clf; grid on; hold on;
title('Caso contido em [100, 250]s, x=0.2 y=0');xlabel('Tempo [s]');ylabel('Ângulo [rad]');
plot_t1 = plot(sim_out.tout, sim_out.theta1);
plot_t2 = plot(sim_out.tout, sim_out.theta2);
if loop_theta == 1 %% dependendo do theta que efectuou o loop, traça linhas
    plot(sim_out.tout(loop_idx), sim_out.theta1(loop_idx), '*r', 'LineWidth', 2);
    yline(theta1_0, '-r', 'LineWidth', 1.5); %% linha y pos inicial 
    yline(theta1_0-2*pi); %% linha y pos inicial -2pi
    yline(theta1_0+2*pi); %% linha y pos inicial +2pi
elseif loop_theta == 2
    plot(sim_out.tout(loop_idx), sim_out.theta2(loop_idx), '*r', 'LineWidth', 2);
    yline(theta2_0, '-r', 'LineWidth', 1.5); 
    yline(theta2_0-2*pi);
    yline(theta2_0+2*pi);
end
legend([plot_t1 plot_t2],{'\theta_1','\theta_2'})
axis([0 250 -15 15]);
% texto para incluir tempo de loop
dim = [.15 .4 .5 .5]; 
txtbox = annotation('textbox',dim,'String',['t_{loop} = ' num2str(sim_out.tout(loop_idx)) 's'],'FitBoxToText','on');

%%
% O último caso (x:0.2 y:0) incide sobre o intervalo 100-250s. À semelhança dos dois casos anteriores, o loop ocorre também sobre
% $\theta_2$ o que demonstra uma maior facilidade para acontecerem rotações
% completas da parte inferior do pêndulo duplo, o que era de esperar atendendo à mecânica do pêndulo em si. 

% close SIMULINK
close_system
close all
%% Funções
%%
% Função 'rot_pi'
type('rot_pi.m');
%%
% Função 'pos_to_angles'
type('pos_to_angles.m');

