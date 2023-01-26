function [sig_mod,env_mod,env_ori] = env_filter(x,fs,lf_cutoff,filter_type);

% Select part of the temporal modulation envelope
%
% USAGE:	[sig_mod,env_mod,env_ori] = env_filter(x,fs,lf_cutoff,filter_type);

env_ori = env_extract(x);
ds_factor=64;
fse = fs/ds_factor;

[length_x nb_bands] = size(x);
[cf,bandwidth,edges] = make_filterbank(fs,nb_bands,100,'n');


for j = 1:nb_bands,
	ls_env(:,j) = resample(env_ori(:,j),1,ds_factor);					% downsampling the envelope (faster computation)
	if filter_type == 'hp',
		coeffs = fir1(100, lf_cutoff/(fse/2), 'high');	% highpass
	else
		coeffs = fir1(100, lf_cutoff/(fse/2));			% lowpass
	end
	ls_env_mod(:,j) = filtfilt(coeffs,1,ls_env(:,j));		% filtering
	env_mod(:,j) = resample(ls_env_mod(:,j),64,1);				% upsampling the envelope

%whos												%half-wave rectification
	tmp = sort(env_mod);										% sorts samples in the envelope matrix
	k = find(tmp>0);										% finds the non-zero values in the sorted matrix
	l = find(env_mod<=0);											% finds zeroes in the original envelope
	env_mod(l) = tmp(k(1),1);										%replaces these samples with the shortest non-zero value
end

env_mod = env_mod([1:length(x)],:);

sig_split = x.*env_mod./env_ori;

%low-pass filtering each channel to remove high-frequency transients (aliases)
for k = 1:nb_bands,
	Order = 300;
	Wn = edges(k,:);
	coeffs_lp = fir1(Order,Wn);
	sig_split(:,k) = filtfilt(coeffs_lp,1,sig_split(:,k));
end

sig_mod = sig_split;
%sig_mod = sum(sig_split,2);
