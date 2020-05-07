function s = set_system9()
    % Declares system struct with question 9 values
    % values for m and l are unknown
    
    % known variables
    L = 0.25;  % m - arm length
    M = 0.1; % Kg - arm mass
    k = 0.35;    % Nm/rad
    g = 9.8;    % m/s^2 - gravitational acceleration
    s.beta = 0.001;   % Nms/rad
    s.J = (3*m + M)*power(l,2)/3; % Moment of inertia
    
    s.A21 = (-k + g*(m*l + M*L/2))/s.J;
    s.A22 = -s.beta/s.J;
    
    A = [0 1;s.A21 s.A22];
    B = [0;inv(s.J)];
    C = eye(2);   % Although thr only ouput is x1, x2 allow us to give feedback to the system
    D = 0;
    
    s.sys=ss(A,B,C,D);
    
    s.x0 = [0 pi/4];    % initial state
    
end