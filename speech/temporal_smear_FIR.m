function final = temporal_smear_FIR(filename,bank_type,Nb_bands,env_cutoff,filter_type,graph_color,column,nb_cols,target,max_amp);

% Filtering of a signal's envelope within narrow frequency bands
%
% Requirements :
%		Auditory toolbox (Malcolm Slaney, http://www.slaney.org) for filterbank analysis
%		Signal Processing Toolbox (Mathworks) for hilbert.m
%		normalize.m (Olivier Crouzet)

if exist('column') == 0,
	column = 1;
	subplot(Nb_bands,nb_cols,column);
end
	
if exist('max_amp') == 0,
	max_amp = 1;
end

[x,Fs] = wavload(filename); % x = length(x)*1
Fse = Fs/64;

%for n = 1:length(Nb_bands),
switch lower(bank_type),
	case {'gt','gammatone','gamma'}
		[y,recombined,cf,bandwidth,edges]  = bank_split(x,Fs,Nb_bands,'gt',100); % y = length(y)* Nb_bands (Nb_bands columns)
	case {'fir','finite'}
		[y,recombined,cf,bandwidth,edges]  = bank_split(x,Fs,Nb_bands,'fir',100); % y = length(y)* Nb_bands (Nb_bands columns)
	otherwise
		error('type help temporal_smear');
end

h = hilbert(y); % h = same as y but complex
env = sqrt(real(h).*real(h)+imag(h).*imag(h)); % env = same as y

%half-wave rectification
env_tmp = sort(env(1,:)); % sorts samples in the envelope matrix
k = find(env_tmp>0); % finds the non-zero values in the sorted matrix
l = find(env<=0); % finds zeroes in the original envelope
env(l) = env(1,k(1)); %replaces these samples with the shortest non-zero value

if ((exist('graph_color','var') == 1)&(target=='ori')),
	duree_env=length(env);
	t=1:duree_env;
	hold on;
	subplot(Nb_bands,nb_cols,column);
%	string_title = ['Modified envelope (lp ',num2str(env_cutoff),')'];
%	title(string_title);
	for k = 1:Nb_bands,
		hold on;
		subplot(Nb_bands,nb_cols,(k*nb_cols)-(nb_cols-column));
		plot(t/Fs,env(k,:),graph_color);
		axis([0 duree_env/Fs 0 max_amp]);
		set(gca,'Fontsize',8,'Fontname','Courrier')
%		string_title = ['envelope cutoff frequency: ',num2str(env_cutoff),' Hz'];
%		plot(tmp2(:,Nb_bands(n)/2),'k');
%		title(string_title);
		hold on
	end
	xlabel('Time (s)');
	ylabel('Amplitude');
end

for i = 1:length(env_cutoff),
	for j = 1:Nb_bands,
		ls_env(j,:) = resample(env(j,:),1,64); % downsampling the envelope (faster computation)
		if filter_type == 'hp',
			coeffs = fir1(100, env_cutoff(i)/(Fse/2), 'high'); % highpass
		else
			coeffs = fir1(100, env_cutoff(i)/(Fse/2)); % lowpass
		end
		ls_env_mod(j,:) = filtfilt(coeffs,1,ls_env(j,:)); %filtering
		mod(j,:) = resample(ls_env_mod(j,:),64,1); % upsampling the envelope
		mod(j,:) = normalize(mod(j,:),env(j,:));
	end

%ind = find(mod_tmp<0); % finds negative values in the original envelope
%mod(ind) = 0; %replaces these samples with zeroes
%mod = normalize(mod,x,'rms');
%rms(mod)
%rms(mod_tmp)
%rms(env)

	if ((exist('graph_color','var') == 1)&(target=='mod')),
		duree_mod=length(mod);
		t=1:duree_mod;
		hold on;
		subplot(Nb_bands,nb_cols,column);
%		string_title = ['Modified envelope (lp ',num2str(env_cutoff),')'];
%		title(string_title);
		for k = 1:Nb_bands,
			hold on;
			subplot(Nb_bands,nb_cols,(k*nb_cols)-(nb_cols-column));
			plot(t/Fs,mod(k,:),graph_color);
			axis([0 duree_mod/Fs 0 max_amp]);
			set(gca,'Fontsize',8,'Fontname','Courrier')
%			string_title = ['envelope cutoff frequency: ',num2str(env_cutoff),' Hz'];
%			plot(tmp2(:,Nb_bands(n)/2),'k');
%			title(string_title);
			hold on
		end
		xlabel('Time (s)');
		ylabel('Amplitude');
	end

sig_mod = y.*mod(:,[1:length(env)])./env;

%low-pass filtering to remove high-frequency transients (aliases)
for k = 1:Nb_bands,
	Order = 300;
	Wn = edges(k,:);
	coeffs_lp = fir1(Order,Wn);
	sig_mod(k,:) = filtfilt(coeffs_lp,1,sig_mod(k,:));
end
	
final = sum(sig_mod,1);
	
% remove this part to produce a function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
save_to_dir = [num2str(Nb_bands),'_',filter_type,'_smeared_',num2str(env_cutoff(i))];
save_to_file = [save_to_dir,'\',filename,'_',num2str(Nb_bands),'ch_smeared_',filter_type,'_',num2str(env_cutoff(i)),'.wav'];
create_dir(save_to_dir);

final = normalize(final,x);
if max(final)>.5,
	final = normalize(final,.5,'max');
end
wavwrite32(final,Fs,save_to_file);
   
end

%end %1:length(Nb_bands)

clear env env_tmp mod mod_tmp ls_env ls_env_mod coeffs coeffs_lp;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
