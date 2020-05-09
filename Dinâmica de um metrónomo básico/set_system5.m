function s = set_system5()
    % Declares system struct with question 6 values
    
    % known variables
    s.L = 0.5;  % m - arm length
    s.M = 0.15; % Kg - arm mass
    s.l = 0.4;  % m - distance to mass
    s.m = 0.2;  % Kg - punctual mass
    s.k = 3;    % Nm/rad
    s.g = 9.8;    % m/s^2 - gravitational acceleration
    s.beta = 0.1;   % Nms/rad
    s.J = s.m*s.l^2 + 3\s.M*s.L^2;  % moment of inertia
    
    s.A21 = (-s.k + s.g*(s.m*s.l + s.M*s.L/2))/s.J;
    s.A22 = -s.beta/s.J;
    
    A = [0 1;s.A21 s.A22];
    B = [0;inv(s.J)];
    C = eye(2);   % Although thr only ouput is x1, x2 allow us to give feedback to the system
    D = 0;
    
    s.sys=ss(A,B,C,D);
    
    s.x0 = [0 pi/4];    % initial state
    
end

