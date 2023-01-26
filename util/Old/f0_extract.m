function [f0_average,f0_contour] = f0_extract(Fs,signal);

% Script analysant un signal de parole pour en extraire le contour de fréquence
% fondamentale avec une procédure d'extraction cepstrale
% Noll (1967), JASA, 41, 293-309. (nb : tout n'est pas implémenté, notamment les
% méthodes d'applanissement de la courbe mais c'est déjà pas mal par rapport
% à d'autres programmmes.
% NB: Fait appel à des procédures de COLEA (téléchargeable sur le site de
% Mathworks

[signal,Fs] = loadsig(signal,Fs);

[f0_average,f0_contour] = getf0(Fs,signal);

% Ecrit le contour dans un fichier texte.
%output_text = [signal + '.f0'];
%fid = fopen(output_text,'wa');
