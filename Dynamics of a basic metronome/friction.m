function s = friction(beta,s)
    % update system for new friction 
    
    % changes beta parameter
    s.beta = beta;
    s.A22 = -s.beta/s.J;
    A = [0 1;s.A21 s.A22];
    s.sys=ss(A,s.sys.B,s.sys.C,s.sys.D);
    
end