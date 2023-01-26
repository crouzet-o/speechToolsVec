function [final,recombined,duration] = temporal_smear(x,fs,bank_type,Nb_bands,env_cutoff,filter_type,graph_color,target,max_amp,column,nb_cols);

% Smear the long-term envelope of a signal (low-pass or high-pass filter)
% Filtering of a signal's envelope within narrow frequency bands
%
% USAGE: [final,recombined,duration] = temporal_smear(x,fs,bank_type,Nb_bands,...
%			env_cutoff,filter_type,graph_color,target,max_amp,column,nb_cols);
%
% EXAMPLE: [final,recombined,duration] = temporal_smear(x,fs,'fir',8,...
%														8,'lp','k','mod',.8,2,3);
%
% bank_type: 	'gt' vs. 'fir'
% filter_type:	'lp' vs. 'hp'
% graph_color:	cf. PLOT function for string arguments
% target:		'ori' vs. 'mod' (original vs. modified signal)
%
% Requirements :
%		Auditory toolbox (Malcolm Slaney, http://www.slaney.org)
%		Signal Processing Toolbox

	
if exist('graph_color') == 1,
	if exist('column') == 0,
		column = 1;
		nb_cols = 1;
	end
	if exist('max_amp') == 0,
		max_amp = 1;
	end
	subplot(Nb_bands,nb_cols,column);
end


fse = fs/64;

switch lower(bank_type),
	case {'gt','gammatone','gamma'}
		[y,recombined,cf,bandwidth,edges]  = bank_split(x,fs,Nb_bands,'gt',100); % y = length(y)* Nb_bands (Nb_bands columns)
	case {'fir','finite'}
		[y,recombined,cf,bandwidth,edges]  = bank_split(x,fs,Nb_bands,'fir',100); % y = length(y)* Nb_bands (Nb_bands columns)
	otherwise
		error('type help temporal_smear');
end

h = hilbert(y);									% h = same as y but complex
env = sqrt(real(h).*real(h)+imag(h).*imag(h));	% env = same as y

												% half-wave rectification
env_tmp = sort(env(1,:));						% sorts samples in the envelope matrix
k = find(env_tmp>0);							% finds the non-zero values in the sorted matrix
l = find(env<=0);								% finds zeroes in the original envelope
env(l) = env(1,k(1));							% replaces these samples with the shortest non-zero value

if ((exist('graph_color','var') == 1)&(target=='ori')),
	duree_env=length(env);
	t=1:duree_env;
	hold on;
	subplot(Nb_bands,nb_cols,column);
	for k = 1:Nb_bands,
		hold on;
		subplot(Nb_bands,nb_cols,(k*nb_cols)-(nb_cols-column));
		plot(t/fs,env(k,:),graph_color);
		axis([0 duree_env/fs 0 max_amp]);
		set(gca,'Fontsize',8,'Fontname','Courrier')
		hold on
	end
	xlabel('Time (s)');
	ylabel('Amplitude');
end

for i = 1:length(env_cutoff),
	for j = 1:Nb_bands,
		ls_env(:,j) = resample(env(:,j),1,64);					% downsampling the envelope (faster computation)
		if filter_type == 'hp',
			coeffs = fir1(100, env_cutoff(i)/(fse/2), 'high');	% highpass
		else
			coeffs = fir1(100, env_cutoff(i)/(fse/2));			% lowpass
		end
		ls_env_mod(:,j) = filtfilt(coeffs,1,ls_env(:,j));		% filtering
		mod(:,j) = resample(ls_env_mod(:,j),64,1);				% upsampling the envelope
		mod(:,j) = normalize(mod(:,j),env(:,j));
	end

	if ((exist('graph_color','var') == 1)&(target=='mod')),
		duree_mod=length(mod);
		t=1:duree_mod;
		hold on;
		subplot(Nb_bands,nb_cols,column);
		for k = 1:Nb_bands,
			hold on;
			subplot(Nb_bands,nb_cols,(k*nb_cols)-(nb_cols-column));
			plot(t/fs,mod(:,k),graph_color);
			axis([0 duree_mod/fs 0 max_amp]);
			set(gca,'Fontsize',8,'Fontname','Courrier')
			hold on
		end
		xlabel('Time (s)');
		ylabel('Amplitude');
	end

	sig_mod = y.*mod([1:length(env)],:)./env;

	%low-pass filtering to remove high-frequency transients (aliases)
	for k = 1:Nb_bands,
		Order = 300;
		Wn = edges(k,:);
		coeffs_lp = fir1(Order,Wn);
		sig_mod(:,k) = filtfilt(coeffs_lp,1,sig_mod(:,k));
	end
	
	final = sum(sig_mod,2);
	
	final = normalize(final,x);

	if max(final)>.5,
		final = normalize(final,.5,'max');
	end
   
end
