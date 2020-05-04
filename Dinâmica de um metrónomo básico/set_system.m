function s = set_system()
    % Declares system struct
    
    % known variables - TODO comment variables names
    L = 0.5;  % m - arm length
    M = 0.15; % Kg - arm mass
    l = 0.4;  % m - distance to mass
    m = 0.2;  % Kg - pontual mass
    k = 3;    % Nm/rad
    g = 9.8;    % m/s^2 - gravitational acceleration
    s.beta = 0.1;   % Nm/rad
    s.J = (3*m + M)*power(l,2)/3; % Moment of inertia
    
    s.A21 = (-k + g*(m*l + M*L/2))/s.J;
    s.A22 = -s.beta/s.J;
    
    A = [0 1;s.A21 s.A22];
    B = [0;inv(s.J)];
    C = eye(2);   % Although thr only ouput is x1, x2 allow us to give feedback to the system
    D = 0;
    s.sys=ss(A,B,C,D);
    
    s.x0 = [0 pi/4];
    
end