function w = lambert_w0(z)
% LAMBERT_W0  Principal branch of the Lambert W function, W_0(z), for z >= 0.
%
% Uses an asymptotic initial guess (log(z) - log(log(z)) for z > 3,
% constant w = 1 otherwise) followed by Halley's method, which converges
% in a few iterations to machine precision.
%
% USAGE:
%   w = lambert_w0(z)
%
% INPUT:
%   z   Non-negative scalar
%
% OUTPUT:
%   w   W_0(z) such that w * exp(w) = z

if z < 0
    w = NaN;
    return;
end

if z < 1e-10
    w = z;  % W(z) ~ z for small z
    return;
end

% Initial guess
if z > 3
    w = log(z) - log(log(z));
else
    w = 1;
end

% Halley iterations
for i = 1:8
    ew  = exp(w);
    f   = w * ew - z;
    fp  = ew * (1 + w);
    fpp = ew * (2 + w);
    w   = w - (2 * f * fp) / (2 * fp * fp - f * fpp);
end

end
