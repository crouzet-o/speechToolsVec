function [signal,Fs] = wav2sig(filename);

% Translates a .WAV (MS Windows) into a .SIG (or .PCM) raw header file.
%
% USAGE: wav2sig('filename');

if nargin<1,
	error('WAV2SIG takes at least one argument. Type help WAV2SIG');
end

if isempty(findstr(filename,'.')),
	filename = [filename,'.wav'];
end

outfile = [filename,'.sig']

[signal,Fs] = wavload(filename);
fid = fopen(outfile,'wb');
fwrite(fid,signal,'short');
