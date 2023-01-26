function samples = t2s(time,fs);

% converts time (in ms) to samples given fs.
%
% USAGE: samples = t2s(time,fs);

%time = samples/(fs/1000);
samples = time*(fs/1000);
