function [signal_out,recombined,cf,bandwidth,edges] = bank_split(signal,Fs,numChannels,bank_type,lowfreq);

% Split a wideband input speech signal into N frequency bands.
%
% USAGE : [signal_out,recombined,cf,bandwidth,edges] =
%					bank_split(signal,Fs,numChannels,bank_type);
%
% band 1 = low frequency, band N = high frequency

if nargin < 3,
	error('Type help bank_split to get USAGE');
end

if exist('lowfreq') == 0,
	lowfreq = 100;
end

if exist('bank_type') == 0,
	bank_type = 'gt';
end

[cf,bandwidth,edges] = make_filterbank(Fs,numChannels,lowfreq,'norm');

if strcmpi(bank_type,'fir')==1,

	a = 1;											% 2nd argument of filtfilt.m
	signal_out = zeros(length(signal),numChannels);	% numChannels matrix for signal

	for j = 1:numChannels,
		Order = 300;
		Wn = edges(j,:);
		b = fir1(Order,Wn);
		signal_out(:,j) = filtfilt(b,a,signal);
	end

%signal_out = signal_out';

elseif strcmpi(bank_type,'gt')==1,

	fcoefs = MakeERBFilters(Fs,numChannels,lowfreq);
	fcoefs=flipud(fcoefs);								%reverses the filterbanks' order (1 = low freq and not high freq)
	signal_out = ERBFilterBank(signal,fcoefs);

signal_out = signal_out';

else error('gt or fir');

end

recombined = sum(signal_out(:,:),2);
