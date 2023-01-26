function status = pest(sujet);

% Proc�dure Adaptative pour l'estimation du seuil de perception de la
% parole dans du bruit.
% Proc�dure adaptative � contraintes fortes : PEST (Bonnet)
% G�n�ration de bruit appari� pour l'enveloppe d'amplitude et le spectre
% � long terme.
%
% USAGE : pest(sujet);

% Param�tres :

if isempty(findstr(sujet,'.')),
	sujet=[sujet,'.res'];
end

snr_ini = 0;
step_ini = 4;

nb_trials_max = 400;
nb_inv_max = 10;

constant = 2;
p_hits_threshold = .75;

% initialisation des variables :

nb_inv = 0;
snr(1:nb_trials_max) = zeros(1:nb_trials_max);
step(1:nb_trials_max) = zeros(1:nb_trials_max);
p_hits(1:nb_trials_max) = zeros(1:nb_trials_max);
t_hits(1:nb_trials_max) = zeros(1:nb_trials_max);
answer(1:nb_trials_max) = zeros(1:nb_trials_max);
stimulus(1:nb_trials_max) = zeros(1:nb_trials_max);


% D�but de l'exp�rience : %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data_file_id = fopen(sujet,'at'); % pr�pare le fichier de r�sultats

n = 0;
snr(n) = snr_ini;
step(n) = step_ini;


% Affichage de l'interface sur l'�cran
close all;
%debut = 0;
interface_seuils_6AFC; % Affiche l'interface
%while debut == 0
%    pause(1);
%end
text_handle1=findobj('String','1');
text_handle2=findobj('String','2');
text_handle3=findobj('String','3');
text_handle4=findobj('String','4');
text_handle5=findobj('String','5');
text_handle6=findobj('String','6');


while ((n < nb_trials_max) | (nb_inv < nb_inv_max)),
n = n + 1;

	if t_hits(n) <= ((p_hits_threshold * n) - constant)
      step(n) = step(n-1)/2;
      snr(n) = snr(n-1) + step(n);
         
% cr�er et jouer stimulus + sauver data + incr�menter variables
% Choix aleatoire du stimulus � jouer : %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

			x = randperm(2);
				if x(:,1) == 1
			   	x = 'm';
				else x = 'n';
				end
   
			y = randperm(2);
				if y(:,1) == 1
			   	y = 'l';
				else y = 'i';
			   end
   
			z = randperm(6);

			file(n) = [x,num2str(z(:,1)),'_',y,snr(n),'.sig'];
         
         % G�n�ration du stimulus bruit�
			signal(n) = normalize(loadsig(file(n),1500);
			noise_wave(n) = rms_noise(signal,'shap','n',0);
			noise_spec(n) = lts_filt(noise_wave(n),signal(n),128,4);
			outsig(n) = merge(signal(n),noise_spec(n),snr(n));
			wavplay(outsig(n),44100); % Joue le stimulus

         % Cotation des r�ponses
         if (((answer(n) == 1) & (x == 'm') | ((answer(n) == 0) & (x == 'n')))
			   t_hits(n) = t_hits(n-1) + 1;
				else
			   t_hits(n) = t_hits(n-1);
				end
         
	elseif t_hits(n) >= ((p_hits_threshold * n) + constant)
   step(n) = -(step(n-1)/2);
   snr(n) = snr(n-1) + step(n);
   % cr�er et jouer stimulus
         
   else
      step(n) = 0;
      snr(n) = snr(n-1) + step(n);
   % cr�er et jouer stimulus
   end
   
   % Ici, ins�rer l'incr�mentation des variables, nb_inv, etc
   if (( step(n) < 0 )&( step(n-1) > 0 ))|(( step(n) > 0)&( step(n-1) < 0))
      nb_inv = nb_inv +1;
   end
   
% Ecrit les r�sultats dans un fichier
fprintf(data_file_id,'%6.0f\t%s\t%6.0f\t%6.0f\t%6.0f\n',n,file(n),snr(n),answer(n),t_hits(n));

%pause(pause_duration);
%reponse = 0;

end % end boucle while sur nb_trials_max essais

status = fclose(data_file_id);
if status == 0
   disp('Exp�rience Termin�e');
end
