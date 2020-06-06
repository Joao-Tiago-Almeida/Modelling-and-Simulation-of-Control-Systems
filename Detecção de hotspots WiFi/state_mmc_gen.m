function y = state_mmc_gen(P,t)
    n = 5e3;  % para termos um intervelado de confiança de 95% - N=1e4/(1-p) -> 2e5
    nr_samples = 250;% numero de transições entre estados
    
    y = zeros(n,nr_samples); % alloc, faster...
    
    f = waitbar(n,'Good things come to those who wait...','Name','MMC');
    for i = 1:n     % simulate n times
        y(i,:) = state_seq_gen(P, nr_samples);
        waitbar(i/n,f);
    end
    close(f);
    
    tbl_s_mc_3 = tabulate(reshape(y,[],1));
    
    f = figure(); clf; hold on;grid on;
    bar(1:20,[tbl_s_mc_3(:,3)*1e-2 , get_limiting_distribution(P)]); % compare with pi_eq from 2a, the bigger nr_samples is the more accurate result will be.
    title(['Distribuição dos Estados na cadeia de Markov ' t]);
    xlabel('Estados');
    xticks(1:1:20);
    ylabel('Probabilidade de obter o Token');
    l = fLegend({'Método de Monte Carlo';'Vetor de Probabilidades \newline Teórico'},'bestoutside');
    f.Position(3) = f.Position(3)*(1+l.Position(3));

end
