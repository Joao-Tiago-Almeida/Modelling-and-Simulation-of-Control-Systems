function e = entropy(pi_eq)
    e = - sum(pi_eq .* log(pi_eq));
end