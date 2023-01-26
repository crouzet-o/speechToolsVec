function sig_out = rms_noise(filename,shaping,snorn,snr,onset,offset,clip);

% TO BE COMPLETED. NOT FUNCTIONNAL !!!
%
%                           Olivier Crouzet
%                      o.crouzet@cns.keele.ac.uk
%
% Generates constant or envelope shaped white noise at SNR for a specified temporal
% duration in a sound file.
%
% USAGE: rms_noise('filename','shaping','snorn',snr,onset,offset,clip);
%
% SNR is expressed in dB.
% To avoid possible clipping effects, CLIP allows to replace 
% noise generated samples which absolute value exceeds CLIP
% with 0 (default clip value: 20000, Note that sample values
% belong to the interval +/- 32000 (in their vicinity)).
%
% EXAMPLE: noisy3 = rms_noise(signal,'shap','sn',3,4000,6000,20000);
% 
% OPTIONS:	
%	'shaping': 	'cont'(mean amplitude matching noise)
%		     	'shap' (envelope shaped noise).
%	'snorn': 	'sn' (signal+noise)
%		   		'n' (noise alone).
%  onset & offset : onset & offset of noise segment (# of sample)
%
% The first 3 arguments are compulsory. The others default to:
% 
%		snr:		0 dB
%		onset:	first sample
%		offset:	last sample
%		clip:		20000

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 3,
	error('Type help addnoise to get USAGE');
end

if exist('snr') == 0
	snr = 0;
end

if exist('onset') == 0
	onset = 1;
end

if exist('offset') == 0
	offset = length(signal);
end

if exist('clip') == 0
	clip = 20000;
end

if isempty(findstr(filename,'.')),
	infile = [filename,'.sig'];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[signal,Fs] = loadsig(infile,16000);
noise = zeros(size(signal));
% Evaluates the interval in which to insert noise.
noise_duration = offset-onset
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Computes the signal's and noise's RMS. 
rms_signal = rms(signal(onset:offset));
rms_noise = 10 ^( log10(rms_signal) - (snr/20) );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Generates the noisy matrix at rms_noise.
rand('state',sum(clock));
noise = (rms_noise*(2*rand(1,length(signal))-1))';

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
		signal(onset:offset) = signal(onset:offset)+noise;
	elseif snorn == 'n', 				% Noise alone
			signal(onset:offset) = noise;
	else ERROR('sn, ... n, and what else?');
	end
elseif shaping == 'shap',				% Envelope Shaped Noise
		if snorn == 'sn',					% Signal + Noise
		for i = onset:offset,
			if noise(i) < 0,
				signal(i) = 0;
			elseif noise(i) >= 0,
				signal(i) = (rms_noise / rms_signal) * 2 * signal(i);
			end 
		end
		elseif snorn == 'n', % Noise alone
		for i = onset:offset,
			if noise(i) < 0,
				signal(i) = (rms_noise / rms_signal) * (-signal(i));
			elseif noise(i) >= 0,
				signal(i) = (rms_noise / rms_signal) * (signal(i));
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
signal = (rms_noise / rms_signal) .* signal;
%last_rms = rms(signal);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sig_out = signal;
filename_out = ['temp/',filename,'.sig']
sigwrite(sig_out,filename_out);