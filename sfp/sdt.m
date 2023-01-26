function [dprime,beta] = sdt(hr,far);

% d-prime and beta computation from hit and false-alarm rate
%
% Calcul du d' et du beta a partir des probabilit�s de hit-rate (hr) et
% de false-alarm-rate (far).

% On transforme d'abord les valeurs hr et far en variables centr�es
% r�duites de moyenne mean = 0 et d'�cart-type stdv = 1.
% Ceci se r�alise en allant consulter les tables de la loi Normale
% r�duite cumul�e avec la fonction zgauss_cum_inv.m
% Une fois qu'on a les probabilit�s de hr et de far (i.e. p(s/S) et p(s/B)
% en valeurs d'une variable centr�e r�duite (i.e. z(s/S) et z(s/B), 
% le d' est �gal � :
%
% d' = z(s/S)-z(s/B)
% 	 = zgauss_cum_inv(1-far) - zgauss_cum_inv(1-hr)
%
% Le Beta est calcul� en divisant la surface sous la courbe de la
% distribution des hr par celle de la distribution des far.
% 
%           Beta = (surface_sous z(s/S)) / (surface_sous z(s/B))
% 	=
%
% Il faudrait aussi permettre d'approximer le d' � Beta constant
% ou Beta = 0 ou Beta = 1 (cf Bonnet, 1986) si on trouve que les
% distributions de s et b ne sont pas hom�ostatiques (ou utiliser 
% le A'). Il faudrait aussi permettre de calculer les autres statistiques
% li�es � la SDT (cf MacMillan & Creelman, Creelman & Kaplan, Swets,
% Tanner & Swets, ...

% Calcul du d' :
% z_hr = zgauss_cum_inv(1-hr)
% z_far = zgauss_cum_inv(1-far)
% dprime = z_far - z_hr
dprime = zgauss_cum_inv(1-far) - zgauss_cum_inv(1-hr);

%Calcul du Beta :
beta = zgauss(zgauss_cum_inv(1-hr))/zgauss(zgauss_cum_inv(1-far));