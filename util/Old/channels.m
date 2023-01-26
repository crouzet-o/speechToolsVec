function out = channels(signal,Fs,Nb_bands,Passband_ripple,Stopband_attenuation);

% Script de transformation d'un signal acoustique naturel en signal simulant
% le type d'information transmise par un implant cochléaire (N bandes spectrales).
% A faire: boucle pour utiliser le même script quel que soit le nombre de bandes
%
% USAGE : out = channels(signal,Fs,Nb_bands,Rp,Rs);

%clear all;

if nargin < 3,
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
Rp = (10^(-Passband_ripple/20))/(10^(Passband_ripple/20)+1)%;
Rs = 10^(-Stopband_attenuation/20)%;
%transition = 10; % transition size in Hz

% Loads and defines the frequency bands
load filterbank; % loads the filterbank into workspace
filters = zeros(2,Nb_bands); % Initializes the filter bank matrix
cutoffs = zeros(Nb_bands,4); % Initializes cutoffs matrix
transitions = zeros(Nb_bands,4); % Initializes cutoffs matrix
signal_out = zeros(length(signal),Nb_bands);
%files_out = zeros();

%Tests whether the frequency centers and bandwidths have been defined in 
% filterbank.mat
if sum(Bands(Nb_bands,:)) == 0,
   error_msg = ['Center Frequencies and Bandwidths have not been defined for ',...
         num2str(Nb_bands),' bands.'...
         'Please choose another number of bands or define them in filterbank.mat'];
   error(error_msg);
end

lower_bound = Freqs(Nb_bands,1:Nb_bands) - Bands(Nb_bands,1:Nb_bands)./2;
upper_bound = Freqs(Nb_bands,1:Nb_bands) + Bands(Nb_bands,1:Nb_bands)./2;
edges = [lower_bound ; upper_bound];

for i = 1:Nb_bands,
 	edges_band(Nb_bands,1:2,i) = [edges(1,i) edges(2,i)];
end

for i = 1:Nb_bands,
 	transitions(Nb_bands,i) = Freqs(Nb_bands,i)./400;
end

%Traitement des bandes de signal individuelles
for j = 1:Nb_bands,
   cutoffs(j,:) = [edges_band(Nb_bands,1,j)...
         edges_band(Nb_bands,1,j)+transitions(Nb_bands,j)...
         edges_band(Nb_bands,2,j)-transitions(Nb_bands,j)...
         edges_band(Nb_bands,2,j)]%; %(F) cutoff frequencies (length(F) = (2*length(M))-2)
	pattern(j,:) = [0 1 0]; %(M) desired amplitudes
	% Filter design
	[Order,Wn,beta,win_type] = kaiserord(cutoffs(j,:),pattern(j,:),[Rs Rp Rs],Fs);
	% Elaboration du filtre adapté
	b = fir1(Order,Wn,win_type,kaiser(Order+1,beta),'noscale');
   signal_out(:,j) = filter(b,1,signal);
end

%for k = 1:Nb_bands,
%   wavwrite(



%   cutoffs(j,:) = [edges_band(Nb_bands,1,j)-transitions(Nb_bands,j)...
%         edges_band(Nb_bands,1,j)+transitions(Nb_bands,j)...
%         edges_band(Nb_bands,2,j)-transitions(Nb_bands,j)...
%         edges_band(Nb_bands,2,j)+transitions(Nb_bands,j)]; %(F) cutoff frequencies (length(F) = (2*length(M))-2)
   
   