function y = quick(x,p_random,alpha,beta);

% Quick (1974) function for psychometric curve estimation
%
% Formule de Quick (1974) pour l'approximation de la fonction
% psychom�trique dans un paradigme de choix forc�.
% La fonction de Quick est une fonction logistique.
%
% alpha = niveau du stimulus correspondant � p(hr) = .75
% (pour une proc�dure 2AFC ; .66 pour 3AFC, ...).
% beta = param�tre li� � la pente de la fonction.
% p_random = 0.5 (car 2 alternatives).
%
% REFERENCES:
% Quick, R.F.Jr. (1974). A vector-magnitude model of contrast detection.
%	Kybernetic, 16, 65-67.
% Bonnet, C. (1985). Manuel pratique de psychophysique. Armand Colin, Paris.

y = 1 - ( p_random * exp ( - ((x/alpha)^beta) ));
