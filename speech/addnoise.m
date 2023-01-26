function y = addnoise(infile,outfile,shaping,snorn,snr,onset,offset,Fs);

% Add (or replace signal with) noise to a sound signal
% Add noise (or replace signal with it) from sample 'onset' (default 1) 
% to sample 'offset' (default end of file) into a PCM Raw Sound File of 
% Sampling Frequency Fs (default 16000).
%
% USAGE: addnoise('infile','outfile','shaping','snorn',snr,onset,offset,Fs);
%
% Onset & offset are expressed in # of sample. SNR is expressed in dB.
%
% Infile and outfile have '.sig' default extension. You may omit it.
% If you want outfile to be saved in a subdirectory, you may call outfile
% subdir/outfile. However, you must create this subdirectory before running
% ADDNOISE.
%
% EXAMPLE: addnoise('a1.sig','temp/a1sn.sig','cont','sn',3,1000,2000,44100);
% 
% OPTIONS:	
%	'shaping': 	'cont'(mean amplitude matching noise)
%					'shap' (envelope shaped noise).
%					'cut' (turns samples to 0 = silence)
%
%	'snorn': 'sn' (signal+noise)
%		   'n' (noise alone).
%
% The first 4 arguments are compulsory. The others default to:
% 
%		snr:		0 dB
% 		onset: 		0 (file onset)
% 		offset: 	maxlength (end of file)
% 		Fs: 		16000 Hz
%


if nargin < 4,
	error('Type help addnoise to get USAGE');
end

if isempty(findstr(infile,'.')),
	infile = [infile,'.sig'];
end

%if isempty(findstr(outfile,'.')),
%	outfile = [outfile,'.wav'];
%end

if exist('snr') == 0
	snr = 0;
end

%if isempty(shaping),
%	shaping = 'shap';
%end

%if isempty(snorn),
%	snorn = 'sn';
%end

if exist('Fs') == 0
	Fs = 44100;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Reads PCM raw sound file.
fid = fopen(infile,'r');
signal = fread(fid,'short');
original = sig2wav(signal);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Evaluates the interval in which to insert noise.
max = length(signal);

if exist('onset') == 0 & exist('offset') == 0,
	onset = 1;
	offset = max;
end

%t = 1:max;
noise_duration = offset-onset;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Computes the signal's and noise's RMS. 
rms_signal = sqrt ( mean ( signal(onset:offset) .^2 ) );
rms_noise = 10 ^( log10(rms_signal) - (snr/20) );

%temp = rms_signal / rms_noise
%temp2 = 1/(rms_signal/rms_noise)
%temp3 = rms_noise/rms_signal
%amplitude_signal = sqrt(3)*rms_signal;
%amplitude_noise = sqrt(3)*rms_noise;
%dB=10*log10(rms_signal)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Generates the noisy matrix at rms_noise.
rand('seed',sum(clock));
%noise = (amplitude*(2*rand(1,noise_duration)-1))';
noise = (rms_noise*(2*rand(1,noise_duration)-1))';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Creates the output signal with noise inside.
if shaping == 'cont',	% Continuous Noise
	if snorn == 'sn',	% Signal + Noise
		signal(onset:offset-1) = signal(onset:offset-1)+noise;
	elseif snorn == 'n', 	% Noise alone
			signal(onset:offset-1) = noise;
      else ERROR('sn, ... n, and what else?');
	end
elseif shaping == 'shap',	% Envelope Shaped Noise
		if snorn == 'sn',	% Signal + Noise
		for i = onset:noise_duration,
			if noise(i) < 0,
				signal(onset-1+i) = 0;
			elseif noise(i) >= 0,
				signal(onset-1+i) = (rms_noise / rms_signal) * 2 * signal(onset-1+i);
%				signal(onset-1+i) = (rms_noise / rms_signal) * 2 * signal(onset-1+i);
			end 
		end
		elseif snorn == 'n', % Noise alone
		for i = onset:noise_duration,
			if noise(i) < 0,
				signal(onset-1+i) = (rms_noise / rms_signal) * (-signal(onset-1+i));
			elseif noise(i) >= 0,
				signal(onset-1+i) = (rms_noise / rms_signal) * (signal(onset-1+i));
			end
		end
      end
   else,
      error('Type help addnoise to get USAGE');
end

   final_rms = sqrt ( mean ( signal(onset:offset) .^2 ) );
	for i = onset:noise_duration,
		signal(onset-1+i) = (rms_signal / final_rms) * signal(onset-1+i);
		signal(onset-1+i) = (rms_noise / rms_signal) * 2 * signal(onset-1+i);
	end
	last_rms = sqrt ( mean ( signal(onset:offset) .^2 ));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Filters the signal (at Nyquist's Frequency (=1))
%[n,Wn] = buttord(Wp, Ws, Rp, Rs);
[b,a] = butter(1,1);
final_signal = filtfilt(b,a,signal);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Saves the output into a SIG file.
%fid = fopen(outfile,'wb');
%fwrite(fid,final_signal,'short');


% Saves the output into a WAV file.
%fid = fopen(outfile,'wb');


%Noisy
final_signal = sig2wav(final_signal);
%wavplay(final_signal,Fs);
save_to_file_noise = [outfile,'_noise.wav'];
%save_to_file_noise_extract = [outfile,'_noise_extract.wav'];
wavwrite(final_signal,Fs,save_to_file_noise);
%wavwrite(final_signal(onset-200:offset+200),Fs,save_to_file_noise_extract);





%WithSilence
%silence = [final_signal(onset-200:onset-1) ; zeros(size(final_signal(onset:offset))) ; final_signal(offset+1:offset+200)];
%cut = [final_signal(1:onset-1) ; silence ; final_signal(offset+1:max)];
%save_to_file_silence = [outfile,'_silence.wav'];
%save_to_file_silence_extract = [outfile,'_silence_extract.wav'];
%wavwrite(cut,Fs,save_to_file_silence);
%wavwrite(cut(onset-200:offset+200),Fs,save_to_file_silence_extract);
%Original
%save_to_file_original = [outfile,'_original.wav'];
%save_to_file_original_extract = [outfile,'_original_extract.wav'];
%original = sig2wav(original);
%wavwrite(original,Fs,save_to_file_original);
%wavwrite(original(onset-200:offset+200),Fs,save_to_file_original_extract);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
