function y = sigwrite(matrix,filename);

% Saves a workspace matrix into a PCM raw sound file (.sig).
%
% USAGE : sigwrite(matrix,'filename');

fid = fopen(filename,'wb');
fwrite(fid,matrix,'short');
fclose('all');
