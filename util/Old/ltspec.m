function [magnitude,frequency] = ltspec(signal,Nb_bands,Fs);

%

[magnitude,frequency] = spectrum(signal,Nb_bands,[],[],Fs);

%Plots SIG_REF's spectrum
figure;
%plot(frequency,magnitude(:,1));
stem(frequency,magnitude(:,1),'k.-');



