function [P_i, A, b] = RSS_m1(nodePos, sourcePos, seq, ni)
    P_o = 100; % valor dado para P_o
    ai = nodePos(seq,2:3); % elimina a primeira coluna (desnecessária...)
    denom = sum((ai - sourcePos).^2,2); % denominador
    
    P_i = (P_o ./ denom) .* exp(ni'); % valor de P_i (disposição coluna)
    A = [-2*P_i.*ai -ones(size(P_i)) P_i];
    b = -P_i.*(sum(ai.^2,2));
end

% gera valores de P_i a partir da sequência de transição de estados gerada
% aleatóriamente e de acordo com a cadeia estabelecida; o método de geração
% é o método (1) do enunciado, i.e. o método real. 
%
% nota importante: as variáveis passadas para funções não são editadas
% (estilo C, são cópias). Isto é importante por causa da linha 3.