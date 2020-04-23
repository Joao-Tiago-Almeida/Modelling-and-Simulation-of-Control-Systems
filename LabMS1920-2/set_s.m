function s = set_s()

    s = struct('Name', 'Disco Rígido');
    
    s.alfa = 0.5;
    s.beta = 0.5;
    s.U = [2 4];
    s.N = [6e3 1e3];
    s.X0 = [1;0];
    
    b = 0.025;% atrito 
    A = [0 1; 0 -b]; B = [0; 1]; C = [1 0]; D = 0;
    s.sys = ss(A,B,C,D);
    s.Gz = tf(s.sys);
    
    % $T_{minimo}$ calculado através das expressões da alínea 6
    s.T = max([sqrt(2*(1+s.beta)*(1+s.alfa)), sqrt(2*(1+s.beta)*(1+s.alfa)/s.alfa)]);

end
