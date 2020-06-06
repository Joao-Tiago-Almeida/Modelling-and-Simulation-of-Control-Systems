function [P_i, A, b] = RSS_weighted(nodePos, sourcePos, pi_eq, acc_fac)
    P_o = 100; % valor dado para P_o
    ai = nodePos(:,2:3); % elimina a primeira coluna (desnecessária...)
    denom = sum((ai - sourcePos).^2,2); % denominador
    
    ni = sum(normrnd(0,0.1,[acc_fac,numel(pi_eq)]))/acc_fac;
    disp(size(ni));
    P_i = (P_o ./ denom) .* exp(ni'); % valor de P_i (disposição coluna)
    A = [-2*P_i.*ai -ones(size(P_i)) P_i];
    b = -P_i.*(sum(ai.^2,2));
    
    factor = diag(pi_eq);
    A = factor * A;
    b = factor * b;
end
