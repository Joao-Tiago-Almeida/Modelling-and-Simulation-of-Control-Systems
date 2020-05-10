function bpm_c = getBPM(y,s,tit,~)
    % return BPM of a simation, and plot a figure with time response if nargin>2
    % and theoretical analysis if nargin>3
    % designed for a linear system arround steady point

    v = y.simout.Data(:,1);
    t = y.simout.Time;

    % plotYY(sig.y,'Response to Initial Condition -  multiple blocks');

    [~,idx] = findpeaks(v,t);   % time instants when one cycle is completed.
    time_cycle = mean(diff(idx)); % average cycle time
    bpm_c = time_cycle\2*60; % one cycle is two beats. bpm = bps * 60;
    
    if nargin > 2 % includes graph of simulation
        
        disp(['[COMPUTED] BPM: ' num2str(bpm_c)]);
        
        f = plotYY(y,[tit num2str(bpm_c)]);
    
        A = s.sys.A;
        
        if nargin > 3   % includes graph of theoretical analysis
            % oscilatory system means complex solution

            r = roots([inv(A(1,2)) -A(2,2)/A(1,2) -A(2,1)]);
            rr = real(r(1));
            ri = imag(r(1));  

            c1 = pi/4;
            c2 = -c1*rr/ri;

            x1 = @(t) c1.*exp(rr*t).*cos(ri*t) + c2.*exp(rr*t).*sin(ri*t);  % response in time

            t = 0:0.1:max(t);

            plot(t,x1(t),'*');
            l = legend();
            l.String{3} = 'theoretical analysis';
        end
    end
    
%end

degub = 1;
