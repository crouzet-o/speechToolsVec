% Synthese de sinusoides et combinaison pour creer un son complexe

clear all;
%nb_signals = input('Nombre de signaux a synthetiser : ','nb_sig');

%for i = 1:nb_sig,
%   amp(i) = input('Intensite du signal : ');
%   freq(i) = input('Frequence du signal : ');
%end

Fs = 16000;
t = (0:1/Fs:1);

%for i = 1:nb_sig,
%   sig(i) = amp(i)*sin(2*pi*freq(i)*t) 
%end

%%%%%%%%%%%%%%%%%%%%%% Synthèse des signaux et normalisation amplitude
x = .5*sin(2*pi*400*t);
y = .5*sin(2*pi*600*t);
z = .5*sin(2*pi*1500*t);

signal_temp = x + y + z;
clipper = max(signal_temp) + 0.001;
signali_temp = signal_temp ./ clipper; % Normalize final signal (for RIFF wav files)
signal = normalize(signal_temp,rms(x));

%rms_signal = rms(signal);
%x = normalize(x,rms_signal);
%y = normalize(y,rms_signal);
%z = normalize(z,rms_signal);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Signal #1
wavwrite(x,Fs,'sin400');

figure; %Spectre a long terme
lts1 = gcf;
[Mx,Fx] = spectrum(x,2048,[],[],Fs);
stem(Fx,Mx(:,1),'.k');
axis([0 8000 0 250]);
title('Son sinusoïdal : 400 Hz');
xlabel('Frequence (Hz)');
ylabel('Amplitude (ou Intensité)');
%colormap('gray');
print -dtiff lts400;

%figure; %Spectrogramme
spectro1 = gcf;
spectro1_axes = gca;
[Tx,Fx,Bx] = spectrogram(x,Fs,2048);
imagesc(Tx,Fx,Bx); colormap(ones(256,3)-gray(256));
axis('xy');
%axis([0 0.4 0 22050]);
%set(spectro1_axes,'YTickLabel',[0 5000 10000 15000 20000]);
%set(spectro1_axes,'XTickLabel',[0 200 400 600 800]);
title('Son sinusoïdal : 400 Hz');
xlabel('Temps (ms)');
ylabel('Frequence (Hz)');
%colormap('gray');
print -dtiff spec400;

figure; %Enveloppe
env1 = gcf;
plot(t,x,'-k','LineWidth',1.5);
%plot(t,x);
axis([0 .01 -2 2]);
title('Son sinusoïdal : 400 Hz');
xlabel('Temps (ms)');
ylabel('Amplitude (ou Intensité)');
%colormap('gray');
print -dtiff env_sin400;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Signal #2
wavwrite(y,Fs,'sin600');

figure; %Spectre a long terme
lts2 = gcf;
[My,Fy] = spectrum(y,2048,[],[],Fs);
stem(Fy,My(:,1),'.k');
axis([0 8000 0 250]);
title('Son sinusoïdal : 600 Hz');
xlabel('Frequence (Hz)');
ylabel('Amplitude (ou Intensité)');
%colormap('gray');
print -dtiff lts600;

%figure; %Spectrogramme
spectro2 = gcf;
spectro2_axes = gca;
[Ty,Fy,By] = spectrogram(y,Fs,2048);
imagesc(Ty,Fy,By); colormap(ones(256,3)-gray(256));
axis('xy');
%axis([0 2000 0 600]);
%set(spectro2_axes,'YTickLabel',[0 5000 10000 15000 20000]);
set(spectro2_axes,'XTickLabel',[0 200 400 600 800]);
title('Son sinusoïdal : 600 Hz');
xlabel('Temps (ms)');
ylabel('Frequence (Hz)');
%colormap('gray');
print -dtiff spec600;

figure; %Enveloppe
env2 = gcf;
plot(t,y,'-k','LineWidth',1.5);
axis([0 .01 -2 2]);
title('Son sinusoïdal : 600 Hz');
xlabel('Temps (ms)');
ylabel('Amplitude (ou Intensité)');
%colormap('gray');
print -dtiff env_sin600;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Signal #3
wavwrite(z,Fs,'sin1500');

figure; %Spectre a long terme
lts3 = gcf;
[Mz,Fz] = spectrum(z,2048,[],[],Fs);
stem(Fz,Mz(:,1),'.k');
axis([0 8000 0 250]);
title('Son sinusoïdal : 1500 Hz');
xlabel('Frequence (Hz)');
ylabel('Amplitude (ou Intensité)');
%colormap('gray');
print -dtiff lts1500;

%figure; %Spectrogramme
spectro3 = gcf;
spectro3_axes = gca;
[Tz,Fz,Bz] = spectrogram(z,Fs,2048);
imagesc(Tz,Fz,Bz); colormap(ones(256,3)-gray(256));
axis('xy');
%axis([0 2000 0 600]);
%set(spectro3_axes,'YTickLabel',[0 5000 10000 15000 20000]);
set(spectro3_axes,'XTickLabel',[0 200 400 600 800]);
title('Son sinusoïdal : 1500 Hz');
xlabel('Temps (ms)');
ylabel('Frequence (Hz)');
%colormap('gray');
print -dtiff spec1500;

figure; %Enveloppe
env3 = gcf;
plot(t,z,'-k','LineWidth',1.5);
axis([0 .01 -2 2]);
title('Son sinusoïdal : 1500 Hz');
xlabel('Temps (ms)');
ylabel('Amplitude (ou Intensité)');
colormap('gray');
print -dtiff env_sin1500;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Signal final
%signal_temp = x + y + z;
%clipper = max(signal_temp) + 1;
%signal = signal_temp ./ clipper;
%signal = normalize(signal_temp,1);
wavwrite(signal,Fs,'complex');

sig1 = x + y;
sig2 = y + z;

% signal (A + B + C)
figure; %Spectre a long terme
lts4 = gcf;
[Mcomplex,Fcomplex] = spectrum(signal,2048,[],[],Fs);
stem(Fcomplex,Mcomplex(:,1),'.k');
axis([0 2000 0 50]);
set(lts4,'Name','Son complexe périodique généré par combinaison des 3 sinusoïdes');
title('Son complexe périodique généré par combinaison des 3 sinusoïdes');
xlabel('Frequence (Hz)');
ylabel('Amplitude (ou Intensité)');
%colormap('gray');
print -dtiff lts_abc;

figure; %Spectrogramme
spectro4= gcf;
spectro4_axes= gca;
[Tcomplex,Fcomplex,Bcomplex] = spectrogram(signal,Fs,2048);
imagesc(Tcomplex,Fcomplex,Bcomplex); colormap(ones(256,3)-gray(256));
axis('xy');
%axis([0 2000 0 600]);
%set(spectro4_axes,'YTickLabel',[0 5000 10000 15000 20000]);
set(spectro4_axes,'XTickLabel',[0 200 400 600 800]);
title('Son complexe périodique généré par combinaison des 3 sinusoïdes');
xlabel('Temps (ms)');
ylabel('Frequence (Hz)');
%colormap('gray');
print -dtiff spec_abc;

figure; %Enveloppe
env4 = gcf;
plot(t,signal,'-k','LineWidth',1.5);
axis([0 .01 -2 2]);
title('Son complexe périodique généré par combinaison des 3 sinusoïdes');
xlabel('Temps (ms)');
ylabel('Amplitude (ou Intensité)');
%colormap('gray');
print -dtiff env_abc;
%fclose all;

figure; %Spectre a long terme
lts4 = gcf;
[Mcomplex,Fcomplex] = spectrum(signal,2048,[],[],Fs);
stem(Fcomplex,Mcomplex(:,1),'.k');
axis([0 2000 0 50]);
set(lts4,'Name','Son complexe périodique généré par combinaison des 3 sinusoïdes');
title('Son complexe périodique généré par combinaison des 2 sinusoïdes (A et B)');
xlabel('Frequence (Hz)');
ylabel('Amplitude (ou Intensité)');
%colormap('gray');
print -dtiff lts_ab;

figure; %Spectrogramme
spectro4= gcf;
spectro4_axes= gca;
[Tcomplex,Fcomplex,Bcomplex] = spectrogram(signal,Fs,2048);
imagesc(Tcomplex,Fcomplex,Bcomplex); colormap(ones(256,3)-gray(256));
axis('xy');
%axis([0 2000 0 600]);
%set(spectro4_axes,'YTickLabel',[0 5000 10000 15000 20000]);
set(spectro4_axes,'XTickLabel',[0 200 400 600 800]);
title('Son complexe périodique généré par combinaison des 2 sinusoïdes (A et B)');
xlabel('Temps (ms)');
ylabel('Frequence (Hz)');
%colormap('gray');
print -dtiff spec_ab;

figure; %Enveloppe
env4 = gcf;
plot(t,signal,'-k','LineWidth',1.5);
axis([0 .01 -2 2]);
title('Son complexe périodique généré par combinaison des 2 sinusoïdes (A et B)');
xlabel('Temps (ms)');
ylabel('Amplitude (ou Intensité)');
%colormap('gray');
print -dtiff env_ab;
%fclose all;

figure; %Spectre a long terme
lts4 = gcf;
[Mcomplex,Fcomplex] = spectrum(signal,2048,[],[],Fs);
stem(Fcomplex,Mcomplex(:,1),'.k');
axis([0 2000 0 50]);
set(lts4,'Name','Son complexe périodique généré par combinaison des 2 sinusoïdes (B et C)');
title('Son complexe périodique généré par combinaison des 2 sinusoïdes (B et C)');
xlabel('Frequence (Hz)');
ylabel('Amplitude (ou Intensité)');
%colormap('gray');
print -dtiff lts_bc;

figure; %Spectrogramme
spectro4= gcf;
spectro4_axes= gca;
[Tcomplex,Fcomplex,Bcomplex] = spectrogram(signal,Fs,2048);
imagesc(Tcomplex,Fcomplex,Bcomplex); colormap(ones(256,3)-gray(256));
axis('xy');
%axis([0 2000 0 600]);
%set(spectro4_axes,'YTickLabel',[0 5000 10000 15000 20000]);
set(spectro4_axes,'XTickLabel',[0 200 400 600 800]);
title('Son complexe périodique généré par combinaison des 2 sinusoïdes (B et C)');
xlabel('Temps (ms)');
ylabel('Frequence (Hz)');
%colormap('gray');
print -dtiff spec_bc;

figure; %Enveloppe
env4 = gcf;
plot(t,signal,'-k','LineWidth',1.5);
axis([0 .01 -2 2]);
title('Son complexe périodique généré par combinaison des 2 sinusoïdes (B et C)');
xlabel('Temps (ms)');
ylabel('Amplitude (ou Intensité)');
%colormap('gray');
print -dtiff env_bc;
fclose all;