function y = snr(signal,noise);

% DOESN'T WORK !!!
% Estimates the signal-noise ratio between two signals
% Laquelle choisir ?
% It doesn't work anyway. (When both RMSs are equal, gives a non-zero SNR).
y = 10 * log10( rms(signal)/rms(noise))
y = 20 * log10( rms(signal)/rms(noise) )
