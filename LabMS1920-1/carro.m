%% Simulação básica em MATLAB(R)/SIMULINK
% Cadeira: Modelação e Simulação 2º Semestre 2019/2020
%
% Trabalho de Laboratório nº 1
%
% Alunos: Daniel Leitão 90042 - João Almeida 90119
%
% Grupo: 2
%
% Turno: Quarta-Feira 8:30-10:30
%
% Docente: Alexandre Bernardino

%% 1. Simulação do movimento livre de uma viatura - SIMULINK

% workspace do SIMULINK
movimento
%% Questão 1.5 - Simulação das equações diferenciais
% A constante de tempo $(\tau)$, é defenida como sendo o tempo que o
% sistema demora a alcançar 63,2\% de resposta estabilizada correspondente
% ao estímulo da função degrau u(t). Na situação do movimento livre da
% viatura $\tau = \frac{m}{\beta} [s]$.

% delete all variables
clear; close all

% definição das variáveis
massa_ = [50 15 15];
beta_ = [5 5 15];
Vo_ = [-3, 3];
Yo_ = 5;
Yo = timeseries(Yo_);
stop_time = 20;

% settings da figura 1 - velocidade
figure(1);clf; grid on; hold on;
title('Variação da velocidade (v) com o tempo (t)');xlabel('t [s]');ylabel('v(t) [m/s]');

% settings da figura 2 - posição
figure(2);clf; grid on; hold on;
title('Variação da posição (y) com o tempo (t)');xlabel('t [s]');ylabel('y(t) [m]');

% criação dos arrays para alojar legendas e plots
plotHandlesV = zeros(1,6);
plotLabelsV = strings(1,6);
plotHandlesY = zeros(1,6);
plotLabelsY = strings(1,6);
cor=['b';'g';'k';'y';'r';'m'];
for i = 1:3 % loop para cada par massa/beta
    
    massa = massa_(i);
    beta = beta_(i);
    
    for j = 1:2 % loop para cada v0 (-3 ou 3 ms^(-1))
        Vo = timeseries(Vo_(j));
        sim_out = sim('movimento','StartTime','0','StopTime',num2str(stop_time), ...
            'FixedStep',num2str(stop_time/100)); % execução da simulaão via simulink
        % i+(j-1)*3 -- increase 1:6 troughout i and j
        % \/ desenho no primeiro plot - velocidade \/
        figure(1) % faz plot e guarda-o conjuntamente com as variáveis
        p = plot(sim_out.tout, sim_out.velocity, cor(2*(i-1)+j)); p.LineWidth = 1; plotHandlesV(i+(j-1)*3)=p;
        plotLabelsV{i+(j-1)*3}=['massa = ' num2str(massa) 'Kg; coef. atrito = ' num2str(beta) 'N/ms^{-1}; \tau = m/\beta = ' num2str(massa/beta) 's'];
        % \/ desenho no segundo plot - posição \/
        figure(2) % faz plot e guarda-o conjuntamente com as variáveis
        p = plot(sim_out.position.Time, sim_out.position.Data, cor(2*(i-1)+j)); p.LineWidth = 1; plotHandlesY(i+(j-1)*3)=p;
        plotLabelsY{i+(j-1)*3}=['massa = ' num2str(massa) 'Kg; coef. atrito = ' num2str(beta) 'N/ms^{-1}; \tau = m/\beta = ' num2str(massa/beta) 's'];
        
        %desafio aula
        
        figure(1); hold on; grid on;
        v_teo = Vo_(j)*exp(-(beta/massa)*sim_out.tout);
        p = plot(sim_out.tout, v_teo, 'o'); p.Color = cor(2*(i-1)+j);
        
        
        figure(2); hold on; grid on;
        y_teo = -(massa/beta)*Vo_(j)*exp(-(beta/massa)*sim_out.tout) + Yo_ + (massa/beta)*Vo_(j);
        p = plot(sim_out.tout, y_teo, 'o'); p.Color = cor(2*(i-1)+j);
        
    end
end

% write plot legend
figure(1);
lgdv = legend(plotHandlesV, plotLabelsV, 'Location', 'northeast');
figure(2);
lgdy = legend(plotHandlesY, plotLabelsY, 'Location', 'northwest');


% draw elipse in steady points
figure(1);
elpsv1 = annotation('ellipse',[0.1 .9 .05 .05]);
tav1 = annotation('textarrow', [0.25 0.15], [0.85 0.91]);
tav1.String = 'Vo';
elpsv2 = annotation('ellipse',[0.1 .09 .05 .05]);
tav2 = annotation('textarrow', [0.25 0.15], [0.17 0.13]);
tav2.String = '-Vo';

% same as above, but for figure 2
figure(2);
elpsy = annotation('ellipse',[0.1 .49 .05 .05]);
tay = annotation('textarrow', [0.25 0.15], [0.52 0.52]);
tay.String = 'yo';

%%
% Sobrepôs-se aos gráficos simulados, os gráficos gerados apartir das
% equações do movimento do carro, obtidas analiticamente:
% 
% $y(t) = -\tau \cdot V_o\cdot \exp \Big( \frac{-t}{-\tau} \Big) \; [m]$ 
% $v(t) = V_o \cdot \exp \Big( \frac{-t}{-\tau} \Big) \; [\frac{m}{s^{-1}}]$
% 
% Analisando do ponto de vista físico, um corpo em condições livres demora
% tanto mais tempo a parar quando maior for a sua massa, visto que para a
% mesma velocidade tem mais energia cinética $E = \frac{1}{2} m v^2$. 
% Inversamente, quanto maior for a constante de atrito do solo menos demorada
% é a imobilização do corpo. Fica assim claro que tal como previsto
% anteriormente, a constante de tempo está porporcionalmente relacionada com o
% tempo de imbolização do veículo.

%%
close_system