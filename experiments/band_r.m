function [r,data,ds_factor] = band_r(x,fs,nb_bands,lfe_split,bank_type,soundfilename,graph_color);

% Compute envelope amplitude correlation between spectral channels
% 
%[r,y] = band_r(x,fs,4,[1 16],'fir','r.');

%lfe_split = [0.5 2 4 8 16 32 64];

% TO-DO list


switch length(lfe_split),
	case {1}
	datafilename = ['data_',mat2str(nb_bands),'ch_0_',mat2str(lfe_split),'.mat'];
	case {2}
	datafilename = ['data_',mat2str(nb_bands),'ch_',[mat2str(lfe_split(1)),'_',mat2str(lfe_split(2))],'.mat'];
end
struct_datafilename = ['struct_',datafilename];


%read available data on disk
if exist(struct_datafilename,'file') == 2,
	load(struct_datafilename);
	load(datafilename);
	new_index = length(s_data)+1;
else
	new_index = 1;
end

ds_factor = 64;
%ds_factor = 128;
fse = fs/ds_factor;

switch lower(bank_type),
	case {'gt','gammatone','gamma'}
		bank_type = 'gt';
	case {'fir','finite'}
		bank_type = 'fir';
	otherwise
		error('type: help band_r');
end
%[y,recombined,cf,bandwidth,edges]  = bank_split(x,fs,nb_bands,'gt',100); % y = length(y)* Nb_bands (Nb_bands columns)
%[y,recombined,cf,bandwidth,edges]  = bank_split(x,fs,nb_bands,'fir',100); % y = length(y)* Nb_bands (Nb_bands columns)
[y,recombined,cf,bandwidth,edges]  = bank_split(x,fs,nb_bands,bank_type,100); % y = length(y)* Nb_bands (Nb_bands columns)

if (exist('graph_color','var') == 1),
	subplot(nb_bands,nb_bands,1);
	figure_handle = gcf;
end

h = hilbert(y); % h = same dimensions as y but complex
env = sqrt(real(h).*real(h)+imag(h).*imag(h)); % env = same dimensions as y

%half-wave rectification
env_tmp = sort(env(1,:)); % sorts samples in the envelope matrix
k = find(env_tmp>0); % finds the non-zero values in the sorted matrix
l = find(env<=0); % finds zeroes in the original envelope
env(l) = env(1,k(1)); %replaces these samples with the shortest non-zero value

for j = 1:nb_bands,
		ls_env(j,:) = resample(env(j,:),1,ds_factor); % downsampling the envelope (faster computation)

		coeffs = fir1(100, lfe_split./(fse/2)); % bandpass
		ls_env_extract_x(j,:) = filtfilt(coeffs,1,ls_env(j,:)); %filtering
%half-wave rectification
		ls_env_tmp = sort(ls_env_extract_x(1,:)); % sorts samples in the envelope matrix
		k = find(ls_env_tmp>0); % finds the non-zero values in the sorted matrix
		l = find(ls_env_extract_x<=0); % finds zeroes in the original envelope
		ls_env_extract_x(l) = ls_env_tmp(1,k(1)); %replaces these samples with the shortest non-zero value
		ls_env_extract_y(j,:) = ls_env_extract_x(j,:);
end

for j = 1:nb_bands,
	for k = 1:nb_bands,
		x_max = max(ls_env_extract_x(j,:));
		y_max = max(ls_env_extract_y(k,:));
		if (exist('graph_color','var') == 1),
		hold on;
		subplot(nb_bands,nb_bands,(k*nb_bands)-(nb_bands-j)); %1=bottomleft, then right and top
		plot(ls_env_extract_x(j,:),ls_env_extract_y(k,:),graph_color,'MarkerSize',4);
		axis([0 x_max 0 y_max]);
		set(gca,'Fontsize',6,'Fontname','Courrier');
			if (k*nb_bands)-(nb_bands-j) >= ((nb_bands*nb_bands)-(nb_bands-1)),
				xlabel(num2str(j),'Fontsize',8,'FontWeight','bold','Fontname','Helvetica','Color',[1 0 0]);
			end
			if (k*nb_bands)-(nb_bands-j) == ((k*nb_bands)-(nb_bands-1)),
				ylabel(num2str(k),'Fontsize',8,'FontWeight','bold','Fontname','Helvetica','Rotation',0,'Color',[1 0 0]);
			end
			if (k*nb_bands)-(nb_bands-j) == 1,
				if length(lfe_split) == 2,
					string_title = ['Filterbank: ',num2str(bank_type),' | Bandpass filter: [',num2str(lfe_split),' Hz]'];
				else
					string_title = ['Filterbank: ',num2str(bank_type),' | Lowpass filter: ',num2str(lfe_split),' Hz'];
				end
				title(string_title,'Position',[0 y_max+(y_max/4)],'Fontsize',8,'FontWeight','bold','Fontname','Helvetica','Color',[1 0 0],'HorizontalAlignment','left');
			end
		end
	end
end

switch length(lfe_split),
	case {1}
	filename = ['corr_',num2str(lfe_split),'_',num2str(bank_type),'.eps'];
	case {2}
	filename = ['corr_',num2str(lfe_split(1)),'-',num2str(lfe_split(2)),'_',num2str(bank_type),'.eps'];
end

if (exist('graph_color','var') == 1),
	print(figure_handle,'-depsc','-r100',filename);
end

%needs stats toolbox
data = ls_env_extract_x;
r = corrcoef(data');
%x = multiband matrix (with data in columns, each spectral channel is a row)
%r = corrcoef(x)
%disp(new_index);

%s_data(new_index) = struct('nbbands',nb_bands,'filterbank',mat2str(bank_type),'soundfile',mat2str(soundfilename),'modulation',lfe_split,'r_table',r);
%save(struct_datafilename,'s_data');


%for i = 1:new_index,
%	r_data(:,:,i) = s_data(i).r_table;
%end
save(datafilename,'r');
%clear all

%mean(r_data,3);
%std(r_data,0,3);
%[h,sig] = ztest(r_data(4,4,:),.50,.2,.05,1)