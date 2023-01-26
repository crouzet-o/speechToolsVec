function y = isgray(x)
%ISGRAY Return true for intensity image.
%   FLAG = ISGRAY(A) returns 1 if A is a grayscale intensity
%   image and 0 otherwise.
%
%   ISGRAY uses these criteria to decide if A is an intensity
%   image:
%
%   - If A is of class double, all values must be in the range
%     [0,1], and the number of dimensions of A must be 2.
%
%   - If A is of class uint8 or uint16, the number of 
%     dimensions of A must be 2.
%
%   Class Support
%   -------------
%   A can be of class uint8, uint16, or double.
%
%   See also ISBW, ISIND, ISRGB.

y = ndims(x)==2 & ~isempty(x);
if ~isa(x, 'uint8') & ~isa(x, 'uint16') & y
   % At first just test a small chunk to get a possible quick negative
   [m,n] = size(x);
   chunk = x(1:min(m,10),1:min(n,10));         
   y = min(chunk(:))>=0 & max(chunk(:))<=1;
   % If the chunk is an intensity image, test the whole image
   if y
      y = min(x(:))>=0 & max(x(:))<=1;
   end
end    

y = logical(double(y));    % Just make sure
