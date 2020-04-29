function [T, alpha, beta, U1, U2, n1, n2] = get_signal(s)

    % get S struct parameters
    
    T=s.T; 
    alpha=s.alpha; 
    beta = s.beta; 
    U1=s.U(1); 
    U2=s.U(2); 
    n1=s.N(1); 
    n2=s.N(2);
    
end

