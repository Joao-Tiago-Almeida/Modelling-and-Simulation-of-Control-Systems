function seq = state_seq_gen(P, nr_samples,init)
    seq = zeros(1,nr_samples); % alloc, faster...
    
    if nargin > 2 % start pos, first entry
        seq(1) = init; 
    else
        seq(1) = randi(20); 
    end

    for i = 2:nr_samples % retrieving the rest of the samples, according to P
        seq(i) = datasample(1:20,1,'Weights',P(seq(i-1),:));
    end
end