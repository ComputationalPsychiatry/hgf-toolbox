function c = tapas_condhalluc_obs3_config
% Contains the configuration for the response model used to analyze data from conditioned
% hallucination paradigm by Powers & Corlett, AS MODIFIED FOR COUPLED PRIOR WEIGHTING AND
% VOLATILITY

% Config structure
c = struct;

% Model name
c.model = 'tapas_condhalluc_obs3';

% Sufficient statistics of Gaussian parameter priors

% Beta
c.logbemu = log(48);
c.logbesa = 1;

% Gather prior settings in vectors
c.priormus = [
    c.logbemu,...
         ];

c.priorsas = [
    c.logbesa,...
         ];

% Model filehandle
c.obs_fun = @tapas_condhalluc_obs3;

% Handle to function that transforms observation parameters to their native space
% from the space they are estimated in
c.transp_obs_fun = @tapas_condhalluc_obs3_transp;

end
