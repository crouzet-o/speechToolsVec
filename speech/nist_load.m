function x = nist_load(filename,fs);

%                    Copyleft Olivier Crouzet, 2000.
%                       o.crouzet@cns.keele.ac.uk
%            Communication and Neuroscience, Keele University.
%
% Loads a NIST wave file.

if nargin<1,
	error('nist_load takes at least one argument. Type help nist_load');
end

if isempty(findstr(filename,'.')),
	filename=[filename,'.wav'];
end

fid = fopen(filename,'r');
x = fread(fid,'int16');
%x = fread(fid,'short'); short is platform dependent. int16 is not (but they refer to the same kind of data (signed integer 16 bits)

%x = x(round(126*1000/fs):length(x));
x = x(626:length(x));
%x = normalize(x,'max',.5);
fclose(fid);

%wavplay(x,20000);
%sound(x,20000,16) % plays the sound part of the file
