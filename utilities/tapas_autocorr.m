function y = tapas_autocorr(x)
% USAGE:
%     Y = tapas_autocorr(X)
% INPUT:
%     X - n-by-m matrix of m time series (columns) of length n
% OUTPUT:
%     Y - n-by-m matrix with m columns of autocorrelation coefficients for lags n-1 

% Length of time series
n = size(x,1);

% De-mean time series
x = x - ones(size(x))*diag(mean(x));

% Get the autocovariance
f = fft(x);
fsq = f.*conj(f);
y = ifft(fsq)/n;

% Get the autocorrelation (the next line is equivalent to y = y*diag(1./y(1,:));)
y = y*diag(1./var(x,1));

end
