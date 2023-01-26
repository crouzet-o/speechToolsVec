function [x_mod,x_split] = env_alt(x,fs,nb_bands,alt_struct,scheme,lfe_split);

% Apply alternative envelope onto a signal
%
% TODO:
% randomise selection
%
% take either envelope from one or nb_bands files
% apply envelope onto primary signal
%
% Run loadsounds first to load alternate signals:
% alt_struct = loadsounds('*.wav',nb_bands,'primarysignal');

% Normalize envelopes before computation?
% Useless time lost by computing envelope for the all channels, in all stimuli in 'multi'

filter_type = 'lp';

% signal padding
for i = 1:length(alt_struct),
	g(i) = length(alt_struct(i).data);
end
[padding_size longest_el]= max([g length(x)]);
if longest_el ~= length(g)+1,
	x = padd(x,padding_size,'both');
end

[target,recombined,cf,bandwidth,edges] = bank_split(x,fs,nb_bands,'fir');
%[sig_mod,ori_mod,ori_env] = env_filter(target,fs,lfe_split,filter_type);
%ori_env = env_extract(target);

% compute the envelope of alt_struct files
switch lower(scheme),
	case {'mono','one'}
		alt_sig = padd(alt_struct(1).data,padding_size,'both');
		alt_sig = bank_split(alt_sig,fs,nb_bands,'fir');
%		[sig_mod,alt_mod,alt_env] = env_filter(alt_sig,fs,lfe_split,filter_type);
	case {'multi','multiple'}
		for i = 1:nb_bands,
			tmp_struct.channels = bank_split(alt_struct(:,i).data,fs,nb_bands,'fir');
			alt_sig(:,i) = padd(tmp_struct.channels(:,i),padding_size,'both');
%			alt_sig(:,i) = padd(alt_sig(:,i),padding_size,'both');
%			alt_env(:,i) = env_extract(alt_sig(:,i).data);
%whos;
%			[sig_mod(:,i),alt_mod(:,i),alt_env(:,i)] = env_filter(alt_sig(:,i),fs,lfe_split,filter_type);
		end
	otherwise
		error('type: help env_alt');
end

[sig_mod,alt_mod,alt_env] = env_filter(alt_sig,fs,lfe_split,filter_type);
[sig_mod,ori_mod,ori_env] = env_filter(target,fs,lfe_split,filter_type);

%figure; plot(alt_env(:,[1:nb_bands])); figure; plot(ori_env(:,[1:nb_bands]));
figure; plot(alt_mod(:,[1:nb_bands])); figure; plot(ori_mod(:,[1:nb_bands]));

%alt_env=flipdim(alt_env,1);

% find bigger file for padding
% padd each signal with zeros


% extract low freq component

% apply alt_struc envelope on x
%output x

x_split = target.*alt_mod./ori_mod;		% modified envelope for computation
%x_split = target.*alt_env./ori_env; 	% full envelope for computation
%x_split = target.*alt_mod./ori_env;		% mod. for alt and full for target
x_mod = sum(x_split,2);
