function c = gaussian_obs_offset_config
% Contains the configuration for the Gaussian noise observation model for continuous responses, with
% an offset lambda
% The Gaussian noise observation model assumes that responses have a Gaussian distribution around
% the inferred mean of the relevant state. The only parameter of the model is the noise variance
% (NOT standard deviation) zeta.


% Config structure
c = struct;

% Model name
c.model = 'gaussian_obs';

% Sufficient statistics of Gaussian parameter priors
% Zeta
c.logzemu = log(0.005);
c.logzesa = 0.1;

% Lambda
c.lamu = 0;
c.lasa = 10;

% Gather prior settings in vectors
c.priormus = [
    c.logzemu,...
    c.lamu,...
         ];

c.priorsas = [
    c.logzesa,...
    c.lasa,...
         ];

% Model filehandle
c.obs_fun = @gaussian_obs_offset;

% Handle to function that transforms observation parameters to their native space
% from the space they are estimated in
c.transp_obs_fun = @gaussian_obs_offset_transp;

