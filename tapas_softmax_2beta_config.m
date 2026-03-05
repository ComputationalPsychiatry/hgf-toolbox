function c = tapas_softmax_2beta_config
% Contains the configuration for the softmax observation model for multinomial responses and
% different betas for rewards and punishments. NOTE: this model is acausal in situations where
% decisions are made before the outcome (reward or punishhment) is known.

% Config structure
c = struct;

% Is the decision based on predictions or posteriors? Comment as appropriate.
c.predorpost = 1; % Predictions
%c.predorpost = 2; % Posteriors

% Model name
c.model = 'softmax_2beta';

% Sufficient statistics of Gaussian parameter priors

% Betas
c.logbemu = [log(1), log(1)];
c.logbesa = [   4^2,    4^2];

% Gather prior settings in vectors
c.priormus = [
    c.logbemu,...
         ];

c.priorsas = [
    c.logbesa,...
         ];

% Model filehandle
c.obs_fun = @tapas_softmax_2beta;

% Handle to function that transforms observation parameters to their native space
% from the space they are estimated in
c.transp_obs_fun = @tapas_softmax_2beta_transp;

return;
