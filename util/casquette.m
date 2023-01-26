for i = 1 : 9,
   sound_file = sprintf('%s%d%s','casquette_',i,'.sig');
   image_file = sprintf('%s%d%s','images\sig',i,'.jpg');
   waveform(sound_file,44100);
	axis([0 0.9 -25000 25000]);
   if i < 9,
      axis off;
   else
      set(gca,'YColor',[1 1 1]);
   end
   figurehandle = gcf;
	print2gray(figurehandle,image_file);
   close;
end

sig1 = imread('images\sig1.jpg','JPEG');
sig2 = imread('images\sig2.jpg','JPEG');
sig3 = imread('images\sig3.jpg','JPEG');
sig4 = imread('images\sig4.jpg','JPEG');
sig5 = imread('images\sig5.jpg','JPEG');
sig6 = imread('images\sig6.jpg','JPEG');
sig7 = imread('images\sig7.jpg','JPEG');
sig8 = imread('images\sig8.jpg','JPEG');
sig9 = imread('images\sig9.jpg','JPEG');

final_image = [sig1 ; sig2 ; sig3 ; sig4 ; sig5 ; sig6 ; sig7 ; sig8 ; sig9 ];
imwrite(final_image,'casquette_gating.jpg','JPEG');
%temp_new = imread(image_file,'JPEG');
%   temp_new = double(temp_new);
%   if i == 1,
%      disp(i);
%      temp = temp_new;
%   else
%      disp(size(temp_new));
%      temp = vertcat(temp,temp_new);
%   end
%end

%imwrite(temp,'gating_casquette.jpg','JPEG');

%temp = imread('images\sig1.jpg','JPEG');
%size_image = size(temp);
%sig = uint8(zeros([size_image(1) size_image(2) 9]));

%   sig(:,:,i) = imread(image_file,'JPEG');

%final_image = vertcat(sig(:,:,1),sig
%sum(sig(:,:,:),3);
%imwrite(final_image, 'gating_casquette.jpg', 'JPEG');
