%                           Olivier Crouzet
%                      o.crouzet@cns.keele.ac.uk
%
% PEST: Parameter Estimation by Sequential Testing ()
% Adaptive Procedure for Speech Perception in noise Threshold measurement
%
% Procédure adaptative à contraintes fortes : PEST (Bonnet, Levitt & Rabiner, 1967)
%
% USAGE : pest;

clear all;
clear classes;

% DIRECTORIES - to be checked against each machine directory structure and disk names
root_disk = 'c:\';
root_signals_dir = 'olivier\env1\run\stimuli\';
%root_disk = 'd:\';
%root_signals_dir = 'home\sounds\expes\env1\run\stimuli\';
%fullname = sprintf('%s%s%s%s',root_disk,root_directory,'specific_dir\',filename);
listID = 'env1';

%global DATA_VALUE_STORED;
debug_value = 0;

% Parameters input:
%if exist('env1.res') == 0,
subjectID = input('subject ID: ','s');
data_dir = sprintf('%s%s','data\',subjectID);


conditionsID = 'conditions.txt';
[var_signal_list,var_noise_list,ini_snr_list] = textread(conditionsID,'%s %s %d');
nb_var = length(var_signal_list);
%noise_list = cell2mat(noise_list);
%signal_list = cell2mat(signal_list);


%%reads the signals list
%%var_signalID = input('Signal var file:','s');
%var_signalID = 'var_signal.txt';
%var_signal_list = readlist(var_signalID);
%var_signal_list = struct2cell(var_signal_list);
%nb_var_signal = length(var_signal_list);
%
%%reads the noises list
%%var_noiseID = input('Noise var file:','s');
%var_noiseID = 'var_noise.txt';
%var_noise_list = readlist(var_noiseID);
%var_noise_list = struct2cell(var_noise_list);
%nb_var_noise = length(var_noise_list);
%
%nb_var = nb_var_signal * nb_var_noise;
%var_list = repmat(var_signal_list,[1 nb_var_signal nb_var_noise]);
%var_list(1,1,:) = repmat(var_noise_list,[1 1 2]);

%displays the interface
data_input;
interface_handle = gcf;

interface_handle = gcf;
data_handle = findobj(gcf,'Tag','data_box');
instruction_handle = findobj(gcf,'Tag','instruction_string');
msg_handle = findobj(gcf,'Tag','msg_string');
end_handle = findobj(gcf,'Tag','end_string');
startbutton_handle = findobj(gcf,'Tag','start');
quitbutton_handle = findobj(gcf,'Tag','quit');
debug_handle = findobj(gcf,'Tag','debug_string');
	
set(msg_handle,'Visible','off');
set(end_handle,'Visible','off'); % Remove the 'Start' button
set(startbutton_handle,'Enable','off'); % Disable the 'Start' button
set(quitbutton_handle,'Enable','off'); % Disable the 'Quit' button

pause(0.1);
done_blocks = 0;

for k = 1:nb_var,
	seed_time_block = clock;
	rand('state',sum(100*seed_time_block));
	blocks_order = randperm(nb_var);
	noise_extension = cell2mat(var_noise_list(blocks_order(k)));
	signal_extension = cell2mat(var_signal_list(blocks_order(k)));
%	create_dir(subjectID);
	create_dir(data_dir);
	test_data_file = [data_dir,'\',subjectID,'_',signal_extension,'_',noise_extension,'.mat'];
	if exist(test_data_file,'file') == 2,
		done_blocks = done_blocks + 1
	end
end


for k = 1:nb_var,
%	seed_time_block = clock;
	rand('state',sum(100*seed_time_block));
	blocks_order = randperm(nb_var);
	noise_extension = cell2mat(var_noise_list(blocks_order(k)));
	signal_extension = cell2mat(var_signal_list(blocks_order(k)));
	initial_snr = ini_snr_list(blocks_order(k));

	create_dir(data_dir);
	test_data_file = [data_dir,'\',subjectID,'_',signal_extension,'_',noise_extension,'.mat'];

	set(msg_handle,'Visible','on');
	msg_string = sprintf('%s%2.0f','Remaining sessions : ',nb_var-done_blocks);
	set(msg_handle,'String',msg_string);
	set(startbutton_handle,'Enable','on'); % Enable the 'Start' button

if exist(test_data_file,'file') == 2,
	pause(0.1);
%	break;
else
	%listID = input('Stimulus list: ','s');
	%digit_size = input('Number of digits per sequence: ');
	data_filename = [data_dir,'\',subjectID,'.res'];
	summary_data_filename = [data_dir,'\',subjectID,'_summary.res'];
	%if isempty(findstr(subjectID,'.')),
	%	subjectID=[subjectID,'.res'];
	%end
		
	% Constants %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	sound_pressure_level = 300;
	snr_ini = initial_snr;
	step_ini = 9;
%	nb_trials_max = 200;
	nb_trials_max = 12;
	nb_inv_max = 10;
	minimal_step = 0.1; %0.05
	constant = 1.0;
	p_hits_threshold = .5;
	threshold_comp_window = 4;
	last_out = 0;
	quit = 0;
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
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
	snr = NaN .* ones(1,nb_stim);% .* snr_ini; % Initialise le snr
	step = NaN .* ones(1,nb_stim);% .* step_ini; % Initialise le step .* 2
	hits = NaN .* ones(1,nb_stim);
	t_hits = zeros(1,nb_stim);
	inversion = zeros(1,nb_stim);
	easy = zeros(1,nb_stim);
	
	n = 1;
	onset=0;
	endofexperiment=0;
	instant_step_value = step_ini;
	
	if debug_value == 0,
		set(debug_handle,'Visible','off'); % Remove the 'debug' area
	end
	
%	pause(0.1);
	set(startbutton_handle,'Enable','on'); % Disable the 'Start' button
	set(quitbutton_handle,'Visible','on'); % Disable the 'Start' button
	set(quitbutton_handle,'Enable','on'); % Disable the 'Start' button
	while (onset == 0) & (endofexperiment == 0),
		pause(0.01);
	end
	
	if endofexperiment == 1,
		break
	else onset == 1,
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
		
			if n <= threshold_comp_window+1,
				step(1,n) = step_ini;
				snr(1,n) = snr_ini;
				inversion(1,n) = 0;
				last_out = 0;
				easy(1,n) = 0;
%%%%%%%%%%%%%%%%% Première possibilité : hits < p_seuil (difficult) %%%%%%%%%%%%
			else
				if sum(hits(1,n-threshold_comp_window-1:n-1),2) <= ((p_hits_threshold * threshold_comp_window) - constant),
%				if ((step(1,n-1) == step(1,n-2)) | (inversion(1,n-1) == 1) | (easy(n-1) == 1)),
%				if ((easy(1,n-1) == 1) & (last_out == 1)),
					if last_out == 1,
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
%					easy(1,n) = -1;
					last_out = -1;
	
%%%%%%%%%%%%%%%% Seconde possibilité : hits > p_seuil (easy) %%%%%%%%%%%%%%%%%%%
				elseif sum(hits(1,n-threshold_comp_window-1:n-1),2) >= ((p_hits_threshold * threshold_comp_window) + constant)
%					if ((step(1,n-1) == step(1,n-2)) | (inversion(1,n-1) == 1) | (easy(n-1) == 1)),
%					if ((easy(1,n-1) == 1) & (last_out == -1)),
					if last_out == -1,
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
%					easy(1,n) = 1;
					last_out = 1;
	
%%%%%%%%%%%%%%%%% Troisième possibilité : hits near threshold %%%%%%%%%%%%%%%%%%
				else
%					easy(1,n) = 1;
					debug_string = sprintf('%s%2.3f\t%s%2.2f','Threshold - Step = ',step(n-1),'SNR = ',snr(n-1));
					set(debug_handle,'String',debug_string);
					step(1,n) = step(1,n-1);
					snr(1,n) = snr(1,n-1);
					inversion(1,n) = 0;
	%				last_out = 0;
				end % if
			end % if number of observations < nb_comp_window
	
			instant_step_value = step(1,n);
	
%%%%%%%%%%%%%%%% Choix aleatoire du stimulus à jouer : %%%%%%%%%%%%%%%%%%%%%%%%%
% reads the names of the signals to play
			signal_file = deblank(signal_list(signals_order(n)).file);
			signal_path = [root_disk,root_signals_dir,'signal\',signal_extension,'\',signal_file,'_',signal_extension,'.wav']
			[signal,Fs] = wavload(signal_path);
			signal = normalize(signal,sound_pressure_level,'rms');
			answer = deblank(answer_list(signals_order(n)).file);
	
			noise_file = deblank(noise_list(noises_order(n)).file);
			noise_path = [root_disk,root_signals_dir,'noise\',noise_extension,'\',noise_file,'_',noise_extension,'_noise.wav']
			[noise,Fs] = wavload(noise_path);
	
% LTS analysis of the signal (already available in lts_filt.m)
% and LTS filtering of the noise
			noise = lts_filt(noise,signal,128,10);
			noise = normalize(noise,sound_pressure_level,'rms');
	
% Padding of the shorter signal with zeros at the end
% merging of the signal + noise w/ SNR controlled dynamically
			output = merge(signal,noise,snr(n));
			output = normalize(output,sound_pressure_level,'rms');
			set(data_handle,'String','');
%			wavplay(output,Fs,struct('scaling',2000)); % Joue le stimulus
			wavplay(output,Fs,struct('scaling','none')); % Joue le stimulus

			debug_string = sprintf('%s%2.0f\t%s%2.0f\t%s%2.0f','MAX: Signal',max(signal),'Noise',max(noise),'Output',max(output));
			set(debug_handle,'String',debug_string);
			waitfor(data_handle,'String');
			DATA_VALUE_STORED = get(data_handle,'String');
	
% Cotation des réponses
			hits(1,n) = strcmp(DATA_VALUE_STORED,answer);
			fprintf(data_file_ID,'%s\t%6.0f\t%s\t%s\t%s\t%s\t%6.0f\t%6.6f\t%s\t%s\t%6.0f\t%6.0f\t%6.3f\t%6.3f\n',...
				subjectID, n, signal_extension, signal_file, noise_extension, noise_file, inversion(n),snr(n),DATA_VALUE_STORED,answer,hits(n),sum(hits(1,1:n),2),(p_hits_threshold*(n-1))-constant,(p_hits_threshold*(n-1))+constant);
	
			set(data_handle,'String','');
	
			last_trial = n;
			n = n + 1;
		end % end of while loop -> n_inv < nb_inv_max %end of adaptive procedure
	
%		expected_threshold = sum(snr) / n;
		expected_threshold = snr(n-1);
		mean_expected_threshold_last = sum(snr(n-10:n-1))/(n-(n-10));
	
		duration = toc;
		fprintf(summary_data_file_ID,'%s\t%s\t%s\t%6.4f\t%6.4f\t%6.0f\t%6.0f\n',subjectID,signal_extension,noise_extension,expected_threshold,mean_expected_threshold_last,n-1,duration);
		status = fclose(data_file_ID);
		status = fclose(summary_data_file_ID);

		save_name = [data_dir,'\',subjectID,'_',signal_extension,'_',noise_extension,'.mat'];
		save(save_name,'subjectID','signal_extension','noise_extension','inversion','snr','hits',...
			'blocks_order','duration','expected_threshold','inversion','last_trial','listID',...
			'nb_inv','p_hits_threshold','seed_time_block','seed_time_noise','seed_time_signal',...
			'signals_order','step','threshold_comp_window','var_signal_list','var_noise_list','ini_snr_list');

		set(data_handle,'Visible','on');
		set(instruction_handle,'Visible','on');
		set(end_handle,'Visible','off');
		set(startbutton_handle,'Visible','on');
		set(quitbutton_handle,'Enable','off');

		figure;
		data_summary_handle = gcf;
		plot(snr,'r');
		axis([threshold_comp_window last_trial -max(abs(snr))-1 max(abs(snr))+1]);

		save_graph_data_name = [data_dir,'\',subjectID,'_',signal_extension,'_',noise_extension,'.eps'];
		print(data_summary_handle,'-depsc','-r150',save_graph_data_name);
%		print(data_summary_handle,'-dmfile',save_graph_data_name);
%		hgsave(data_summary_handle,save_graph_data_name);
		close(data_summary_handle);

		done_blocks = done_blocks + 1;

%		clear signal_extension;
%		clear noise_extension;

	end % if onset or quit = 1

end %(if exist data_file for this subject in this condition)

end % for loop on blocks

endofexperiment=0;
set(msg_handle,'Visible','off');
set(startbutton_handle,'Visible','off'); % Disable the 'Start' button
set(data_handle,'Visible','off');
set(instruction_handle,'Visible','off');
set(end_handle,'Visible','on');
%set(startbutton_handle,'Visible','off');
set(quitbutton_handle,'Visible','on');
set(quitbutton_handle,'Enable','on'); % Disable the 'Start' button

while endofexperiment == 0,
	pause(0.01);
end
	

%pause(0.1);
%if exist('data_file_ID') == 1,
%	fclose('data_file_ID');
%end
%if exist('summary_data_file_ID') == 1,
%	fclose('summary_data_file_ID');
%end
fclose('all');
close(interface_handle);
clear all;

%pause(1);

%waitfor(data_handle,'String');
%DATA_VALUE_STORED = get(data_handle,'String');

%while quit == 0,
%	pause(0.01);
%end
%while strncmp(DATA_VALUE_STORED,'quit')~=1),
%	pause(0.1);
%end
