function y = nyquist(x);

% Filters the signal x at Nyquist's Frequency.

[b,a] = butter(1,1);
y = filter(b,a,x);
