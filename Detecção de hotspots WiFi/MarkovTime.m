function MarkovTime(m,tt)
    % plot3 a evolutive probability matrix
    
    if size(m,2) ~= 20   % 20 states - size(m,1) == nr if runs
        disp('[ERROR] In MarkovTime, entry matrix must have 20 columns.')
    end
    
    [nodes,t] = meshgrid(1:20,1:size(m,1));
    
    figure(); clf; hold on;grid on;
    plot3(nodes,t,m);
    view([111.9909 56.0635]);
    xlabel("Estado");
    ylabel('Instante da Run');
    title({'Evolução da Probabilidade de Obtenção do Token na "Run"';['na Cadeia de Markov ' tt]});
    set(gca,'XTick',1:20);

end

