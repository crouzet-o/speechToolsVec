function [f0_average,f0_contour] = f0_extract(Fs,signal);

% Script analysant un signal de parole pour en extraire le contour de fr�quence
% fondamentale avec une proc�dure d'extraction cepstrale
% Noll (1967), JASA, 41, 293-309. (nb : tout n'est pas impl�ment�, notamment les
% m�thodes d'applanissement de la courbe mais c'est d�j� pas mal par rapport
% � d'autres programmmes.
% NB: Fait appel � des proc�dures de COLEA (t�l�chargeable sur le site de
% Mathworks

[signal,Fs] = loadsig(signal,Fs);

[f0_average,f0_contour] = getf0(Fs,signal);

% Ecrit le contour dans un fichier texte.
%output_text = [signal + '.f0'];
%fid = fopen(output_text,'wa');
