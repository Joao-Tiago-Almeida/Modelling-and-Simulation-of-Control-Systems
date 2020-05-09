function c = set_controller(question)
    % Declares controller struct
    
    % default: state-space model
    if nargin == 0
        question = 2;
    end
    
    c = struct('name', 'Controlador');
    
    c.samptime = 1e-2;  % sampling time
    c.schematic = question; % switch input based on system schematic
    c.torquelimit = pi/90; % limit for external torque action
    c.torque = 0;   % represents logical signal of torque
    
end