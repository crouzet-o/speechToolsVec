function [y,y_split,phase] = desync(x,fs,nb_bands,max_delay);

% Insert artificial phase reverberation (a la Greenberg)
%
% USAGE : desync(signal,Fs,Nb_bands,deviation,filename);
%
% Need constraints adjacent deviation must be at least 
% 1/4 of the maximum deviation

%max_delay = 200; % in ms
max_delay = round(t2s(max_delay,fs));

[target,recombined,cf,bandwidth,edges] = bank_split(x,fs,nb_bands,'fir');
matrix_size = length(x);

%%%%%%%%%%%%%%% TEST CONSTRAINTS
%phase = linspace(-max_delay,max_delay,nb_bands);
%seed_time = clock;
%rand('state',sum(100*seed_time));
%order = randperm(length(phase));


%%%%%%%%%%%%%%% TEST CONSTRAINTS
i = ones(1,nb_bands);
i(1) = 0;
while sum(i(:)) > 0,
phase = linspace(0,max_delay,4);
%phase = linspace(0,max_delay,nb_bands/8);
phase = repmat(phase,1,nb_bands/4);
seed_time_phase = clock;
rand('state',sum(100*seed_time_phase));
phase_order = randperm(length(phase));
%in = mod(phase_order,2);
%phase(find(in)) = -phase(find(in));
	for n = 2:length(phase),
		if phase(phase_order(n)) == phase(phase_order(n-1)),
			i(n) = 1;
		else,
			i(n) = 0;
		end
	end
end

phase = round(phase-max_delay/2);

for i = 1:nb_bands,
	y_split(:,i) = delay(target(:,i),phase(i),'cut');
end

y = sum(y_split,2);

%x_split = target.*alt_mod./ori_env;		% mod. for alt and full for target
%x_split = target.*alt_env./ori_mod;		% modified envelope for computation

y = normalize(y,.4,'max');

