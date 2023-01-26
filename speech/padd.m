function [x,y] = padd(x,y,where);

% Padd a signal with zeros
%
% USAGE: [x,y] = padd(x,y,where);
%
% 'where': 	'begin'		signal at beginning
%			'end'		signal at end
%			'both'		silence on both sides

taille1 = length(x);

if length(y) > 1,
	taille2 = length(y);
else
	taille2 = y;
end
taille = max(taille1,taille2);

if taille2 < taille1,
	error('y must be greater than x');
end

% Convolves both signals % ? exchange x and y depending on size?
switch lower(where),
	case 'begin'
		   x = [x ; zeros(taille2-taille1,1)];
	case 'end'
		   x = [zeros(taille2-taille1,1); x];
	case 'both'
		   x = [zeros(floor((taille2-taille1)/2),1); x ; zeros(ceil((taille2-taille1)/2),1)];
	otherwise
		   x = [zeros(round((taille2-taille1)/2),1); x ; zeros(round((taille2-taille1)/2),1)];
%		error('type help padd');
end

%signal_out = signal1 + signal2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
