function y = extract(infile,outfile,onset,offset);

% Extracts the portion of a 16 bit PCM raw sound file.
%
% USAGE: 	extract('infile','outfile',onset,offset,'unit');
%
% Note that 'onset' and 'offset' are either expressed in samples or in milliseconds.
% This is managed by the 'unit' variable (sp or ms).
%
% Infile and outfile have '.sig' default extension. You may omit it.
% If you want outfile to be saved in a subdirectory, you may call outfile
% subdir/outfile. However, you must create this subdirectory before running
% EXTRACT.
%
% EXAMPLE: 	extract('a1.sig','extract/a1.sig',300,12024,'sp');
%
% The first argument is necessary.
% Outfile defaults to infile'.ext', onset to '0', offset to 'end' and
% unit to 'sp'.
% If you want to omit a variable, insert a '[]'.

if nargin<1,
	error('Type HELP EXTRACT to get usage');
end

if isempty(findstr(infile,'.')),
	infile=[infile,'.sig'];
end

if isempty(findstr(outfile,'.')),
	outfile=[outfile,'.ext'];
end


%reads PCM raw sound file
fid=fopen(infile,'r');
signal1=fread(fid,'short');


if exist('onset')==0,
	onset=1;
end

if exist('offset')==0,
	offset=length(signal1);
end

%if exist('unit')==0
%	unit='sp';
%end

signal2=signal1(onset:offset);

%saves file;
fid = fopen(outfile,'w+');
fwrite(fid,signal2,'short');
