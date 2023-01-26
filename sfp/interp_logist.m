function [X_fit,Y_fit] = interp_sigmoid(x,y);

% Sigmoidal interpolation from [x] and [y] coordinates
%
% Plots a graph with the original points along with the estimated
% psychometric function.
%
% USAGE : [X,Y] = interp_sigmoid(x,y);
%
% Example :
% x = [1 2 3 4 5 6 7 8]';
% y = [93 95 93 90 45 10 3 5]';
% [X,Y] = interp_sigmoid(x,y);

%x = [1 2 3 4 5 6 7 8]';
%y = [93 95 93 90 45 10 3 5]';

%Y_fit = [fonction ne mentionnant pas les inconnues];
%Y_fit = [ ones(size(x)) 1 - ( p_random * exp ( - ((x/alpha).^beta) ));

Y_fit = [ones(size(x)) 1-(exp(-((x/5).^9)))];
coeff = Y_fit\y;
X_fit = (min(x)-1:(max(x)-min(x))/1000:max(x)+1)';

%Y_fit = [meme formulation]*coeff;
Y_fit = [ones(size(X_fit)) 1-(exp(-((X_fit/5).^9)))]*coeff;

% tracé
figure;
%plot(x,y,'w+',X_fit,Y_fit,'k');
plot(X_fit,Y_fit,'k');
%grid on;
options = get(gcf,'Children');
set(options,'YGrid','on');
set(options,'XLim',[0 8],'XTick',0:8,'XTickLabel',str2mat('type',...
   '','','','','','','','dype'),...
   'YLim',[0 100],'YTick',0:10:100,'YColor',[0 0 0]);

% polynomial interpolation
%[coeff,err] = polyfit(x,y,poly_order);
%X_fit = min(x)-1:(max(x)-min(x))/1000:max(x)+1;
%Y_fit = polyval(coeff,X_fit);

% Autre méthode (plus générale)
%X_fit = [ones(size(x)) x x.^2 x.^3];
%coeff = X_fit\y;

