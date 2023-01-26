function y = rmsdb(infile,onset,offset);

% Calcule la RMS en dB(SPL) d'un fichier PCM Raw Sound File
% Attention, pour l'instant, ça donne des résultats complètement
% farfelus. Problème de la valeur de référence de la pression acoustique.
% De toutes façons, il faut avoir une calibration du système de sortie
% du son pour avoir une estimation valide du lien entre rms et amplitude en dB.


% Constantes :
Izero=(10^(-12));
pzero=20;

if nargin<1,
	error('Type help rmsdb to get USAGE');
end

if isempty(findstr(infile,'.')),
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
dB_SPL1=20*log(amplitude/pzero)
dB_SPL2=10*log(amplitude/Izero)
dB_SPL1=20*log(rms/pzero)
dB_SPL2=10*log(rms/Izero)


% NB: formule de calcul de l'amplitude en dB:
% N = 20*log(rms/pzero) avec p0=20microPa
% N = 10*log(rms/Izero) avec I0=10^(-12)W/m^2
% Mais les valeurs de p0 et I0 ne donnent pas des résultats concordants
% avec ce que calcule CoolEdit !!!
% En fait, la valeur de dB calculée dépend uniquement des caractéristiques
% du casque et de la carte son utilisés. On ne peut pas mesurer une intensité
% en dB à partir d'un fichier informatique. Pour faire ça, il faut avoir
% les caractéristiques du casque sur cette carte par calibration.
% Une fois qu'on a cette calibration, on peut même générer des sons
% avec un rapport S/B défini. Il suffit alors de calculer l'intensité du
% signal et de générer par exemple un bruit qui, additionné au signal
% donnera un rapport S/B de 3dB par exemple.
