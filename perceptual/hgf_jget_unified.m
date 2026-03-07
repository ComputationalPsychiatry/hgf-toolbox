function [traj, infStates] = hgf_jget_unified(r, p, varargin)
% Unified HGF for the jumping Gaussian estimation task (JGET).
%
% Implements both HGF and eHGF for the JGET, which has a dual hierarchy
% tracking position (x) and precision/volatility (a).
% The update type is controlled by r.c_prc.update_type:
%   'hgf'  - Standard HGF
%   'ehgf' - Enhanced HGF (safe precision updates)

% Determine update type from config
try
    update_type = r.c_prc.update_type;
catch
    update_type = 'ehgf';
end

% Transform parameters back to their native space if needed
if ~isempty(varargin) && strcmp(varargin{1},'trans')
    if strcmp(update_type, 'hgf')
        p = hgf_jget_transp(r, p);
    else
        p = ehgf_jget_transp(r, p);
    end
end

% Number of levels
try
    l = r.c_prc.n_levels;
catch
    l = length(p)/8;

    if l ~= floor(l)
        error('tapas:hgf:UndetNumLevels', 'Cannot determine number of levels');
    end
end

% Unpack parameters
mux_0 = p(1:l);
sax_0 = p(l+1:2*l);
mua_0 = p(2*l+1:3*l);
saa_0 = p(3*l+1:4*l);
kau   = p(4*l+1);
kax   = p(4*l+2:5*l);
kaa   = p(5*l+1:6*l-1);
omu   = p(6*l);
omx   = p(6*l+1:7*l-1);
oma   = p(7*l+1:8*l-1);
thx   = exp(p(7*l));
tha   = exp(p(8*l));

% Add dummy "zeroth" trial
u = [0; r.u(:,1)];

% Number of trials (including prior)
n = length(u);

% Construct time axis
t = ones(n,1);

% Initialize updated quantities
mux = NaN(n,l);
pix = NaN(n,l);
mua = NaN(n,l);
pia = NaN(n,l);

muuhat = NaN(n,1);
piuhat = NaN(n,1);
muxhat = NaN(n,l);
pixhat = NaN(n,l);
muahat = NaN(n,l);
piahat = NaN(n,l);
daux   = NaN(n,1);
daua   = NaN(n,1);
wx     = NaN(n,l-1);
dax    = NaN(n,l-1);
wa     = NaN(n,l-1);
daa    = NaN(n,l-1);

% Representation priors
mux(1,:) = mux_0;
pix(1,:) = 1./sax_0;
mua(1,:) = mua_0;
pia(1,:) = 1./saa_0;

% Representation update loop
for k = 2:1:n
    if not(ismember(k-1, r.ign))

        %%%%%%%%%%%%%%%%%%%%%%
        % Effect of input u(k)
        %%%%%%%%%%%%%%%%%%%%%%

        % Input level
        muuhat(k) = mux(k-1,1);
        piuhat(k) = 1/exp(kau * mua(k-1,1) + omu);
        daux(k) = u(k) - muuhat(k);

        % 1st level
        muxhat(k,1) = mux(k-1,1);
        muahat(k,1) = mua(k-1,1);
        pixhat(k,1) = hgf_pihat(pix(k-1,1), t(k), kax(1), mux(k-1,2), omx(1));
        piahat(k,1) = hgf_pihat(pia(k-1,1), t(k), kaa(1), mua(k-1,2), oma(1));

        % x-updates
        pix(k,1) = pixhat(k,1) + piuhat(k);
        mux(k,1) = muxhat(k,1) + piuhat(k)/pix(k,1) * daux(k);

        % Prediction error of input precision
        daua(k) = (1/pix(k,1) + (mux(k,1) - u(k))^2) * piuhat(k) - 1;

        % alpha-updates
        pia(k,1) = piahat(k,1) + 1/2 * kau^2 * (1 + daua(k));
        mua(k,1) = muahat(k,1) + 1/2 * 1/pia(k,1) * kau * daua(k);

        % Volatility prediction errors
        dax(k,1) = hgf_volatility_pe(pix(k,1), mux(k,1), muxhat(k,1), pixhat(k,1));
        daa(k,1) = hgf_volatility_pe(pia(k,1), mua(k,1), muahat(k,1), piahat(k,1));

        if l > 2
            % Pass through higher levels
            for j = 2:l-1
                muxhat(k,j) = mux(k-1,j);
                muahat(k,j) = mua(k-1,j);
                pixhat(k,j) = hgf_pihat(pix(k-1,j), t(k), kax(j), mux(k-1,j+1), omx(j));
                piahat(k,j) = hgf_pihat(pia(k-1,j), t(k), kaa(j), mua(k-1,j+1), oma(j));

                % x-hierarchy update
                [pix(k,j), mux(k,j), wx(k,j-1), ~] = hgf_volatility_update(...
                    muxhat(k,j), pixhat(k,j), ...
                    kax(j-1), pixhat(k,j-1), dax(k,j-1), ...
                    mux(k-1,j), omx(j-1), pix(k-1,j-1), ...
                    pix(k,j-1), mux(k,j-1), muxhat(k,j-1), t(k), update_type);

                % a-hierarchy update
                [pia(k,j), mua(k,j), wa(k,j-1), ~] = hgf_volatility_update(...
                    muahat(k,j), piahat(k,j), ...
                    kaa(j-1), piahat(k,j-1), daa(k,j-1), ...
                    mua(k-1,j), oma(j-1), pia(k-1,j-1), ...
                    pia(k,j-1), mua(k,j-1), muahat(k,j-1), t(k), update_type);

                dax(k,j) = hgf_volatility_pe(pix(k,j), mux(k,j), muxhat(k,j), pixhat(k,j));
                daa(k,j) = hgf_volatility_pe(pia(k,j), mua(k,j), muahat(k,j), piahat(k,j));
            end
        end

        % Last level
        muxhat(k,l) = mux(k-1,l);
        muahat(k,l) = mua(k-1,l);
        pixhat(k,l) = hgf_pihat_last(pix(k-1,l), t(k), thx);
        piahat(k,l) = hgf_pihat_last(pia(k-1,l), t(k), tha);

        [pix(k,l), mux(k,l), wx(k,l-1), ~] = hgf_volatility_update(...
            muxhat(k,l), pixhat(k,l), ...
            kax(l-1), pixhat(k,l-1), dax(k,l-1), ...
            mux(k-1,l), omx(l-1), pix(k-1,l-1), ...
            pix(k,l-1), mux(k,l-1), muxhat(k,l-1), t(k), update_type);

        [pia(k,l), mua(k,l), wa(k,l-1), ~] = hgf_volatility_update(...
            muahat(k,l), piahat(k,l), ...
            kaa(l-1), piahat(k,l-1), daa(k,l-1), ...
            mua(k-1,l), oma(l-1), pia(k-1,l-1), ...
            pia(k,l-1), mua(k,l-1), muahat(k,l-1), t(k), update_type);

        dax(k,l) = hgf_volatility_pe(pix(k,l), mux(k,l), muxhat(k,l), pixhat(k,l));
        daa(k,l) = hgf_volatility_pe(pia(k,l), mua(k,l), muahat(k,l), piahat(k,l));
    else
        mux(k,:) = mux(k-1,:);
        mua(k,:) = mua(k-1,:);
        pix(k,:) = pix(k-1,:);
        pia(k,:) = pia(k-1,:);
        muuhat(k) = muuhat(k-1);
        piuhat(k) = piuhat(k-1);
        muxhat(k,:) = muxhat(k-1,:);
        muahat(k,:) = muahat(k-1,:);
        pixhat(k,:) = pixhat(k-1,:);
        piahat(k,:) = piahat(k-1,:);
        daux(k) = daux(k-1);
        daua(k) = daua(k-1);
        wx(k,:)  = wx(k-1,:);
        wa(k,:)  = wa(k-1,:);
        dax(k,:) = dax(k-1,:);
        daa(k,:) = daa(k-1,:);
    end
end

% Remove representation priors
mux(1,:) = [];
mua(1,:) = [];
pix(1,:) = [];
pia(1,:) = [];

% Check validity of trajectories (standard HGF only)
if strcmp(update_type, 'hgf')
    if any(isnan(mux(:))) || any(isnan(pix(:))) || any(isnan(mua(:))) || any(isnan(pia(:)))
        error('tapas:hgf:VarApproxInvalid', ...
            'Variational approximation invalid. Parameters are in a region where model assumptions are violated.');
    else
        dmux = diff(mux);
        dmua = diff(mua);
        dpix = diff(pix);
        dpia = diff(pia);
        rmdmux = repmat(sqrt(mean(dmux.^2)),length(dmux),1);
        rmdmua = repmat(sqrt(mean(dmua.^2)),length(dmua),1);
        rmdpix = repmat(sqrt(mean(dpix.^2)),length(dpix),1);
        rmdpia = repmat(sqrt(mean(dpia.^2)),length(dpia),1);
        jumpTol = 256;
        if any(abs(dmux(:)) > jumpTol*rmdmux(:)) || any(abs(dmua(:)) > jumpTol*rmdmua(:)) || ...
           any(abs(dpix(:)) > jumpTol*rmdpix(:)) || any(abs(dpia(:)) > jumpTol*rmdpia(:))
            error('tapas:hgf:VarApproxInvalid', ...
                'Variational approximation invalid. Parameters are in a region where model assumptions are violated.');
        end
    end
end

% Remove other dummy initial values
muuhat(1)   = [];
piuhat(1)   = [];
muxhat(1,:) = [];
muahat(1,:) = [];
pixhat(1,:) = [];
piahat(1,:) = [];
wx(1,:)     = [];
wa(1,:)     = [];
daux(1)     = [];
daua(1)     = [];
dax(1,:)    = [];
daa(1,:)    = [];

% Extract learning rates
lrx = NaN(n-1,l);
lra = NaN(n-1,l);
lrx(:,1) = piuhat./pix(:,1);
lrx(:,2:end) = kax./2 * wx./pix(:,2:end);
lra(:,1) = 1/2 * kau./pia(:,1);
lra(:,2:end) = kaa./2 * wa./pia(:,2:end);

% Create result data structure
traj = struct;
traj.mux     = mux;
traj.mua     = mua;
traj.sax     = 1./pix;
traj.saa     = 1./pia;
traj.muuhat  = muuhat;
traj.muxhat  = muxhat;
traj.muahat  = muahat;
traj.sauhat  = 1./piuhat;
traj.saxhat  = 1./pixhat;
traj.saahat  = 1./piahat;
traj.wx      = wx;
traj.wa      = wa;
traj.daux    = daux;
traj.daua    = daua;
traj.dax     = dax;
traj.daa     = daa;
traj.lrx     = lrx;
traj.lra     = lra;

% Create matrices for use by the observation model
infStates = NaN(n-1,1,10);
infStates(:,1,1)  = traj.muuhat;
infStates(:,1,2)  = traj.sauhat;
infStates(:,1,3)  = traj.muxhat(:,1);
infStates(:,1,4)  = traj.saxhat(:,1);
infStates(:,1,5)  = traj.muahat(:,1);
infStates(:,1,6)  = traj.saahat(:,1);
infStates(:,1,7)  = traj.mux(:,1);
infStates(:,1,8)  = traj.sax(:,1);
infStates(:,1,9)  = traj.mua(:,1);
infStates(:,1,10) = traj.saa(:,1);

end
