function signal = waveform(signal,Fs);

% Displays the waveform of a matrix.
%
% USAGE: waveform(matrix,Fs);
% EXAMPLE: waveform(y,44100);
%
% Fs defaults to 16000. '.sig' is the default extension.

if nargin<1,
	error('WAVEFORM takes at least one argument. Type help waveform');
end

if exist('Fs')==0,
	Fs=16000;
end

duree=length(signal);
maximum = max(abs(signal));
t=1:duree;
%figure;
plot(t/Fs,signal,'k');

graph1 = get(gca,'Children');
%set(graph1,'Yscale','');
%set(graph1,'Ygrid','on');
%set(graph1,'XLim',[0 5],'XTick',1:4,'XTickLabel',str2mat('occl.-liq.',...
%   'fric.-liq.','nas.-liq.','occl.-occl.'),...
%   'YLim',[25 100],'YTick',30:10:100);

axis([0 duree/Fs -(maximum+.05) maximum+.05]);
%axis([0 duree/Fs -(maximum+.05) maximum+.05]);
title('');
xlabel('Time (s)');
ylabel('Amplitude');
