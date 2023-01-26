function sig_out = rms_noise(signal,shaping,snorn,snr,clip);

% Generate constant or envelope shaped white noise at SNR
%
% USAGE: rms_noise(signal,'shaping','snorn',snr,clip);
%
% SNR is expressed in dB.
% To avoid possible clipping effects, CLIP allows to replace 
% noise generated samples which absolute value exceeds CLIP
% with 0 (default clip value: 20000, Note that sample values
% belong to the interval +/- 32000 (in their vicinity)).
%
% EXAMPLE: noisy3 = rms_noise(signal,'shap','sn',3,20000);
% 
% OPTIONS:	
%	'shaping': 	'cont'(mean amplitude matching noise)
%		     	'shap' (envelope shaped noise).
%	'snorn': 	'sn' (signal+noise)
%		   		'n' (noise alone).
%
% The first 3 arguments are compulsory. The others default to:
% 
%		snr:		0 dB
%		clip:		65536

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 3,
	error('Type help addnoise to get USAGE');
end

if exist('snr') == 0
	snr = 0;
end

if exist('clip') == 0
	clip = 65536;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Evaluates the interval in which to insert noise.
noise_duration = length(signal);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Computes the signal's and noise's RMS. 
rms_s = rms(signal);
rms_n = 10 ^( log10(rms_s) - (snr/20) );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Generates the noisy matrix at rms_noise.
rand('state',sum(clock));
noise = (rms_n*(2*rand(1,noise_duration)-1))';

%for i = 1:length(signal),
%   if abs(noise(i)) > clip,
%      noise(i) = 0;
%   else noise(i) = noise(i);
%   end
%end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Creates the output signal with noise inside.
if shaping == 'cont',			% Continuous Noise
	if snorn == 'sn',				% Signal + Noise
		signal(1:length(signal)) = signal(1:length(signal))+noise;
	elseif snorn == 'n', 				% Noise alone
			signal(1:length(signal)) = noise;
	else ERROR('sn, ... n, and what else?');
	end
elseif shaping == 'shap',				% Envelope Shaped Noise
		if snorn == 'sn',					% Signal + Noise
		for i = 1:length(signal),
			if noise(i) < 0,
				signal(i) = 0;
			elseif noise(i) >= 0,
				signal(i) = (rms_n / rms_s) * 2 * signal(i);
			end 
		end
		elseif snorn == 'n', % Noise alone
		for i = 1:length(signal),
			if noise(i) < 0,
				signal(i) = (rms_n / rms_s) * (-signal(i));
			elseif noise(i) >= 0,
				signal(i) = (rms_n / rms_s) * (signal(i));
			end
		end
		end
else,
      error('Type help addnoise to get USAGE');
end

% Cuts high-valued samples ( > clip).
%for i = 1:length(signal),
%   if abs(signal(i)) > clip,
%      signal(i) = 0;
%   else signal(i) = signal(i);
%   end
%end

% Normalizes RMS (so that SNR be ok)
%final_rms = rms_signal;
signal = (rms_n / rms_s) .* signal;
%last_rms = rms(signal);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sig_out = signal;
