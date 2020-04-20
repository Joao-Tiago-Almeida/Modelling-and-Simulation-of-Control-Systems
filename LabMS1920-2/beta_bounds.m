function beta = beta_bounds(beta)
% case when beta < 0 or beta > 1
    if beta > 1
        beta = 1;
        disp('ERROR: \beta > 1 (limit), during this function \beta = 1')
    elseif beta < 0
        beta = 0;
        disp('ERROR: \beta < 0 (limit), during this function \beta = 0')
    end
end

