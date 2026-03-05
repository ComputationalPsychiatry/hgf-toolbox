function c = tapas_bayes_optimal_config
% Contains the configuraton for the estimation of Bayes optimal perceptual parameters
% Usage:
%     tapas_fitModel([], inputs, '<perceptual_model>', 'tapas_bayes_optimal_config', ...)
% Note that the first argument (responses) is empty.
% This optimization requires no observation parameters. The corresponding variables are therefore
% empty.


% Config structure
c = struct;

% Model name
c.model = 'Bayes optimal';

% Gather prior settings in vectors
c.priormus = [];
c.priorsas = [];

% Model filehandle
c.obs_fun = @tapas_bayes_optimal;

% This is the handle to a dummy function since there are no parameters to transform
c.transp_obs_fun = @tapas_bayes_optimal_transp;

return;
