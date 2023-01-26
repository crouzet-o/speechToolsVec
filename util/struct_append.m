function struct_data = struct_append(original,structure);

% Append structure to a mat-file or to a workspace structure.
%
% USAGE: struct_append(original,new_structure);

new_index = 1;

%if (ischar(original) == 1) & (exist(original,'file') == 2),		% read data on disk if available
if ischar(original) == 1,		% read data on disk if available
	file = [original,'.mat'];
	if exist(original,'file') == 2,		% read data on disk if available
		s = load(original);
	elseif exist(file,'file') == 2,
		s = load(file);
	end
	if isstruct(getfield(s,char(fieldnames(s)))),
		struct_data = getfield(s,char(fieldnames(s)));
		new_index = length(struct_data)+1;
	end
elseif isstruct(original),
			struct_data = original; %getfield(s,char(fieldnames(s)));
			new_index = length(original)+1;
else
disp('Unpredicted input');
end

struct_data(new_index) = structure(length(structure));

if ischar(original) == 1,
	save(original,'struct_data');
end
