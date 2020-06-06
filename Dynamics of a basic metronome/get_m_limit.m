function m = get_m_limit(I)
    g = 9.8;
    M = 0.1;
    L = 0.25;
    beta = 0.001;
    K = 0.35;
  
    m = (2*K-M*L*g)./(2*I*g);
end