function s = set_signal()
    % Declares input sinal struct
    
    s = struct('name', 'Entrada');
    
    s.K = 100;                  % gain pre-saturation
    s.u = 0;                    % input
    s.y = 0;                    % output
    s.sample_time = 1e-3;       % sample time
    s.q = 10;                   % input decision based on question number  
    s.yl = 10;                  % question 10 saturation levels
    s.ref = timeseries(0);                  % input reference for position y1
    
end