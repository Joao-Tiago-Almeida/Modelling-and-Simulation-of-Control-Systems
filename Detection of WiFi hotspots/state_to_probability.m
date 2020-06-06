function y = state_to_probability(x)
    % create a evolutive probability matrix from many runs (mmc)
    
    prob = zeros(size(x,2),20);
    [~,t] = meshgrid(1:20,1:size(prob,1));
        
    for i = 1:size(prob,1)  % evolution average per instant
        aux = tabulate(x(:,i));
        prob(i,aux(:,1)) = aux(:,3)/100;
    end
    y = cumsum(prob)./t; % time evolution

end

