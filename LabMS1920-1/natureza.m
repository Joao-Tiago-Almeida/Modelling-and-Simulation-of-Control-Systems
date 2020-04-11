%% 2. Modelo predador-presa - SIMULINK

% workspace do SIMULINK
modelo

%% Questão 2.2 - Simulação das equações diferenciais

% delete all variables
clear; close all

% definição das variáveis
delta_1 = [1.5 -3 -1];                  alfa1 = 1;  N1_o = 5;               N1o = timeseries(N1_o);
delta_2 = [1 1 -2];     global alfa2;   alfa2 = 1;  N2_o = 1;   global N2o; N2o = timeseries(N2_o);
stop_time = 20;
fig=1; %first figure of the file


for i = 1:3                                                                     
    delta1=delta_1(i); delta2=delta_2(i);                                  
    sim_out = sim('modelo','StartTime','0','StopTime',num2str(4));                     
    figure(fig); clf; fig=fig+1; hold on; grid on; ylim([0 inf]);
    if i < 3
        yyaxis left;
        plot(sim_out.tout,sim_out.N1);
        ylabel('Nível de abundância da população - N_1');
        yyaxis right;
        plot(sim_out.tout,sim_out.N2);
        sgtitle(['Relação ecológica.   \delta_1 = ' num2str(delta1) ';    \delta_2 = ' num2str(delta2)]);
        legend(['Presas N_1(0) = ' num2str(N1_o)], ['Predadores N_2(0) = ' num2str(N2_o)], 'Location', 'north');
        ylabel('Nível de abundância da população - N_2');
    else                                                                    %caso espefício da solução 3
        plot(sim_out.tout,sim_out.N1,'b--',sim_out.tout,sim_out.N2,'b');
        delta2_aux = delta2;
        delta2 = delta2-N1_o;
        sim_out = sim('modelo','StartTime','0','StopTime',num2str(4));
        plot(sim_out.tout,sim_out.N1,'r--',sim_out.tout,sim_out.N2,'r');
        legend(['Presas (caso 1) N_1(0) = ' num2str(N1_o)], ['Predadores (caso 1) N_2(0) = ' num2str(N2_o)], ...
            ['Presas (caso 2) N_1(0) = ' num2str(N1_o)], ['Predadores (caso 2) N_2(0) = ' num2str(N2_o)], 'Location', 'north');
        sgtitle(['Relação ecológica.   delta_1 = ' num2str(delta1) ';(caso 1)   \delta_2 = ' num2str(delta2_aux) ';(caso 2)   \delta_2 = ' num2str(delta2)]);
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
% contrário da população das presas que decresce estritamente até à sua extinção, o níel de predadores pode aumentar consoante a abundância inicial das presas.
% Este caso (1) corresponde à situação em que o módulo da diferença entre as taxas de natalidade e de mortalidade da espécie perdadora é menor que o nível da 
% abundância inicial das presas, dN2/dt = N2(delta2+N1). No caso contrário (2) (|delta2|<N1o), a população das presas tem um decrescimento estrito.


delta_1 = [3 1 3];       N1_o = 5;  N1o = timeseries(N1_o);
delta_2 = [-3 -3 -1];    N2_o = 2;  N2o = timeseries(N2_o);
 
plotHandles = zeros(1,4);   plotLabels = strings(1,4);
for d = 1:3
    delta1 = delta_1(d); delta2 = delta_2(d);
    figure(fig); clf; fig=fig+1; hold on; grid on;
    sgtitle(['Relação ecológica.   \delta_1 = ' num2str(delta1) ';    \delta_2 = ' num2str(delta2)]);
    %solução oscilatória
    sim_out = sim('modelo','StartTime','0','StopTime','stop_time/2');                     %simulação  
    p = plot(sim_out.tout,sim_out.N1, '--',sim_out.tout,sim_out.N2); plotHandles(1:2) = p;
    plotLabels(1:2) = {['Presas N_1(0) = ' num2str(N1_o)], ['Predadores  N_2(0) = ' num2str(N2_o)]};       
    %solução estacionária
    N1o = timeseries(-delta2/alfa2); N2o = timeseries(delta1/alfa1);
    sim_out = sim('modelo','StartTime','0','StopTime','stop_time/2');                     
    p = plot(sim_out.tout,sim_out.N1, '--',sim_out.tout,sim_out.N2); plotHandles(3:4) = p;
    plotLabels(3:4) = {['Presas N_1(0) = \delta/\alpha = ' num2str(-delta2/alfa2)], ['Predadores  N_2(0) = \delta/\alpha = ' num2str(delta1/alfa1)]};
    l = legend(plotHandles, plotLabels, 'Location', 'best');
    %l.NumColumns = 2;
end

%%
% Na primeira figura, pode ser observada uma soluação oscilatória equilibrada, pois há um paralelismo entre os parâmetros de ambas as espécies. Em relação à 
% segunda figura, visto que a capacidade de aumento de espécie das presas diminui, a espécie prepadora tem longos períodos com nível de abundância baixo associado
% ao facto da sua elevada tendência para desaparecer, apenas aumentando quando o nível de abundância das presas é elevado. Em relação à terceira figura observa-se
% o oposto da situação anterior pois neste caso a tendência para as presas desvanecerem é menor e a capacidade para a população das presas aumentar é maior,
% proporciona um período de tempo longo da espécie das presas com um nível de abundância baixo que sofre um aumento significativo apenas quando há um número
% reduzido da espécie prepadora.

%% Questão 2.3 - Modo (N1, N2)

delta1 = 1; delta2 = -1;
figure(fig); clf; hold on; fig=fig+1; grid on;
sgtitle(['Espaço de fase (N_1,N_2) para \delta_1 = ' num2str(delta1) ' e \delta_2 = ' num2str(delta2)]);
plotHandlesn = zeros(1,7);   plotLabelsn = strings(1,7);
p = plot(delta1/alfa1,-delta2/alfa2,'*'); p.Color='black';  p.LineWidth=1;   %condição de regime estacionário
d = 1; plotHandlesn(d) = p; plotLabelsn(d) = ['Condição estacionárias (N_1,N_2)=(' num2str(-delta2/alfa2) ',' num2str(-delta2/alfa2) ')']; d=d+1;
for i = [3 8]
    for j = [2 5]
        N1o = timeseries(i);    N2o = timeseries(j);
        sim_out = sim('modelo','StartTime','0','StopTime', num2str(stop_time));
        p = plot(sim_out.N1, sim_out.N2);
        plotHandlesn(d) = p; plotLabelsn(d) = ['(N_1,N_2)=(' num2str(i) ',' num2str(j) ')']; d=d+1;
    end
    if i==8 && j==5
        N1o = timeseries(j);    N2o = timeseries(i);
        sim_out = sim('modelo','StartTime','0','StopTime', num2str(stop_time));
        p = plot(sim_out.N1, sim_out.N2,'o');
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

%% Questão 2.4 - Upload do ficheiro <preasas.mat>

% valores próprios do estudo, definidos pelo enunciado
delta1 = 3.1;
alfa1 = 1.4;
N1o = timeseries(4);

global yr;global tr;load('presas.mat');

%% Alínea a) - Obtenção do resultado por tentativa e erro
%
% Após se ter carrgado o ficheiro: presas.mat, por aproximação das variáveis $N_2(0)$ e $\alpha2$ gerou-se um aproximação dos resultados obtidos carregados.

%{
    De acordo com o estudado na pergunta 2.3, cada solução corresponde a um
    par de condições iniciais. Assim, a unicidade da solução aproximada
    está garantida. ??
%}

delta2 = -1.5;
alfa2 = 0.7;
N2o = timeseries(1.6);

sim_out = sim('modelo','StartTime','0','StopTime',num2str(stop_time));

figure(fig); clf; hold on; grid on; fig=fig+1;
plot(tr, yr, '*', sim_out.tout,sim_out.N1);
legend('pressas.mat','aproximação');
ylabel('Nível de abundância da espécie das presas - N_1'); xlabel('Tempo');

%% Alínea b) - Obtenção do resultado por norma l∞ do vetor de erro

% Suponha em seguida que $N_2(0)$ e $\alpha_2$ estão compreendidos entre valores mínimos e máximos conhecidos.

x = linspace(1.5,1.7,40);y = linspace(0.6,0.8,40);z_graph = zeros(length(x),length(y));
total=length(x)*length(y);d=1;
for i = 1:length(x)
    for j = 1:length(y)
        z_graph(j,i) = erro([x(i), y(j)]);
        w = waitbar(d/total);d=d+1;
    end
end
w.delete;%close waitbar window
    
figure(fig);clf;fig=fig+1;
surfc(x,y,z_graph);colorbar;colormap(summer);shading flat;                 %draw 3D plot
xlabel('N_2(0)'); ylabel('\alpha_2'); zlabel('l∞');
sgtitle({'Máximo valor absoluto das diferenças entre os valores'; 'monitorizados e os correspondentes valores calculados'})
figure(fig); fig=fig+1;
surfc(x,y,log10(z_graph));colorbar;colormap(hot);shading flat ;             %draw 3D plot
sgtitle({'Máximo valor absoluto das diferenças entre os valores'; 'monitorizados e os correspondentes valores calculados';'escala logorítmica base 10'});
xlabel('N_2(0)'); ylabel('\alpha_2'); zlabel('l∞');

%%
% Através deste método não é possível obter o mínimo global extado, visto que visa simular um sistema para valores iniciais definidos à priori. Estimou-se um
% mínimo global da função para as cordenadas ($N_2(0)$, $\alpha_2$) = (1.612,0.706).

%% Função erro l∞
%função que cálcula a diferença máxima entre os valores fornecidos e simulados
type('erro.m')

finish

%% Alínea c) - Obtenção do resultado com recurso a uma função de otimização (fminsearch)

xx = linspace(1.55,1.65,3);yy = linspace(0.65,0.75,3);
total=length(xx)*length(yy);d=1;
z_search=zeros(length(xx)*length(yy),2);                                    % array with calculated variables
val = zeros(1,length(xx)*length(yy));                                       % error for each pair  
for i = 1:length(xx)
    for j = 1:length(yy)
        z_search((i-1)*length(yy)+j,:) = fminsearch(@erro,[xx(i), yy(j)]);  % get variables
        val(1,(i-1)*length(yy)+j) = erro(z_search((i-1)*length(yy)+j,:));   % set the error
        w = waitbar(d/total);d=d+1;
    end
end
w.delete;%close waitbar window
[min_value,index]=min(val);
aux = fminsearch(@erro,z_search(index,:)); N2o = timeseries(aux(1)); alfa2 = aux(2);
disp(aux);

%%
% Através da função fminsearch é possível obter o mínimo de uma função sem recurso à derivada da mesma, este método permite-nos obter um valor muito próximo ou 
% mesmo o ótimo mínimo global da função. O resultado obtido foi ($N_2(0)$,
% $\alpha_2$) = (1.6117,0.7070)



%% Alínea d) - Validação do modelo 
sim_out = sim('modelo','StartTime','0','StopTime',num2str(stop_time));
figure(fig); hold on; fig=fig+1; grid on;
plot(tr, yr, 'o',sim_out.tout, sim_out.N1);
legend('pressas.mat','fminsearch','Location','best');
ylabel('Nível de abundância da espécie das presas - N_1'); xlabel('Tempo');
sgtitle({'Gráfico da população das presas num ambiente real';'e simulado com recurso à função fminsearch'});

%%
close all;
close_system