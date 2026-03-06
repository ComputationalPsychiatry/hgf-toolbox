function c = softmax_config
% Contains the configuration for the softmax observation model for multinomial responses

% Config structure
c = struct;

% Is the decision based on predictions or posteriors? Comment as appropriate.
c.predorpost = 1; % Predictions
%c.predorpost = 2; % Posteriors

% Model name
c.model = 'softmax';

% Sufficient statistics of Gaussian parameter priors

% Beta
c.logbemu = log(1);
c.logbesa = 4^2;

% Gather prior settings in vectors
c.priormus = [
    c.logbemu,...
         ];

c.priorsas = [
    c.logbesa,...
         ];

% Model filehandle
c.obs_fun = @softmax;

% Handle to function that transforms observation parameters to their native space
% from the space they are estimated in
c.transp_obs_fun = @softmax_transp;

