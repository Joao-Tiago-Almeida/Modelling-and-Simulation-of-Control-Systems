function alpha = alpha_bounds(alpha)
% case when alpha < 0 
    if alpha < 0
        alpha = 0;
        disp('ERROR: \alpha < 0 (limit), during this function \alpha = 0')
    end
end

