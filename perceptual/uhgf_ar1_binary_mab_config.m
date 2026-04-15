function c = uhgf_ar1_binary_mab_config
% Configuration for the unbounded HGF (uHGF) AR(1) binary MAB variant.
% This is a thin wrapper around hgf_ar1_binary_mab_config_base. See that function for full documentation.
%
% Usage:
%   c = uhgf_ar1_binary_mab_config;

c = hgf_ar1_binary_mab_config_base('uhgf');

end
