function y = ramps_signal(t,m,xo)
    % generates one sinal with several ramps from period and slope values.
    
    % t and m vectores have to be the same size;
    if( length(t) ~= length(m) )
        aux = min(length(t),length(m));
        t=t(1:aux);
        m=m(1:aux);
    end
    
    t = abs(t); % t must be positive
    samp_t = 0.1;   % max period resolution 
    y(1:round(sum(t)/samp_t+1)) = xo;   % declare signal
    aux = t;    j=1;    % auxiliar variables
    
    for i = 1:sum(t)/samp_t    % ouput sinal increment
        
        % period limit
        if aux(j) <= 0
            j=j+1;
        end
        aux(j) = aux(j) - samp_t;
        
        y(i+1)=y(i)+(m(j)*samp_t);      % slope
    end
    
    y = timeseries(y',linspace(0,sum(t)+1,sum(t)/samp_t+1));    % return a sinal with multiple slopes
    
end

