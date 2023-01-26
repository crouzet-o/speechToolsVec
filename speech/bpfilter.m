function y = bpfilter(signal,band,fs,order);

% Matlab script written from C source provided by Georg.
% Not finished.
%
% Génère 2 matrices correspondant respectivement aux fréquences caractéristiques des filtres
% et aux largeurs de bande de ces filtres.
%
% Apres avoir charge le MAT-file correspondant, on peut acceder aux moyennes et
% largeurs de bande des filtres (en Hz) de la maniere suivante (avec N = nb de bandes) :
%
% lower_bound = Freqs(N,1:N) - Bands(N,1:N)./2
% upper_bound = Freqs(N,1:N) - Bands(N,1:N)./2
% edges = [lower_bound ; upper_bound];
% edges_band1 = [edges(1,1) edges(2,1)];
% edges_band2 = [edges(1,2) edges(2,2)];
% edges_band3 = [edges(1,3) edges(2,3)];
% edges_bandN = [edges(1,N) edges(2,N)];
% etc...
% BPfilter is a bandpass iir auditory filter, it is called with
% infile outfile fc fs f_order
%     fc   is the centre frequency for the bandpass filter
%     fs   is the sampling rate of the input file

%char_freqs = zeros(17,10);
%bandwidths = zeros(17,10);



%Center_Freqs = dlmread('filterbank_charfreq.txt','\t');
%Bandwidths = dlmread('filterbank_bandwidth.txt','\t');

%save filterbank Center_Freqs Bandwidths;


cf = [0.1,   0.152, 0.204, 0.257, 0.313, 0.370, 0.430, 0.493,...
			0.560, 0.630, 0.705, 0.785, 0.870, 0.961, 1.059, 1.164,...
			1.278, 1.400, 1.532, 1.674, 1.828, 1.995, 2.176,...
			2.372, 2.584, 2.815, 3.065, 3.336, 3.630, 3.950,...
			4.297, 4.674];

cf = cf .*1000;

% Initialize filter coefficients assuming BARK scale Bandwidth on an ERB scale : 
% where cf is in kHz.

bw = 0.00000623*fc*fc + 0.09339*fc + 28.52;

frequ = cf(fc); 
alpha = bw / (fac_cf(order) * frequ);
w = (2.0 * pi * frequ) / fs;







% filtering
a1 = 1.0-exp(-w * alpha);
a2 = exp(-w * alpha) * cos(w);
a3 = exp(-w * alpha) * sin(w);

% perform filter loop <k> times (= filter order)
for (l=0:order),
	yr[0] = a1*xr[0];
	yi[0] = a1*xi[0];
	for (j=1; j<nox; j++) {
		yr[j] = a1*xr[j] + a2*yr[j-1] - a3*yi[j-1];
		yi[j] = a1*xi[j] + a2*yi[j-1] + a3*yr[j-1];
	}
	tp = xr; xr = yr; yr = tp;   /* swap X-Y buffers */
	tp = xi; xi = yi; yi = tp;
}

% final result in real part of X should be multiplied by two
for (j=0; j<nox; j++) 
    fy->area[j] = xr[j] + xr[j];
    
% free buffers
free(xr);
free(xi);
free(yr);
free(yi);
