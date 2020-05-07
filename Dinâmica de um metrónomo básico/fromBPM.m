% function fromBPM(bpm)
    bpm = 150;
    % find values for m and l, based on kwonw BPM
    
    % known variables
    L = 0.25;  % m - arm length
    M = 0.1; % Kg - arm mass
    k = 0.35;    % Nm/rad
    g = 9.8;    % m/s^2 - gravitational acceleration
    beta = 0.001;   % Nms/rad
    
    l = 0.05:1e-3:0.25; l=l';
    m = 1:0.5:200; m=m'*1e-3;   % supposing that pontual mass is less than 0.2 Kg
    
    wd = bpm*pi/60; % known from the question 9
    
    [l,m] = meshgrid(l,m);
    num = k - g * (l.*m + M*L/2);
    J = m.*l.^2 + 3\M*L^2;  % moment of inertia
    
    wn_c = real(sqrt(num./J));  % calculated natural frequency
    
    % Due to damping ratio is not 0, natural and damping frequencies differ
    zeta = beta./(2*J.*wn_c); % damping ratio
    wd_c = real(wn_c.*sqrt(1-zeta.^2)); % relation between frequencies
    
    w_dif = abs(wd_c - wd);
    
    [~,col] = min(min(w_dif,[],1)); % get minimum from the minimum of each column
    [~,row] = min(min(w_dif,[],2)); % get minimum from the minimum of each row

    disp(['[GOAL] damping frequency: ' num2str(wd)]);
    disp(['[CALCULATED] damping frequency: ' num2str(wd_c(row,col))]);
    disp(['difference: ' num2str(w_dif(row,col))]);
    disp(['[CALCULATED] length - l: ' num2str(l(1,col))]);
    disp(['[CALCULATED] mass - m: ' num2str(m(row))]);
    
% end

    surfc(l,m,wd_c*60/pi)
    shading interp;
    view(45,30);

    m = m(row);
    l = l(1,col);
    
    s.J = m.*l.^2 + 3\M*L^2;  % moment of inertia
   


s.A21 = (-k + g*(m*l + M*L/2))/s.J;
s.A22 = -beta/s.J;

A = [0 1;s.A21 s.A22];
B = [0;inv(s.J)];
C = eye(2);   % Although thr only ouput is x1, x2 allow us to give feedback to the system
D = 0;

s.sys=ss(A,B,C,D);

s.x0 = [pi/4;0];    % initial state

sig = set_signal();

c = set_controller(6);
sig.y=sim('metron','StopTime','20');

v = sig.y.simout.Data(:,1);
t = sig.y.simout.Time;

% plotYY(sig.y,'Response to Initial Condition -  multiple blocks');

findpeaks(v,t);