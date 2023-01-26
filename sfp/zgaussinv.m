function x = zgaussinv(z);

% Formule inverse de la distribution centr�e r�duite (de moyenne = 0 et
% d'�cart-type = 1).
% Permet de retrouver x � partir de z.

% Attention, z doit �tre inf�rieur ou �gal � .3989
x = sqrt( 2 * log(1/( z * (sqrt(2*pi)) )) );
