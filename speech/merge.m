function signal_out = merge(signal1, signal2, snr);

% Merges two signals at a specified SNR.
%
% USAGE : out = merge(sig1,sig2,snr[sig2|sig1]);


% Computes signal1's RMS and derives signal2's RMS. 
rms_signal1 = rms(signal1);
rms_signal2 = rms(signal2);
rms_signal2_target = 10 ^( log10(rms_signal1) - (snr/20) );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

signal2 = (rms_signal2_target / rms_signal2) .* signal2;

taille1 = size(signal1,1);
taille2 = size(signal2,1);
taille = max(size(signal1,1),size(signal2,1));

% Convolves both signals
if (taille1 < taille2),
   signal1 = [signal1 ; zeros(taille2-taille1,1)];
else signal2 = [signal2 ; zeros(taille1-taille2,1)];
end

signal_out = signal1 + signal2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rms_out = rms(signal_out);

% Normalizes RMS (so that SNR be ok)
signal_out = (rms_signal1 / rms_out) .* signal_out;
            
signal_out = nyquist(signal_out);
