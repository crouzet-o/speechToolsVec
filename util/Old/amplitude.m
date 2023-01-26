function y = amplitude(infile,onset,offset);

if nargin<1,
	error('Type help amplitude to get USAGE');
end

if findstr(infile,'.')==[],
	infile=[infile,'.sig'];
end


%reads PCM raw sound file.
fid=fopen(infile,'r');
signal=fread(fid,'short');

%evaluates the interval in which to measure amplitude.
max=length(signal);

if exist('onset')==0 & exist('offset')==0,
	onset=1;
	offset=max;
end

rms=sqrt(mean(signal(onset:offset).^2))
amplitude=sqrt(3)*rms;
dB_SPL=20*log(rms/20)

% NB: formule de calcul de l'amplitude en dB:
% N = 20*log(rms/p0) avec p0=20microPa
% N = 10*log(rms/I0) avec I0=10^(-12)W/m^2
% Mais les valeurs de p0 et I0 ne donnent pas des résultats concordants
% avec ce que calcule CoolEdit.