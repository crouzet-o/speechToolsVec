function signal = display_sound(filename,Fs);

% Script pour créer images de l'enveloppe et un spectro directement à partir d'un fichier
% wav ou sig (PCM raw data).


if ~isempty(findstr(filename,'.sig')),
	[signal,Fs] = loadsig(filename,Fs);
elseif ~isempty(findstr(filename,'.wav')),
	[signal,Fs] = wavload(filename);
else error('Please type filename extension');
end

duree=length(signal);
t=1:duree;

% Insérer légendes
figure;
subplot(2,1,1);
hold on;
maximum = max(abs(signal));
plot(t/Fs,signal,'k');
%temp = axis;

graph1 = get(gca,'Children');
%set(graph1,'Yscale','');
%set(graph1,'Ygrid','on');
%set(graph1,'XLim',[0 5],'XTick',1:4,'XTickLabel',str2mat('occl.-liq.',...
%   'fric.-liq.','nas.-liq.','occl.-occl.'),...
%   'YLim',[25 100],'YTick',30:10:100);

axis([0 duree/Fs -(maximum+.05) maximum+.05]);
title('');
xlabel('Temps (s)');
ylabel('Intensité');

%figure;
subplot(2,1,2);
hold on;
spectrogram(signal,Fs);
axis([0 duree/Fs 0 Fs/2]);
   
graph2 = get(gca,'Children');
%set(graph2,'Yscale','');
%set(graph2,'Ygrid','on');
%set(graph2,'XLim',[0 5],'XTick',1:4,'XTickLabel',str2mat('occl.-liq.',...
%   'fric.-liq.','nas.-liq.','occl.-occl.'),...
%   'YLim',[25 100],'YTick',30:10:100);

title('');
xlabel('Temps (s)');
ylabel('Fréquence (Hz)');
