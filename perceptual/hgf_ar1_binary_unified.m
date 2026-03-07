function [traj, infStates] = hgf_ar1_binary_unified(r, p, varargin)
% Unified HGF for AR(1) processes and binary outcomes.
%
% This implements both the standard HGF and the enhanced HGF (eHGF)
% for binary inputs with AR(1) drift. The update type is controlled by
% r.c_prc.update_type:
%   'hgf'  - Standard HGF (uses phi only, no rho; 6*l-1 params)
%   'ehgf' - Enhanced HGF (uses both rho and phi; 7*l-1 params)
%
% The parameter vectors differ between HGF and eHGF variants:
%   HGF:  [mu_0, sa_0, phi, m, ka, om, th]
%   eHGF: [mu_0, sa_0, phi, m, rho, ka, om, th]

% Determine update type from config
try
    update_type = r.c_prc.update_type;
catch
    update_type = 'ehgf';
end

% Transform parameters back to their native space if needed
if ~isempty(varargin) && strcmp(varargin{1},'trans')
    if strcmp(update_type, 'hgf')
        p = hgf_ar1_binary_transp(r, p);
    else
        p = ehgf_ar1_binary_transp(r, p);
    end
end

% Number of levels and parameter unpacking depend on update type
try
    l = r.c_prc.n_levels;
catch
    if strcmp(update_type, 'hgf')
        l = (length(p)+1)/6;
    else
        l = (length(p)+1)/7;
    end

    if l ~= floor(l)
        error('tapas:hgf:UndetNumLevels', 'Cannot determine number of levels');
    end
end

% Unpack parameters (layout differs between hgf and ehgf)
if strcmp(update_type, 'hgf')
    % HGF AR1 binary: [mu_0, sa_0, phi, m, ka, om, th]
    mu_0 = p(1:l);
    sa_0 = p(l+1:2*l);
    phi  = p(2*l+1:3*l);
    m    = p(3*l+1:4*l);
    rho  = zeros(1,l);  % No rho in standard HGF AR1
    ka   = p(4*l+1:5*l-1);
    om   = p(5*l:6*l-2);
    th   = exp(p(6*l-1));
else
    % eHGF AR1 binary: [mu_0, sa_0, phi, m, rho, ka, om, th]
    mu_0 = p(1:l);
    sa_0 = p(l+1:2*l);
    phi  = p(2*l+1:3*l);
    m    = p(3*l+1:4*l);
    rho  = p(4*l+1:5*l);
    ka   = p(5*l+1:6*l-1);
    om   = p(6*l:7*l-2);
    th   = exp(p(7*l-1));
end

% Add dummy "zeroth" trial
u = [0; r.u(:,1)];

% Number of trials (including prior)
n = length(u);

% Get time axis
t = hgf_time_axis(r, n);

% Initialize updated quantities
mu    = NaN(n,l);
pi    = NaN(n,l);
muhat = NaN(n,l);
pihat = NaN(n,l);
v     = NaN(n,l);
w     = NaN(n,l-1);
da    = NaN(n,l);

% Representation priors
mu(1,1) = tapas_sgm(mu_0(1), 1);
pi(1,1) = Inf;
mu(1,2:end) = mu_0(2:end);
pi(1,2:end) = 1./sa_0(2:end);

% Pass through representation update loop
for k = 2:1:n
    if not(ismember(k-1, r.ign))

        %%%%%%%%%%%%%%%%%%%%%%
        % Effect of input u(k)
        %%%%%%%%%%%%%%%%%%%%%%

        % 2nd level prediction (with AR1 drift)
        muhat(k,2) = hgf_prediction(mu(k-1,2), t(k), 'rho', rho(2), 'phi', phi(2), 'm', m(2));

        % 1st level
        [mu(k,1), pi(k,1), muhat(k,1), pihat(k,1), da(k,1)] = ...
            hgf_binary_level1(u(k), ka(1), muhat(k,2));

        % 2nd level
        pihat(k,2) = hgf_pihat(pi(k-1,2), 1, ka(2), mu(k-1,3), om(2));
        [pi(k,2), mu(k,2), da(k,2)] = hgf_binary_level2(muhat(k,2), pihat(k,2), ka(1), pihat(k,1), da(k,1));

        if l > 3
            % Pass through higher levels
            for j = 3:l-1
                muhat(k,j) = hgf_prediction(mu(k-1,j), t(k), 'rho', rho(j), 'phi', phi(j), 'm', m(j));
                pihat(k,j) = hgf_pihat(pi(k-1,j), t(k), ka(j), mu(k-1,j+1), om(j));

                [pi(k,j), mu(k,j), v(k,j-1), w(k,j-1)] = hgf_volatility_update(...
                    muhat(k,j), pihat(k,j), ...
                    ka(j-1), pihat(k,j-1), da(k,j-1), ...
                    mu(k-1,j), om(j-1), pi(k-1,j-1), ...
                    pi(k,j-1), mu(k,j-1), muhat(k,j-1), t(k), update_type);

                da(k,j) = hgf_volatility_pe(pi(k,j), mu(k,j), muhat(k,j), pihat(k,j));
            end
        end

        % Last level
        muhat(k,l) = hgf_prediction(mu(k-1,l), t(k), 'rho', rho(l), 'phi', phi(l), 'm', m(l));
        pihat(k,l) = hgf_pihat_last(pi(k-1,l), t(k), th);

        v(k,l)   = t(k) * th;
        v(k,l-1) = t(k) * exp(ka(l-1) * mu(k-1,l) + om(l-1));

        [pi(k,l), mu(k,l), ~, w(k,l-1)] = hgf_volatility_update(...
            muhat(k,l), pihat(k,l), ...
            ka(l-1), pihat(k,l-1), da(k,l-1), ...
            mu(k-1,l), om(l-1), pi(k-1,l-1), ...
            pi(k,l-1), mu(k,l-1), muhat(k,l-1), t(k), update_type);

        da(k,l) = hgf_volatility_pe(pi(k,l), mu(k,l), muhat(k,l), pihat(k,l));
    else
        mu(k,:) = mu(k-1,:);
        pi(k,:) = pi(k-1,:);
        muhat(k,:) = muhat(k-1,:);
        pihat(k,:) = pihat(k-1,:);
        v(k,:)  = v(k-1,:);
        w(k,:)  = w(k-1,:);
        da(k,:) = da(k-1,:);
    end
end

% Implied learning rate at the first level
sgmmu2 = tapas_sgm(ka(1) * mu(:,2), 1);
dasgmmu2 = u - sgmmu2;
lr1    = diff(sgmmu2)./dasgmmu2(2:n,1);
lr1(da(2:n,1)==0) = 0;

% Remove representation priors
mu(1,:) = [];
pi(1,:) = [];

% Check validity of trajectories (standard HGF only)
if strcmp(update_type, 'hgf')
    hgf_check_trajectories(mu, pi, 16, 2:size(mu,2));
end

% Remove other dummy initial values
muhat(1,:) = [];
pihat(1,:) = [];
v(1,:)     = [];
w(1,:)     = [];
da(1,:)    = [];

% Create result data structure
traj = struct;
traj.mu     = mu;
traj.sa     = 1./pi;
traj.muhat  = muhat;
traj.sahat  = 1./pihat;
traj.v      = v;
traj.w      = w;
traj.da     = da;
traj.ud     = mu - muhat;

psi        = NaN(n-1,l);
psi(:,2)   = 1./pi(:,2);
psi(:,3:l) = pihat(:,2:l-1)./pi(:,3:l);
traj.psi   = psi;

epsi        = NaN(n-1,l);
epsi(:,2:l) = psi(:,2:l) .* da(:,1:l-1);
traj.epsi   = epsi;

wt        = NaN(n-1,l);
wt(:,1)   = lr1;
wt(:,2)   = psi(:,2);
wt(:,3:l) = 1/2 * (v(:,2:l-1) * diag(ka(2:l-1))) .* psi(:,3:l);
traj.wt   = wt;

infStates = NaN(n-1,l,4);
infStates(:,:,1) = traj.muhat;
infStates(:,:,2) = traj.sahat;
infStates(:,:,3) = traj.mu;
infStates(:,:,4) = traj.sa;

end
