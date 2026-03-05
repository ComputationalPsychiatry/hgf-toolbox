function c = tapas_softmax_mu3_config
% Contains the configuration for the softmax observation model for multinomial responses with phasic
% volatility exp(mu3) as the decision temperature

% Config structure
c = struct;

% Is the decision based on predictions or posteriors? Comment as appropriate.
c.predorpost = 1; % Predictions
%c.predorpost = 2; % Posteriors

% Model name
c.model = 'softmax_mu3';

% Sufficient statistics of Gaussian parameter priors

% Gather prior settings in vectors
c.priormus = [
         ];

c.priorsas = [
         ];

% Model filehandle
c.obs_fun = @tapas_softmax_mu3;

% Handle to function that transforms observation parameters to their native space
% from the space they are estimated in
c.transp_obs_fun = @tapas_softmax_mu3_transp;

