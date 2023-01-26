function [y,noise] = addnoise_image(matrix,proportion);

% Adds noise into an image (Olivier Crouzet, 12 Novembre 1998).
%
% USAGE: 	addnoise_image(matrix,Prop. of randomly modified pixels);
% EXAMPLE: 	addnoise_image(data,33);

if nargin < 2,
	error('Type help addnoise_image to get USAGE');
end

%if isempty(findstr(infile,'.')),
%	infile=[infile,'.bmp'];
%end

%if isempty(findstr(outfile,'.')),
%	outfile=[outfile,'.bmp'];
%end


%reads image file and tries to find the image format.
%in_image = imread(infile);
%colormap(gray);

% REPRENDRE ICI POUR LE SCRIPT BRUIT DANS IMAGE
% Image = matrice en deux dimensions (si grayscale)
% Ces deux dimensions représentent la verticale et
% l'horizontale. Chaque élément de cette matrice
% contient un nombre qui code pour la luminance de gris.
% Ce nombre etant necessairement compris entre
% 0 et 255 (256 niveaux de gris, format uint8
% (unsigned integer sur 8 bits), on ne peut pas faire
% n'importe quel type de calcul dessus puisqu'on ne peut pas
% logiquement sortir de l'intervalle [0,255].
% La solution pour insérer du bruit dans une image
% consiste donc à générer une matrice de bruit
% de mêmes dimensions et à attribuer de manière aléatoire
% à chaque pixel sa propre valeur ou sa valeur symétrique
% par rapport à 127 (255/2) donc, si x_noise < proportion,
% x_signal = x_signal + 255 - (2*x_signal) si x_signal < 127 et
% x_signal = x_signal - 255 + (2*x_signal) si x_signal > 127.

[M,N] = size(matrix);
y = zeros(size(matrix));
%rms=sqrt(mean(POWER(in_image(:),2)));
%amplitude=sqrt(3)*rms;

rand('seed',sum(clock));
noise = (randn(M,N));
noise = uint8(noise);

for i = 0:M-1,
   for j = 0:N-1,
		if noise(i,j) < 255*(proportion/100),
		%if noise(i,j) < 0,
            y(i,j) = matrix(i,j) + 255 - 2*matrix(i,j);
      else if noise(i,j) >= 255*(proportion/100),
            y(i,j) = matrix(i,j) - 255 + 2*matrix(i,j);
      else
         error('Erreur');
      end
   end
end

% Affiche l'image originale dans une fenêtre
figure;
image(matrix);
map = colormap;

% Affiche l'image finale dans une autre fenêtre
figure;
image(y);
colormap(map);

% Save final image
% imwrite('temp/'out_image,'bmp');
 