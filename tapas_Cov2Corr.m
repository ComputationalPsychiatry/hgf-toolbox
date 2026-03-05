function Corr = tapas_Cov2Corr(Cov)
% Converts a covariance matrix into a correlation matrix

% Check if Cov is symmetric
if any(any(Cov'~=Cov))
    error('tapas:hgf:Cov2Corr:MatNotSymm', 'Input matrix is not symmetric.');
end

% Check if Cov is positive semi-definite
if any(isinf(Cov(:))) || any(isnan(Cov(:))) || any(eig(Cov)<0)
    error('tapas:hgf:Cov2Corr:MatNotPosDef', 'Input matrix is not positive semi-definite.');
end

sdev = sqrt(diag(Cov));
Norm = sdev * sdev';
Corr = Cov./Norm;

return;
