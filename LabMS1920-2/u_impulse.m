function y = u_impulse(t, beta)
    t_size = length(t);
    y = zeros(1, t_size);
    for i = 1:t_size
        if t(i) <= -(beta+1)/2 % zona 1
        	continue;
        
        elseif t(i) >= (beta+1)/2 % zona 7
        	continue;
        
        elseif -(beta+1)/2 < t(i) && t(i) <= -1/2 % zona 2
             y(i) = (2/beta^2)*t(i)^2 + ((2*beta+2)/beta^2)*t(i) + ((2*beta+1)/(2*beta^2)) + 1/2;
        
        elseif -1/2 < t(i) && t(i) <= (beta-1)/2 % zona 3
             y(i) = -(2/beta^2)*t(i)^2 + ((2*beta-2)/beta^2)*t(i) + ((2*beta-1)/(2*beta^2)) + 1/2;
        
        elseif (beta-1)/2 < t(i) && t(i) < (1-beta)/2 % zona 4
             y(i) = 1;
        
        elseif (1-beta)/2 <= t(i) && t(i) < 1/2 % zona 5
             y(i) = -(2/beta^2)*t(i)^2 + ((2-2*beta)/beta^2)*t(i) + ((2*beta-1)/(2*beta^2)) + 1/2;
        
        elseif 1/2 <= t(i) && t(i) < (beta+1)/2 % zona 6
             y(i) = (2/beta^2)*t(i)^2 - ((2*beta+2)/beta^2)*t(i) + ((2*beta+1)/(2*beta^2)) + 1/2;
        end
    end
end