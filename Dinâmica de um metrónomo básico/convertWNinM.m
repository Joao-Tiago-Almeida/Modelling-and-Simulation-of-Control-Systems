function massa = convertWNinM(wn,l)
    % get the mass base on natural frequency
    % based on question 9 values
    
    wn = reshape(wn,[],1);   % change every kind of vector to 1D vector
    l = reshape(l,[],1);   % change every kind of vector to 1D vector
    
     % known variables
    L = 0.25;  % m - arm length
    M = 0.1; % Kg - arm mass
    k = 0.35;    % Nm/rad
    g = 9.8;    % m/s^2 - gravitational acceleration
    beta = 0.001;   % Nms/rad
  
    if length(wn) ~= length(l)
        disp('Both lengths must be the same');
        return;
    end
    
    m = sym('m', [length(wn) 1]);   % multiples incognites (??)

    J = @(m) m.*l.^2 + 3\M*L^2;  % function_handle
    W(m) = sqrt(J(m).\(k-g*(l.*m+M*L/2))); % symfunc
    Sm = solve(W == wn ,m); % get expression in order of mass
    massa=[double(Sm.m1);double(Sm.m2)];    % computed mass based on each wn and l
    
end