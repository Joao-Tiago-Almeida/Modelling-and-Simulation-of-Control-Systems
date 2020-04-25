function [v_t, v_u] = u_generator(s,str)
    % parsing da string de entrada
    [T, alpha, beta, U1, U2, n1, n2] = get_s(s);
    
    % verificao dos limites de alpha e beta 
    beta = beta_bounds(beta);
    alfa = alfa_bounds(alpha);
    
    % calculo do comprimento de u1 e u2
    T1 = T/(1+alpha);
    T2 = T - T1;
    
    % vector de tempos normalizados para u1 e u2
    v_t1 = linspace(-(beta+1)/2, (beta+1)/2, n1);
    v_t2 = linspace(-(beta+1)/2, (beta+1)/2, n2);
    
    % vector resultante da funcao de impulso para u1 e u2 (normalizado)
    v_u1 = u_impulse(v_t1, beta);
    v_u2 = u_impulse(v_t2, beta);
    
    % desnormalizacao amplitude
    v_u1 = -U1*v_u1;
    v_u2 = U2*v_u2;
    
    % desnormalizacao comprimento e posicao no tempo
    v_t1 = v_t1*((T1)/(1+beta)) + T1/2;
    v_t2 = v_t2*((T2)/(1+beta)) + T1 + T2/2;
    
    % array de tempos e amplitude final
    v_t = [v_t1 v_t2(2:end)];
    v_u = [v_u1 v_u2(2:end)];
end