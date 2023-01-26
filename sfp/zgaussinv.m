function x = zgaussinv(z);

% Formule inverse de la distribution centrée réduite (de moyenne = 0 et
% d'écart-type = 1).
% Permet de retrouver x à partir de z.

% Attention, z doit être inférieur ou égal à .3989
x = sqrt( 2 * log(1/( z * (sqrt(2*pi)) )) );
