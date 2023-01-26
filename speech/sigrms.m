function rms = sigrms(signal);
  
  %% Compute the RMS of a signal
  %%
  %% USAGE value = rms(signal);
  
  rms = sqrt ( mean ( signal(1:length(signal)) .^2 ) );
  
end

