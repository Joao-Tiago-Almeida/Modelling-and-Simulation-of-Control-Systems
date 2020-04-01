% definição das variáveis
delta_1 = [1 -1 -1];                    alfa1 = 1;  N1_o = 5;               N1o = timeseries(N1_o);
delta_2 = [1 1 -2];     global alfa2;   alfa2 = 1;  N2_o = 1;   global N2o; N2o = timeseries(N2_o);
stop_time = 20;
fig=1; %first figure of the file

plotLabelsRe = strings(1,3);    % criação dos arrays para alojar legendas e plots

%legendas com a explicação das diferentes soluções não oscilatórias
plotLabelsRe{1} = ['Fruto de outras relações ecológicas, a espécie predadadora tem tendência a aumentar independentemente do nível de abundância da presa. '...
                   'Assim o nível de abundância dos predadores tende para valores muito grandes, levando à extinção da população das presas.'];
plotLabelsRe{2} = ['Situação idêntica à anterior. Caso particular que as presas têm tendência natural a desaparecerem (independente da relação ecológica em'...
                   ' estudo), logo a sua extinção acontece mais rápido, implicando assim um crescimento menos rápido dos predadores'];
plotLabelsRe{3} = ['Ambas as espécies têm tendência natural a extinguirem-se (taxa de mortalidade superior à taxa de natalidade). '...
                   'Realça-se que ao contrário da população das presas que decresce estritamente até à sua extinção, os predadores '...
                   'podem aumentar consoante a abundância inicial das presas. O caso (1) anterior corresponde à situação em que o módulo da '...
                   'diferença entre as taxas de natalidade e de mortalidade da espécie perdadora é menor que o nível da abundância '...
                   'inicial das presas, dN2/dt = N2(delta2+N1) .No caso contrário (2) ( |delta2|<N1o ), a população das presas tem um decrescimento estrito.'];


dim = [[0.37 0.73 0.5 0.16]; [0.37 0.73 0.5 0.16]; [0.27 0.61 0.60 0.28]];  %dimensão e posição das caixas de texto

for i = 1:3                                                                     %gráficos das soluções não oscilatórias
    delta1=delta_1(i); delta2=delta_2(i);                                       %atualização dos parametros da nova soluções
    sim_out = sim('modelo','StartTime','0','StopTime',num2str(4));                     %simulação
    figure(fig); clf; fig=fig+1; hold on; grid on; ylim([0 inf]);
    if i < 3
        yyaxis left;
        plot(sim_out.tout,sim_out.N1);
        yyaxis right;
        plot(sim_out.tout,sim_out.N2);
    end                                                          %restrição da dimensão da soluação a apresentar
    annotation('textbox', dim(i,1:4), 'String', plotLabelsRe{i});               %explicação
    if i == 3                                                                   %caso espefício de uma solução
        plot(sim_out.tout,sim_out.N1,sim_out.tout,sim_out.N2);
        delta2_aux = delta2;
        delta2 = delta2-N1_o;
        sim_out = sim('modelo','StartTime','0','StopTime',num2str(4));
        plot(sim_out.tout,sim_out.N2);
        legend('Presas', 'Predadores, caso 1', 'Predadores caso 2', 'Location', 'east');
        sgtitle(['Relação ecológica.   delta1 = ' num2str(delta1) ';    (caso 1)delta2 = ' num2str(delta2_aux) ';    (caso 2)delta2 = ' num2str(delta2)]);
    else
        sgtitle(['Relação ecológica.   delta1 = ' num2str(delta1) ';    delta2 = ' num2str(delta2)]);
        legend('Presas', 'Predadores', 'Location', 'east');
    end
end

finish

delta_1 = [3 1 3];       N1_o = [4 3 2];
delta_2 = [-3 -3 -1];    N2_o = [4 5 1];
c=['#D95319'; '#0072BD'; '#77AC30'];
plotHandles = zeros(1,2*(length(delta_1)+1));
plotLabels = strings(1,2*(length(delta_1)+1));
d_max=length(delta_1); n_max = length(N1_o);
for d = 1:d_max
    delta1 = delta_1(d); delta2 = delta_2(d);
    figure(fig); clf; fig=fig+1; hold on; grid on;
    sgtitle(['Relação ecológica.   delta1 = ' num2str(delta1) ';    delta2 = ' num2str(delta2)]);
    for n = 1:n_max
        N1o = timeseries(N1_o(n)); N2o = timeseries(N2_o(n));
        sim_out = sim('modelo','StartTime','0','StopTime','stop_time/2');                     %simulação  
        p = plot(sim_out.tout,sim_out.N1, '--',sim_out.tout,sim_out.N2); plotHandles(2*n-1:2*n) = p;
        p(1).Color = c(n,:); p(2).Color = c(n,:); p(1).LineWidth = 2; p(2).LineWidth = 2;
        plotLabels(2*n-1:2*n) = {['Presas N(0) = ' num2str(N1_o(n))], ['Predadores  N(0) = ' num2str(N2_o(n))]};       
    end
    N1o = timeseries(-delta2/alfa2); N2o = timeseries(delta1/alfa1);
    sim_out = sim('modelo','StartTime','0','StopTime','stop_time/2');                     %simulação
    p = plot(sim_out.tout,sim_out.N1, '--',sim_out.tout,sim_out.N2); plotHandles(2*n+1:2*n+2) = p;
    p(1).Color = '#7E2F8E'; p(2).Color = '#7E2F8E'; p(1).LineWidth = 2; p(2).LineWidth = 2;
    plotLabels(2*n+1:2*n+2) = {['Presas N(0) = \delta/\alpha = ' num2str(-delta2/alfa2)], ['Predadores  N(0) = \delta/\alpha = ' num2str(delta1/alfa1)]};
    l = legend(plotHandles, plotLabels, 'Location', 'best');
    l.NumColumns = 2;
end

%modo (N1, N2)
delta1 = 1; delta2 = -1;
figure(100); clf; hold on;
for i = [3 5]
    for j = [2 8]
        N1o = timeseries(i);
        N2o = timeseries(j);
        sim_out = sim('modelo','StartTime','0','StopTime', num2str(stop_time));
        plot(sim_out.N1, sim_out.N2);
    end
end

plot(sim_out.N1, sim_out.N2);
[n1,n2]=meshgrid(-2:0.5:12, -2:0.5:12); dn1= delta1.*n1-alfa1.*n1.*n2; dn2= delta2.*n2+alfa2.*n1.*n2;
q = quiver(n1, n2, dn1, dn2); q.Color = '#A2142F'; q.LineWidth = 1;


%2.4-resultados próximos dos reais
delta1 = 3.1;
alfa1 = 1.4;
N1o = timeseries(4);

global yr;global tr;load('presas.mat');

%parâmetros da formula dos predadores
delta2 = -1.5;
alfa2 = 0.7;
N2o = timeseries(1.6);

sim_out = sim('modelo','StartTime','0','StopTime',num2str(stop_time));

figure(101); hold on;
plot(tr, yr, '*');
plot(sim_out.tout,sim_out.N1);
legend('pressas.mat','aproximação');

axis([0 4 0 5])

if exist('z_graph','var') ~= 1
    x = linspace(1.5,1.7,40);y = linspace(0.6,0.8,40);z_graph = zeros(length(x), length(y));
    total=length(x)*length(y);counter=1;
    for i = 1:length(x)
        for j = 1:length(y)
            z_graph(j,i) = erro([x(i), y(j)]);
            w = waitbar(counter/total);counter=counter+1;
        end
    end
    w.delete;%close waitbar window
end

%rever
%n1(1:40,1:40)=4;N1o=timeseries(n1);
%[n2,a2]=meshgrid(x,y);N2o=timeseries(n2);% alfa2=a2;
%sim_out = sim('modelo','StartTime','0','FixedStep',num2str(0.1),'StopTime',num2str(stop_time));
%ee = sim_out.N1-yr;
%finish


figure(24);
surfc(x,y,z_graph);colorbar;colormap(summer);shading flat ;%draw 3D plot
xlabel('N(0)');ylabel('alfa2');
zlabel({'máximo valor absoluto das diferenças entre os valores'; 'monitorizados e os correspondentes valores calculados'})
sgtitle({'Estudo da dimensão da população N(0) e o coefieciente \alpha que reflecte'; 'o efeito das presas na abundância de predadores'})
figure();
surfc(x,y,log10(z_graph));colorbar;colormap(hot);shading flat ;%draw
        
if exist('val','var') ~= 1
    xx = linspace(1.5,1.7,3);yy = linspace(0.6,0.8,3);
    total=length(xx)*length(yy);counter=1;
    z__unc=zeros(length(xx)*length(yy),2);
    z_search=zeros(length(xx)*length(yy),2);
    val = zeros(1,length(xx)*length(yy));
    for i = 1:length(xx)
        for j = 1:length(yy)
            %z__unc((i-1)*length(yy)+j,:) = fminunc(@erro,[xx(i), yy(j)]);
            z_search((i-1)*length(yy)+j,:) = fminsearch(@erro,[xx(i), yy(j)]);
            val(1,(i-1)*length(yy)+j) = erro(z_search((i-1)*j+j,:));
            w = waitbar(counter/total);counter=counter+1;
        end
    end
    w.delete;%close waitbar window
end

[min_value,index]=min(val);
aux = fminsearch(@erro,z_search(index,:)); N2o = timeseries(aux(1)); alfa2 = aux(2);
sim_out = sim('modelo','StartTime','0','StopTime',num2str(stop_time));
figure(); hold on;
plot(tr, yr, 'o',sim_out.tout, sim_out.N1);

figure(7);figure(24);figure(101);figure(100);figure(6);figure(5);figure(4);figure(3);figure(2);figure(1);