function s = set_signal()
    % Declares input sinal struct
    
    s = struct('name', 'Entrada');
    
    s.alfa = alfa_bounds(0.5);	% relation between T1 and T2: T1 = $\alpha T2$
    s.beta = beta_bounds(0.5);	% curve efect of the u(t) up and donw range
    s.U = [2 4];	% max range of $u_1$(t) and $u_2$(t)
    s.N = [6e3 1e3];	% number of ponits of $u_1$(t) and $u_2$(t)
    s.T = max([sqrt(2*(1+s.beta)*(1+s.alfa)), sqrt(2*(1+s.beta)*(1+s.alfa)/s.alfa)]);	% $T_{minimo}$ calculated from question 6
    s.u = 0;	% input
end