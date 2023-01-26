waveform('casquette_1.sig',44100);
axis([0 0.9 -25000 25000]);
axis off;
colormap(gray(256));
print -dbmp256 'sig1';
close;

waveform('casquette_2.sig',44100);
axis([0 0.9 -25000 25000]);
axis off;
colormap(gray(256));
print -dbmp256 'sig2';
close;

waveform('casquette_3.sig',44100);
axis([0 0.9 -25000 25000]);
axis off;
colormap(gray(256));
print -dbmp256 'sig3';
close;

waveform('casquette_4.sig',44100);
axis([0 0.9 -25000 25000]);
axis off;
colormap(gray(256));
print -dbmp256 'sig4';
close;

waveform('casquette_5.sig',44100);
axis([0 0.9 -25000 25000]);
axis off;
colormap(gray(256));
print -dbmp256 'sig5';
close;

waveform('casquette_6.sig',44100);
axis([0 0.9 -25000 25000]);
axis off;
colormap(gray(256));
print -dbmp256 'sig6';
close;

waveform('casquette_7.sig',44100);
axis([0 0.9 -25000 25000]);
axis off;
colormap(gray(256));
print -dbmp256 'sig7';
close;

waveform('casquette_8.sig',44100);
axis([0 0.9 -25000 25000]);
axis off;
colormap(gray(256));
print -dbmp256 'sig8';
close;

waveform('casquette_9.sig',44100);
axis([0 0.9 -25000 25000]);
%axis off;
colormap(gray(256));
print -dbmp256 'sig9';
close;

sig1 = imread('sig1.bmp','BMP');
sig2 = imread('sig2.bmp','BMP');
sig3 = imread('sig3.bmp','BMP');
sig4 = imread('sig4.bmp','BMP');
sig5 = imread('sig5.bmp','BMP');
sig6 = imread('sig6.bmp','BMP');
sig7 = imread('sig7.bmp','BMP');
sig8 = imread('sig8.bmp','BMP');
sig9 = imread('sig9.bmp','BMP');
map = colormap;

final_image = [sig1; sig2; sig3; sig4; sig5; sig6; sig7; sig8; sig9]; % alignement vertical
%final_image = [sig1; sig2; sig3; sig4; sig5; sig6; sig7; sig8; sig9]; % alignement horizontal
image(final_image);
colormap(map);
axis off;
print -djpeg90 'gating_casquette2';
