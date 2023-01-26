function y = wav_norm(file);

% Normalizes RMS so that it would conform to WAV specification (stupid ones!!!). 

%[x,Fs] = wavload(filename);
y = normalize(x,.02,'rms');
%wavwrite(y,Fs,filename);
