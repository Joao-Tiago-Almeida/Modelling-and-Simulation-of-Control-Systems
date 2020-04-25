function s = set_s()
    % Declares system struct
    
    s = struct('name', 'Disco Rígido');
    
    s.alfa = alfa_bounds(0.5);	% relation between T1 and T2: T1 = $\alpha T2$
    s.beta = beta_bounds(0.5);	% curve efect of the u(t) up and donw range
    s.U = [2 4];	% max range of $u_1$(t) and $u_2$(t)
    s.N = [6e3 1e3];	% number of ponits of $u_1$(t) and $u_2$(t)
    s.X0 = [1;0];	% initial condiction
    
    b = 1;	% friction 
    A = [0 1; 0 -b]; B = [0; 1]; C = eye(2); D = 0;	% $\ddot{y} = u - b\dot{y}$
    s.sys = ss(A,B,C,D);	% steady-state
    s.Gz = tf(s.sys);	% continuous-time transfer function.
    
    s.T = max([sqrt(2*(1+s.beta)*(1+s.alfa)), sqrt(2*(1+s.beta)*(1+s.alfa)/s.alfa)]);	% $T_{minimo}$ calculated from question 6
    
end
