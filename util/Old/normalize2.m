function signal_out = normalize(infile,outfile,value);

% Normalizes RMS so that it would be equal to a constant value. 
% Takes a PCM Raw sound file as its input.
%
% USAGE : out = normalize(infile,outfile,value);

signal = loadsig(infile);
signal_out = (value / rms(signal)) .* signal;
sigwrite(signal_out,outfile);

%first_rms = rms(signal)
%last_rms = rms(signal_out)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
