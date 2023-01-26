function t = tdist(df,proba);

% Compute Student t statistic from df and probability (Non-functional)
% Needs to compute the inverse probability distribution function (not available)

%   Voir:
%      [1]  E. Kreyszig, "Introductory Mathematical Statistics",
%      John Wiley, New York, 1970, Section 10.3, pages 144-146.

i = -5:.01:5;
pdf = zeros(size(i));
cdf = zeros(size(i));

pdf = abs(tpdf(i,df));
plot(i,pdf);

%cdf = abs(qt(proba,df));
%hold on;
%plot(i,cdf);

if exist('proba','var')==1,
	hold on;
	value = abs(qt(proba,df));
	label = texlabel(num2str(value));
	stem(abs(qt(proba,df)),proba,'r.');
	text(abs(qt(proba,df)),value,label);
end

%x = texlabel('lambda12^(3/2)/pi - pi*delta^(2/3)')