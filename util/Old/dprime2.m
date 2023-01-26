function [dprime,beta] = dprime(hr,far);

% Calcul du d' et du beta a partir d'un fichier texte.
%
% On transforme d'abord les valeurs hr et far en variables centrées
% réduites de moyenne mean = 0 et d'écart-type stdv = 1.
% Ceci se réalise en allant consulter les tables de la loi Normale
% réduite avec la fonction gaus_pdf.m (communications toolbox).

% Une fois qu'on a les probabilités de hr et de far (i.e. p(s/S) et p(s/B),
% on va consulter la table de gauss qui donne en abcisse les probabilités
% correspondant aux valeurs de la variable centrée réduite. Il faut donc 
% regarder dans cette table à quelle abcisse correspond la probabilité sur
% l'ordonnée.
%
% Fonction normale réduite :
% MEAN = 0, VAR = 1;
%
% y = 1/(sqrt(2*pi*VAR)) * exp(-(x-MEAN)^2/(2*VAR)).x

% d' = z(s/S)-z(s/B)
% Beta = (surface_sous_la_courbe z(s/S)) / (surface_sous_la_courbe z(s/B))
%
% Pour transformer les hr et far en variables normales réduites,
% il faut connaître la distribution de ces variables. Or, par définition,
% on ne les connaît pas. On a donc besoin d'une table de la loi normale 
% réduite pour transformer les probabilités correspondantes en probabilités
% centrées réduites.
%
% Est-ce possible sous Matlab ? En C, il existe une fonction critz et une
% fonction normaldensity qui font ça (???).
% Utiliser la fonction normalpdf.m (fonction de la loi normale réduite),
% A partir de cette fonction, on peut localiser p(s/S) et p(s/B), en déduire
% leurs valeurs en variables centrées réduites et faire une approximation
% de la surface contenue sous la courbe entre ces deux valeurs en
% intégrant avec quad.m (???).
%
% Il faudrait aussi permettre d'approximer le d' à Beta constant
% ou Beta = 0 ou Beta = 1 (cf Bonnet, 1986) si on trouve que les
% distributions de s et b ne sont pas homéostatiques (ou utiliser 
% le A').



z_hr = hr/

[p,x] = gaus_pdf(0,1,1000);
x = x';
p = p';
