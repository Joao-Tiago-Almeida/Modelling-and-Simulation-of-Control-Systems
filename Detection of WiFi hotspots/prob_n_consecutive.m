n = 1e6;    % número de runs
M = randi(6,n,20);  % lançamento aleatório de dados

p = 0;  % inicialização
f = waitbar(n,'Good things come to those who wait...','Name','Challenge');
for i = 1:n     % run
    p = p + mmc_challenge(M(i,:));  % soma cumulativa dos acontecimentos ocurridos 
    waitbar(i/n,f);
end
close(f);

p = 100*p/n;    % probabilidade em percentagem
disp([num2str(p) ' %']);

function y = mmc_challenge(v)
% avalia o número de aconteceimentos de acontecer n vezes ou mais consecutivas o número i
    v = reshape(v,1,[]);    % vetor linha

    n = 3; % número minimo de vezes consecutivo 
    i = 6; % estado a avaliar
    
    d = [0 diff(v) == 0];   % true se o número é igual ao anteior
    mov = movmean(d,n-1);   % vê se o número acontece n vezes seguidas, 1 caso aconteça à pelo menos 2 vezes
    mov(1:n-1) = 0;   % nos n-1 primeiros casos não há amostras sufucientes
    
    % conta apenas 1 vez por bloco, ou seja, no caso do número de
    % acontecimentos consecutivos superer n. 
    %for i = 1:n-1   
    %    mov(i) = mov(i) * ~mov(i+1); % o valor seguinte é diferente ou seja, o bloco consecutivo acaba
    %end


    result = (mov == 1) .* (v == i);
    
    y = sum(result); % número de acontecimentos na run

end

