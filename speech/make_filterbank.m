function [cf,bandwidth,edges] = make_filterbank(Fs,numChannels,lowfreq,output_type,b);

## Compute an N-channel filterbank 
## USAGE [cf,bandwidth,edges] = make_filterbank(Fs,numChannels,lowfreq,output_type);
## BECAREFULL: Pb with bandwidth (computed with gammatone fb, bw larger, not actual bw in implementation. Change computation for output of bw, cf and edges.
##
## Fs and lowfreq:	are in Hz
## output:		may be in Hz or in normalized coordinates (nyquist's freq = 1)
##
## output_type = 'h...(ertz)' vs. 'n...(ormalized)'


if nargin < 2,
	error('Type help bank_split to get USAGE');
end

if nargin < 3 || isempty(lowfreq), lowfreq = 100; end
if nargin < 4 || isempty(output_type), output_type = 'h'; end

## Change the following parameters if you wish to use a different
## ERB scale.
EarQ = 9.26449;               ##  Glasberg and Moore Parameters
##EarQ = 1/0.107939;
minBW = 24.7;
order = 1;

## b = constant
if nargin < 5, b = 1.019; end; ## default by Patterson and Holdworth 

## All of the following expressions are derived in Apple TR #35, An
## Efficient Implementation of the Patterson-Holdsworth Cochlear
## Filter Bank.

cf = -(EarQ*minBW)+exp((1:numChannels)'*(-log(Fs/2 + EarQ*minBW) + ...
	log(lowfreq + EarQ*minBW))/numChannels)*(Fs/2 + EarQ*minBW);

ERBwidth = ((cf/EarQ).^order + minBW^order).^(1/order);
bandwidth=b*2*pi*ERBwidth;

cf = flipud(cf);
bandwidth = flipud(bandwidth);

##square_bandwidth = 

edges = zeros(numChannels,2); ## passband edges for each filter band
		##transitions = zeros(1,4); ## passband transitions for each filter band
cutoffs = zeros(numChannels,4); ## passband cutoffs for each filter band
		##edges_band = zeros(numChannels,2);

##change the way it computes edges : 
for i = 1:numChannels,
	if i == 1,
		edges(i,1) = bandwidth(i)/3;
		edges(i,2) = (cf(i+1)+cf(i))/2;
	else
		edges(i,1) = edges(i-1,2);
		edges(i,2) = cf(i)+(cf(i)-edges(i-1,2));
##		edges(i,2) = Fs/2;
	end
end
##for i = 1:numChannels,
##	if i == 1,
##		edges(i,1) = bandwidth(i)/3;
##		edges(i,2) = (cf(i+1)+cf(i))/2;
##	elseif i == numChannels,
##		edges(i,1) = (cf(i-1)+cf(i))/2;
##		edges(i,2) = cf(i)+bandwidth(i)/4;
##		edges(i,2) = Fs/2;
##	else
##		edges(i,1) = (cf(i-1)+cf(i))/2;
##		edges(i,2) = (cf(i+1)+cf(i))/2;
##	end
##end

if strncmpi('h',output_type,1) == 1,
	edges = edges;
	cf = cf;
elseif strncmpi('n',output_type,1) == 1,
	edges = edges ./ (Fs/2);
	cf = cf ./ (Fs/2);
else
	msg = sprintf('%s\n%s','You must specify the output type for frequencies','Type help make_filterbank to get usage.');
	error(msg);
end

		
##plot(cf,'r+-')
##hold on
##grid on
##plot(cf-(bandwidth./3),'g+-')
##plot(cf-(bandwidth./3),'b+-')
##plot(cf+(bandwidth./3),'b+-')

##plot(edges,'+-');
##set(gca,'Yscale','log');
