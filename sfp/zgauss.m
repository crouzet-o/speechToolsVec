function y = zgauss(x);

% Formule de la distribution centrée réduite (de moyenne = 0 et
% d'écart-type = 1).

y = (1/sqrt(2*pi)) * exp(-(x.^2) ./2);


% sigma = 1;
% mu = 0;
% y = 1/sqrt(2*pi*sigma))*exp(-(x-mu).^2/(2*sigma));
% y = (1/sqrt(2*pi)) * exp(-.5 * (x.^2));

% Pour intégrer cette fonction (et donc déterminer l'aire sous la courbe
% entre deux valeurs de l'abcisse, on lance :
%
%q = quad8('zgauss',x1,x2);
% ou
%q = quad('zgauss',x1,x2);

% On peut la plotter avec :
% fplot('zgauss',[x1 x2]);

% Nota (à vérifier) :
% Gaussian cdf (Cumulée)
% cdfinv = 0.5 * ( 1 + erf( (x-mu)./ (sigma*sqrt(2)) ));
% cdf = 0.5 * ( 1 - erf( (mu-x) ./ sqrt(2*sigma) ) );
