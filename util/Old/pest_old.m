%function status = pest(sujet);

% NB: le lien entre interface et script ne fonctionne pas si le script est
% d�clar� comme une fonction.

% Proc�dure Adaptative pour l'estimation du seuil de perception de la
% parole dans du bruit.
% Proc�dure adaptative � contraintes fortes : PEST (Bonnet)
% G�n�ration de bruit appari� pour l'enveloppe d'amplitude et le spectre
% � long terme.
%
% USAGE : pest(sujet);

% Param�tres :

sujet = input('Sujet : ','s');

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

% D�but de l'exp�rience : %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data_file_id = fopen(sujet,'at'); % pr�pare le fichier de r�sultats

n = 1;
debut = 0;
answer = 0;

% Affichage de l'interface sur l'�cran
close all;
interface_seuils_6AFC; % Affiche l'interface


pause(0.1);
while debut == 0,
    pause(0.1);
end
pause(0.1);

% Lancement du Premier essai %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Choix aleatoire du stimulus � jouer � l'essai 1: %%%%%%%%%%%%%%%%%%%%%%%

			x = randperm(2); % Tirage al�atoire mot vs. non-mot
				if x(:,1) == 1
			   	lex = 'm';
				else lex = 'n';
				end
   
			y = randperm(2); % Tirage al�atoire illegal vs. legal
				if y(:,1) == 1
			   	origin = 'l';
				else origin = 'i';
			   end
 
            z = randperm(6); % Tirage al�atoire num�ro d'item

			file = [lex,num2str(z(:,1)),'_',origin,'.sig']; % Reconstruction du nom du fichier son
        
         % G�n�ration du stimulus bruit�
         signal = normalize(loadsig(file),2000);
			noise_wave = rms_noise(signal,'shap','n',0);
			noise_spec = lts_filt(noise_wave,signal,128,4);
			outsig = merge(signal,noise_spec,snr_ini);
         answer = 0; % Vide le buffer r�ponse
         wavplay(outsig,44100,struct('scaling','none')); % Joue le stimulus
         
                  
while answer == 0, % Attend une r�ponse
   pause(0.1);
   end
   
% Cotation des r�ponses
if (( (answer>=4)&(~isempty(strmatch('m',lex))) )|( (answer<=3)&(~isempty(strmatch('n',lex)) ) ) );
%if (( (answer>=4)&(lex=='m') )|( (answer<=3)&(lex=='n') ) )
	hits(1) = 1;
   else
	hits(1) = 0;
	end
   
t_hits(1) = hits(1);
   
% Ecrit les r�sultats dans un fichier
fprintf(data_file_id,'%6.0f\t%s\t%6.0f\t%6.0f\t%6.0f\t%6.0f\t%6.0f\n',n,file,snr_ini,answer,hits(1),t_hits(1));

snr(n) = snr_ini; % Initialise le snr
step(n) = step_ini; % Initialise le step

while ((n < nb_trials_max) | (nb_inv < nb_inv_max)), % D�but de la boucle adaptative
n = n + 1; % Initialisation n
answer = 0;

%%%%%%%%%%%%%%%%% Premi�re possibilit� : hits < p_seuil (trop difficile) %%%%%%%%%%%%%%%
	if t_hits(n-1) <= ((p_hits_threshold * n) - constant)
   	step(n) = step(n-1)/2;
   	snr(n) = snr(n-1) + step(n);
         
         % Saute � la fin de la boucle if
         
%%%%%%%%%%%%%%%% Seconde possibilit� : hits > p_seuil (trop facile) %%%%%%%%%%%%%%%%%%%
	elseif t_hits(n-1) >= ((p_hits_threshold * n) + constant)
   	step(n) = -(step(n-1)/2);
   	snr(n) = snr(n-1) + step(n);
   
%%%%%%%%%%%%%%%%% Troisi�me possibilit� : hits proche p_seuil %%%%%%%%%%%%%%%%%%%%%%%%%%
	else
      step(n) = 0;
      snr(n) = snr(n-1) + step(n);
      
	end % if
   
%%%%%%%%%%%%%%%% Choix aleatoire du stimulus � jouer : %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			x = randperm(2);
				if x(:,1) == 1
			   	lex = 'm';
				else lex = 'n';
				end
   
			y = randperm(2);
				if y(:,1) == 1
			   	origin = 'l';
				else origin = 'i';
			   end
 
			z = randperm(6);

			file = [lex,num2str(z(:,1)),'_',origin,'.sig'];
         
         % G�n�ration du stimulus bruit�
			signal = normalize(loadsig(file),2000);
			noise_wave = rms_noise(signal,'shap','n',0);
			noise_spec = lts_filt(noise_wave,signal,128,4);
			outsig = merge(signal,noise_spec,snr(n));
         while answer ~= 0,
            answer = 0; % Vide le buffer r�ponse
         end
         wavplay(outsig,44100,struct('scaling','none')); % Joue le stimulus

         while answer == 0
            pause(0.1)
         end
         
% Cotation des r�ponses
if (( (answer>=4)&(isempty(strmatch('m',lex))) )|( (answer<=3)&(isempty(strmatch('n',lex)) ) ) );
%if (( (answer>=4)&(lex=='m') )|( (answer<=3)&(lex=='n') ) )
   hits(n) = 1;
   else
      hits(n) = 0;
	end

t_hits(n) = t_hits(n-1) + hits(n);

% Incr�mentation nb_inv
if (( step(n) < 0 )&( step(n-1) > 0 ))|(( step(n) > 0)&( step(n-1) < 0))
      nb_inv = nb_inv + 1;
end

% Ecrit les r�sultats dans un fichier
fprintf(data_file_id,'%6.0f\t%s\t%6.0f\t%6.0f\t%6.0f\t%6.0f\t%6.0f\n',n,file,snr(n),answer,hits(n),t_hits(n));

% Retourne au d�but tant que n < nb_essais_max ou nb_inv < nb_inv_max
   
end % end boucle while sur nb_trials_max essais

status = fclose(data_file_id);
if status == 0
   disp('Exp�rience Termin�e');
end

%snr = zeros(nb_trials_max,1);
%p_hits = zeros(nb_trials_max,1);
%t_hits = zeros(nb_trials_max,1);
%reponse = zeros(nb_trials_max,1);
%stimulus = zeros(nb_trials_max,1);
%lex = zeros(nb_trials_max,1);
%step = zeros(nb_trials_max,1);
%origin = zeros(nb_trials_max,1);


