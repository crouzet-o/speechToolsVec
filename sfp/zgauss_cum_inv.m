function inv_cdf = zgauss_cum_inv(p);

% Formule inverse de la distribution centrée réduite cumulée :
% (de moyenne = 0 et d'écart-type = 1).

inv_cdf = erfinv(2*p-1) * sqrt(2);