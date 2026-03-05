function c = tapas_unitsq_sgm_config
% Contains the configuration for the unit square sigmoid observation model for binary responses
% The unit square sigmoid (ussgm) is the function
% f(x) = x^zeta/(x^zeta + (1-x)^zeta) = ustapas_sgm(x; zeta),
% where x is in the unit interval, and zeta > 0 is a parameter that determines the shape of the
% sigmoid. Since both its argument and value are always in the unit interval, its graph is
% restricted to the unit square, hence the name unit square sigmoid.
% In the application here, the ussgm is the probability of observing a decision y=1 (rather than
% the only alternative y=0) given the current probability mu1hat (or value) of input u=1:
% p(y=1|mu1hat) = ustapas_sgm(mu1hat; zeta)
% The parameter zeta regulates the steepness of the sigmoid such that it forms the diagonal of
% the unit square for zeta=1 and approaches a step function at 0.5 as zeta approaches infinity.
% Values of 0 < zeta < 1 lead to sigmoids with reverse concavity than usual, but they still
% represent valid observation models.
% Zeta can be interpreted as inverse decision noise. To have a shrinkage prior on this, choose a
% high value. It is estimated log-space since it has a natural lower bound at zero.

% Config structure
c = struct;

% Is the decision based on predictions or posteriors? Comment as appropriate.
c.predorpost = 1; % Predictions
%c.predorpost = 2; % Posteriors

% Model name
c.model = 'tapas_unitsq_sgm';

% Sufficient statistics of Gaussian parameter priors

% Zeta
c.logzemu = log(48);
c.logzesa = 1;

% Gather prior settings in vectors
c.priormus = [
    c.logzemu,...
         ];

c.priorsas = [
    c.logzesa,...
         ];

% Model filehandle
c.obs_fun = @tapas_unitsq_sgm;

% Handle to function that transforms observation parameters to their native space
% from the space they are estimated in
c.transp_obs_fun = @tapas_unitsq_sgm_transp;

return;
