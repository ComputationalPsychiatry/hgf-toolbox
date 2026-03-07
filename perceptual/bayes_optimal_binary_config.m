function c = bayes_optimal_binary_config
% Contains the configuraton for the estimation of Bayes optimal perceptual parameters
% Usage:
%     fitModel([], inputs, '<perceptual_model>', 'bayes_optimal_binary_config', ...)
% Note that the first argument (responses) is empty.
% This optimization requires no observation parameters. The corresponding variables are therefore
% empty.


% Config structure
c = struct;

% Model name
c.model = 'Bayes optimal (binary)';

% Gather prior settings in vectors
c.priormus = [];
c.priorsas = [];

% Model filehandle
c.obs_fun = @bayes_optimal_binary;

% This is the handle to a dummy function since there are no parameters to transform
c.transp_obs_fun = @bayes_optimal_binary_transp;

