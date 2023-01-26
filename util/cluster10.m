% Paramètres :

sujet = input('Sujet : ','s');
snr_threshold = input('Rapport Signal-Bruit : ');
nom_liste = input ('Liste de stimuli : ','s');

nb_blocs_max = 40;

if isempty(findstr(sujet,'.')),
	sujet=[sujet,'.res'];
end

% Charge la liste des stimuli et compte le nombre de stimuli:
liste = readlist(nom_liste);
nb_stim = size(liste);
nb_stim = nb_stim(:,2);

% Début de l'expérience : %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data_file_id = fopen(sujet,'at'); % prépare le fichier de résultats

n = 0;
nb_bloc = 0;
debut = 0;
answer = 0;
confidence = 0;

% Affichage de l'interface sur l'écran
close all;
interface_niveaux; % Affiche l'interface


pause(0.1);
while debut == 0,
    pause(0.1);
end
pause(0.1);

while nb_bloc < nb_blocs_max, % Boucle des blocs de stimuli
   
   nb_bloc = nb_bloc + 1;
   ordre_stimuli = randperm(nb_stim);
   
   while n < nb_stim, % Boucle des stimuli à l'intérieur des blocs
      
      n = n + 1; % Initialisation n
      answer = 0;
      confidence = 0;

%%%%%%%%%%%%%%%% Choix aleatoire du stimulus à jouer : %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			file = deblank(liste(ordre_stimuli(n)).file);

         % Génération du stimulus bruité
			signal = normalize(loadsig(file),2000);
			noise_wave = rms_noise(signal,'shap','n',0);
			noise_spec = lts_filt(noise_wave,signal,128,4);
			outsig = merge(signal,noise_spec,snr_threshold);
         %while ((answer ~= 0) | (confidence ~= 0)),
            %answer = 0; % Vide le buffer réponse
            %confidence = 0;
         %end
         wavplay(outsig,44100,struct('scaling','none')); % Joue le stimulus

         while answer == 0,
            pause(0.1);
         end
         while confidence == 0,
            pause(0.1);
         end
                  
% Ecrit les résultats dans un fichier
fprintf(data_file_id,'%6.0f\t%6.0f\t%s\t%6.0f\t%6.0f\t%6.0f\n',nb_bloc,n,file,snr_threshold,answer,confidence);

	end  % Retourne au début tant que n < nb_stim
   
end % end boucle while sur nb_blocs_max

status = fclose(data_file_id);
if status == 0
   disp('Expérience Terminée');
end
