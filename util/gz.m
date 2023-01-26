function x=gz(filename,load)

% Compress and uncompress files
% Needs GNU gzip (http://www.gzip.org) on your system
% Lacks load of the uncompressed file
 
if isempty(findstr(filename,'.gz')),
	eval(['!gzip ' filename]);	%compress
else
	eval(['!gzip' '-d' filename]);	%uncompress
%	if exist('load') == 1,
%		file =
%		x = load(filename
%	end
end

x = fclose('all');
