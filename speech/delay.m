function y = delay(x,value,type);

% Introduce a (negative or positive) delay
%
% USAGE: y = delay(x,value,type);
%
% value must be given in # of samples
% If type = 'add', modify the length of the matrix
% if type = 'cut', cut the matrix to the original size

[matrix_size nb_bands] = size(x);
value = round(value);

if type == 'add',
	if value < 0
		y = cat(1,x,zeros(abs(value),1));
	else
		y = cat(1,zeros(value,1),x),
	end
else
	if value < 0
		y = cat(1,x([1+(abs(value)):matrix_size]),zeros(abs(value),1));
	else
		y = cat(1,zeros(value,1),x([1:matrix_size-value]));
	end
end


%for i = 1:nb_bands,
%	if value(i) < 0,
%		onset(i) = [];
%		offset(i) = zeros(abs(value(i)),1);
%		cutoff_onset(i) = abs(value(i));
%		cutoff_offset(i) = [];
%	else
%		onset(i) = zeros(abs(value(i)),1);
%		offset(i) = [];
%		cutoff_onset(i) = [];
%		cutoff_offset(i) = abs(value(i));
%	end
%end

%y = cat(1,onset,x([cutoff_onset:matrix_size]),onset%if type == 'add',

