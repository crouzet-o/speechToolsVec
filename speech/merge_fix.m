function y = merge_fix(signal1,signal2);

% Merges two signals and normalizes RMS so that the 
% sum-of-signals' RMS be equal to signal1's RMS.

signal_out = signal1 + signal2;

signal_out = (rms(signal1) / rms(signal2)) .* signal_out;
%last_rms = rms(signal);
