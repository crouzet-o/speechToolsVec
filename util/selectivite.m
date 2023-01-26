function out = selectivite(file1,file2,Nb_bands,parite);

% Script de transformation d'un signal acoustique naturel en signal simulant
% le type d'information transmise par un implant cochléaire (N bandes spectrales).
%
% USAGE : selectivite(file1,file2,Nb_bands,parite);
%
% Banques de filtres implémentées dans filterbank.mat. Taper help filterbank
% Nombre de bandes : 2,3,4,5,6,8,10,12,16
%

% filename'_original_all.wav' = signal original ayant subi les mêmes manipulations
% sans dégradation spectrale (uniquement filtrage de largeurs de bandes équivalentes).

if nargin < 4,
	error('Type help selectivite to get USAGE');
end

Passband_ripple = 1;
Stopband_attenuation = 40;

% computes deviations (Rp Rs)
Rp = (10^(-Passband_ripple/20))/(10^(Passband_ripple/20)+1);
Rs = 10^(-Stopband_attenuation/20);
transition = 50; % transition size in Hz
a = 1; % 2nd argument of filtfilt.m

% Loads and defines the frequency bands
load filterbank; % loads the filterbank into workspace

%Tests whether the frequency centers and bandwidths have been defined in filterbank.mat
if sum(Bandwidths(Nb_bands,:)) == 0,
   error_msg = sprintf('%s%d%s%s','Center Frequencies and Bandwidths have not been defined for ',...
         Nb_bands,' band(s).','\rPlease choose another number of bands or define them in filterbank.mat');
   error(error_msg);
end

edges = zeros(2,Nb_bands); % passband edges for each filter band
cutoffs = zeros(Nb_bands,4); % passband cutoffs for each filter band
lower_bound = Center_Freqs(Nb_bands,1:Nb_bands) - Bandwidths(Nb_bands,1:Nb_bands)./2;
upper_bound = Center_Freqs(Nb_bands,1:Nb_bands) + Bandwidths(Nb_bands,1:Nb_bands)./2;
edges = [lower_bound ; upper_bound];

cutoffs = [edges(1,1:Nb_bands);...
   edges(1,1:Nb_bands)+transition;...
   edges(2,1:Nb_bands)-transition;...
   edges(2,1:Nb_bands)]'; %(F) cutoff frequencies (length(F) = (2*length(M))-2)

pattern = [0 1 0]; %(M) desired amplitudes

%Matrices initialization
[signal1,Fs] = wavread(file1);
[signal2,Fs] = wavread(file2);
taille1 = size(signal1);
taille2 = size(signal2);
taille_out = max(size(signal1),size(signal2));
noisy1 = zeros(taille1,Nb_Bands);
noisy2 = zeros(taille2,Nb_Bands);
signal_tmp1 = zeros(taille1,Nb_Bands);
signal_tmp2 = zeros(taille2,Nb_Bands);
signal_out = zeros(taille_out,Nb_Bands);

if parite == 'pair',
   bandes = [2:2:Nb_bands];
else if parite == 'impair',
      bandes = [1:2:Nb_bands];
   else if parite == 'all',
         bandes = [1:1:Nb_bands];
         else 	ERROR('Controler la frappe');
      end
   end
end

%signal_out = zeros(length(signal_out),Nb_bands); % Nb_bands matrix for signal
%signal_tmp = zeros(length(signal_out),Nb_bands);
%noisy = zeros(length(signal),Nb_bands); % Nb_bands matrix for enveloppe modulated noise

% Signal1
%Traitement des bandes de signal individuelles
for j = 1:Nb_bands,
   message = sprintf('%s%d%s%d%s%d%s%d%s','Processing Band #',j,' / ',Nb_bands,'. Freq. Cutoffs = [',round(edges(1,j)),' ',round(edges(2,j)),'].');
   disp(message);
   pause(1);
   % Filter design
	[Order,Wn,beta,win_type] = kaiserord(cutoffs(j,:),pattern,[Rs Rp Rs],Fs);
	% Elaboration du filtre adapté
	b = fir1(Order,Wn,win_type,kaiser(Order+1,beta),'noscale');
   signal_tmp1(:,j) = filtfilt(b,a,signal1);
   %Insertion du bruit, refiltrage et normalization
   noisy1(:,j) = rms_noise(signal_tmp1(:,j),'shap','n');
   noisy1(:,j) = filtfilt(b,a,noisy1(:,j));
   noisy1(:,j) = normalize(noisy1(:,j),rms(signal_tmp1(:,j)));
%end

%for k = 1:Nb_bands,
%   save_to_file = [filename,'_',num2str(Nb_bands),'_',num2str(j)];
%	%signal_out = sig2wav(signal_out);
%   wavwrite(signal_out(:,j),Fs,save_to_file);
%end

%Parite
parite = [2:2:Nb_bands];
%save_to_file_pair = [filename,'_',num2str(Nb_bands),'_all'];

noisy_pair1 = sum(signal_out(:,parite),2);
noisy_pair1 = normalize(noisy_pair1,rms(signal));
noisy_pair1 = sig2wav(out);
%wavwrite(noisy_pair1,Fs,save_to_file_whole);


%Bandes impaires
parite = [1:2:Nb_bands];

save_to_file_whole = [filename,'_',num2str(Nb_bands),'_all'];
out = sum(signal_out(:,parite),2);
out = normalize(out,rms(signal));
out = sig2wav(out);
wavwrite(out,Fs,save_to_file_whole);
%Tout
save_to_file_whole = [filename,'_',num2str(Nb_bands),'_all'];
out = sum(signal_out(:,:),2);
out = normalize(out,rms(signal));
out = sig2wav(out);
wavwrite(out,Fs,save_to_file_whole);

% Original ayant subi le même type de filtrage mais dont les ###############################
% composantes fréquentielles sont intactes. ################################################

%Traitement des bandes de signal individuelles
for j = 1:Nb_bands,
   message = sprintf('%s%d%s%d%s%d%s%d%s','Processing Band #',j,' / ',Nb_bands,'. Freq. Cutoffs = [',round(edges(1,j)),' ',round(edges(2,j)),'] No noise.');
   disp(message);
   pause(1);
   % Filter design
		[Order,Wn,beta,win_type] = kaiserord(cutoffs(j,:),pattern,[Rs Rp Rs],Fs);
	% Elaboration du filtre adapté
		b = fir1(Order,Wn,win_type,kaiser(Order+1,beta),'noscale');
   orisignal_tmp(:,j) = filtfilt(b,a,signal);
   orisignal_out(:,j) = orisignal_tmp(:,j);
end

%for k = 1:Nb_bands,
%   save_to_file = [filename,'_',num2str(Nb_bands),'_',num2str(k)];
%   wavwrite(signal_out(:,k),Fs,save_to_file);
%end

save_to_file_whole = [filename,'_',num2str(Nb_bands),'_original_all'];
orisignal = sum(orisignal_out(:,:),2);
oriout = normalize(orisignal,rms(signal));
oriout = sig2wav(oriout);
wavwrite(oriout,Fs,save_to_file_whole);
