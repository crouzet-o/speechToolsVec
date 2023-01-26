function cdf = zgauss_cum(x,mu,sigma);

% Formule de la fonction normale cumul�e de moyenne mu et
% d'�cart-type sigma.
%
% Default values : mu = 0, sigma = 1 (fonction normale r�duite)

if nargin < 1,
	error('Type help zgauss_cum to get USAGE');
end

if exist('mu') == 0
	mu = 0;
end

if exist('sigma') == 0
	sigma = 1;
end

cdf = 0.5 * ( 1 - erf( (mu-x) ./ sqrt(2*sigma) ) );
