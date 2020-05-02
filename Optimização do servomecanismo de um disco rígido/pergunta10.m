
% variáveis e vectores
ref = 0;
yl = 1;
y = -2:0.01:2;
d_y = -2:0.01:2;

% meshgrid
[Y, D_Y] = meshgrid(y,d_y);

% geração da matriz de U
U = u_10(Y, D_Y, ref, yl);

% surface plot
figure(1); clf;
surfc(Y,D_Y,U);
view(-136,40.35);
xlabel("$y [\mu m]$", 'Interpreter','latex');
ylabel("$\dot{y} [\mu ms^{-1}]$", 'Interpreter','latex');
sgtitle("$u(y, \dot{y}, $ref$)$" ,'Interpreter','latex');
colormap(jet);
shading interp;
colorbar;

% surface plot
figure(2); clf;
contourf(Y,D_Y,U);
xlabel("$y [\mu m]$", 'Interpreter','latex');
ylabel("$\dot{y} [\mu ms^{-1}]$", 'Interpreter','latex');
sgtitle("$u(y, \dot{y}, $ref$)$" ,'Interpreter','latex');
colormap(jet);
colorbar;



function u = u_10(y, d_y, ref, yl)
    % definicao de k1, k2
    k1 = 1/yl;
    k2 = sqrt(2*k1);
    % calculo da entrada ao subsys (subtracao de posicao)
    aux1 = ref - y;
    % f(x)
    aux2 = ((k1/k2)*aux1).*(abs(aux1) <= yl) + (sign(aux1).*(sqrt(2*abs(aux1))-1/k2)).*(abs(aux1) > yl);
    % subtracao da velocidade
    aux3 = aux2 - d_y;
    % multiplicacao por ganho k2
    aux4 = aux3*k2;
    % saturacao
    aux4(aux4>1) = 1; aux4(aux4<-1) = -1; 
    u = aux4;
end