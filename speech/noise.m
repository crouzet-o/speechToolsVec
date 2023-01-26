function y = noise(filename,shape,snorn);

% Script implementing the rms_noise function

[x,Fs] = wavload(filename_ext);
y = rms_noise(x,shape,snorn,0);
%f = filesep;
create_dir('noise');
save_to_file = ['noise\',filename,'_noise.wav']
y = wav_norm(y);
wavwrite(y,Fs,save_to_file);
