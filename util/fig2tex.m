function filename = fig2tex(gcf,filename,width,factor,caption);

% Print a fig to EPS and LaTeX for use with PSFRAG
%
% USAGE: fig2tex(gcf,filename,width,factor,caption);
%
% REQUIRES: print2latex.m


% function filename = fig2tex(gcf,target_width,filename);

%print2latex(gcf,filename,'width=12','factor=0.8','noextrapicture','caption=Filterbank');
%print2latex(gcf,'fig3','width=12','factor=0.8','noextrapicture','caption=filterbank');

width_str = sprintf('%s%s','width=',num2str(width));
factor_str = sprintf('%s%s','factor=',num2str(factor));
caption_str = sprintf('%s%s','caption=',caption);


%eval(print2latex(gcf,filename,'width=10','factor=0.8','caption=desynchrony'));
print2latex(gcf,filename,width_str,factor_str,caption_str);
