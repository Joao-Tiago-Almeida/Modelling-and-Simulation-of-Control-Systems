function pi_eq = get_limiting_distribution(P)
    % get vetor limit from probability matrix
    
    [V,D] = eig(P', 'vector');% eigenstuff

    [~,one_idx] = max(D); % idx do valor próprio máximo

    pi_eq = V(:,one_idx); % distr. eq. (desnorm.); vector próprio associado.
    pi_eq = pi_eq/sum(pi_eq); % normalização (soma == 1)
end