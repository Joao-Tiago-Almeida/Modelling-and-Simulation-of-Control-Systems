clear; close all;

n = 1e5; % samples

occu1 = 0; % contador ocorrências
occu2 = 0; 

for i = 1:n
   a = randi(6, 1, 20); % 20 lançamentos
   b = movmean(a~=6,3)==0; % explicação detalhada no final
   s = sum(b(2:end-1)); % soma dos elementos relevantes de b
   if s > 0
       occu1 = occu1 + s; % soma às ocorrências método 1
       occu2 = occu2 + 1; % incrementa método 2
   end
end

disp(['Solução 1: ' num2str(occu1/n*100) '%']);
disp(['Solução 2: ' num2str(occu2/n*100) '%']);

% Explicação da linha 10:
% -Sobre o vector a retorna-se o vector que sinaliza posições onde o 6
% ocorre com 0, restantes a 1 (a~=6)
% -Sobre este novo vector efectua-se a moving average 3 a 3 para detectar 3
% zeros seguidos (sinaliza sequência 6-6-6) (movmean(a~=6,3))
% -Sobre o vector obtido de movmean pesquisa-se o número de zeros
% retornando um vector novo com 1 nas posições onde tal acontece.
% A ocorrência de 1 algures no vector b (segunda posição à antepenúltima,
% dada a maneira como o moving average é calculado) sinaliza ocorrência da
% sequência 6-6-6 seguida.
% sobre este vector b podemos inferir tanto se a sequência ocorre, como o
% número de vezes que esta ocorre, e assim calcular os dois métodos