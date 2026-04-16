function c = hgf_jget_config_base(update_type)
% Base configuration for the HGF for the jumping Gaussian estimation task (JGET).
% This factory function generates configs for both HGF and eHGF variants.
%
% Usage:
%   c = hgf_jget_config_base('hgf')   % classic HGF
%   c = hgf_jget_config_base('ehgf')  % enhanced HGF
%   c = hgf_jget_config_base('uhgf')  % unbounded HGF
%
% NOTE: The eHGF and uHGF variants use different default priors for several parameters.

% Validate update_type
if ~ismember(update_type, {'hgf', 'ehgf', 'uhgf'})
    error('tapas:hgf:InvalidUpdateType', 'update_type must be ''hgf'', ''ehgf'', or ''uhgf''.');
end

% Config structure
c = struct;

% Model name
c.model = [update_type, '_jget'];

% Number of levels (minimum: 2)
c.n_levels = 2;

% Sufficient statistics of Gaussian parameter priors

% PLACEHOLDER VALUES
% 99991   Value of the first input
% 99992   Variance of the first 20 inputs
% 99993   Log-variance of the first 20 inputs
% 99994   Log-variance of the first 20 inputs minus two

% Initial mus and sigmas
c.mux_0mu = [99991, 1];
c.mux_0sa = [    0, 0];

switch update_type
    case 'hgf'
        c.logsax_0mu = [log(3), log(0.1)];
        c.logsax_0sa = [     0,        0];

        c.mua_0mu = [log(1), 1];
        c.mua_0sa = [   0.1, 0];

        c.logsaa_0mu = [log(3), log(0.1)];
        c.logsaa_0sa = [     0,        0];
    case {'ehgf', 'uhgf'}
        c.logsax_0mu = [log(16), log(1)];
        c.logsax_0sa = [      1,      1];

        c.mua_0mu = [-4, -4];
        c.mua_0sa = [ 0,  0];

        c.logsaa_0mu = [log(1), log(4)];
        c.logsaa_0sa = [     1,      1];
end

% Kappas
c.logkaumu = log(1);
c.logkausa = 0;

c.logkaxmu = [log(1)];
c.logkaxsa = [     0];

c.logkaamu = [log(1)];
c.logkaasa = [     0];

% Omegas
switch update_type
    case 'hgf'
        c.omumu = 0;
        c.omusa = 0;

        c.omxmu = [  0,  -7];
        c.omxsa = [5^2,   1];

        c.omamu = [  0,  -7];
        c.omasa = [5^2,   1];
    case {'ehgf', 'uhgf'}
        c.omumu = 8;
        c.omusa = 0;

        c.omxmu = [ -1,   0];
        c.omxsa = [2^2, 2^2];

        c.omamu = [  4,   2];
        c.omasa = [2^2, 2^2];
end

% Gather prior settings in vectors
c.priormus = [
    c.mux_0mu,...
    c.logsax_0mu,...
    c.mua_0mu,...
    c.logsaa_0mu,...
    c.logkaumu,...
    c.logkaxmu,...
    c.logkaamu,...
    c.omumu,...
    c.omxmu,...
    c.omamu,...
         ];

c.priorsas = [
    c.mux_0sa,...
    c.logsax_0sa,...
    c.mua_0sa,...
    c.logsaa_0sa,...
    c.logkausa,...
    c.logkaxsa,...
    c.logkaasa,...
    c.omusa,...
    c.omxsa,...
    c.omasa,...
         ];

% Check whether we have the right number of priors
expectedLength = 8*c.n_levels;
if length([c.priormus, c.priorsas]) ~= 2*expectedLength;
    error('tapas:hgf:PriorDefNotMatchingLevels', 'Prior definition does not match number of levels.')
end

% Update type
c.update_type = update_type;

% Model function handle
c.prc_fun = str2func([update_type, '_jget']);

% Handle to function that transforms perceptual parameters to their native space
% from the space they are estimated in
c.transp_prc_fun = str2func([update_type, '_jget_transp']);

end
