function [r,data,positive,ds_factor,struct_data] = env_r(x,fs,nb_bands,lfe_split,bank_type,corr_type);

% Compute envelope amplitude correlation between spectral channels
% 
% USAGE: [r,data] = env_r(x,fs,nb_bands,lfe_split,bank_type,corr_type);
% 
% corr_type: 'ncor' (normalized correlation) or 'ncov' (normalized covariance)
% bank_type: 'fir' or 'gt'
% lfe_split: array (band-pass) or scalar (low-pass filter)
%
% EXAMPLE: [r,y] = band_r(x,fs,4,[1 16],'fir');
%

%function [r,h,sig,data] = env_r(x,fs,nb_bands,lfe_split,bank_type,graph_color);
%lfe_split = [0.5 2 4 8 16 32 64];

%global wavload_filename; % enable access to a filename output by wavload if relevant

ds_factor = 64;
%ds_factor = 128;
fse = fs/ds_factor;


switch lower(bank_type),
	case {'gt','gammatone','gamma'}
		bank_type = 'gt';
	case {'fir','finite'}
		bank_type = 'fir';
	otherwise
		error('type: help env_r');
end

if exist('corr_type') == 0,
	corr_type = 'ncor';
end

[y,recombined,cf,bandwidth,edges]  = bank_split(x,fs,nb_bands,bank_type,100);	% y = length(y)* Nb_bands (Nb_bands columns)

h = hilbert(y);									% h = same dimensions as y but complex
env = sqrt(real(h).*real(h)+imag(h).*imag(h));	% env = same dimensions as y

								% half-wave rectification
env_tmp = sort(env(:,1));		% sorts samples in the envelope matrix
k = find(env_tmp>0);			% finds the non-zero values in the sorted matrix
l = find(env<=0);				% finds zeroes in the original envelope
env(l) = env(k(1),1);			% replaces these samples with the shortest non-zero value

% Modulation components extraction
for j = 1:nb_bands,
		ls_env(:,j) = resample(env(:,j),1,ds_factor);			% downsampling the envelope (faster computation)
		coeffs = fir1(100, lfe_split./(fse/2));					% bandpass
		ls_env_extract_x(:,j) = filtfilt(coeffs,1,ls_env(:,j));	%filtering
																%half-wave rectification
		ls_env_tmp = sort(ls_env_extract_x(:,1));				% sorts samples in the envelope matrix
		k = find(ls_env_tmp>0);									% finds the non-zero values in the sorted matrix
		l = find(ls_env_extract_x<=0);							% finds zeroes in the original envelope
		ls_env_extract_x(l) = ls_env_tmp(k(1),1);				%replaces these samples with the shortest non-zero value
		ls_env_extract_y(:,j) = ls_env_extract_x(:,j);
end

data = ls_env_extract_x;

% Does not change correlation coefficients (caus' corrcoef computes the normalized covariance
% But changes the data (better).
if corr_type == 'ncov',
	for i = 1:nb_bands,
		z(:,i) = ztrans(data(:,i));
	end
data = z;
end

for i = 1:nb_bands,
	positive(:,i) = data(:,i)-min(data(:,i));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r = corrcoef(data);		%needs stats toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

r = triu(r,1);
i = find(r==0);
r(i) = NaN;


% save with text_append ?
% sum([s.value]);
% s(2,:) = struct('file','a2','value',[5 4 3 2 1])

% Plotting (removed - Do ONE 2D plot of the whole data from the data file)

% Use these lines to compute correlation information on several signals
%for i = 1:new_index,
%	r_data(:,:,i) = s_data(i).r_table;
%end
%save(datafilename,'r');
%clear all
%mean(r_data,3);
%std(r_data,0,3);
%[h,sig] = ztest(r_data(4,4,:),.50,.2,.05,1);


switch length(lfe_split),
	case {1}
%	struct_data = struct('file',wavload_filename,'modulation',[0 lfe_split],'env_data',positive,'r_table',r);
	struct_data = struct('modulation',[0 lfe_split],'env_data',positive,'r_table',r);
	case {2}
%	struct_data = struct('file',wavload_filename,'modulation',lfe_split,'env_data',positive,'r_table',r);
	struct_data = struct('modulation',lfe_split,'env_data',positive,'r_table',r);
end

