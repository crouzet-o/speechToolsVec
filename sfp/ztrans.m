function [z,ref_mean,ref_std] = ztrans(x,ref);

% z-transform 1D array or scalar

if exist('ref') == 0,
	ref = x;
end

if length(ref)>2,
	ref_mean = mean(ref);
	ref_std = std(ref);
else
	ref_mean = ref(1);
	ref_std = ref(2);
end

z = (x-ref_mean)./ref_std;
