function fileset = loadsounds(spec,max,reject);

% Read a directory and load file data and information in a structure
%
% USAGE fileset = loadsounds(spec,max);

d_tmp = dir(spec);
%r = dir(reject);

% look for rejection criterium
j = 1;
for i = 1:length(d_tmp),
	if strcmp(d_tmp(i).name,reject)==0,
		d(j) = d_tmp(i);	
		j = j+1;
	end;
end;

if max == 'max',
	max = length(d);
end

%seed_time = clock;
%rand('state',sum(100*seed_time));
%state = rand('state');
%order = randperm(length(d));

% put a switch for different file formats

seed_time = clock;
rand('state',sum(100*seed_time))
order = randperm(length(d));
	
for i = 1:max,
	[name,fs] = wavload(d(order(i)).name);
	fileset(i) = struct('data',name,'fs',fs,'filename',d(order(i)).name,'size',d(order(i)).bytes);
%	fileset(i) = struct('data',wavload(d(nd).name),'fs');
end

%fileset = [fileset(1:rej-1) fileset(rej+1:max)];
