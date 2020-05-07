function quiverSS(A,X)  % Calls this function after a SS plot is drawn
% draws a velocity plot.

if isa(X,'Simulink.SimulationOutput')   % comes from SIMULINK simulation
    
    x1 = X.simout.Data(:,1);    % angular position
    x2 = X.simout.Data(:,2);    % angular velocity
    
    n = length(x1)/30; % number of arrows per position and velocity
   
    
elseif isa(X,'matlab.ui.Figure')  % is an figure 
    
    x1 = X.CurrentAxes.XLim;    % limits of xx axe
    x2 = X.CurrentAxes.YLim;    % limits of yy axe
    
    n = 20; 
end

 x = [linspace(min(x1),max(x1),n);linspace(min(x2),max(x2),n)];  % coordinates where arrows will be displayed

x1 = x(1,:);    % make it easy to do maths
x2 = x(2,:);

[x1,x2] = meshgrid(x1,x2);  % extend arrows along all display

dx1 = A(1,1)*x1+A(1,2)*x2;  % dx = Ax
dx2 = A(2,1)*x1+A(2,2)*x2;

q = quiver(x1,x2,dx1,dx2); % velocity plot
color_hex = '32CD32';
q.Color = 255\[hex2dec(color_hex(1:2)) hex2dec(color_hex(3:4)) hex2dec(color_hex(5:6))];
%q.LineWidth = 1;
q.AutoScaleFactor = 0.7;
q.DisplayName = 'scale: 1 rad/s';
q.DataTipTemplate.Interpreter = 'latex';
q.DataTipTemplate.FontName = 'Arial';
q.DataTipTemplate.FontSize = 13;

end