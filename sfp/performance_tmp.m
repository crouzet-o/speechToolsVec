function [x,y] = performance(a,b,type);

% Compute the matching rate between two strings
%
% USAGE: [best,matrix] = performance(a,b);
% EXAMP: perf = performance('210','2010');
%
% Algorigthm: If the data is '210' and the comparison string is '2010',
%			the program maximizes the fit between the data and the string.
%			Here, the performance would be .75 ('2', '1' and '0' are OK).


%a = str2num(a(:))';
%b = str2num(b(:));

padded = a;
begin_string = '';
size_diff = length(b)-length(a);
if ((length(a) < length(b)) & (length(a)>0)),
% insert beginning string of blanks
	for m = 1:1+size_diff,
		% insert middle string of blanks
		for n = 1:1+size_diff,
			c = strvcat(padded,b);
			d = ['#';'#'];
			e = [d,c,d]
			instant_perf = 0;
			% compute	 the matching rate
			for k = 1:2:2*length(c),
				instant_perf = instant_perf + strcmp(c(k),c(k+1));
			end
			middle_string=repmat(' ',1,size_diff-length(begin_string)-n);
			padded = [begin_string,padded(1:n),middle_string,padded(n+1:end)];
			y(n*m) = instant_perf/length(b);
		end
		begin_string=repmat(' ',1,m);%length(b)-length(a));
		padded=[begin_string,a];
	end
elseif length(a)>0,
	c = strvcat(padded,b);
	instant_perf = 0;
	for k = 1:2:2*length(c),
		instant_perf = instant_perf + strcmp(c(k),c(k+1));
	end
	y = instant_perf/length(b);
else
y = 0;
end
x = max(y);
