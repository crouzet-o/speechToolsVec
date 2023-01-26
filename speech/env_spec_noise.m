function y = env_spec_noise(signal,snr);

% Computes a speech modulated noise with matched LT-spectrum
%
% Creates envelope-and-spectrum matched noise from a sound matrix.
%
% USAGE : out = env_spec_noise(signal,snr);
%
% EXAMPLE : env_spec_noise(speech1,-5);

% Creates envelope-matched noise
noise_wave = rms_noise(signal,'shap','n',snr,10000);

% Filters it with LTS' characteristics of reference signal
noise_spec = lts_filt(noise_wave,signal,128,4);

%Pour le debuggage de la procédure de contrôle du SNR
%sigwrite(noise_spec,outfile);

sig_and_noise = signal + noise_spec;
%sig_and_noise = noise_spec; % On ne garde que le bruit pour verification

y = nyquist(sig_and_noise);
