clear;

l = 0.5;

x = linspace(-1,1,11);
y = linspace(-1,1,51);
[X,Y] = meshgrid(x,y);

figure(1);clf; grid on; 
dim = [.4 .4 .5 .5];
txtbox = annotation('textbox',dim,'FitBoxToText','on');
for i = 1:numel(X)
    if (X(i)^2 + Y(i)^2 > 1) || (X(i) == 0 && Y(i) == 0)
        continue; 
    else
        [theta1,theta2] = pos_to_angles(X(i), Y(i), l);
        arm_x = [0 l*sin(theta1)+[0 l*sin(theta2)]];
        arm_y = [0 -l*cos(theta1)+[0 -l*cos(theta2)]];
        if(abs(theta1) > pi || abs(theta2) > pi)
            plot(arm_x, arm_y, '-or', 'LineWidth', 2);
        else
            plot(arm_x, arm_y, '-ob', 'LineWidth', 2);
        end
        axis([-1 1 -1 1]);
        set(txtbox,'String',['th1: ' num2str(theta1) '\newlineth2: ' num2str(theta2)]);
        pause(0.01);
    end
end
