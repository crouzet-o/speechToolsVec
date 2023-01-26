function y = temporal_smear_GT(filename,Nb_bands,env_cutoff);

% OBSOLETE. smears with ERBfilterbank splitting
% Low-pass filtering of a signal's envelope inside narrow frequency bands
%
% Requirements :
%		Auditory toolbox (Malcolm Slaney, http://www.slaney.org) for filterbank analysis
%		Signal Processing Toolbox (Mathworks) for hilbert.m
%		wav_norm.m (Olivier Crouzet)


debug = 1;
% remove this part to produce a function and replace filename by x,Fs
[x,Fs] = wavload(filename);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = x';
Fse = Fs/64;

%y = bank_split(x,Fs,32);

%%Try it with a for loop
%tic;
fcoefs = MakeERBFilters(Fs,Nb_bands,100);
fcoefs=flipud(fcoefs); %reverses the filterbanks' order (1 = low freq and not high freq)
y = ERBFilterBank(x,fcoefs);
%if debug == 1, time_filterbank = toc, end

%tic;
%h = hilbert(y);
%if debug == 1, time_hilbert=toc, end

%tic;
%env = sqrt(real(h).*real(h)+imag(h).*imag(h));
%if debug == 1, time_envelopecomputation = toc, end

%tmp_env = sort(env(1,:)); % sorts samples in the envelope matrix
%k = find(tmp_env>0); % finds the non-zero values in the sorted matrix
%l = find(env==0); % finds zeroes in the original envelope
%env(l) = env(1,k(1)); %replaces these samples with the shortest non-zero value

%plot(env(1,:));
%[m,n] = size(env);
%tmp = zeros(m,n);

tic;
for i = 1:Nb_bands,
   h(i,:) = hilbert(y(i,:));
	env(i,:) = sqrt(real(h(i,:)).*real(h(i,:))+imag(h(i,:)).*imag(h(i,:)));
   
tmp_env(i,:) = sort(env(i,:)); % sorts samples in the envelope matrix
k = find(tmp_env(i,:)>0); % finds the non-zero values in the sorted matrix
l = find(env(i,:)==0); % finds zeroes in the original envelope
env(l) = env(1,k(1)); %replaces these samples with the shortest non-zero value
   
   ls_env(i,:) = resample(env(i,:),1,64); % downsampling the envelope (faster computation)
   tmp = ls_env'; % translation for filtering first dimension
   
%	[n, Wn, Beta, type] = kaiserord([64/(Fse/2) 70/(Fse/2)], [1 0], [.01 .1], Fse); %filter coefficients estimation
%	c = fir1(n, Wn, type, kaiser(n+1, Beta), 'noscale'); % filter design

	c = fir1(200, env_cutoff/(Fse/2), 'noscale'); % filter design
	tmp2(:,i) = filtfilt(c,1,tmp(:,i)); %filtering
   ls_env_mod = tmp2'; %translated back
	mod(i,:) = resample(ls_env_mod(i,:),64,1); % upsampling the envelope
end
if debug == 1, time_envelopefiltering = toc, end

tic;
clear tmp_env;
tmp_env = sort(abs(ls_env_mod(1,:))); % sorts samples in the envelope matrix
k = find(tmp_env>0); % finds the non-zero values in the sorted matrix
l = find(ls_env_mod<=0); % finds zeroes or negative samples in the original envelope
ls_env_mod(l) = ls_env_mod(1,k(1)); % replaces these samples with the shortest non-zero value

sig_mod = y.*mod(:,[1:length(env)])./env;
final = sum(sig_mod,1);
if debug == 1, time_envelopemodification = toc, end

% remove this part to produce a function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
save_to_file = [filename,'_',num2str(Nb_bands),'_',num2str(env_cutoff),'.wav'];
final = wav_norm(final);
wavwrite(final,Fs,save_to_file);

%string_title = ['envelope cutoff frequency: ',num2str(env_cutoff),' Hz'];
%figure;
%plot(tmp2(:,Nb_bands/2));
%title(string_title);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
