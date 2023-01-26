function y = addnoise(infile,outfile,snr);

% Adds envelope-and-spectrum matched noise to a signal.
%
% USAGE : addnoise(infile,outfile,snr);

signal = loadsig(infile);
noise_wave = rms_noise(signal,'shap','n',snr,20000);
noise_spec = lts_filt(noise_wave,signal,128,10);

%Pour le debuggage de la procédure de contrôle du SNR
sigwrite(noise_spec,outfile);

%sig_and_noise = signal + noise_spec;
%result = nyquist(sig_and_noise);
%sigwrite(sig_and_noise,outfile);
