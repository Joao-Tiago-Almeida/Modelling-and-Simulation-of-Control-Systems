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
pi_eq = get_limiting_distribution(P);

figure(); clf;
bar(pi_eq);
set(gca,'XTick', 1:20);

%% Pergunta 2b - Geração de observações de RSS

[~,A,b] = RSS_weighted(nodePos, sourcePos, pi_eq, 20);

RlsPar = struct('lam',1); % algoritmo para determinar parâmetros
[e,w,RlsPar] = qrrls(A,b,RlsPar);

disp(norm(sourcePos'-w(1:2))); % distância entre source e estimado w (RLS)

figure(1);
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
disp(['Entropia ótima: ' num2str(entropy(zeros(1,20)+1/20))]);
disp(['Entropia da cadeia: ' num2str(entropy(pi_eq))]);

P_opt = P;
P_opt(3,19) = 0.65; P_opt(3,12) = 0.35;
P_opt(1,6) = 0.3; P_opt(1,7) = 0.35; P(1,20) = 0.35;
P_opt(19,3) = 0.4; P_opt(19,4)= 0.2; P_opt(19,13) = 0.2;

pi_eq_opt = get_limiting_distribution(P_opt);

disp(['Entropia da cadeia alterada (melhorias): ' num2str(entropy(pi_eq_opt))]);

figure(); clf;
bar(pi_eq_opt);
set(gca,'XTick', 1:20);

nr_samples = 1000;

ni_v = normrnd(0,0.1,[1,nr_samples]);
seq = state_seq_gen(P_opt, nr_samples);
[P_i,A,b] = RSS_m1(nodePos, sourcePos, seq, ni_v); % gera RSS via metodo 1

z = A\b;

figure();
plot(z(1),z(2),'g*', 'LineWidth', 2); % plot do estimado z
% isto funciona... falta fazer o oposto (Jamming)
% esta pergunta é um pouco freestyle e deve ser feita em último, porque
% quanto mais melhor.

P_jam = P;

%P_jam(7,19) = 0.10; P_jam(7,20) = 0.3; P_jam(7,16) = 0.3; P_jam(7,1) = 0.3;
%P_jam(19,7) = 0.55; P_jam(19,3) = 0.1; P_jam(19,4) = 0.1;

P_jam(6,1) = 0.02; P_jam(6,11) = 0.49; P_jam(6,15) = 0.49;
P_jam(1,6) = 0.98; P_jam(1,20) = 0.01; P_jam(1,7) = 0.01;

pi_eq_jam = get_limiting_distribution(P_jam);

etrp = entropy(pi_eq_jam);

disp(['Entropia da cadeia alterada (jamming): ' num2str(entropy(pi_eq_jam))]);

figure(); clf;
bar(pi_eq_jam);
set(gca,'XTick', 1:20);

nr_samples = 1000;

seq = state_seq_gen(P_jam, nr_samples);
[P_i,A,b] = RSS_m1(nodePos, sourcePos, seq, ni_v); % gera RSS via metodo 1

z = A\b;

figure();
plot(z(1),z(2),'b*', 'LineWidth', 2);
%% Pergunta 3a - Monte Carlo
close all

seq_MC = state_mmc_gen(P,'Original');
evo_mat_eq = state_to_probability(seq_MC);
MarkovTime(evo_mat_eq,'Original');
convergence_pace(evo_mat_eq,pi_eq,'Original');

%% - otimizado
seq_MC_opt = state_mmc_gen(P_opt,'Otimizada');
evo_mat_opt = state_to_probability(seq_MC_opt);
MarkovTime(evo_mat_opt,'Otimizada');
convergence_pace(evo_mat_opt,pi_eq_opt,'Otimizada');

%% - jamming
seq_MC_jam = state_mmc_gen(P_jam,'com Jamming');
evo_mat_jam = state_to_probability(seq_MC_jam);
MarkovTime(evo_mat_jam,'com Jamming');
convergence_pace(evo_mat_jam,pi_eq_jam,'com Jamming');

%% Pergunta 3b - erro ao longo do tempo
RSS_mmc(seq_MC,'Original');
RSS_mmc(seq_MC_opt,'Otimizada');
RSS_mmc(seq_MC_jam,'com Jamming');
RSS_mmc(seq_MC,'Original e estado inicial 8',8);
RSS_mmc(seq_MC,'Original e estado inicial 12',12);
RSS_mmc(seq_MC,'Original e estado inicial 17',17);
%% Pergunta 3c - source a mexer-se
RSS_mmc(seq_MC,'Original e fator de esquecimento \lambda = 1','',1);
RSS_mmc(seq_MC,'Original e fator de esquecimento \lambda = 0.7','',0.7);
RSS_mmc(seq_MC,'Original e fator de esquecimento \lambda = 0.3','',0.3);

