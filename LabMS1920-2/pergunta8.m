
% variáveis e vectores
ref = 0;
y = -2:0.01:2;
d_y = -2:0.01:2;

% meshgrid
[Y, D_Y] = meshgrid(y,d_y);

% geração da matriz de U
U = u_8(Y, D_Y, ref);

% surface plot
figure(1); clf;
surfc(Y,D_Y,U);
view(-158,46);
xlabel("$y [\mu m]$", 'Interpreter','latex');
ylabel("$\dot{y} [\mu ms^{-1}]$", 'Interpreter','latex');
sgtitle("$u(y, \dot{y}, $ref$)$" ,'Interpreter','latex');
colormap(jet);
shading interp;
colorbar;

% pcolor plot
figure(2); clf;
pcolor(Y, D_Y, U);
shading interp;
xlabel("$y [\mu m]$", 'Interpreter','latex');
ylabel("$\dot{y} [\mu ms^{-1}]$", 'Interpreter','latex');
sgtitle("$u(y, \dot{y}, $ref$)$" ,'Interpreter','latex');
colormap(gray);
colorbar;

% funcao que gera u dados y, d_y e ref
function u = u_8(y, d_y, ref)
    % subtracao de posicao a ref
    aux1 = ref - y;
    % calculo de f(x)
    aux2 = sign(aux1) .* sqrt(2*abs(aux1));
    % subtracao de velocidade
    aux3 = aux2 - d_y;
    % limitar a -1/1
    u = sign(aux3);
end

