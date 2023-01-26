function y = zeroends(x,fs);

% Apply an amplitude window to a signal.
%
% USAGE y = zeroends(x,fs);

d = size(x);
if d(2) > d(1)
    x = x';
end

[size_matrix nb_bands] = size(x); % OK if sound vector is vertical
    

t = (0:1/fs:1)';
w = sin(2*pi*0.5*t);
w = resample(w,1,8);

if mod(length(w),2) ~= 0,
	w = w(1:length(w)-1);
end

l = [w(1:length(w)/2);ones(length(x)-length(w),1);w(((length(w)/2)+1):length(w))];
l = repmat(l,1,nb_bands);

%plot(l);
y = l.*x;										% apply the window to the signal

