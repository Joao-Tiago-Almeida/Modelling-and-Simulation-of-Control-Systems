function alfa = alfa_bounds(alfa)
% case when alfa < 0 
    if alfa < 0
        alfa = 0;
        disp('ERROR: \alpha < 0 (limit), during this function \alpha = 0')
    end
end

