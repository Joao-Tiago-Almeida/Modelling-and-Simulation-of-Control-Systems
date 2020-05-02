% funções para calcular posição
function [th1, th2] = pos_to_angles(x_pos, y_pos, length)
    th1 = atan(x_pos/y_pos) - 0.5*acos((x_pos^2+y_pos^2)/(2*(length^2))-1);
    th2 = atan(x_pos/y_pos) + 0.5*acos((x_pos^2+y_pos^2)/(2*(length^2))-1);
    if y_pos < 0
       th1 = rot_pi(th1); th2 = rot_pi(th2);  
    end
    if x_pos < 0 
       [th1,th2] = deal(th2,th1); % escolha da sol de menor potencial.
    end
end