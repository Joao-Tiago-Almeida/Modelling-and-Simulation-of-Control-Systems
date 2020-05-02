%a partir de um ângulo em -pi e pi, roda 180º ficando no mesmo intervalo
%o ângulo à entrada da função tem de estar nesse intervalo. 
function new_angle = rot_pi(angle)
    if angle < 0
        new_angle = angle + pi;
    else
        new_angle = angle - pi;
    end
end