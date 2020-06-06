function c_p_norm = convergence_pace(m,v,esp)
    % gets the convergence pace which correspond of an average of an error
    % of 0.25% per state between evolution probability and limit probability.
    
    if size(m,2) ~= 20  % 20 states - size(m,1) == nr if runs
        disp('[ERROR] In convergence_pace, entry matrix must have 20 columns.')
    end
     
    if size(v,1) * size(v,2) == 20   % 20 states 
        v = reshape(v,1,20);
    else
        disp('[ERROR] In convergence_pace, entry vector must have only 20 elements.')
    end
    
    dif = abs(m-v)*v';    % weight difference between evolution probability and limit probability 
    c_p = find( dif <= 0.0025, 1 ); % first run with less or less then 0.2% error of difference
    c_p_norm = c_p/size(m,1); % return cp normalized
    
    % in case it never converges
    if isempty(c_p_norm)
        disp(['A evolução da probabilidade de obtenção do token, na cadeia de Markov ' esp ', não convergiu para (± 0.25%) dos valores de probabilidades limite em ' num2str(size(m,1)) ' runs.']);
    else
        disp(['A evolução da probabilidade de obtenção do token, na cadeia de Markov ' esp ', demora em média ' num2str(c_p_norm,'%.2f') ' da "Run" a convergir para (± 0.25%) dos valores de probabilidades limite.'])
    end
    
end

