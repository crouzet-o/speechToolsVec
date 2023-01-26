function [x_mod,x_split,alt_env,alt_sin] = env_sin(x,fs,nb_bands,scheme,freq,max_delay);

% Apply sinewave envelope onto a signal
%
% USAGE: [x_mod,x_split,alt_env] = env_sin(x,fs,nb_bands,scheme,freq,minima);
%
% TODO:
% 'multi'. Apply envelope only when rms > computed threshold


filter_type = 'lp';
minima = .1;
depth = 1-minima;
%max_delay = 200; % in ms
max_delay = round(t2s(max_delay,fs));

[target,recombined,cf,bandwidth,edges] = bank_split(x,fs,nb_bands,'fir');
[sig_mod,ori_mod,ori_env] = env_filter(target,fs,2,filter_type);
matrix_size = length(x);

% compute the modifying sinewave(s)
switch lower(scheme),
	case {'mono'}
		sinewave = make_sin(freq,fs,depth,minima,matrix_size);
		alt_env = repmat(sinewave,1,nb_bands);
	case {'multi'}
		phase = linspace(-max_delay,max_delay,nb_bands);
		seed_time = clock;
		rand('state',sum(100*seed_time));
		order = randperm(length(phase));
		for i = 1:nb_bands,
%			phase_rand(i) = phase(order(i))
%		end;
%		for i = 1:nb_bands,
			alt_env(:,i) = make_sin(freq,fs,depth,minima,matrix_size);
			alt_env(:,i) = delay(alt_env(:,i),phase(order(i)),'cut');
		end
	otherwise
		error('type: help env_alt');
end


alt_env = zeroends(alt_env,fs); % or later


%l = (ori_env>(threshold*mean(mean(ori_env)))); %provides a thresholded matrix from the original envelope
%alt_env = alt_env.*l;

alt_sin = alt_env;
alt_env = alt_env.*ori_mod;					% weigh the sinewave by the 0-4Hz original envelope

x_split = target.*alt_env./ori_env; 		% full envelope for computation
x_mod = sum(x_split,2);

%x_split = target.*alt_mod./ori_env;		% mod. for alt and full for target
%x_split = target.*alt_env./ori_mod;		% modified envelope for computation

x_mod = normalize(x_mod,.4,'max');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y = make_sin(freq,fs,depth,minima,nb_samples);

t = (0:1/fs:(nb_samples-1)/fs)'; % # of samples
y = (depth/2)*sin(2*pi*freq*t);
if exist('minima') ~= 0,
	y = y+(minima-min(y));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
