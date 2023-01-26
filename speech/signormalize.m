function signal_out = signormalize(matrix, reference, type);
  
	% Normalizes RMS so that it would be equal to a constant value. 
	%
	% USAGE : out = normalize(matrix,reference,type);
	%
	% if reference = matrix, final RMS = matrix' RMS
	% if reference = scalar, the effect depends on the type string.
	% if type = 'max', max(out) = that value
	% if type = 'rms', rms(out) = that value
	% to normalize a to-be MS 'wav' file, use 'max' with .9
  
  if length(reference) > 1,
    signal_out = (sigrms(reference) / sigrms(matrix)) .* matrix;
  else
    if strncmpi(type,'max',3),
	signal_out = (reference / max(abs(matrix))) .* matrix;
    elseif strncmpi(type,'rms',3),
	signal_out = (reference / sigrms(matrix)) .* matrix;
    end
  end
  
end

