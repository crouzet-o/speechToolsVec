function [processed, unprocessed, bands, carrier, env, cf, bandwidth, edges] = bandvocoder(x, fs, NbBands, FilterType, VocoderType, lowestcf, lpcutoff, filterorder, fftwindow, hffslope);

  % Speech-modulated noise or sinewave in N bands (a la
  % Shannon). This program transforms an audio recording into Script
  % de transformation d'un signal acoustique naturel en signal
  % simulant le type d'information transmise par un implant
  % cochléaire (N bandes spectrales).
  %
  % USAGE:
  %
  % [processed,unprocessed,bands,env,cf,bandwidth,edges] =
  %       bandvocoder(x,fs,NbBands,FilterType,VocoderType,lowestcf,lpcutoff,filterorder,fftwindow,hffslope);
  %
  % EXAMPLE:
  %
  % [processed,unprocessed,bands,env,cf,bandwidth,edges] =
  %       bandvocoder(x,fs,6, "fir", "lpnoise", 100, 128, filterorder, fftwindow, hffslope);
  %
  % signal: a 1-dimensional sound matrix (vector)
  %
  % fs: sampling frequency
  %
  % Nb_bands: number of vocoding bands (default: 4)
  %
  % FilterType: 'FIR' (default) vs. 'IIR' (only FIR works as for now)
  %
  % VocoderType: 'schroeder' (default) vs. 'lpnoise' vs. 'lpsin'
  % (both use a Hilbert transform, you need to define a frequency
  % cutoff for the Low-Pass envelope filter).
  %
  % - 'schroeder': each sample is randomly multiplied by 1 or -1
  % (each sample is then either kept as is or inversed on a random
  % basis);
  %
  % - 'lpnoise': carrier and envelope are extracted through a Hilbert
  % transform. The envelope is low-pass filtered. A broadband noise
  % is synthesized and modulated by the filtered envelope.
  %
  % - 'lpsin' : carrier and envelope are extracted through a Hilbert
  % tranform. The envelope is low-pass filtered. A sinewave is
  % synthesized and modulated by the filtered envelope.
  %
  %
  % lpcutoff: Frequency cutoff for envelope extraction through the
  % Hilbert transform.
  %
  % hffslope: Expected filterslope (in dB/octave) non-functionnal TODO
  % Should be a vector of slopes for each band, should be derived to
  % a vector / matrix of filter orders
  %
  % FilterOrder ?? ou dans bank_split.m ?
  %
  % lowestcf: Lowest center frequency (in Hz) for the filterbank.
  %
  % TODO: Create a function find_banksplit_order.m which will search
  % for the adequate filter order depending on both filter type and
  % expected (minimum) filter slope (should be based on testFIR.m.

  if (nargin < 2),
    error('Type help bandvocoder to get USAGE');
  end
  
  if exist('NbBands') == 0
    NbBands = 4;
  endif
  
  if exist('FilterType') == 0
    FilterType = 'fir';
  endif

  if exist('VocoderType') == 0
    VocoderType = 'schroeder';
  endif

  if exist('lpcutoff') == 0
    lpcutoff = 256;
  endif

  if exist('hffslope') == 0
    hffslope = -3;
  endif

  if exist('filterorder') == 0
    filterorder = 7000;
  endif
  
  if exist('lowestcf') == 0
    lowestcf = 100;
  endif

  %   switch lower(bank_type),
  %     case {'gt','gammatone','gamma'}
  %       bank_type = 'gt';
  %     case {'fir','finite'}
  %       bank_type = 'fir';
  %     otherwise
  %       error('type: help noisevocoder');
  %   endswitch

fftwindow = 'hamming';
%fftwindow = 'gaussian';


% I don't understand what I wanted to do here...
%NbBands
%max(size(NbBands))
%if (max(size(NbBands)) > 1),
%  print("more than 1 channel");
%  % if there are more than 1 channel to be processed
%  [signal, recombined, cf, bandwidth, edges] = bank_split(x, fs, NbBands, FilterType, lowestcf, filterorder, fftwindow); % y = length(y)*
%else,

%if (NbBands > 1)
% hffslope / order 100 / 1000 / 7000 contribution plus grande des
% hautes fréquences ?
[signal, recombined, cf, bandwidth, edges] = bank_split(x, fs, NbBands, FilterType, lowestcf, filterorder, fftwindow); % y = length(y)*
  % Nb_bands (Nb_bands columns)e
%else
%  signal = x;	% y = length(y)* Nb_bands (Nb_bands columns)
%end;
%end;
signal_out = zeros(length(signal), NbBands); % NbBands matrix for signal
signal_tmp = zeros(length(signal), NbBands);
carrier = zeros(length(signal), NbBands); % NbBands matrix for enveloppe modulated noise

% Processing with frequency content manipulation.

if (NbBands > 1),
  for j = 1:NbBands,
    % Processing of individual frequency channels.
    coeffs = fir1(100, edges(j,:)); % bandpass filtering
    
					  %Insertion du bruit, refiltrage et
					  %normalization
    env(:,j) = env_extract(signal(:,j), fs, lpcutoff);
    switch lower(VocoderType),
	case {'lpnoise'}
	  carrier(:,j) = addnoise(signal(:,j), fs, 'cont', 'n');
	  signal_out(:,j) = env(:,j).*carrier(:,j);
	  signal_out(:,j) = normalize(signal_out(:,j), signal(:,j), 'rms');

	case {'lpsin'} % Tester avec un son complexe périodique
	  % (suffisamment d'harmoniques pour stimuler un ensemble
	  % important de zones de la cochlée (comme avec un bruit).
	  %cf(j) * fs;
	  %edges(j,:) * fs
	  %bandwidth(j)
	  carrier(:,j) = synth_sin(cf(j) * fs, rms(signal(:,j)), s2t(length(signal(:,j)), fs), fs);
	  startfreq = edges(1,1) * fs;
	  harm = synth_complex(startfreq, rms(signal(:,j)), s2t(length(signal(:,j)), fs) * 1000, fs);
	  size(harm);
	  size(signal);
	  size(carrier);
	  fs;
	  carrier(:,j) = synth_complex(startfreq, rms(signal(:,j)), s2t(length(signal(:,j)), fs), fs);

	  taille1 = size(carrier(:,j), 1);
	  taille2 = size(signal(:,j), 1);
	  taille = max(taille1, taille2);
	  if (taille1 < taille2),
	    carrier(:,j) = [carrier(:,j) ; zeros(taille2-taille1, 1)];
	  else
	    carrier(:,j) = carrier(1:taille2, j);
	  end
	  signal_out(:,j) = env(:,j).*carrier(:,j);
	  signal_out(:,j) = normalize(signal_out(:,j), signal(:,j), 'rms');

	case {'schroeder'}
	  env(:,j) = zeros(length(signal(:,j)), 1);
	  carrier(:,j) = addnoise(signal(:,j),fs,'shap','n');
	  signal_out(:,j) = carrier(:,j);
	otherwise
	  env(:,j) = zeros(length(signal(:,j)), 1);
	  carrier(:,j) = addnoise(signal(:,j),fs,'shap','n');
	  signal_out(:,j) = carrier(:,j);
    endswitch
    
    signal_out(:,j) = filtfilt(coeffs,1,signal_out(:,j));
    
    signal_out(:,j) = normalize(signal_out(:,j),rms(signal(:,j)),'rms');
					  %end
    bands = signal_out;
    
    processed = sum(signal_out(:,:),2);
					  %    processed = normalize(processed,rms(signal));
					  %    processed = wav_norm(processed);
    
    %save_to_file = [filename,'_',num2str(NbBands),'_',num2str(j)];
    end
  else
    env(:,1) = env_extract(signal(:,1),fs,lpcutoff);
    switch lower(VocoderType),

	case {'lpnoise'}
	  carrier(:,1) = addnoise(signal(:,1),fs,'cont','n');
	  signal_out(:,1) = env(:,1).*carrier(:,1);
	  signal_out(:,1) = normalize(signal_out(:,1),signal(:,1),'rms');

	case {'lpsin'}
	  carrier(:,1) = synth_sin(cf(1) * fs, rms(signal(:,1)), s2t(length(signal(:,1)), fs), fs);
	  taille1 = size(carrier(:,1), 1);
	  taille2 = size(signal(:,1), 1);
	  taille = max(taille1, taille2);
	  if (taille1 < taille2),
	    carrier(:,1) = [carrier(:,1) ; zeros(taille2-taille1, 1)];
	  else 
	    carrier(:,1) = carrier(1:taille2, 1);
	  end
	  signal_out(:,1) = env(:,1).*carrier(:,1);
	  signal_out(:,1) = normalize(signal_out(:,1), signal(:,1), 'rms');

	case {'schroeder'}
	  carrier(:,1) = addnoise(signal(:,1),fs,'shap','n');
	  signal_out(:,j) = carrier(:,j);

	otherwise
	  carrier(:,1) = addnoise(signal(:,1),fs,'shap','n');
	  signal_out(:,j) = carrier(:,j);
    endswitch

    signal_out = normalize(signal_out,rms(signal),'rms');
					  %end
    bands = signal_out;

    processed = signal_out;
end

unprocessed = x;

% Original ayant subi le même type de filtrage mais dont les
% composantes fréquentielles sont intactes.
    
  
%   for j = 1:NbBands,
%     % Processing of individual frequency channels.
%     coeffs = fir1(100, edges); % bandpass filtering
    
% 					  %Insertion du bruit, refiltrage et normalization
%     carrier(:,j) = signal(:,j);
%     carrier(:,j) = filtfilt(coeffs,1,carrier(:,j));
    
%     signal_out(:,j) = normalize(carrier(:,j),rms(signal(:,j)));
% 					  %end
    
%     processed = sum(signal_out(:,:),2);
% 					  %    processed = normalize(processed,rms(signal));
% 					  %    processed = wav_norm(processed);
%     save_to_file = [filename,'_',num2str(NbBands),'_',num2str(j)];
%   end
  
  %save_to_file_whole = [filename,'_',num2str(NbBands),'_original_all'];
  %wavwrite(oriout,fs,save_to_file_whole);
  
  
endfunction

