function s = set_controller()
    % Declares system struct
    
    s = struct('name', 'Controlador');
    
    s.K = 10000;	% gain pre-saturation
    s.y = 0;	% output
    s.sample_time = 1e-3;	% sample time
    s.q = 10;	% input decision based on question number  
    s.yl = 1e-2;	% question 10 saturation levels
    s.lz = 0; % activate linear zone exclusively
    s.ref = timeseries(0);	% input reference for position y1 
end
