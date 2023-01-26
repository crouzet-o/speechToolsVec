function y = splice(infile1,infile2,cuttingpoint1,cuttingpoint2,unit,outfile1,outfile2);

% Cross splices the end and the beginning of two 16 bit PCM raw sound files.
%
% USAGE: 	splice('infile1','infile2',cuttingpoint1,cuttingpoint2,'unit','outfile1','outfile2');
%
% Note that 'cutting points' are either expressed in samples or in milliseconds.
% This is managed by the 'unit' variable (sp or ms).
%
% Infiles and outfiles have '.sig' default extension. You may omit it.
% If you want outfile to be saved in a subdirectory, you may call outfile
% subdir/outfile. However, you must create this subdirectory before running
% SPLICE.
%
% EXAMPLE: 	splice('a1.sig','a2.sig',10344,12024,'ms','splice/essai1.sig','splice/essai2.sig');
%
% The first 4 arguments are necessary. Outfile1 and outfile2 are not ;
% they are the same as infile1 and infile2 but will be given the extension '.spl'.
% Note that 'unit' defaults to 'sp'.

if nargin<4,
	error('Type help splice to get USAGE');
end

if isempty(findstr(infile1,'.')),
	infile1=[infile1,'.sig'];
end

if isempty(findstr(infile2,'.')),
	infile2=[infile2,'.sig'];
end

if isempty(findstr(outfile1,'.')),
	outfile1=[outfile1,'.spl'];
end

if isempty(findstr(outfile2,'.')),
	outfile2=[outfile2,'.spl'];
end


%reads PCM raw sound files.
fid=fopen(infile1,'r');
signal1=fread(fid,'short');
fclose(fid);

fid=fopen(infile2,'r');
signal2=fread(fid,'short');
fclose(fid);

max1=length(signal1);
max2=length(signal2);

tmp1_1=signal1(1:cuttingpoint1);
tmp1_2=signal2(cuttingpoint2:max2);
tmp2_1=signal2(1:cuttingpoint2);
tmp2_2=signal1(cuttingpoint1:max1);

signal3=tmp1_1+tmp1_2;
signal4=tmp2_1+tmp2_2;

%saves files;
fid = fopen(outfile1,'wb');
fwrite(fid,signal3,'short');
fclose(fid);

fid = fopen(outfile2,'wb');
fwrite(fid,signal4,'short');
fclose(fid);
