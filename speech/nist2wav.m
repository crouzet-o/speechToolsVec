function y = nist2wav(filename);

y = nist_load(filename);
Fs = 20000;
wavwrite(y,Fs,16,filename);
