function y = ramps_signal(t,m,xo)
    % generates one sinal with several ramps from period and slope values.
    
    % t and m vectores have to be the same size;
    if( length(t) ~= length(m) )
        aux = min(length(t),length(m));
        t=t(1:aux);
        m=m(1:aux);
    end
    
    % t must be positive
    t = abs(t);
    
    % max period resolution 
    samp_t = 0.1;
    
    % create signal
    y(1:round(sum(t)/samp_t+1)) = xo;
  
    aux = t;
    j=1;
    
    for i = 1:sum(t)/samp_t

        if aux(j) <= 0
            j=j+1;
        end
        y(i+1)=y(i)+(m(j)*samp_t);      % slop
        aux(j) = aux(j) - samp_t;

    end
    y = timeseries(y',linspace(0,sum(t)+1,sum(t)/samp_t+1));
    
end

