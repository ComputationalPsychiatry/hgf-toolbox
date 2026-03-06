function c = condhalluc_obs2_config
% Contains the configuration for the response model used to analyze data from conditioned
% hallucination paradigm by Powers & Corlett
% The rationale for this model is as follows:
% TO BE DESCRIBED...

% Config structure
c = struct;

% Model name
c.model = 'condhalluc_obs2';

% Sufficient statistics of Gaussian parameter priors

% Beta
c.logbemu = log(48);
c.logbesa = 1;

% Nu
c.lognumu = log(1);
c.lognusa = 1;

% Gather prior settings in vectors
c.priormus = [
    c.logbemu,...
    c.lognumu,...
         ];

c.priorsas = [
    c.logbesa,...
    c.lognusa,...
         ];

% Model filehandle
c.obs_fun = @condhalluc_obs2;

% Handle to function that transforms observation parameters to their native space
% from the space they are estimated in
c.transp_obs_fun = @condhalluc_obs2_transp;

