function [t,f,array,raw] = spectrogram(wave,Fs,segsize,nlap,ntrans);

% function array = spectrogram(wave,Fs,segsize,nlap,ntrans);
% Function adapted (by Olivier Crouzet, 1999) from the Auditory toolbox in order to
% represent time and frequency along the x and y axes (not implemented in the ATbx).
%
% defaults spectrogram(wave,Fs,128,8,4)
% segsize = number of frequency bands
% nlap is number of hamming windows overlapping a point; (overlap)
% ntrans is factor by which transform is bigger than segment;
% returns a spectrogram 'array' with fourth root of power,
% filter smoothed and formatted for display.
% USAGE : 	[t,f,array] = spectrogram(signal,Fs);
% 				imagesc(t,f,array); colormap(ones(256,3)-gray(256)); axis('xy');


% Added option to return raw spectrogram.... Malcolm 5/26/95
% Added code so that input could be any direction ... Malcolm 5/26/95
% (c) 1998 Interval Research Corporation

if nargin < 5; ntrans=4; end
if nargin < 4; nlap=8; end
if nargin < 3; segsize=128; end

[r c] = size(wave);
if (r < c)
	wave = filter([1 -0.95],[1],wave');
else
	wave = filter([1 -0.95],[1],wave);
end

s = length(wave);
nsegs = floor(s/(segsize/nlap))-nlap+1;
array = zeros(ntrans/2*segsize,nsegs);
window = 0.54-0.46*cos(2*pi/(segsize+1)*(1:segsize)');
for i = 1:nsegs
 seg = zeros(ntrans*segsize,1); % leave half full of zeroes
 seg(1:segsize) = ...
	 window.*wave(((i-1)*segsize/nlap+1):((i+nlap-1)*segsize/nlap));
 seg = abs(fft(seg));
% seg = abs(fft(seg));
						% reverse for image display
 array(:,i) = seg(((ntrans/2*segsize)+1):(ntrans*segsize));
end

if nargout > 1
	raw = array;
end

array = array .* array;			% back into power domain for smoothing

for i=1:nsegs    % smooth the spectral slices
 array(:,i) = filter([.2 1 .2],[1],array(:,i));
end

for i=1:ntrans/2*segsize    % smooth the channels
 array(i,:) = filter([.2 1 .2],[1],array(i,:));
end

%f=(0:fftlen/2)*fs/fftlen;
%winlen = fix(2*Fs/segsize);
%fftlen = max([winlen fftmin]);
%win = [hamming(winlen) ; zeros(fftlen-winlen,1)]; 
%win = win/sum(win);
%windel =  (0:(length(win)-1)) * win;
%t = (r1+windel)/fs;

%Frequency Scale
f=fliplr((0:segsize/2)*Fs/segsize);

%Time Scale
ntime=fix((length(wave)-nlap)/(segsize-nlap));
r1=(0:ntime-1)*(segsize-nlap);
winlen = fix(2*Fs/segsize);
%fftlen = max([winlen fftmin]);
win = [hamming(winlen) ; zeros(nlap-winlen,1)]; 
win = win/sum(win);
windel =  (0:(length(win)-1)) * win;
t = ((r1+windel)/Fs)*1000;

% compress with square root of amplitude (fourth root of power)
off = 0.0001*max(max(array));      	% low end stabilization offset,
array = (off+array).^0.25-off^0.25; 	% better than a threshold hack!
array = 255 / max(max(array))*array;

%[t,f,array] = spectrogram(signal,Fs);
%figure;
imagesc(t,f,array); colormap(ones(256,3)-gray(256)); axis('xy');
xlabel('Time (ms)');
ylabel('Frequency (Hz)');
