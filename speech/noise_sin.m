function [x_mod,x_split,alt_env,sin_phase] = noise_sin(x,fs,nb_bands,freq,max_delay,sin_phase);

% Create sinewave modulated white noise
%
% USAGE: [x_mod,x_split,alt_env] = env_sin(x,fs,nb_bands,sin_freq,max_delay);
%

% TODO:
% 'multi'. Apply envelope only when rms > computed threshold

% ramdom sinewave phase
if exist('sin_phase') == 0,
	sin_phase = linspace((1/freq)/8,(1/freq)/2,5);
	seed_phase = clock;
	rand('state',sum(100*seed_phase));
	order_phase = randperm(length(sin_phase));
	sin_phase = sin_phase(order_phase(1));
end

%phase = t2s((1/freq*1000)/2,fs); % phase opponency for the noise stimuli
%sin_phase = (1/freq)/2; % phase opponency for the noise stimuli

minima = 0;
depth = 1-minima;
max_delay = round(t2s(max_delay,fs));

if length(x)>1,
	duration = length(x);
else
	duration = t2s(x,fs);
end

x_noise = mknoise(duration,fs);
matrix_size = length(x_noise);

%[target,recombined,cf,bandwidth,edges] = bank_split(x,fs,nb_bands,'fir');
target_noise = bank_split(x_noise,fs,nb_bands,'fir');


% compute the modifying sinewave(s)
%switch lower(scheme),
if max_delay==0,
%	case {'mono'}
		sinewave = make_sin(freq,fs,depth,minima,matrix_size,sin_phase);
		alt_env = repmat(sinewave,1,nb_bands);
elseif max_delay>0,
%	case {'multi'}
		phase = linspace(-max_delay,max_delay,nb_bands);
		seed_time = clock;
		rand('state',sum(100*seed_time));
		order = randperm(length(phase));
		for i = 1:nb_bands,
%			phase_rand(i) = phase(order(i))
%		end;
%		for i = 1:nb_bands,
			alt_env(:,i) = make_sin(freq,fs,depth,minima,matrix_size,sin_phase);
			alt_env(:,i) = delay(alt_env(:,i),phase(order(i)),'cut');
		end
else
%	otherwise
		error('type: help env_alt');
end


alt_env = zeroends(alt_env,fs); % or later

%alt_sin = alt_env;
%alt_env = alt_env.*ori_mod;					% weigh the sinewave by the 0-4Hz original envelope


x_split = target_noise.*alt_env; %./ori_env; 		% full envelope for computation
x_mod = sum(x_split,2);

x_mod = normalize(x_mod,.4,'max');

%x_split = target.*alt_mod./ori_env;		% mod. for alt and full for target
%x_split = target.*alt_env./ori_mod;		% modified envelope for computation


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y = make_sin(freq,fs,depth,minima,nb_samples,phase);

if exist('phase')==0,
	phase=0;
end

t = (0:1/fs:(nb_samples-1)/fs)'; % # of samples
y = (depth/2)*(sin(2*pi*freq*(t+phase)));
if exist('minima') ~= 0,
	y = y+(minima-min(y));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
