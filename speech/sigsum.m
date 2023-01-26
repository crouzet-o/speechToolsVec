function y = sigsum(infile1,infile2,outfile);

% Aggregates auditory files into one file.
%
% USAGE : sigsum(infile1,infile2,outfile);
%
% EXAMPLE : sigsum('speech1.sig','speech2.sig','out/speech.sig');

signal1 = loadsig(infile1);
signal2 = loadsig(infile2);

sum_of_signals = signal1 + signal2;

sig_and_noise = nyquist(sum_of_signals);
sigwrite(sum_of_signals,outfile);
