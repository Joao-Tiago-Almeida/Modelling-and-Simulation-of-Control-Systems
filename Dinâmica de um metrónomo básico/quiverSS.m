function quiverSS(A,X)  % Calls this function after a SS plot is drawn
% draws a velocity plot.


x1 = X.simout.Data(:,1);    % angular position
x2 = X.simout.Data(:,2);    % angular velocity

n = 20; % number of arrows per position and velocity

x = [linspace(min(x1),max(x1),n);linspace(min(x2),max(x2),n)];  % coordinates where arrows will be displayed

x1 = x(1,:);    % make it easy to do maths
x2 = x(2,:);

[x1,x2] = meshgrid(x1,x2);  % extend arrows along all display

dx1 = A(1,1)*x1+A(1,2)*x2;  % dx = Ax
dx2 = A(2,1)*x1+A(2,2)*x2;

quiver(x1,x2,dx1,dx2); % velocity plot

end