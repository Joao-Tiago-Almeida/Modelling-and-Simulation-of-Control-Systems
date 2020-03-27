% definição das variáveis
alfa1 = 1;
global alfa2;  alfa2 = 1;
delta_1 = [1 -1 -1];
delta_2 = [1 1 -2];
N1_o = 5;
N2_o = 1;
N1o = timeseries(N1_o);
global N2o; N2o = timeseries(N2_o);
stop_time = 20;
fig=1; %first figure of the file

% criação dos arrays para alojar legendas e plots
plotLabelsRe = strings(1,3);

%legendas com a explicação de cada caso
plotLabelsRe{1} = ['Fruto de outras relações ecológicas, a espécie predadadora ' ...
                   'tem tendência a aumentar independentemente do nível de '...
                   'abundância da presa. Assim o nível de abundância dos '...
                   'predadores tende para valores muito grandes, levando à '...
                   'extinção da população das presas.'];
plotLabelsRe{2} = ['Situação idêntica à anterior. Caso particular que as '...
                   'presas têm tendência natural a desaparecerem (independente '...
                   'da relação ecológica em estudo), logo a sua extinção '...
                   'acontece mais rápido, implicando assim um crescimento '...
                   'menos rápido dos predadores'];
plotLabelsRe{3} = ['Ambas as espécies têm tendência natural a extinguirem-se '...
                   '(taxa de mortalidade superior à taxa de natalidade). '...
                   'Realça-se que ao contrário da população das presas que '...
                   'decresce estritamente até à sua extinção, os predadores '...
                   'podem aumentar consoante a abundância inicial das presas. '...
                   'O caso (1) anterior corresponde à situação em que o módulo da '...
                   'diferença entre as taxas de natalidade e de mortalidade '...
                   'da espécie perdadora é menor que o nível da abundância '...
                   'inicial das presas, dN2/dt = N2(delta2+N1) .'...
                   'No caso contrário (2) ( |delta2|<N1o ), a população das presas '...
                   'tem um decrescimento estrito.'];


dim = [[0.37 0.73 0.5 0.16]; [0.37 0.73 0.5 0.16]; [0.27 0.61 0.60 0.28]];

for i = 1:3
    delta1=delta_1(i); delta2=delta_2(i);
    sim_out = sim('modelo','StartTime','0','StopTime','2');
    figure(fig); clf; fig=fig+1; hold on; grid on;
    plot(sim_out.tout,sim_out.N1,sim_out.tout,sim_out.N2);
    axis([0 2 -1 5]);
    annotation('textbox', dim(i,1:4), 'String', plotLabelsRe{i});
    legend('Presas', 'Predadores', 'Location', 'east');
    if i == 3
        delta2_aux = delta2;
        delta2 = delta2-N1_o;
        sim_out = sim('modelo','StartTime','0','StopTime',num2str(stop_time));
        plot(sim_out.tout,sim_out.N2);
        legend('Presas', 'Predadores, caso 1', 'Predadores caso 2', 'Location', 'east');
        title(['Relação ecológica.   delta1 = ' num2str(delta1) ';    (caso 1)delta2 = '...
            num2str(delta2_aux) ';    (caso 2)delta2 = ' num2str(delta2)]);
    else
        title(['Relação ecológica.   delta1 = ' num2str(delta1) ';    delta2 = ' num2str(delta2)]);
    end
end


       

%modo (N1, N2)
figure(100); hold on; axis([-1 12 -1 12])
for i = [3 5]
    for j = [2 8]
        N1o = timeseries(i);
        N2o = timeseries(j);
        sim_out = sim('modelo','StartTime','0','StopTime', num2str(stop_time));
        plot(sim_out.N1, sim_out.N2);
    end
end

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
close 100 1 2 3 101


if exist('z_graph','var') ~= 1
    x = linspace(1.5,1.7,40);y = linspace(0.6,0.8,40);z_graph = meshgrid(x,y);
    total=length(x)*length(y);counter=1;
    for i = 1:length(x)
        for j = 1:length(y)
            z_graph(j,i) = erro([x(i), y(j)]);
            w = waitbar(counter/total);counter=counter+1;
        end
    end
    w.delete;%close waitbar window
end
figure();
surfc(x,y,z_graph);colorbar;colormap(summer);shading flat ;%draw 3D plot
xlabel('N(0)');ylabel('alfa2');
zlabel({'máximo valor absoluto das diferenças entre os valores';...
            'monitorizados e os correspondentes valores calculados'})
sgtitle({'Estudo da dimensão da população N(0) e o coefieciente \alpha que reflecte';...
            'o efeito das presas na abundância de predadores'})
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

close all
[min_value,index]=min(val);
aux = fminsearch(@erro,z_search(index,:)); N2o = timeseries(aux(1)); alfa2 = aux(2);
sim_out = sim('modelo','StartTime','0','StopTime',num2str(stop_time));
figure(); hold on;
plot(tr, yr, 'o',sim_out.tout, sim_out.N1);
