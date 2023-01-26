% PEST: Parameter Estimation by Sequential Testing ()
% Adaptive Procedure for Speech Perception in noise Threshold measurement
%
% Procédure adaptative à contraintes fortes : PEST (Bonnet, Levitt & Rabiner, 1967)
%
% USAGE : pest;

clear all;

% DIRECTORIES - to be checked against each machine directory structure and disk names
root_disk = 'd:\';
root_signal_dir = 'sounds\env1\signal\';
root_noise_dir = 'sounds\env1\noise\';
%fullname = sprintf('%s%s%s%s',root_disk,root_directory,'specific_dir\',filename);

%global DATA_VALUE_STORED;
debug_value = 1;

% Parameters input:
subjectID = input('subject ID: ','s');

%reads the signals list
%var_signalID = input('Signal var file:','s');
var_signalID = 'var_signal.txt';
signal_list = readlist(var_signalID);
signal_list = struct2cell(signal_list);
nb_var_signal = length(signal_list);

%reads the noises list
%var_noiseID = input('Noise var file:','s');
var_noiseID = 'var_noise.txt';
noise_list = readlist(var_noiseID);
noise_list = struct2cell(noise_list);
nb_var_noise = length(noise_list);

nb_var = nb_var_signal * nb_var_noise;
var_list = repmat(signal_list,[1 nb_var_signal nb_var_noise]);
var_list(1,1,:) = repmat(noise_list,[1 1 2]);

for k = 1:nb_var,

seed_time_block = clock;
rand('state',sum(100*seed_time_block));
blocks_order = randperm(nb_var);
noise_extension = cell2mat(var_list(1,1,blocks_order(k)));
signal_extension = cell2mat(var_list(1,2,blocks_order(k)));





	listID = input('Stimulus list: ','s');
	%digit_size = input('Number of digits per sequence: ');
	
	data_filename = [listID,'.res'];
	summary_data_filename = [listID,'_summary.res'];
	%if isempty(findstr(subjectID,'.')),
	%	subjectID=[subjectID,'.res'];
	%end
		
	% Constants
	snr_ini = 0;
	step_ini = 3;
	nb_trials_max = 200;
	nb_inv_max = 10;
	minimal_step = 0.05;
	constant = 1.0;
	p_hits_threshold = .5;
	threshold_comp_window = 16;
	last_out = 0;
	quit = 0;
	
	% Initialize variables :
	nb_inv = 0;
	
	% Needs these four files to run %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	signal_listID=[listID,'_signals.txt'];
	answer_listID=[listID,'_answers.txt'];
	misc_listID=[listID,'_misc.txt'];
	noise_listID=[listID,'_signals.txt'];
	
	signal_list = readlist(signal_listID);
	nb_stim = size(signal_list);
	nb_stim = nb_stim(:,2);
	
	answer_list = readlist(answer_listID);
	misc_list = readlist(misc_listID);
	noise_list = readlist(noise_listID); %could use the signal list and add _noise to the name
	
	% Checks whether same origin stimuli are in the same position after scrambling
	% gets time and use it to set the random seed for the signal list but keeps the seed in memory
	seed_time_signal = clock;
	rand('state',sum(100*seed_time_signal));
	signals_order = randperm(nb_stim);
	
	i = ones(size(signals_order));
	while sum(i(:)) > 0,
		seed_time_noise = clock;
		rand('state',sum(100*seed_time_noise))
		noises_order = randperm(nb_stim);
		for n = 1:nb_stim,
			signal_file = deblank(signal_list(signals_order(n)).file);
			noise_file = deblank(noise_list(noises_order(n)).file);
			i(n) = strcmp(signal_file,noise_file); % l(10): line ID, .file(1:3): first three characters
		end
	end
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% This is where everything starts - don't loose time here
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	% Start of experiment: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	data_file_ID = fopen(data_filename,'at'); % prepares the results file
	summary_data_file_ID = fopen(summary_data_filename,'at'); % prepares the results file
	%fprintf(data_file_ID,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n',...
	%		'subj', 'n', 'signal', 'noise', 'inv','snr','VALUE','answer','hits','sumhits','(p_hits_threshold*(n-1))-constant','(p_hits_threshold*(n-1))+constant');
	
	% Matrices initialisation (snr, step, hits, t_hits, inversion)
	snr = ones(1,nb_stim) .* snr_ini; % Initialise le snr
	step = ones(1,nb_stim) .* step_ini; % Initialise le step .* 2
	hits = zeros(1,nb_stim);
	t_hits = zeros(1,nb_stim);
	inversion = zeros(1,nb_stim);
	easy = zeros(1,nb_stim);
	
	n = 1;
	onset=0;
	instant_step_value = step_ini;
	
	% Displays the interface
	close all;
	data_input;
	
	data_handle = findobj(gcf,'Tag','data_box');
	instruction_handle = findobj(gcf,'Tag','instruction_string');
	end_handle = findobj(gcf,'Tag','end_string');
	startbutton_handle = findobj(gcf,'Tag','start');
	quitbutton_handle = findobj(gcf,'Tag','quit');
	debug_handle = findobj(gcf,'Tag','debug_string');
	
	set(end_handle,'Visible','off'); % Remove the 'Start' button
	set(quitbutton_handle,'Visible','off'); % Disable the 'Start' button
	
	if debug_value == 0,
		set(debug_handle,'Visible','off'); % Remove the 'debug' area
	end
	
	pause(1);
	while onset == 0,
		pause(0.01);
	end
	
	set(startbutton_handle,'Enable','off'); % Disable the 'Start' button
	set(quitbutton_handle,'Visible','off'); % Disable the 'Start' button
	
	tic;
	pause(0.1);
	
	% Début de la boucle adaptative.
	% Change the way hits proportion is computed?
	
	rand('state',sum(100*seed_time_signal))
	signals_order = randperm(nb_stim);
	rand('state',sum(100*seed_time_noise))
	noises_order = randperm(nb_stim);
	
	while ((nb_inv < nb_inv_max) & (n < nb_trials_max) & (instant_step_value > minimal_step)),
	%while (instant_step_value > minimal_step),
		set(data_handle,'String','');
	
	%%%%%%%%%%%%%%%%% Première possibilité : hits < p_seuil (difficult) %%%%%%%%%%%%
		if n <= threshold_comp_window+1,
				step(1,n) = step_ini;
				snr(1,n) = snr_ini;
				inversion(1,n) = 0;
		else
			if sum(hits(1,n-threshold_comp_window-1:n-1),2) <= ((p_hits_threshold * threshold_comp_window) - constant),
				easy(1,n) = 0;
	%			if ((step(1,n-1) == step(1,n-2)) | (inversion(1,n-1) == 1) | (easy(n-1) == 1)),
				if ((easy(n-1) == 1) & (last_out == 1)),
				debug_string = sprintf('%s%2.3f\t%s%2.2f','Hard/inversion - Step = ',step(n-1),'SNR = ',snr(n-1));
				set(debug_handle,'String',debug_string);
					step(1,n) = step(1,n-1)/2;
					inversion(1,n) = 1;
					nb_inv = nb_inv + 1;
				else
				debug_string = sprintf('%s%2.3f\t%s%2.2f','Hard - Step = ',step(n-1),'SNR = ',snr(n-1));
				set(debug_handle,'String',debug_string);
					inversion(1,n) = 0;
					step(1,n) = (step(1,n-1));
				end
				snr(1,n) = snr(1,n-1) + step(1,n);
				last_out = -1;
	% jump to the end of the 'if' loop
	
	%%%%%%%%%%%%%%%% Seconde possibilité : hits > p_seuil (easy) %%%%%%%%%%%%%%%%%%%
			elseif sum(hits(1,n-threshold_comp_window-1:n-1),2) >= ((p_hits_threshold * threshold_comp_window) + constant)
				easy(1,n) = 0;
	%			if ((step(1,n-1) == step(1,n-2)) | (inversion(1,n-1) == 1) | (easy(n-1) == 1)),
				if ((easy(n-1) == 1) & (last_out == -1)),
				debug_string = sprintf('%s%2.3f\t%s%2.2f','Easy/Inversion - Step = ',step(n-1),'SNR = ',snr(n-1));
				set(debug_handle,'String',debug_string);
					step(1,n) = step(1,n-1)/2;
					inversion(1,n) = 1;
					nb_inv = nb_inv + 1;
				else
				debug_string = sprintf('%s%2.3f\t%s%2.2f','Easy - Step = ',step(n-1),'SNR = ',snr(n-1));
				set(debug_handle,'String',debug_string);
					step(1,n) = step(1,n-1);
					inversion(1,n) = 0;
				end
				snr(1,n) = snr(1,n-1) - step(1,n);
				last_out = 1;
	
	% jump to the end of the 'if' loop
	
	%%%%%%%%%%%%%%%%% Troisième possibilité : hits near threshold %%%%%%%%%%%%%%%%%%
			else
				easy(1,n) = 1;
				debug_string = sprintf('%s%2.3f\t%s%2.2f','Threshold - Step = ',step(n-1),'SNR = ',snr(n-1));
				set(debug_handle,'String',debug_string);
				step(1,n) = step(1,n-1);
				snr(1,n) = snr(1,n-1);
				inversion(1,n) = 0;
	
			end % if
		end
	
	instant_step_value = step(1,n);
	
	%%%%%%%%%%%%%%%% Choix aleatoire du stimulus à jouer : %%%%%%%%%%%%%%%%%%%%%%%%%
	% reads the names of the signals to play
			signal_file = deblank(signal_list(signals_order(n)).file);
			signal_path = [root_disk,root_signal_dir,signal_extension,'\',signal_file,'_',signal_extension,'.wav'];
			[signal,Fs] = wavread32(signal_path);
			answer = deblank(answer_list(signals_order(n)).file);
	
			noise_file = deblank(noise_list(noises_order(n)).file);
			noise_path = [root_disk,root_noise_dir,noise_extension,'\',noise_file,'_',noise_extension,'_noise.wav'];
			[noise,Fs] = wavread32(noise_path);
	
	% LTS analysis of the signal (already available in lts_filt.m)
	% and LTS filtering of the noise
			noise = lts_filt(noise,signal,128,10);
	
	% Padding of the shorter signal with zeros at the end
	% merging of the signal + noise w/ SNR controlled dynamically
			output = merge(signal,noise,snr(n));
			set(data_handle,'String','');
			wavplay(output,Fs,struct('scaling',800)); % Joue le stimulus
			waitfor(data_handle,'String');
			DATA_VALUE_STORED = get(data_handle,'String');
	
	%		Cotation des réponses
			hits(1,n) = strcmp(DATA_VALUE_STORED,answer);
			fprintf(data_file_ID,'%s\t%6.0f\t%s\t%s\t%s\t%s\t%6.0f\t%6.6f\t%s\t%s\t%6.0f\t%6.0f\t%6.3f\t%6.3f\n',...
				subjectID, n, signal_extension, signal_file, noise_extension, noise_file, inversion(n),snr(n),DATA_VALUE_STORED,answer,hits(n),sum(hits(1,1:n),2),(p_hits_threshold*(n-1))-constant,(p_hits_threshold*(n-1))+constant);
	
			set(data_handle,'String','');
	
	n = n + 1;
	end % end of while loop -> n_inv < nb_inv_max
	
	%expected_threshold = sum(snr) / n;
	expected_threshold = snr(n-1);
	mean_expected_threshold = sum(snr(n-10:n-1))/(n-(n-10));
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% !!! Need to maintain the experiment for the estimation 
	% of the psychometrical curve !!! statistical reliability...
	% With SNRs depending on the previous data.
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	duration = toc;
	fprintf(summary_data_file_ID,'%s\t%6.4f\t%6.4f\t%6.0f\t%6.0f%s\n',subjectID,expected_threshold,mean_expected_threshold,n-1,duration,' secondes');
	status = fclose(data_file_ID);
	status = fclose(summary_data_file_ID);
	
end % for loop on blocks

if status == 0
	set(data_handle,'Visible','off');
	set(instruction_handle,'Visible','off');
	set(end_handle,'Visible','on');
	set(startbutton_handle,'Visible','off');
	set(quitbutton_handle,'Visible','on');
else
	set(data_handle,'Visible','off');
	set(instruction_handle,'Visible','off');
	set(end_handle,'Visible','on');
	set(startbutton_handle,'Visible','off');
	set(quitbutton_handle,'Enable','off');
end

close all;

%pause(1);

%waitfor(data_handle,'String');
%DATA_VALUE_STORED = get(data_handle,'String');

%while quit == 0,
%	pause(0.01);
%end
%while strncmp(DATA_VALUE_STORED,'quit')~=1),
%	pause(0.1);
%end
