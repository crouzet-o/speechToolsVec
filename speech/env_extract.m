function env = env_extract(x);

% Extract the envelope of a signal
%
% USAGE: y = env_extract(x);

if nargin<1,
	error('ENV_EXTRACT takes at least one argument. Type help env_extract');
end

%[length_x nb_bands] = size(x);

%for i = 1:nb_bands,
%	h(:,i) = hilbert(x(:,i));												% h = same as y but complex
%	env(:,i) = sqrt(real(h(:,i)).*real(h(:,i))+imag(h(:,i)).*imag(h(:,i)));	% env = same as y
%end

h = hilbert(x);								% h = same as y but complex
env = sqrt(real(h).*real(h)+imag(h).*imag(h));	% env = same as y

											% half-wave rectification
env_tmp = sort(env);							% sorts samples in the envelope matrix
k = find(env_tmp>0);							% finds the non-zero values in the sorted matrix
l = find(env<=0);								% finds zeroes in the original envelope
env(l) = env(k(1),1);							% replaces these samples with the shortest non-zero value

