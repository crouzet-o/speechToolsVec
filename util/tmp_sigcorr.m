function [y,z,r] = tmp_sigcorr(x,window_size);


% temporary work
y = zeros([length(x)+window_size 1]);
z = zeros([length(x)+window_size 1]);
y(window_size+1:length(y)) = x; %moves forward in time
z(1:length(z)-window_size) = x; %moves backward in time

plot(y,z);

% r = corr2(y,z);
