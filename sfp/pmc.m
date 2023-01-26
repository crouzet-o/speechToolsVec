function [coeff,err] = pmc(infile,poly_order);

% Polynomial interpolation of data from [x] and [y] coordinates
% 
% PMC = PsychoMetric Curve.
% Lit un fichier texte contenant deux colonnes de
% donn�es (x et y). La premi�re colonne appara�tra en abcisse et la seconde
% en ordonn�e. Fait ensuite une interpolation sur les donn�es en cherchant
% une fonction (d'ordre N) qui soit une bonne approximation des donn�es.
% G�n�re ensuite un graphique plottant les points originaux et la courbe
% psychom�trique suppos�e.
%
% Donner le choix entre un fit � partir des d' ou des taux de bonnes r�ponses.
%
% USAGE : [p,s] = pmc(infile,N);
% Exemple : [p,s] = pmc('sujet1.txt',3);

% lecture du fichier texte
array = dlmread(infile,' ')
noise = array(:,1);
hr = array(:,2);
far = array(:,3);

[dprime,beta] = sdt(array(:,2),array(:,3))



% polynomial interpolation
[coeff,err] = polyfit(x,y,poly_order);
X_fit = min(x)-1:(max(x)-min(x))/1000:max(x)+1;
Y_fit = polyval(coeff,X_fit);

% Autre m�thode (plus g�n�rale)
%X_fit = [ones(size(x)) x x.^2 x.^3];
%coeff = X_fit\y;

% trac�
figure;
plot(x,y,'o',X_fit,Y_fit);
grid on;

%Idem avec une fonction non-polynomiale :

%Y_fit = [fonction ne mentionnant pas les inconnues];
%Y_fit = [ ones(size(x)) 1 - ( p_random * exp ( - ((x/alpha).^beta) ))

%coeff = Y_fit\y;
%X_fit = (min(x)-1:(max(x)-min(x))/1000:max(x)+1)';
%Y_fit = [meme formulation]*coeff;

%Plots the real points and the hypothesized curve.
%plot(X_fit,Y_fit,'-',x,y,'o');
%grid on;

% Calcul du seuil
%seuil = 50;
%for X_fit = min(x):(max(x)-min(x))/1000:max(x)
%	if round(Y_fit) == seuil
%		threshold = X_fit
%	end
%end

