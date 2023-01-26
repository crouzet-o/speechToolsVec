function f0_contour = f0_extract(signal,Fs,method,filename,onset,offset);

% Script en cours de modification pour extraire le contour f0 d'un signal et le
% stocker dans un fichier texte. Fait appel aux procédures présentes dans COLEA
% (nécessite donc la présence de COLEA dans le path).
%
% ###########    NB: Ne marche pas avec la méthode 'auto' ######################
%
% USAGE : f0_extract(signal,Fs,method,outfile,onset,offset);
%
% EXAMPLE : f0_extract('signal',16000,'ceps',0,4000);
%
% Defaults : filename extension, '.sig'
%					onset, 0 (in ms)
%					offset, end_of_file (in ms)
%					method, 'ceps' (alternate choice, 'auto' for autocorrelation)

% # echantillon = round(duree en ms * 16)

if nargin < 2,
	error('Type help f0_extract to get USAGE');
end

if ~isempty(findstr(filename,'.')),
   error('Please don''t specify filename''extension');
end

%signal = loadsig(filename);
max = length(signal);

% conversion ms > echantillons
onset_sample = fix(onset/1000*Fs)
offset_sample = fix(offset/1000*Fs)

if exist('onset') == 0
	onset = 0;
end

if exist('offset') == 0
	offset = max;
end

data_file = [filename,'.pit'];
data_file_id = fopen(data_file,'wt'); % prépare le fichier de résultats

n_samples = offset - onset;

%-----select a method for pitch detection -----------
%
if strcmp(method,'ceps')
	 CEPSTRUM=1;	
 else 
	CEPSTRUM=0; 
	[bf0,af0]=butter(4,900/(Fs/2));
 end;


%---- Do some error checking on the signal level ---
meen = mean(signal);
signal= signal - meen; %----------remove the DC bias---


updRate = floor(20*Fs/1000);  %-- Update every 20 msec
if CEPSTRUM == 1
 fRate = floor(40*Fs/1000);  % -- Use a 40 msec segment
else
 fRate = floor(30*Fs/1000);  % -- Use a 30 msec segment
end
nFrames = floor(n_samples/updRate)-1;

k=1;
f01=zeros(1,nFrames);
f0=zeros(1,nFrames);

m=1;
avgF0=0;
for t=1:nFrames
		yin=signal(k:k+fRate-1);
		
		if CEPSTRUM==1
			a=pitch(fRate,Fs,yin); % Use the cepstrum method
		else
	        	a=pitchaut(fRate,Fs,yin); % Use the autocorr. method
		end
		f0(t)=a;
		if t>2 & nFrames>3 %--do some median filtering
		  z=f0(t-2:t); 
		  md=median(z);
		  f01(t-2)=md;
		  if md > 0
		    avgF0=avgF0+md;
		    m=m+1;
		   end
		elseif nFrames<=3
		  f01(t)=a;
		  avgF0=avgF0+a;
		  m=m+1;
		end

		
k=k+updRate;
    
end


if m==1, avgF0=0; else, avgF0=avgF0/(m-1); end;

  upd=round(1000*updRate/Fs);

  fprintf(data_file_id,'Average F0:\t%5.2f (Hz)\n',avgF0);
  fprintf(data_file_id,'t(msec)\tF0(Hz)\n');
  k=1;
  for t=upd/2:upd:nFrames*upd
     f0_contour = f01(k);
     fprintf(data_file_id,'%4.2f\t%5.2f\n',t,f01(k));
  k=k+1;
  end 
 
  fclose(data_file_id);


%-------------- Plot F0 contour  ---------------------------------
%
xt=1:nFrames;
xt=20*xt;

plot(xt,f01);
current_fig = gcf;
%axis([xt(1) xt(nFrames) 0 max(f01)+50]);
axis([xt(1) xt(nFrames) 80 150]);
%else
%  if nFrames==1, plot(f01,'o'); else, plot(f01); end;
%end

str = sprintf('Average F0=%5.2f Hz',avgF0);
set(current_fig,'Name',str);

ylabel('Fundamental Frequency (Hz)');
xlabel('Time (msecs)');
