% Speech Toolbox - (last modification: 16-Oct-2001)
% e-mail: o.crouzet@cns.keele.ac.uk
% 
%   addnoise           - Add (or replace signal with) noise to a sound signal
%   bank_split         - Split a wideband input speech signal into N frequency bands.
%   bpfilter           - Matlab script written from C source provided by Georg.
%   channels           - Speech-modulated noise in N bands (a la Shannon)
%   depth              - How to estimate the modulation depth of a signal?
%   desync             - Insert artificial phase reverberation (a la Greenberg)
%   disp_envelope      - displays a filterbank view of amplitude envelope
%   display_sound      - Script pour cr?er images de l'enveloppe et un spectro directement ? partir d'un fichier
%   env_r              - Compute envelope amplitude correlation between spectral channels
%   env_spec_noise     - Computes a speech modulated noise with matched LT-spectrum
%   extract            - Extracts the portion of a 16 bit PCM raw sound file.
%   f0_extract         - Script en cours de modification pour extraire le contour f0 d'un signal et le
%   loadsig            - Loads a 16 bit PCM Raw Sound File (sig file) into the workspace.
%   lt_spectrum        - Compute (and plot) the long-term spectrum of a signal
%   lts_filt           - Filter a signal with the Long-Term spectrum of another signal.
%   make_filterbank    - Compute an N-channel filterbank 
%   merge              - Merges two signals at a specified SNR.
%   merge_fix          - Merges two signals and normalizes RMS so that the 
%   nist2wav           - (No help available)
%   nist_load          - Copyleft Olivier Crouzet, 2000.
%   noise              - Script implementing the rms_noise function
%   normalize          - Normalizes RMS so that it would be equal to a constant value. 
%   nyquist            - Filters the signal x at Nyquist's Frequency.
%   phon_rest          - TO BE COMPLETED. NOT FUNCTIONNAL !!!
%   rms                - Compute the RMS of a signal
%   rms_noise          - Generate constant or envelope shaped white noise at SNR
%   s2t                - converts samples to time in ms given fs.
%   sigplay            - Plays a PCM RAW SOUND FILE at Fs Hz.
%   sigsum             - Aggregates auditory files into one file.
%   sigwrite           - Saves a workspace matrix into a PCM raw sound file (.sig).
%   spectrogram        - function array = spectrogram(wave,Fs,segsize,nlap,ntrans);
%   splice             - Cross splices the end and the beginning of two 16 bit PCM raw sound files.
%   synth_sin          - Synthesize a sinewave
%   t2s                - converts time (in ms) to samples given fs.
%   temporal_smear     - Smear the long-term envelope of a signal (low-pass or high-pass filter)
%   temporal_smear_FIR - Filtering of a signal's envelope within narrow frequency bands
%   temporal_smear_GT  - OBSOLETE. smears with ERBfilterbank splitting
%   testERB            - Test script for MakeERBfilters.
%   testFIR            - Displays the response of a FIR filterbank
%   testIIR            - 
%   wav2sig            - Translates a .WAV (MS Windows) into a .SIG (or .PCM) raw header file.
%   wav_norm           - Normalizes RMS so that it would conform to WAV specification (stupid ones!!!). 
%   waveform           - Displays the waveform of a matrix.
%   wavload            - Read Microsoft WAVE (".wav") sound file (Modified, type help for more info).
%   wavstore           - Write Microsoft WAVE (".wav") sound file.
%   window             - Apply an amplitude window to a signal.
%
% Copyright Olivier Crouzet