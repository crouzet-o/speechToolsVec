function sig_out = lts_filt(sig_in,sig_ref,N_band,yw_order);

% Filter a signal with the Long-Term spectrum of another signal.
%
% Computes the Long-Term spectrum of SIG_REF (with SPECTRUM.M)
% and filters SIG_IN (with YULEWALK.M) from this spectrum.
%
% USAGE : sig_out = lts_filt(sig_in,sig_ref,N_band,yw_order);
%
% PARAMETERS :	SIG_REF = reference signal.
%				SIG_IN = to-be-filtered signal (may be a white noise).
%				N_band = Number of frequency bands (default: 128).
% 				yw_order = YULEWALK filter order (default: 10).
%
% Note : the matrices SIG_REF and SIG_IN should previously have been
% loaded into the workspace.
%
% EXAMPLE : out = lts_filt(bruit,phrase);


if nargin < 2,
	error('Type help lts_filt to get USAGE');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SIGNAL_REF's Long-Term Spectrum computation (Magnitude vs. Frequency)

if exist('N_band') == 0
	N_band = 128;
end

if exist('yw_order') == 0
	yw_order = 10;
end

[M,F] = spectrum(sig_ref,N_band);

				% Plots SIG_REF's spectrum
				%figure;
				%plot(F,M(:,1));

% Generates the filter's characteristics
[param2,param1] = yulewalk(yw_order,F,M(:,1));

% Filters SIG_IN with SIG_REF frequency characteristics
sig_out = filter(param2,param1,sig_in);

% RMS Correction
rms_in = rms(sig_in);
%rms_ref = rms(sig_ref)
rms_out = rms(sig_out);

sig_out = (rms_in / rms_out) .* sig_out;

				% Plots SIG_OUT's spectrum
				%[M2,F2] = spectrum(sig_out,N_band);
				%figure;
				%plot(F2,M2(:,1));
