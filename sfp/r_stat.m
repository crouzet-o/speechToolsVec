function [significance_data,random_probability,average_data,std_data] = r_stat(r_data,reference,action);

% Inferential Statistics (student t) on correlation data
%
% function sig = r_stat(r_data,reference,action);

if exist('action','var') == 0,
	action = 'display';
else,
	action = 'save';
end

output_data_filename = [r_data,'.txt'];
struct_filename = ['struct_',r_data];
load(r_data);
load(struct_filename);

r_data_sizes = size(r_data);
r_data_dims = ndims(r_data);
significance_data = zeros(r_data_sizes(1),r_data_sizes(2));
random_probability = significance_data;
student_value = random_probability;

for i = 1:r_data_sizes(1),
	for j = 1:r_data_sizes(1),
		standard_dev = std(r_data(i,j,:));
		if mean(r_data(i,j,:)) == 1,
			significance_data(i,j) = NaN;
			random_probability(i,j) = NaN;
			student_value(i,j) = NaN;
		else,
			[significance_data(i,j),random_probability(i,j)] = ttest(r_data(i,j,:),reference,.05,1);
			student_value(i,j) = abs(qt(random_probability(i,j),r_data_sizes(3)-1)); % provides the t value based on df and proba
%			temp_data = squeeze(r_data(i,j,:));
%			[random_probability(i,j),significance_data(i,j)] = signtest((temp_data),reference,.05);
%			[significance_data(i,j),random_probability(i,j)] = ztest(r_data(i,j,:),reference,standard_dev,.05,1);
		end
	end
end

average_data = mean(r_data,r_data_dims);
std_data = std(r_data,0,r_data_dims);


switch(action),
	case{'display'}
		disp(average_data);
%		disp(std_data);
		disp(significance_data);
%		disp(random_probability);
%		disp(student_value);
	case{'save'}
		text_append(output_data_filename,average_data,['average_data - ',mat2str(s_data(1).nbbands),' channels - ',mat2str(s_data(1).modulation),' Hz - ',mat2str(s_data(1).filterbank)],' ');
		text_append(output_data_filename,std_data,['std_data - ',mat2str(s_data(1).nbbands),' channels - ',mat2str(s_data(1).modulation),' Hz - ',mat2str(s_data(1).filterbank)],' ');
		text_append(output_data_filename,significance_data,['significance_data (t test, p<.05, one tailed -- obs>',mat2str(reference),' --)'],' ');
		text_append(output_data_filename,random_probability,['probability_data - ',mat2str(s_data(1).nbbands),' channels - ',mat2str(s_data(1).modulation),' Hz - ',mat2str(s_data(1).filterbank)],' ');
		text_append(output_data_filename,student_value,['t value - df = ',mat2str(r_data_sizes(3)-1),' -- ',mat2str(s_data(1).nbbands),' channels - ',mat2str(s_data(1).modulation),' Hz - ',mat2str(s_data(1).filterbank)],' ');
end

%if exist(filename,'file') == 2,
%	temp_file = dlmread(filename,'\t');
%	temp_size = size(temp_file);
%	dlmwrite('average_data.txt',average_data,'\t',temp_size(1)-1,temp_size(2)-1);
%dlmwrite('average_data.txt',average_data,'\t');
%dlmwrite(filename,


%format_conversion = '%0.3g\t';
%format_string = [repmat(format_conversion,1,r_data_sizes(1)),'\n'];
%keyboard
%fid = fopen(filename,'at');
%fwrite(fid,average_data,'float32');
%for i = 1:r_data_sizes(1),
%	fprintf(fid,format_string,average_data(i,:));
%end
%fclose(fid);


