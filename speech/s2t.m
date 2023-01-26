function time = s2t(samples,fs);

% converts samples to time in ms given fs.
%
% USAGE: time = s2t(samples,fs);

time = samples/(fs/1000);
