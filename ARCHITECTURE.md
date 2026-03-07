# HGF Toolbox Architecture

This document describes the architecture of the HGF (Hierarchical Gaussian
Filter) toolbox: how the files are organized, how the different components
relate to each other, and how to choose and configure models.


## Directory structure

```
hgf-toolbox/
├── setup.m                 Run once to add all directories to the MATLAB path
├── README.md               Overview, quick start, release notes
├── ARCHITECTURE.md         This file
├── LICENSE
│
├── core/                   Entry points and optimization (5 files)
│   ├── fitModel.m          Fit model parameters to data (MAP estimation)
│   ├── simModel.m          Simulate beliefs and responses
│   ├── sampleModel.m       Sample from the prior
│   ├── quasinewton_optim.m Quasi-Newton optimizer
│   └── quasinewton_optim_config.m
│
├── building_blocks/        Shared HGF update equations (10 files)
│   ├── hgf_prediction.m    One-step-ahead prediction
│   ├── hgf_volatility_update.m  Volatility-level update (HGF vs eHGF)
│   ├── hgf_pihat.m         Predicted precision
│   └── ...
│
├── perceptual/             Perceptual models and their configs (149 files)
│   ├── hgf_binary_unified.m      Unified binary HGF implementation
│   ├── hgf_binary.m              Wrapper (sets update_type='hgf')
│   ├── ehgf_binary.m             Wrapper (sets update_type='ehgf')
│   ├── hgf_binary_config_base.m  Config factory
│   ├── hgf_binary_config.m       Config wrapper (calls base('hgf'))
│   ├── ehgf_binary_config.m      Config wrapper (calls base('ehgf'))
│   ├── hgf_binary_transp.m       Parameter transformation
│   ├── hgf_binary_namep.m        Parameter naming
│   ├── rw_binary.m               Rescorla-Wagner
│   └── ...
│
├── observation/            Observation (response) models (82 files)
│   ├── gaussian_obs.m      Gaussian noise model
│   ├── softmax_binary.m    Binary softmax
│   ├── unitsq_sgm.m        Unit-square sigmoid
│   ├── *_sim.m             Simulation files
│   └── ...
│
├── plotting/               Visualization functions (26 files)
│   ├── hgf_binary_plotTraj.m
│   ├── fit_plotCorr.m
│   └── ...
│
├── utilities/              Math and helper functions (15 files)
│   ├── tapas_sgm.m         Logistic sigmoid
│   ├── bayesian_parameter_average.m
│   ├── riddersgradient.m   Numerical differentiation
│   └── ...
│
├── demo/                   Tutorial and example data (6 files)
│   ├── hgf_demo.mlx        Interactive tutorial (LiveScript)
│   ├── hgf_demo.m          Script version
│   ├── hgf_demo_commands.m Raw commands
│   ├── example_binary_input.txt
│   ├── example_usdchf.txt
│   └── example_categorical_input.mat
│
├── tests/                  Test suite
└── _original_models/       Pre-refactoring backups (can be removed)
```

After running `setup`, all functions are on the MATLAB path and can be
called by name without path prefixes — e.g., `fitModel(...)`,
`'hgf_binary_config'`, `hgf_binary_plotTraj(est)`, etc.


## Entry points

The toolbox has three main entry points:

| Function | Purpose |
|---|---|
| `fitModel` | Fit model parameters to observed responses using MAP estimation |
| `simModel` | Simulate an agent's beliefs and responses given known parameters |
| `sampleModel` | Sample parameters from the prior and compute implied trajectories |

A typical workflow:

```matlab
% Fit a binary HGF with unit-square sigmoid response model
est = fitModel(responses, inputs, 'hgf_binary_config', 'unitsq_sgm_config', 'quasinewton_optim_config');

% Simulate with known parameters
sim = simModel(inputs, 'hgf_binary', [NaN 0 1 NaN 1 1 NaN 0 0 NaN 1 NaN -2.5 -6], 'unitsq_sgm', 5);

% Sample from the prior
sam = sampleModel(inputs, 'ehgf_binary_config', 'unitsq_sgm_config');
```


## File naming conventions

Every model is accompanied by a family of files following a consistent
naming pattern. For a model named `<model>`:

| Suffix | Purpose | Example |
|---|---|---|
| `<model>.m` | The perceptual or observation model function | `hgf_binary.m` |
| `<model>_config.m` | Configuration: priors, initial values, model metadata | `hgf_binary_config.m` |
| `<model>_transp.m` | Parameter transformation from optimization space to native space | `hgf_binary_transp.m` |
| `<model>_namep.m` | Maps a flat parameter vector to a named struct | `hgf_binary_namep.m` |
| `<model>_sim.m` | Simulates responses (observation models only) | `softmax_binary_sim.m` |
| `<model>_plotTraj.m` | Plots belief trajectories (perceptual models only) | `hgf_binary_plotTraj.m` |
| `<model>_config_base.m` | Config factory shared by HGF and eHGF variants | `hgf_binary_config_base.m` |


## HGF vs eHGF (unified architecture)

The classic HGF and enhanced HGF (eHGF) share the same update equations
except for the precision update at volatility levels. Rather than
maintaining separate implementations, all HGF model families use a
**unified implementation** controlled by a single flag:

```matlab
r.c_prc.update_type = 'hgf';   % classic HGF (Mathys et al., 2011)
r.c_prc.update_type = 'ehgf';  % enhanced HGF (safe precision update)
```

The unified model files are:

| Unified file | Covers |
|---|---|
| `hgf_unified.m` | `hgf.m`, `ehgf.m` (continuous inputs) |
| `hgf_binary_unified.m` | `hgf_binary.m`, `ehgf_binary.m` |
| `hgf_binary_pu_unified.m` | `hgf_binary_pu.m`, `ehgf_binary_pu.m` |
| `hgf_binary_pu_tbt_unified.m` | `hgf_binary_pu_tbt.m`, `ehgf_binary_pu_tbt.m` |
| `hgf_ar1_binary_unified.m` | `hgf_ar1_binary.m`, `ehgf_ar1_binary.m` |
| `hgf_ar1_binary_mab_unified.m` | `hgf_ar1_binary_mab.m`, `ehgf_ar1_binary_mab.m` |
| `hgf_jget_unified.m` | `hgf_jget.m`, `ehgf_jget.m` |

The original model files (e.g., `hgf_binary.m`, `ehgf_binary.m`) are
thin backward-compatible wrappers that set `update_type` and delegate
to the unified version.

### Building-block functions

The unified models are built from shared building-block functions that
implement individual steps of the HGF update:

| Function | Step |
|---|---|
| `hgf_time_axis.m` | Compute time steps (supports irregular intervals) |
| `hgf_prediction.m` | One-step-ahead prediction of means (with optional drift, AR1) |
| `hgf_pihat.m` | Predicted precision at intermediate levels |
| `hgf_pihat_last.m` | Predicted precision at the highest level |
| `hgf_binary_level1.m` | Binary level-1 update (input level) |
| `hgf_binary_level2.m` | Binary level-2 update |
| `hgf_continuous_level1.m` | Continuous level-1 update (input level) |
| `hgf_volatility_update.m` | Volatility-level update (implements HGF vs eHGF difference) |
| `hgf_volatility_pe.m` | Volatility prediction error |
| `hgf_check_trajectories.m` | Validate trajectories for numerical issues |


## Config factory pattern

For model families that have both HGF and eHGF variants, the
configuration is generated by a shared factory function:

```
hgf_binary_config_base.m        <-- factory, accepts update_type argument
  ├── hgf_binary_config.m       <-- calls base('hgf')
  └── ehgf_binary_config.m      <-- calls base('ehgf')
```

Where the HGF and eHGF variants have different default priors, the
factory uses a `switch` statement on `update_type` to set
variant-specific values. For example, in `hgf_binary_config_base.m` the
default prior for omega differs between HGF and eHGF.


## Perceptual models

### HGF family

The main HGF model variants:

| Model | Input type | Description |
|---|---|---|
| `hgf` / `ehgf` | Continuous | Standard HGF for continuous inputs |
| `hgf_binary` / `ehgf_binary` | Binary | HGF for binary inputs |
| `hgf_binary_pu` / `ehgf_binary_pu` | Binary | Binary HGF with perceptual uncertainty |
| `hgf_binary_pu_tbt` / `ehgf_binary_pu_tbt` | Binary | Binary HGF with trial-by-trial perceptual uncertainty |
| `hgf_ar1_binary` / `ehgf_ar1_binary` | Binary | AR(1) binary HGF (with drift and mean-reversion) |
| `hgf_ar1_binary_mab` / `ehgf_ar1_binary_mab` | Binary | AR(1) binary HGF for multi-armed bandits |
| `hgf_jget` / `ehgf_jget` | Continuous | HGF for the jumping Gaussian estimation task |

### Other perceptual models

| Model | Description |
|---|---|
| `rw_binary` | Rescorla-Wagner (delta) learning rule |
| `rw_binary_dual` | Rescorla-Wagner with dual learning rates |
| `ph_binary` | Pearce-Hall learning rule |
| `sutton_k1_binary` | Sutton K1 learning rule |
| `hgf_categorical` | HGF for categorical (multi-outcome) inputs |
| `hgf_ar1` | AR(1) continuous HGF |
| `hgf_whatworld` / `hgf_whichworld` | HGF for world-switching tasks |
| `bayes_optimal_*` | Bayes-optimal agents (benchmark models) |


## Observation (response) models

Observation models define how internal beliefs map to observable
responses. They compute the log-probability of observed responses given
the agent's belief trajectories.

| Model | Response type | Description |
|---|---|---|
| `gaussian_obs` | Continuous | Gaussian noise around predicted mean |
| `gaussian_obs_offset` | Continuous | Gaussian noise with additive offset |
| `softmax_binary` | Binary | Binary softmax (logistic) decision |
| `softmax` | Categorical | Softmax over multiple options |
| `softmax_mu3` | Binary | Softmax using level-3 beliefs |
| `softmax_2beta` | Binary | Softmax with two temperature parameters |
| `unitsq_sgm` | Binary | Unit-square sigmoid mapping |
| `unitsq_sgm_mu3` | Binary | Unit-square sigmoid using level-3 beliefs |
| `beta_obs` | Probability | Beta-distribution for probability responses |
| `cdfgaussian_obs` | Binary | Cumulative Gaussian (probit) response |
| `condhalluc_obs` | Binary | Conditional hallucination model |
| `logrt_linear_binary` | Continuous | Log reaction time, linear model |

Each observation model has a corresponding `*_sim.m` file for
simulation.


## Parameter conventions

### Notation

| Symbol | Field name | Meaning |
|---|---|---|
| $\mu$ | `mu` | Posterior mean |
| $\hat{\mu}$ | `muhat` | Predicted (prior) mean |
| $\pi$ | `pi` | Posterior precision ($1/\sigma^2$) |
| $\hat{\pi}$ | `pihat` | Predicted (prior) precision |
| $\sigma^2$ | `sa` | Posterior variance ($1/\pi$) |
| $\hat{\sigma}^2$ | `sahat` | Predicted (prior) variance ($1/\hat{\pi}$) |
| $\kappa$ | `ka` | Coupling strength between levels |
| $\omega$ | `om` | Tonic (log-)volatility |
| $\vartheta$ | `th` | Meta-volatility (noise at highest level) |
| $\rho$ | `rho` | Drift rate |
| $\phi$ | `phi` | AR(1) mean-reversion rate |
| $m$ | `m` | AR(1) equilibrium mean |

### Parameter transformations

Parameters are estimated in a transformed space where they are
unbounded, then mapped back to their native space:

- **Unbounded parameters** (e.g., $\omega$, $\rho$, $\mu_0$): estimated
  directly (identity transform)
- **Positive parameters** (e.g., $\sigma^2_0$, $\kappa$): estimated in
  log-space ($\exp$ transform)

A parameter is **fixed** (not estimated) by setting its prior variance
to zero. Parameters with zero prior variance remain at their prior mean.

### Placeholder values in configs

Config files use special placeholder values that are replaced at runtime
based on the input data:

| Placeholder | Replaced by | Typical use |
|---|---|---|
| `99991` | First input value | Prior mean of $\mu_{0,1}$ |
| `99992` | Variance of first 20 inputs | Prior variance of $\mu_{0,1}$ |
| `99993` | Log-variance of first 20 inputs | Prior mean of $\log(\sigma^2_{0,1})$ |
| `99994` | Log-variance of first 20 inputs $-$ 2 | Prior mean of $\omega_1$ |


## Trajectory structure (`traj` and `infStates`)

The perceptual model returns two outputs:

1. **`traj`** — a struct with full trajectory information
2. **`infStates`** — a 3D array summarizing beliefs for use by the
   observation model

### `traj` fields

All fields are matrices of size ($n_{\text{trials}} \times n_{\text{levels}}$):

| Field | Meaning |
|---|---|
| `mu` | Posterior means |
| `sa` | Posterior variances ($1/\pi$) |
| `muhat` | Predicted means |
| `sahat` | Predicted variances ($1/\hat{\pi}$) |
| `v` | Volatility terms (precision update intermediate) |
| `w` | Volatility learning rate factors |
| `da` | Prediction errors (mean) |
| `ud` | Updates ($\mu - \hat{\mu}$) |
| `psi` | Precision weights on prediction errors |
| `epsi` | Precision-weighted prediction errors |
| `wt` | Full learning rates |

### `infStates` array

A 3D array of size ($n_{\text{trials}} \times n_{\text{levels}} \times 4$):

| Slice | Content |
|---|---|
| `infStates(:,:,1)` | `muhat` — predicted means |
| `infStates(:,:,2)` | `sahat` — predicted variances |
| `infStates(:,:,3)` | `mu` — posterior means |
| `infStates(:,:,4)` | `sa` — posterior variances |

This is the standard interface between perceptual and observation
models. Observation models typically access `infStates(:,1,1)` for
first-level predicted means or `infStates(:,1,3)` for first-level
posterior means.


## Optimization

The default optimizer is a quasi-Newton algorithm configured in
`quasinewton_optim_config.m`. The objective function minimized is the
negative log-joint (negative log-likelihood + negative log-prior) of the
parameters given the data.


## Utilities

| Function | Directory | Purpose |
|---|---|---|
| `bayesian_parameter_average` | `utilities/` | Bayesian parameter averaging across subjects |
| `align_priors` | `utilities/` | Ensure consistency of prior specification |
| `fit_plotCorr` | `plotting/` | Plot posterior parameter correlations |
| `fit_plotResidualDiagnostics` | `plotting/` | Residual diagnostic plots |
| `tapas_sgm` | `utilities/` | Logistic sigmoid function |
| `tapas_logit` | `utilities/` | Logit (inverse sigmoid) function |
| `boltzmann` | `utilities/` | Boltzmann (softmax) distribution |
