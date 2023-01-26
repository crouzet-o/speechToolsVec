function fid = text_append(filename,matrix,header,footer,format_conversion);

% Append (2D) matrix data to an ascii file, keeping the matrix dimensions
%
% BEWARE: only works with 2D matrices of course. As for now, its behaviour with
% N dimensions matrices is undefined (should add a test).
%
% USAGE: text_append(filename,matrix,header,footer,format_conversion);
%
% EXAMPLE: text_append('data.txt',x,'Correlation data','','%0.5f\t');
%
% format_conversion defaults to '%0.3f\t' (decimal number with 3 digits precision)

fid = fopen(filename,'at');
r_data_sizes = size(matrix);

if exist('format_conversion','var') == 0,
	format_conversion = '%0.3f\t';
end

format_string = [repmat(format_conversion,1,r_data_sizes(2)),'\n'];

%print header
fprintf(fid,'%s\n',header);

for i = 1:r_data_sizes(1),
	fprintf(fid,format_string,matrix(i,:));
end

fprintf(fid,'%s\n\n',footer);
%print footer

fclose(fid);
