function c = tapas_quasinewton_optim_config
% Contains the configuration for the Broyden, Fletcher, Goldfarb and Shanno (BFGS)
% quasi-Newton optimization algorithm


% Config structure
c = struct;

% Algorithm name
c.algorithm = 'BFGS quasi-Newton';

% Verbosity
c.verbose   = false;

% Options for optimization
c.tolGrad = 1e-3;
c.tolArg  = 1e-3;
c.maxStep = 1;
c.maxIter = 100;
c.maxRegu = 16;
c.maxRst  = 10;
c.nRandInit = 0;
c.seedRandInit = NaN;
c.optIter = 1;

% Algorithm filehandle
c.opt_algo = @tapas_quasinewton_optim;

