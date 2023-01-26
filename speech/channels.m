function out = channels(signal,Fs,Nb_bands,filename,Passband_ripple,Stopband_attenuation);

% Speech-modulated noise in N bands (a la Shannon)
% Script de transformation d'un signal acoustique naturel en signal simulant
% le type d'information transmise par un implant cochléaire (N bandes spectrales).
%
% USAGE : channels(signal,Fs,Nb_bands,filename,Rp,Rs);
%
% Banques de filtres implémentées dans filterbank.mat. Taper help filterbank
% Nombre de bandes : 2,3,4,5,6,8,10,12,16
%
% filename'_original_all.wav' = signal original ayant subi les mêmes manipulations
% sans dégradation spectrale (uniquement filtrage de largeurs de bandes équivalentes).

if nargin < 4,
	error('Type help channels to get USAGE');
end

% Définition des constantes
if exist('Passband_ripple') == 0, % passband ripple (dB)
   Passband_ripple = 1;
end
if exist('Stopband_attenuation') == 0,
   Stopband_attenuation = 40;         % stopband attenuation (dB)
end

% computes deviations (Rp Rs)
Rp = (10^(-Passband_ripple/20))/(10^(Passband_ripple/20)+1);
Rs = 10^(-Stopband_attenuation/20);
transition = 50; % transition size in Hz
a = 1; % 2nd argument of filtfilt.m

% Loads and defines the frequency bands
load filterbank; % loads the filterbank into workspace

%Matrices initialization
edges = zeros(2,Nb_bands); % passband edges for each filter band
		%transitions = zeros(1,4); % passband transitions for each filter band
cutoffs = zeros(Nb_bands,4); % passband cutoffs for each filter band
		%edges_band = zeros(Nb_bands,2);
signal_out = zeros(length(signal),Nb_bands); % Nb_bands matrix for signal
signal_tmp = zeros(length(signal),Nb_bands);
noisy = zeros(length(signal),Nb_bands); % Nb_bands matrix for enveloppe modulated noise
		%pattern = zeros(Nb_bands,3);

%Tests whether the frequency centers and bandwidths have been defined in filterbank.mat
if sum(Bandwidths(Nb_bands,:)) == 0,
   error_msg = sprintf('%s%d%s%s','Center Frequencies and Bandwidths have not been defined for ',...
         Nb_bands,' band(s).','\rPlease choose another number of bands or define them in filterbank.mat');
   error(error_msg);
end

lower_bound = Center_Freqs(Nb_bands,1:Nb_bands) - Bandwidths(Nb_bands,1:Nb_bands)./2;
upper_bound = Center_Freqs(Nb_bands,1:Nb_bands) + Bandwidths(Nb_bands,1:Nb_bands)./2;
edges = [lower_bound ; upper_bound];

%transitions = round(Center_Freqs(Nb_bands,1:Nb_bands)./400)';
%cutoffs = [edges(1,:);...
%	edges(1,:)+transitions;...
%	edges(2,:)-transitions;...
%	edges(2,:)]'%; %(F) cutoff frequencies (length(F) = (2*length(M))-2)

cutoffs = [edges(1,1:Nb_bands);...
   edges(1,1:Nb_bands)+transition;...
   edges(2,1:Nb_bands)-transition;...
   edges(2,1:Nb_bands)]'; %(F) cutoff frequencies (length(F) = (2*length(M))-2)

pattern = [0 1 0]; %(M) desired amplitudes

%Traitement des bandes de signal individuelles
for j = 1:Nb_bands,
   message = sprintf('%s%d%s%d%s%d%s%d%s','Processing Band #',j,' / ',Nb_bands,'. Freq. Cutoffs = [',round(edges(1,j)),' ',round(edges(2,j)),'].');
   disp(message);
   pause(1);
   % Filter design
	[Order,Wn,beta,win_type] = kaiserord(cutoffs(j,:),pattern,[Rs Rp Rs],Fs);
	% Elaboration du filtre adapté
	b = fir1(Order,Wn,win_type,kaiser(Order+1,beta),'noscale');
   signal_tmp(:,j) = filtfilt(b,a,signal);
   %Insertion du bruit, refiltrage et normalization
   noisy(:,j) = rms_noise(signal_tmp(:,j),'shap','n');
   noisy(:,j) = filtfilt(b,a,noisy(:,j));
   signal_out(:,j) = normalize(noisy(:,j),rms(signal_tmp(:,j)));
%end

%for k = 1:Nb_bands,
   save_to_file = [filename,'_',num2str(Nb_bands),'_',num2str(j)];
	%signal_out = sig2wav(signal_out);
   wavwrite(signal_out(:,j),Fs,save_to_file);
end

save_to_file_whole = [filename,'_',num2str(Nb_bands),'_all'];
out = sum(signal_out(:,:),2);
out = normalize(out,rms(signal));
out = wav_norm(out);
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
   %Insertion du bruit, refiltrage et normalization
   %noisy(:,j) = rms_noise(signal_tmp(:,j),'shap','n');
   %noisy(:,j) = filtfilt(b,1,noisy(:,j));
   %signal_out(:,j) = normalize(noisy(:,j),rms(signal_tmp(:,j)));
   orisignal_out(:,j) = orisignal_tmp(:,j);
end

for k = 1:Nb_bands,
   save_to_file = [filename,'_',num2str(Nb_bands),'_',num2str(k)];
   %wavwrite(signal_out(:,k),Fs,save_to_file);
end

save_to_file_whole = [filename,'_',num2str(Nb_bands),'_original_all'];
orisignal = sum(orisignal_out(:,:),2);
oriout = normalize(orisignal,rms(signal));
oriout = wav_norm(oriout);
wavwrite(oriout,Fs,save_to_file_whole);
