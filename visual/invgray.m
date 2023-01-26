function g = gray(m)
%GRAY   Inverse Linear gray-scale color map (Olivier, November 1999).
%   GRAY(M) returns an M-by-3 matrix containing a gray-scale colormap.
%   GRAY, by itself, is the same length as the current colormap.
%
%   For example, to reset the colormap of the current figure:
%
%             colormap(invgray)
%
%   See also HSV, HOT, COOL, BONE, COPPER, PINK, FLAG, 
%   COLORMAP, RGBPLOT.

%   Copyright (c) 1984-97 by The MathWorks, Inc.
%   $Revision: 5.2 $  $Date: 1997/04/08 06:10:51 $

if nargin < 1, m = size(get(gcf,'colormap'),1); end
g = (0:m-1)'/max(1,m-1);
g = [g g g];

%[T,F,B] = spgrambw(signal,Fs,20,2048);