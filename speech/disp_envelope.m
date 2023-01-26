function y = disp_envelope(x,fs,nb_bands,cutoff,nb_cols,colid,max_y,color_string);

% Display a filterbank view of amplitude envelope
%
% Should use env_extract rather than env_r
%
% y = disp_envelope(x,fs,nb_bands,cutoff,max_y,leave_subplot);

if exist('nb_cols')~=1,
	nb_cols = 1;
	colid=1;
end
if exist('color_string')~=1,
	color_string = 'b';
end

% use of normalised coordinates to display amplitude would be better
% (cf correlation computation)
% should use env_extract
[r,y,positive,ds_factor] = env_r(x,fs,nb_bands,cutoff,'fir','ncov');
%[r,y,ds_factor] = band_r(x,fs,nb_bands,cutoff,'fir');

y = positive;
%y = ztrans(positive,[2,1]);
%for i = 1:nb_bands,
%	y(i,:) = ztrans(y(i,:),[mean(y(i,:)) 1]);
%end

% axes display
t = 1:length(y);
spacing=250;
spaced_vector=[0:spacing:max((t/fs*ds_factor)*1000)];

%subplot(nb_bands,nb_bands,(k*nb_bands)-(nb_bands-j)); %1=topleft, then right and bottom
%subplot(nb_bands,nb_bands,(k*nb_bands)-(nb_bands-j)); %1=bottomleft, then right and top
for i = 1:nb_bands,
%	subplot(nb_bands,nb_cols,(nb_bands-i+1);
	subplot(nb_bands,nb_cols,((nb_bands-i+1)*nb_cols)-(nb_cols-colid)); %i*colid);
hold on;
	plot((t/fs*ds_factor)*1000,y(:,i),color_string);
	grid on;
xlabel('xlabel');
ylabel('ylabel');
	set(gca,'XTick',spaced_vector);
%	set(gca,'XTick',[0 250 500 750 1000 1250 1500 1750 2000]);
	max_data(i)=max(y(:,i));
end

max_data_final=abs(max(max_data));
%(t/fs*ds_factor)*1000

%max_x = length(y)/fs*64
if exist('max_y')==1,
	for i = 1:nb_bands,
	subplot(nb_bands,nb_cols,((nb_bands-i+1)*nb_cols)-(nb_cols-colid)); %i*colid);
%		subplot(nb_bands,1,nb_bands-i+1);
		axis([0 max((t/fs*ds_factor)*1000) 0 max_y]);
	end
else,
	for i = 1:nb_bands,
	subplot(nb_bands,nb_cols,((nb_bands-i+1)*nb_cols)-(nb_cols-colid)); %i*colid);
		axis([0 max((t/fs*ds_factor)*1000) 0 max_data_final]);
	end
end
