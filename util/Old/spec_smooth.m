function data = spec_smooth(wav,array,segsize,nlap,ntrans);

if nargin < 5; ntrans=4; end
if nargin < 4; nlap=8; end
if nargin < 3; segsize=128; end

s = length(wave);
nsegs = floor(s/(segsize/nlap))-nlap+1;

for i=1:nsegs    % smooth the spectral slices
 array(:,i) = filter([.2 1 .2],[1],array(:,i));
end

for i=1:ntrans/2*segsize    % smooth the channels
 array(i,:) = filter([.2 1 .2],[1],array(i,:));
end

% compress with square root of amplitude (fourth root of power)
off = 0.0001*max(max(array));      	% low end stabilization offset,
array = (off+array).^0.25-off^0.25; 	% better than a threshold hack!
array = 255 / max(max(array))*array;

function [array,raw] = spectrogram(wave,segsize,nlap,ntrans);
%function array = spectrogram(wave,segsize,nlap,ntrans);
% defaults spectrogram(wave,128,8,4)
% nlap is number of hamming windows overlapping a point;
% ntrans is factor by which transform is bigger than segment;
% returns a spectrogram 'array' with fourth root of power,
% filter smoothed and formatted for display.

% Added option to return raw spectrogram.... Malcolm 5/26/95
% Added code so that input could be any direction ... Malcolm 5/26/95
% (c) 1998 Interval Research Corporation  

