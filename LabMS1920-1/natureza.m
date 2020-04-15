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