function y = tickaxis(duration,spacing);

% Compute an array of equally spaced values given a spacing constant
%
% USAGE: y = tickaxis(duration,spacing);
%
% add 'lin' vs 'log' choice

n = round(duration/spacing);
n = duration/spacing

y = linspace(0,duration,n);
