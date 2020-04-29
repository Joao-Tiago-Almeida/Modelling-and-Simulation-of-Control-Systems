function s = set_signal(T, alpha, beta, U1, U2, n1, n2, ctrl)
    % Declares input sinal struct
    
    s = struct('name', 'Entrada');
    
    s.alpha = alpha_bounds(alpha);	% relation between T1 and T2: T1 = $\alpha T2$
    s.beta = beta_bounds(beta);	% curve efect of the u(t) up and donw range
    s.U = [U1 U2];	% max range of $u_1$(t) and $u_2$(t)
    s.N = [n1 n2];	% number of ponits of $u_1$(t) and $u_2$(t)
    s.T = T;
    
    if ctrl == 1 % para obter o sinal conforme a alínea 6
        s.T = max([sqrt(2*(1+s.beta)*(1+s.alpha)), sqrt(2*(1+s.beta)*(1+s.alpha)/s.alpha)]);	% $T_{minimo}$ calculated from question 6
        s.U(1) = alpha*s.U(2);
    end
    
end