function [dprime,beta] = dprime(hr,far);

% Calcul du d' et du beta a partir d'un fichier texte.
%
% On transforme d'abord les valeurs hr et far en variables centr�es
% r�duites de moyenne mean = 0 et d'�cart-type stdv = 1.
% Ceci se r�alise en allant consulter les tables de la loi Normale
% r�duite avec la fonction gaus_pdf.m (communications toolbox).

% Une fois qu'on a les probabilit�s de hr et de far (i.e. p(s/S) et p(s/B),
% on va consulter la table de gauss qui donne en abcisse les probabilit�s
% correspondant aux valeurs de la variable centr�e r�duite. Il faut donc 
% regarder dans cette table � quelle abcisse correspond la probabilit� sur
% l'ordonn�e.
%
% Fonction normale r�duite :
% MEAN = 0, VAR = 1;
%
% y = 1/(sqrt(2*pi*VAR)) * exp(-(x-MEAN)^2/(2*VAR)).x

% d' = z(s/S)-z(s/B)
% Beta = (surface_sous_la_courbe z(s/S)) / (surface_sous_la_courbe z(s/B))
%
% Pour transformer les hr et far en variables normales r�duites,
% il faut conna�tre la distribution de ces variables. Or, par d�finition,
% on ne les conna�t pas. On a donc besoin d'une table de la loi normale 
% r�duite pour transformer les probabilit�s correspondantes en probabilit�s
% centr�es r�duites.
%
% Est-ce possible sous Matlab ? En C, il existe une fonction critz et une
% fonction normaldensity qui font �a (???).
% Utiliser la fonction normalpdf.m (fonction de la loi normale r�duite),
% A partir de cette fonction, on peut localiser p(s/S) et p(s/B), en d�duire
% leurs valeurs en variables centr�es r�duites et faire une approximation
% de la surface contenue sous la courbe entre ces deux valeurs en
% int�grant avec quad.m (???).
%
% Il faudrait aussi permettre d'approximer le d' � Beta constant
% ou Beta = 0 ou Beta = 1 (cf Bonnet, 1986) si on trouve que les
% distributions de s et b ne sont pas hom�ostatiques (ou utiliser 
% le A').



z_hr = hr/

[p,x] = gaus_pdf(0,1,1000);
x = x';
p = p';
