function s = set_system9(l,m)
    % Declares system struct with question 9 values
    % values for m and l were found to match BPM    
    
    % known variables
    s.L = 0.25;  % m - arm length
    s.M = 0.1; % Kg - arm mass
    s.l = l;  % m - distance to mass
    s.m = m;  % Kg - pontual mass
    s.k = 0.35;    % Nm/rad
    s.g = 9.8;    % m/s^2 - gravitational acceleration
    s.beta = 0.001;   % Nms/rad
    s.J = s.m*s.l^2 + 3\s.M*s.L^2;  % moment of inertia
    
    s.A21 = (-s.k + s.g*(s.m*s.l + s.M*s.L/2))/s.J;
    s.A22 = -s.beta/s.J;
    
    A = [0 1;s.A21 s.A22];
    B = [0;inv(s.J)];
    C = eye(2);   % Although thr only ouput is x1, x2 allow us to give feedback to the system
    D = 0;
    
    s.sys=ss(A,B,C,D);
    
    s.x0 = [pi/4;0];    % initial state
    
end