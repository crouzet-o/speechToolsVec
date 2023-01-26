function y = depth(x);

% How to estimate the modulation depth of a signal?
h = hilbert(x);									% h = same dimensions as y but complex
env = sqrt(real(h).*real(h)+imag(h).*imag(h));	% env = same dimensions as y


coeffs = fir1(100, 4./(fse/2));				% bandpass
env_extract = filtfilt(coeffs,1,env);		%filtering
													%half-wave rectification
env_tmp = sort(env_extract);				% sorts samples in the envelope matrix
k = find(env_tmp>0);									% finds the non-zero values in the sorted matrix
l = find(env_extract<=0);							% finds zeroes in the original envelope
env_extract(l) = env_tmp(1,k(1));				%replaces these samples with the shortest non-zero value


								% half-wave rectification
tmp = sort(env);		% sorts samples in the envelope matrix
k = find(env_tmp>0);			% finds the non-zero values in the sorted matrix
l = find(env<=0);				% finds zeroes in the original envelope
env(l) = env(1,k(1));			% replaces these samples with the shortest non-zero value
