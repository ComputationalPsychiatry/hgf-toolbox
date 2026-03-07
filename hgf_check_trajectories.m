function hgf_check_trajectories(mu, pi, jumpTol, columns)
% Checks the validity of HGF trajectories.
%
% Used by standard HGF models (not eHGF) to detect invalid parameter
% regions that lead to NaN values or implausible jumps.
%
% INPUT:
%   mu        Matrix of posterior means [trials x levels]
%   pi        Matrix of posterior precisions [trials x levels]
%   jumpTol   Tolerance for jump detection (e.g., 16 for binary, 256 for continuous)
%   columns   Which columns of mu/pi to check (e.g., 2:end for binary, 1:end for continuous)
%             If empty, checks all columns.

if isempty(columns)
    columns = 1:size(mu, 2);
end

if any(isnan(mu(:))) || any(isnan(pi(:)))
    error('tapas:hgf:VarApproxInvalid', ...
        'Variational approximation invalid. Parameters are in a region where model assumptions are violated.');
else
    dmu = diff(mu(:, columns));
    dpi = diff(pi(:, columns));
    rmdmu = repmat(sqrt(mean(dmu.^2)), length(dmu), 1);
    rmdpi = repmat(sqrt(mean(dpi.^2)), length(dpi), 1);

    if any(abs(dmu(:)) > jumpTol*rmdmu(:)) || any(abs(dpi(:)) > jumpTol*rmdpi(:))
        error('tapas:hgf:VarApproxInvalid', ...
            'Variational approximation invalid. Parameters are in a region where model assumptions are violated.');
    end
end

end
