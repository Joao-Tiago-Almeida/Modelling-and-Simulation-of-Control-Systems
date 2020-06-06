%% Optimização do servomecanismo de um disco rígido
%
% Cadeira: Modelação e Simulação 2º Semestre 2019/2020
% Trabalho de Laboratório nº 2
% Alunos: Daniel Leitão 90042 - João Almeida 90119
% Grupo: 2
% Turno: Quarta-Feira 8:30-10:30
% Docente: Alexandre Bernardino

%% Inicialização, carregamento dos dados
close all; clear;

% conteúdos: P - matriz de transição; nodePos - posição de cada estado;
% sourcePos - origem; e muitos mais...
run MarkovChainDraw.m; % load MarkovChain.mat feito aqui

%% Pergunta 2a - Distribuição de Equilíbrio
[V,D] = eig(P', 'vector');% eigenstuff

[~,one_idx] = max(D); % idx do valor próprio máximo

pi_eq = V(:,one_idx); % distr. eq. (desnorm.); vector próprio associado.
pi_eq = pi_eq/sum(pi_eq); % normalização (soma == 1)

figure(); clf;
bar(pi_eq);
set(gca,'XTick', 1:20);

%% Pergunta 2b - Geração de observações de RSS
nr_samples = 500; % number of samples

seq = state_seq_gen(P, nr_samples); % sequência de transições entre estados
%tbl_s = tabulate(seq);
%figure(); clf;
%bar(tbl_s(:,1),tbl_s(:,3)); % tende para o equílibro, igual ao bar acima...

ni_v = normrnd(0,0.1,[1,nr_samples]); % tira nr_samples de ni (gaussiana)
%ni_v = floor(ni_v*1000)/1000;
%tbl_g = tabulate(ni_v);
%figure(); clf;
%bar(tbl_g(:,1),tbl_g(:,3)); % só para ver que é gaussiana...

[~,A,b] = RSS_m1(nodePos, sourcePos, seq, ni_v); % gera RSS via metodo 1

z = A\b;

RlsPar = struct('lam',1); % algoritmo para determinar parâmetros
[e,w,RlsPar] = qrrls(A,b,RlsPar);

disp(norm(sourcePos'-w(1:2))); % distância entre source e estimado w (RLS)

figure(1);
plot(z(1),z(2),'o', 'LineWidth', 2); % plot do estimado z
plot(w(1),w(2),'x', 'LineWidth', 2); % plot do estimado w (RLS)

%% Pergunta 2c - Evolução das probabilidades
pi0 = randi(100,1,20);
pi0 = pi0/sum(pi0);
disp(pi0) % random pi0 gerado (display)
t_step = 2;% intervalo de t
n = 20; % nr de vezes em que se repete o dito intervalo
pi_t = zeros(n+1,20); % inclui o zero (n+1)

pi_t(1,:) = pi0;
for i = 2:n+1
    pi_t(i,:) = pi_t(i-1,:) * P^t_step;
end

figure(); clf;
bar3(pi_t); % passar para plot3, apesar de também ser vísivel em bar3
set(gca,'XTick',1:20);
xlabel("Estados");
ylabel("Iterações");

disp(sum(pi_t,2));

%% Pergunta 2d - Teste de possíveis otimizações.
P_opt = P;
%P_opt(19,3) = 0.55; P_opt(19,4) = 0.15; P_opt(19,7) = 0.15; P_opt(19,13) = 0.15;
P_opt(3,19) = 0.65; P_opt(3,12) = 0.35;
[V,D] = eig(P_opt', 'vector');% eigenstuff

[~,one_idx] = max(D); % idx do valor próprio máximo

pi_eq_opt = V(:,one_idx); % distr. eq. (desnorm.); vector próprio associado.
pi_eq_opt = pi_eq_opt/sum(pi_eq_opt); % normalização (soma == 1)

figure(); clf;
bar(pi_eq_opt);
set(gca,'XTick', 1:20);

seq = state_seq_gen(P_opt, nr_samples);
[P_i,A,b] = RSS_m1(nodePos, sourcePos, seq, ni_v); % gera RSS via metodo 1

z = A\b;
figure(1);
plot(z(1),z(2),'g*', 'LineWidth', 2); % plot do estimado z
% isto funciona... falta fazer o oposto (Jamming)
% esta pergunta é um pouco freestyle e deve ser feita em último, porque
% quanto mais melhor.

%% Pergunta 3a - Monte Carlo

% a função state_seq_gen faz exatamente aquilo que é pedido. Inicialmente
% foi empregue na questão 2b, mas afinal a b é algo mais simples. 

nr_samples = 4000;% o tal número elevado que eles pedem
seq_MC = state_seq_gen(P, nr_samples);

tbl_s_mc = tabulate(seq_MC);
figure(); clf;
bar(tbl_s_mc(:,1),tbl_s_mc(:,3)); % compara com pi_eq da 2a (igual), quanto maior nr_samples melhor fica.

% a partir de seq_MC gera o que precisares.S

