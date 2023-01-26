function y = data2img(xaxis,yaxis,xtext,ytext,title,xscale,yscale);

% Generate graph from data

%set(0,'DefaultAxesColorOrder',[0 0 0],...
%   'DefaultAxesLineStyleOrder',[-|:|--|-:]);

clf

subplot(1,1,1);
hold on;
bar([1 2 3 4],[81 40 37 31],.5,'w');
plot([1 2 3 4],[81 40 37 31],'k');
errorbar([1 2 3 4],[81 40 37 31],[20 13 12 10],[20 13 12 10],'.k');
barres = get(gca,'Children')
set(gca,'Yscale','log');
set(gca,'Ygrid','on');

%set(barres,'FaceColor',[.7 .7 .9]);
%set(barres,'CData',rayures,'FaceColor','texturemap');

set(gca,'XLim',[0 5],'XTick',1:4,'XTickLabel',str2mat('occl.-liq.',...
   'fric.-liq.','nas.-liq.','occl.-occl.'),...
   'YLim',[25 100],'YTick',30:10:100);
title('Fréquence des groupes de consonnes');
xlabel('Type de cluster');
ylabel('Fréquence');









%subplot(2,1,1)

%plot([1 2],[486 521],[1 2],[486 521],'o')
%hold on
%plot([1 2],[530 492],[1 2],[530 492],'o')

%set(gca,'XLim',[0 3.5],'XTick',1:2,'YLim',[470 540],...
%        'XTickLabel',str2mat('CV','CVC'),...
%        'YTick',480:10:530)

%text(2.1,521,'mots CV');
%text(2.1,492,'mots CVC');

%title('mots français');
%xlabel('cibles');
%ylabel('temps de réaction (ms)');

%subplot(3,3,2)

%plot([1 2],[600 598],[1 2],[600 595],'o');
%hold on
%plot([1 2],[551 540],[1 2],[551 540],'o');

%set(gca,'XLim',[0 3.5],'XTick',1:2,'YLim',[450 650],...
%        'XTickLabel',str2mat('CV','CVC'),...
%        'YTick',500:50:650);

%text(2.1,595,'mots CVC');
%text(2.1,540,'mots CV');

%title('mots anglais');
%xlabel('cibles');
%ylabel('temps de réaction (ms)');