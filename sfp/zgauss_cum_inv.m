function inv_cdf = zgauss_cum_inv(p);

% Formule inverse de la distribution centr�e r�duite cumul�e :
% (de moyenne = 0 et d'�cart-type = 1).

inv_cdf = erfinv(2*p-1) * sqrt(2);