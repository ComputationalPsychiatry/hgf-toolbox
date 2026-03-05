function c = tapas_cdfgaussian_obs_config
% Observation model for binary responses based on the probability mass (cumulative distribution
% function) of the second level belief (on x2). The probability of choosing 1 (instead of 0)
% is the posterior probability that x2 is greater than 0.
% Usage:
%     tapas_fitModel(responses, inputs, '<perceptual_model>', 'tapas_cdfgaussian_config', ...)
% This optimization requires no observation parameters. The corresponding variables are therefore
% empty.


% Config structure
c = struct;

% Model name
c.model = 'CDF Gaussian';

% Gather prior settings in vectors
c.priormus = [];
c.priorsas = [];

% Model filehandle
c.obs_fun = @tapas_cdfgaussian_obs;

% This is the handle to a dummy function since there are no parameters to transform
c.transp_obs_fun = @tapas_cdfgaussian_obs_transp;

return;
