function y = create_dir(directory_name);

% Create a directory only if it does not already exist
%
% USAGE: create_dir(directory_name);
%
% This function is faster than letting mkdir.m decide whether it should create it or not

directory_name = ['.\',directory_name];

if exist(directory_name,'dir') ~= 7,
	mkdir(directory_name);
end


