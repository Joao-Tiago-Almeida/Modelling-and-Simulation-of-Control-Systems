function s = set_system(b)
    % Declares system struct
    
    s = struct('name', 'Disco Rígido');
    
    if nargin == 0  % default value for friction
        b = 0;  % friction
    end

    A = [0 1; 0 -b]; B = [0; 1]; C = eye(2); D = 0;	% $\ddot{y} = u - b\dot{y}$
    s.X0 = [1;0];	% initial condiction
    s.sys = ss(A,B,C,D);	% steady-state
    s.Gz = tf(s.sys);	% continuous-time transfer function.
end

