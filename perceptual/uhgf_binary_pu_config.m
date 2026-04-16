function c = uhgf_binary_pu_config
% Configuration for the unbounded HGF (uHGF) binary variant with perceptual uncertainty.
% This is a thin wrapper around hgf_binary_pu_config_base. See that function for full documentation.
%
% Usage:
%   c = uhgf_binary_pu_config;

c = hgf_binary_pu_config_base('uhgf');

end
