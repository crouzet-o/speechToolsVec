function y = print2gray(figurehandle,filename);

% Prints a figure window to a grayscale JPEG image (8-bit);
%
% Type gcf; to get figurehandle

figure(figurehandle);
print('-djpeg90','-r0', filename); % JPEG 90% compression, screen resolution
y = imread(filename,'JPEG');
y = rgb2gray(y);
imwrite(y, filename, 'JPEG');
