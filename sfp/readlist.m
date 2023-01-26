function text_array = readlist(filename);

% Read a text file and store each line into a matlab structure
%
% Cette fonction permet de lire un fichier texte et de stocker chaque ligne 
% dans un tableau (une structure). La matrice créée est une structure avec
% un seul champ. On fait référence à ce champ en appelant name.file
% On appelle une case de cette matrice par name(4).file
%
% On peut alors aller chercher dans cette structure tout ce que l'on veut
% et notamment, le nom d'un fichier son à jouer en appliquant n'importe
% quelle fonction sur ce référent :
% EXEMPLE : stimulus = readlist('stimuli.txt');
%			x = loadsig(stimulus(4).file);
%
% On peut aussi connaître le nombre de champs (et donc de lignes dans le
% fichier texte) par la commande :
% nb_stim = size(list);
%
% L'info est dans la seconde colonne :
% size_list = nb_stim(:,2);
%
% Ce qui permet de jouer les stimuli dans un ordre aléatoire avec :
% randperm(size_list);

fid = fopen(filename,'rt');
if fid < 0,
	errmsg = sprintf('%s%s%s','File: ',filename,' does not exist.');
	error(errmsg);
end

n = 0;

while feof(fid) ~= 1,
   n = n + 1;
   text_array(n).file = fgetl(fid);
end

fclose(fid);
