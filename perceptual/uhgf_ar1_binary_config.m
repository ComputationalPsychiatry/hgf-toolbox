function c = uhgf_ar1_binary_config
% Configuration for the unbounded HGF (uHGF) AR(1) binary variant.
% This is a thin wrapper around hgf_ar1_binary_config_base. See that function for full documentation.
%
% Usage:
%   c = uhgf_ar1_binary_config;

c = hgf_ar1_binary_config_base('uhgf');

end
