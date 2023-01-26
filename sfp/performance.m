function [x,y] = performance(a,b,type);

y = zeros(1,1+(length(b)-length(a)));
padded = a;
for m = 1:1+(length(b)-length(a)),
	instant_perf = 0;
	perf = 0;
	c = strvcat(padded,b);
	for n = 1:2:2*length(c),
		instant_perf = instant_perf + strcmp(c(n),c(n+1));
	end
	y(m) = instant_perf*100/length(b);
	padded = repmat(' ',1,m);
	padded = [padded,a];
end
%for j = 1:length(DATA_VALUE_STORED),
%	for k = 1:length(answer),
%		instant_perf = instant_perf + strcmp(DATA_VALUE_STORED(j),answer(k));
%	end
%end
%perf = (perf+(instant_perf*100/length(answer)))/2;
y = y./100;
x = max(y);
