function y = merge(infile1,infile2,outfile,snr);

% Merges two signals at a specified SNR.
%
% USAGE : merge(infile1,infile2,outfile,snr);


% Loads in-signals
signal1 = loadsig(infile1);
signal2 = loadsig(infile2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Computes signal1's RMS and derives signal2's RMS. 
rms_signal1 = rms(signal1);
rms_signal2 = 10 ^( log10(rms_signal1) - (snr/20) );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
signal2 = (rms_signal2 / rms_signal1) .* signal2;
%rms(signal1),rms(signal2)
% Convolves both signals
signal_out = signal1 + signal2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Normalizes RMS (so that SNR be ok)
%signal_out = (rms_signal2 / rms(signal_out)) .* signal_out;
%signal_out = nyquist(signal_out);

% Cuts high-valued samples ( > clip).
%for i = 1:length(signal_out),
%   if abs(signal_out(i)) > 20000,
%      signal_out(i) = 0;
%   else signal_out(i) = signal_out(i);
%   end
%end

rms_out = rms(signal_out);

% Normalizes RMS (so that SNR be ok)
signal_out = (rms_signal1 / rms_out) .* signal_out;
				%signal_out = (rms_signal2 / rms_signal1) .* signal_out;
signal_out = nyquist(signal_out);
%rms(signal_out)
sigwrite(signal_out,outfile);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%