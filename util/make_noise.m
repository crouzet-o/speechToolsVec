function y = make_noise(liste_stimuli,snr);

% Charge la liste des stimuli et compte le nombre de stimuli:
liste = readlist(liste_stimuli);
nb_stim = size(liste);
nb_stim = nb_stim(:,2);

for i = 1:nb_stim,
   
   file = deblank(liste(i).file);
   signal_file = [file,'.sig'];
   noise_file = [file,'.noi'];
   
	% Génération du stimulus bruité
	signal = normalize(loadsig(signal_file),1500);
	noise_wave = rms_noise(signal,'shap','n',snr);
	%noise_spec = lts_filt(noise_wave,signal,128,4);
   sigwrite(noise_wave,noise_file);
end

y = fclose('all');

