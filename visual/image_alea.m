function out = image_alea(image);

% mélange aléatoirement les échantillons d'une matrice image.

dimensions = size(image);

% si format de l'image et uint8, la transformer en double
temp = double(image);

% ne garder que les deux premieres dimensions pour image NB
%x = rand(dimensions(1)*dimensions(2)*dimensions(3),1); % pour une image couleur ???
x = rand(dimensions(1)*dimensions(2),1); % pour une image NB.

[Xs, I] = sort(x);
temp = temp(:);

% ne garder que les deux premieres dimensions pour image NB
%temp = reshape(temp(I),dimensions(1),dimensions(2),dimensions(3)); ???
temp = reshape(temp(I),dimensions(1),dimensions(2));

out = uint8(temp);
