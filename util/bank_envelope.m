function final = bank_envelope(x,fs,Nb_bands);

% OBSOLETE. Low-pass filtering of a signal's envelope inside narrow frequency bands
%
% Requirements :
%		Auditory toolbox (Malcolm Slaney, http://www.slaney.org) for filterbank analysis
%		Signal Processing Toolbox (Mathworks) for hilbert.m
%		wav_norm.m (Olivier Crouzet)

% Introduce a highpass filtering of the envelope?

fse = fs/64;
for n = 1:length(Nb_bands),
	[y,recombined,cf,bandwidth,edges]  = bank_split(x,fs,Nb_bands(n),100); % y = length(y)* Nb_bands (Nb_bands columns)
	h = hilbert(y); % h = same as y but complex
	env_tmp = sqrt(real(h).*real(h)+imag(h).*imag(h)); % env = same as y

	%replaces negative values with zeroes
	env = env_tmp;
	l = find(env_tmp<0); % finds negative values in the original envelope
	env(l) = 0; %replaces these samples with the shortest non-zero value
	env = normalize(env,env_tmp);
	maximum = max(env,[],1);

	for j = 1:Nb_bands(n),
		ls_env(:,j) = resample(env(:,j),1,64); % downsampling the envelope (faster computation)
	end
	
	split_signal = y;
	ls_split_env = ls_env;

end %1:length(Nb_bands)

clear all;
fclose('all');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
