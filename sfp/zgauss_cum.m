function cdf = zgauss_cum(x,mu,sigma);

% Formule de la fonction normale cumulée de moyenne mu et
% d'écart-type sigma.
%
% Default values : mu = 0, sigma = 1 (fonction normale réduite)

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
