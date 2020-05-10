function mass = getWnfromSimulation(s,c)
    % this function computes mass over fixed length from the center until
    % the punctual mass

    c.torque = 1;   % enable sin wave on simulink
    c.schematic = 2;    % choose SS block as system to test
    c.stoptime = 60;    % make sure the system is stabilized
    
    options.SrcWorkspace = 'current'; % set function's worspace for simulink
    
    % only 2 sim are required
    An = zeros(2,1);    % range during saturation state
    freq = [1 10];    % rad/s
    
    for j = 1:2 
        c.freq = freq(j);   % frequencies to simulate
        y = sim('metron',options);    % simulation
        a = findpeaks(y.simout.Data(:,1),y.simout.Time);    % range during all simulation
        An(j) = a(end); % last peak should occur during a establish movement
    end
    
    s = rmfield(s, 'm'); % to be sure it isn't used to compute
    
    s_freq = 1i*freq';   % s = jw
    s_f = @(x) s_freq(x); % handle function to get whether simulation one or two
    
    syms m real positive % assuming that incognite are real and positive
    % assumptions   % uncomment to check
    
    J(m) = m*s.l^2 + 3\s.M*s.L^2;  % symfun
    H = @(x) J/(s_f(x)^2 + s.beta*s_f(x)/J + J\(s.k - s.g*(m*s.l+s.M*s.L/2)));  % handle function
    
    FT_1 = abs(An(1)/H(1)); % symfun
    FT_2 = abs(An(2)/H(2)); % symfun
    
    Sm = solve(FT_1 == FT_2, m);    % Resolve 1st order system   
    mass = double(Sm);  % computed mass
      
end