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

% workspace do SIMULINKs
movimento
%% Questão 1.5 - Simulação das equações diferenciais
% A constante de tempo $(\tau)$, é definida como sendo o tempo que o
% sistema demora a alcançar 63,2% de resposta estabilizada correspondente
% ao estímulo da função degrau u(t). Na situação do movimento livre da
% viatura $\tau = \frac{m}{\beta}$ [s].

% clear workspace and close all figures
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
title('Variação da velocidade (v) com o tempo (t)');xlabel('Tempo [s]');ylabel('v(t) [m/s]');

% settings da figura 2 - posição
figure(2);clf; grid on; hold on;
title('Variação da posição (y) com o tempo (t)');xlabel('Tempo [s]');ylabel('y(t) [m]');

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
        sim_out = sim('movimento');  % execução da simulação via simulink
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
elpsv2 = annotation('ellipse',[0.0975 .09 .05 .05]);
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
% $y(t) = -\tau \cdot V_o\cdot \exp \Big( \frac{-t}{\tau} \Big) \; [m]$
%
% $v(t) = V_o \cdot \exp \Big( \frac{-t}{\tau} \Big) \; [ms^{-1}]$
% 
% Analisando do ponto de vista físico, um corpo em condições livres demora
% tanto mais tempo a parar quando maior for a sua massa, visto que para a
% mesma velocidade tem mais energia cinética $E = \frac{1}{2} m v^2$. 
% Inversamente, quanto maior for a constante de atrito dinâmico do solo menos demorada
% é a imobilização do corpo. Fica assim claro que tal como previsto
% anteriormente, a constante de tempo está porporcionalmente relacionada com o
% tempo de imobilização do veículo.

% close SIMULINK
close_system

%% 2. Modelo predador-presa - SIMULINK

% workspace do SIMULINK
modelo

%% Questão 2.2 - Simulação das equações diferenciais
% As relações ecológicas são os efeitos que os organismos de uma
% comunidade tem sobre organismos de outras. Foi simulado a relação entre duas espécies
% diferentes com base na abundância de cada uma das populações ($N_o$), a 
% diferença entre a taxa de natalidade e mortalidade ($\delta$) e o impacto que o nível de uma das
% populações tem na taxa de natalidade ou mortalidade da outra ($\alpha$).

% clear workspace and close all figures
clear; close all

% definição das variáveis
delta_1 = [1.5 -3 -1];  alfa1 = 1;  N1_o = 5;   N1o = timeseries(N1_o);
delta_2 = [1 1 -2];     alfa2 = 1;  N2_o = 1;   N2o = timeseries(N2_o);
stop_time = 20;
fig=1;  %first figure of the file
samp_time = 0.01;   %tempo de sim


for i = 1:3                                                                     
    delta1=delta_1(i); delta2=delta_2(i);                                  
    sim_out = sim('modelo','StopTime','4');                     
    figure(fig); clf; fig=fig+1; hold on; grid on; ylim([0 inf]);
    if i < 3
        yyaxis left;
        plot(sim_out.tout,sim_out.N1);
        ylabel('Nível de abundância da população - N_1');
        yyaxis right;
        plot(sim_out.tout,sim_out.N2);
        sgtitle(['Relação ecológica entre duas espécies.   \delta_1 = ' num2str(delta1) '    \delta_2 = ' num2str(delta2)]);
        legend(['Presas N_1(0) = ' num2str(N1_o)], ['Predadores N_2(0) = ' num2str(N2_o)], 'Location', 'north');
        ylabel('Nível de abundância da população - N_2');
    else
        %caso espefício da solução 3
        plot(sim_out.tout,sim_out.N1,'b--',sim_out.tout,sim_out.N2,'b');
        delta2_aux = delta2;
        delta2 = delta2-N1_o;
        sim_out = sim('modelo','StopTime','4');
        plot(sim_out.tout,sim_out.N1,'r--',sim_out.tout,sim_out.N2,'r');
        legend(['Presas (caso 1) N_1(0) = ' num2str(N1_o)], ['Predadores (caso 1) N_2(0) = ' num2str(N2_o)], ...
            ['Presas (caso 2) N_1(0) = ' num2str(N1_o)], ['Predadores (caso 2) N_2(0) = ' num2str(N2_o)], 'Location', 'north');
        sgtitle(['Relação ecológica entre duas espécies.   \delta_1 = ' num2str(delta1) '   \delta_2 = ' num2str(delta2_aux) '(caso 1)   \delta_2 = ' num2str(delta2) '(caso 2)']);
        ylabel('Nível de abundância da população');
    end
    xlabel('Tempo');
end

%%
% Fruto de outras relações ecológicas, na primeira figura a espécie predadadora tem tendência a aumentar independentemente do nível de abundância da presa.
% Assim o nível de abundância dos predadores tende para valores muito grandes, levando à extinção da população das presas. Na segunda figura encontra-se uma
% situação idêntica à anterior. Caso particular que as presas têm tendência natural a desaparecerem (independente da relação ecológica em estudo), logo a sua
% extinção acontece mais rápido, implicando assim um crescimento menos rápido dos predadores.
%
% Na terceira figura, ambas as espécies têm tendência natural a extinguirem-se (taxa de mortalidade superior à taxa de natalidade). Realça-se que ao
% contrário da população das presas que decresce estritamente até à sua extinção, o nílel de predadores pode aumentar consoante a abundância inicial das presas.
% Este caso (1) corresponde à situação em que o módulo da diferença entre as taxas de natalidade e de mortalidade da espécie perdadora é menor que o nível da 
% abundância inicial das presas, $\frac{dN_2}{dt}$ = $N_2\cdot(\delta_2 + N_1)$. No caso contrário (2) $(|\delta_2| < N1o)$, a população das presas tem um decrescimento estrito.


delta_1 = [3 1 3];       N1_o = 5;  N1o = timeseries(N1_o);
delta_2 = [-3 -3 -1];    N2_o = 2;  N2o = timeseries(N2_o);
 
plotHandles = zeros(1,4);   plotLabels = strings(1,4);
for d = 1:3
    delta1 = delta_1(d); delta2 = delta_2(d);
    figure(fig); clf; fig=fig+1; hold on; grid on;
    sgtitle(['Relação ecológica entre duas espécies.   \delta_1 = ' num2str(delta1) '    \delta_2 = ' num2str(delta2)]);
    %solução oscilatória
    sim_out = sim('modelo','StopTime','stop_time/2');                     %simulação  
    p = plot(sim_out.tout,sim_out.N1, '--',sim_out.tout,sim_out.N2); plotHandles(1:2) = p;
    plotLabels(1:2) = {['Presas N_1(0) = ' num2str(N1_o)], ['Predadores  N_2(0) = ' num2str(N2_o)]};       
    %solução estacionária
    N1o = timeseries(-delta2/alfa2); N2o = timeseries(delta1/alfa1);
    sim_out = sim('modelo','StopTime','stop_time/2');                     
    p = plot(sim_out.tout,sim_out.N1, '--',sim_out.tout,sim_out.N2); plotHandles(3:4) = p;
    plotLabels(3:4) = {['Presas N_1(0) = \delta/\alpha = ' num2str(-delta2/alfa2)], ['Predadores  N_2(0) = \delta/\alpha = ' num2str(delta1/alfa1)]};
    l = legend(plotHandles, plotLabels, 'Location', 'best');
    ylabel('Nível de abundância da população');
    xlabel('Tempo');
end

%%
% Na primeira figura, pode ser observada uma solução oscilatória equilibrada, pois há um paralelismo entre os parâmetros de ambas as espécies. Em relação à 
% segunda figura, visto que a capacidade de aumento da espécie das presas diminui, a espécie predadora tem longos períodos com nível de abundância baixo associado
% ao facto da sua elevada tendência para desaparecer, apenas aumentando quando o nível de abundância das presas é elevado. Em relação à terceira figura observa-se
% o oposto da situação anterior, pois neste caso a tendência para os predadores desvanecerem é menor e a capacidade para a população das presas aumentar é maior,
% o que proporciona um período de tempo longo da espécie das presas com um nível de abundância baixo que sofre um aumento significativo apenas quando há um número
% reduzido da espécie prepadora.

%% Questão 2.3 - Modo $(N_1, N_2)$
% Tendo em conta as equações que regem o modelo, simulou-se interdependência das
% variáveis de abundância de cada população ($N_o$).

delta1 = 1; delta2 = -1;
figure(fig); clf; hold on; fig=fig+1; grid on;
sgtitle(['Espaço de fase (N_1,N_2) para \delta_1 = ' num2str(delta1) ' e \delta_2 = ' num2str(delta2)]);
plotHandlesn = zeros(1,7);   plotLabelsn = strings(1,7);
p = plot(delta1/alfa1,-delta2/alfa2,'*'); p.Color='black';  p.LineWidth=1;   %condição de regime estacionário
d = 1; plotHandlesn(d) = p; plotLabelsn(d) = ['Condição estacionárias (N_1,N_2)=(' num2str(-delta2/alfa2) ',' num2str(-delta2/alfa2) ')']; d=d+1;
for i = [3 8]
    for j = [2 5]
        N1o = timeseries(i);    N2o = timeseries(j);
        sim_out = sim('modelo');
        p = plot(sim_out.N1, sim_out.N2);
        plotHandlesn(d) = p; plotLabelsn(d) = ['(N_1,N_2)=(' num2str(i) ',' num2str(j) ')']; d=d+1;
    end
    if i==8 && j==5 %desenho do ponto de equilíbrio 
        N1o = timeseries(j);    N2o = timeseries(i);
        sim_out = sim('modelo');
        p = plot(sim_out.N1, sim_out.N2, 'o');
        plotHandlesn(d) = p; plotLabelsn(d) = ['(N_1,N_2)=(' num2str(j) ',' num2str(i) ')']; d=d+1;
    end
        
end

[n1,n2]=meshgrid(0:1:10, 0:1:10); dn1= delta1.*n1-alfa1.*n1.*n2; dn2= delta2.*n2+alfa2.*n1.*n2;
q = quiver(dn1, dn2); q.LineWidth = 1;
plotHandlesn(d) = q; plotLabelsn(d) = 'Gráfico de velocidade (quiver)';
l = legend(plotHandlesn,plotLabelsn, 'Location', 'best');
xlabel('Nível de abundância da espécie das presas - N_1')
ylabel('Nível de abundância da espécie dos predadores - N_2')


%%
% Analisando a figura anterior observa-se que as soluções em espaços de fase têm um  comportamento em torno do ponto (preto) com as condições estacionárias.
% 
% Também foi estudado o comportamento do sistema para uma amostra de combinações de níveis de abundância, ilustrando assim o desempenho do modelo (quiver).
% 
% É de notar que o gráfico do espaço de fase tem sentido contrário ao dos ponteiros do relógio pois, em regime oscilatório, uma diminuição da população dos
% predadores traduz um aumento da população das presas que por sua vez traduz num aumento da espécie predadora. Este aumento é seguido por um diminuição da espécie
% das presas implicando assim uma diminuição da espécie dos predadores, dando ínicio a um novo ciclo.
% 
% Por último, tendo em conta a simetria do gráfico será de esperar que para condições iniciais trocadas, o resultado obtido esteja a menos de um deslocamento
% temporal, e portanto o comportamento em espaço de fase é igual. O resultado encontra-se pelo traço a verde e os círculos a azul.

%% Questão 2.4 - Upload do ficheiro <presas.mat>
%
% Fez-se o upload de valores reais, definidos pelo enunciado. São conhecidos
% os valores de $\alpha_1$, $\delta_1$, $\delta_2$, $N_1(0)$
%
% Definiu-se as variáveis retornadas pela leitura (yr,tr) globais, de
% modo a estarem acessíveis nos workspaces das funções usadas.

delta2 = -1.5;
delta1 = 3.1;
alfa1 = 1.4;
N1o = timeseries(4);

global yr;global tr;load('presas.mat');

%% Alínea a) - Obtenção do resultado por tentativa e erro
%
% Após se ter carregado o ficheiro: presas.mat, simulou-se um gráfico para
% cada tentativa de variáveis $N_2(0)$ e $\alpha_2$. A sobreposição dos
% dados do ficheiro no gráfico, permitiu que se pudesse estimar, com algum
% erro, uma boa solução.

alfa2 = 0.7;
N2o = timeseries(1.6);

sim_out = sim('modelo');

figure(fig); clf; hold on; grid on; fig=fig+1;
plot(tr, yr, '*', sim_out.tout,sim_out.N1);
legend('pressas.mat','aproximação');
ylabel('Nível de abundância da espécie das presas - N_1'); xlabel('Tempo');


%% Alínea b) - Obtenção do resultado por norma l∞ do vetor de erro
%
% Segundo o enunciado, sendo conhecidos os limites máximo e mínimo do par
% de variáveis $N_2(0)$ e $\alpha_2$, simulou-se o sistema de modo a
% abranger diversas combinações de ambos os valores. O intervalo escolhido
% tem como objetivo mostrar o comportamento da função em torno do minímo
% obtido.
%
% De acordo com o estudado na pergunta 2.3, cada solução tem um conjunto de
% pares $(N_1, N_2)$ próprio e correspondente sentido. No caso desta solução há apenas um valor de
% $N_2(0)$ correspondente a $N_1(0) = 4$ que faz com que as presas aumentem no instante a seguir, e tendo em conta que o efeito
% que uma população tem sobre a outra é constante, conclui-se que a
% solução é única. No entanto para parâmetros ligeiramente diferentes, é de esperar 
% que a função apresentes mínimos locais.

x = linspace(1.5,1.7,30);y = linspace(0.6,0.8,30);z_graph = zeros(length(x),length(y));
total=length(x)*length(y);d=1;
for i = 1:length(x)
    for j = 1:length(y)
        z_graph(j,i) = erro([x(i), y(j)]);  % erro function return the diff between sim and real values for the same instante
        w = waitbar(d/total);d=d+1;
    end
end
w.delete; %close waitbar window
    
figure(fig);clf;fig=fig+1;
surfc(x,y,z_graph);colorbar;colormap(summer);shading flat;                 %draw 3D plot
xlabel('N_2(0)'); ylabel('\alpha_2'); zlabel('l∞');
sgtitle({'Máximo valor absoluto das diferenças entre os valores'; 'monitorizados e os correspondentes valores calculados'})
figure(fig); fig=fig+1;
surfc(x,y,log10(z_graph));colorbar;colormap(hot);shading flat ;            %draw 3D plot
sgtitle({'Máximo valor absoluto das diferenças entre os valores'; 'monitorizados e os correspondentes valores calculados';'escala logorítmica base 10'});
xlabel('N_2(0)'); ylabel('\alpha_2'); zlabel('l∞');

%%
% Analisando a superfície, esta representa um vale, ou seja é sensível a erros pois irá ser convergir para o mínimo global.
% Através deste método não é possível obter o mínimo global extado, visto que visa simular um sistema para valores iniciais definidos à priori. Estimou-se um
% mínimo global da função para as cordenadas ($N_2(0)$, $\alpha_2$) = (1.612,0.706) e l∞ = 0.158.

%% Função erro l∞
% Função que cálcula a diferença máxima entre os valores fornecidos e
% simulados.

type('erro.m')

%% Alínea c) - Obtenção do resultado com recurso a uma função de otimização (fminsearch)
% A função fminsearch, é uma função que permite obter o mínimo de uma
% função multivariável sem recorrer a derivadas da mesma.

xx = linspace(1.55,1.65,3);yy = linspace(0.65,0.75,3);
[val,z_search] = minimos(xx,yy);
[min_value,index]=min(val);
aux = fminsearch(@erro,z_search(index,:)); N2o = timeseries(aux(1)); alfa2 = aux(2);
type('minimos.m');
disp(aux); disp(min(val));
%%
% Através da função fminsearch é possível obter o mínimo de uma função sem recurso à derivada da mesma, este método permite-nos obter um valor muito próximo ou 
% mesmo o ótimo mínimo global da função. O resultado obtido foi $(N_2(0)$, $\alpha_2)$ = (1.6144,0.7047) e l∞ = 0.1558.
%
% Numa tentativa de tentar ilustrar a convergência para outras soluções
% (mínimos locais), segui-se o procedimento anterior (vetor com várias hipóteses 
% para as condições iniciais a descobrir). É apenas apresentado 
% os valores($N_2(0)$, $\alpha_2$) que conduziram a esse mínimo.

% mínimo local
xx = 3;yy = 1.5;
[val,z_search] = minimos(xx,yy);
disp(z_search); disp(min(val));

%%
% O mínimo local obtido encontra-se nas condições $(N_2(0)$, $\alpha_2)$ =
% (4.7514,1.2787) e l∞ = 4.3368.

%% Alínea d) - Validação do modelo 
% Finalmente, simulou-se o sistema com o par de variáveis obtidas através
% da função de otimização e sobrepôs-se com os dados reais.

sim_out = sim('modelo');
figure(fig); hold on; fig=fig+1; grid on;
plot(tr, yr, 'o',sim_out.tout,sim_out.N1);
legend('pressas.mat','fminsearch','Location','best');
ylabel('Nível de abundância da espécie das presas - N_1'); xlabel('Tempo');
sgtitle({'Gráfico da população das presas num ambiente real';'e simulado com recurso à função fminsearch'});

%%

% close SIMULINK
close_system

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

