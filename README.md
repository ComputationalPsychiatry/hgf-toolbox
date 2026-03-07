# HGF Toolbox
Release ID: $Format:%h %d$

--- 

The HGF toolbox is free and open source software released under the MIT License.
See the LICENSE file for details.

---

## How to cite the HGF Toolbox
Please cite the following paper when using the HGF Toolbox:

Frässle, S., et al. (2021). TAPAS: An Open-Source Software Package for
Translational Neuromodeling and Computational Psychiatry. Frontiers in
Psychiatry, 12:680811. https://doi.org/10.3389/fpsyt.2021.680811


## Installation

Move this folder to a location of your choice and run `setup` in Matlab
to add all subdirectories to the path:

```matlab
cd /path/to/hgf-toolbox
setup
```


## Quick start

```matlab
% Load example binary input (in demo/)
u = load('example_binary_input.txt');

% Fit a 3-level binary HGF with unit-square sigmoid response model
est = fitModel([], u, 'hgf_binary_config', 'bayes_optimal_binary_config', 'quasinewton_optim_config');

% Plot the estimated belief trajectories
hgf_binary_plotTraj(est)

% Simulate with known parameters and an observation model
sim = simModel(u, 'hgf_binary', [NaN 0 1 NaN 1 1 NaN 0 0 NaN 1 NaN -2.5 -6], 'unitsq_sgm', 5);

% Use the enhanced HGF (eHGF) instead — just change the config
est_e = fitModel(sim.y, u, 'ehgf_binary_config', 'unitsq_sgm_config', 'quasinewton_optim_config');
```


## Documentation

- **Architecture guide**: See [ARCHITECTURE.md](ARCHITECTURE.md) for an
  overview of file organization, naming conventions, the unified
  HGF/eHGF architecture, parameter notation, and the trajectory
  data structures.
- **Tutorial demo**: Open `demo/hgf_demo.mlx` in Matlab for an
  interactive walkthrough.
- **Source code**: All functions have header comments accessible via
  `help <function_name>` in Matlab.

## Release notes

### v8.2
- **Reorganized directory structure**: Files are now organized into
  `core/`, `building_blocks/`, `perceptual/`, `observation/`,
  `plotting/`, `utilities/`, and `demo/` directories instead of a
  flat top-level layout
- **Added `setup.m`**: Run once to add all subdirectories to the
  MATLAB path. All function calls remain unchanged — no path prefixes
  needed
- Updated `ARCHITECTURE.md` with directory structure tree
- Updated `README.md` installation instructions

### v8.1
- **Added `ARCHITECTURE.md`**: Comprehensive guide to file organization,
  naming conventions, model inventory, parameter notation, the unified
  HGF/eHGF architecture, and the `traj`/`infStates` data structures
- **Added INPUT/OUTPUT documentation** to all 18 observation model files
  and all 14 simulation (`*_sim.m`) files
- **Expanded `sampleModel.m` documentation** with full INPUT/OUTPUT
  descriptions and usage examples, matching the quality of `fitModel.m`
- **Enriched wrapper files** (e.g., `hgf.m`, `ehgf_binary.m`) with
  context on when to use them, which unified model they delegate to,
  and cross-references to detailed documentation
- **Fixed garbled comments** in `hgf_binary_pu.m`
- **Removed outdated `Manual.pdf`** (replaced by `ARCHITECTURE.md` and
  `hgf_demo.mlx`)
- **Expanded README.md** with quick-start example and documentation
  section

### v8.0
- **Unified HGF/eHGF architecture**: All HGF and eHGF model variants
  now share the same update equations via unified implementation files
  (e.g., `hgf_binary_unified.m`). The choice between classic HGF and
  enhanced HGF is controlled by a single flag:
  `r.c_prc.update_type = 'hgf'` or `'ehgf'`
- Extracted shared building-block functions (`hgf_volatility_update.m`,
  `hgf_prediction.m`, `hgf_pihat.m`, etc.) so that the update equations
  appear in only one place
- Original model files (e.g., `hgf_binary.m`, `ehgf_binary.m`) are now
  thin backward-compatible wrappers
- All config files now include `c.update_type` field
- Updated `hgf_demo.m` documentation
- **Config factory pattern**: Created `*_config_base.m` files that
  generate configs for both HGF and eHGF variants. Each existing config
  file (e.g., `hgf_binary_config.m`, `ehgf_binary_config.m`) is now a
  thin wrapper calling the shared base with the appropriate update_type
- **Consolidated transp/namep/plotTraj files**: eHGF versions of
  identical file pairs now delegate to their HGF counterparts
  (5 transp, 5 namep, 2 plotTraj pairs consolidated)
- **Replaced `eval()` calls** in `fitModel.m` and `sampleModel.m` with
  `str2func()` for safer function resolution

### v7.2
- Switched to MIT licence
- Fix MIT licence file
- Update seed in fitModel
- Remove unneeded return statements at the end of files
- Undo mistaken LME calculation bugfix
- Minor bug fixes and additions

### v7.1
- Add ehgf_ar1_plotTraj
- Bugfix

### v7.0
- Numerical stability improvements to optimization
- Combined response models (more than one observation per trial)
- Various bugfixes and minor improvements

### v6.1
- Improved functionality of beta_obs response model
- Included reference to TAPAS paper

### v6.0
- Introduced first eHGF models (ehgf, ehgf_binary, ehgf_jget)
- Enabled calling fitModel with config structures as arguments
- Enabled changing config structures on the fly
- Introduced sampleModel for sampling from the prior
- Various other additions, improvements, and bugfixes

### v5.3
- Enabled setting and storing of seed for random number generator in simulations
- Debugged reading of response model configuration in simModel
- Reduced default maxStep from 2 to 1 in quasinewton_oqptim_config
- Improved readability of siem files for unitsq_sgm and softmax_binary
- Added simulation capability for softmax_wld and softmax_mu3_wld
- Added softmax_wld response model
- Improved readability of softmax_mu3_wld code
- Improved readability of softmax and softmax_mu3 code

### v5.2
- Brought hgf_demo.pdf up to date
- Added gaussian_obs_offset response model
- Brought example in simModel up to date
- Added sim and namep files for unitsq_sgm_mu3
- Fixed typo in softmax_mu3_wld
- Introduced softmax_mu3_wld decision model
- Estimate mu0_2 by default in hgf_ar1_binary_mab
- Improved comment in softmax_mu3_config
- Change to pi_2 update in hgf_ar1_binary_mab
- Enabled simulation for hgf_ar1_binary_mab
- Added softmax_mu3
- Added hgf_ar1_binary_mab
- Fixed automatic detection of number of levels in hgf_ar1_binary
- Fixed documentation of hgf_ar1_binary
- Fixed hgf_binary_mab_plotTraj
- Fixed trajectory calculations in hgf_binary_mab
- Adapted riddersgradient and riddershessian to new Matlab versions
- Quashed bug in rw_binary_dual found by gbelluc@gmail.com

### v5.1
- Added condhalluc_obs and condhalluc_obs2 models
- Introduced kappa1 in all binary HGF models

### v5.0
- Ported interactive demo to Matlab LiveScript
- Various additional small improvements
- Updated manual
- Updated and renamed README to README.md

### v4.17
- Improvements to logrt_linear_binary_minimal

### v4.16
- Added the binary HGF with trial-by-trial perceptual uncertainty as hgf_binary_pu_tbt

### v4.15
- Added the Kalman filter as kf

### v4.14
- Improved the beta_obs model
- Improved calculation of implied 1st-level learning rate

### v4.13
- Corrected sign of update trajectories
- Added option to base responses on predictions or posteriors in
  the beta_obs model

### v4.12
- Added autocorr.m

### v4.11
- Predictions and residuals returned by all observations models
- Added fit_plotResidualDiagnostics()

### v4.10
- Added hgf_categorical_norm
- Added Boltzmann distribution (i.e., softmax normalization) as boltzmann()

### v4.9
- Set implied learning rate at first level to 0 if update is zero

### v4.8
- Give choice of using predictions or posteriors with softmax_binary

### v4.7
- Added cdfgaussian_obs model
- Added hgf_binary_pu (perceptual uncertainty) model
- Improvements for beta_obs with hgf_whichworld

### v4.6
- Adapted beta_obs to deal with ph_binary
- Added Pearce-Hall in ph_binary
- Clarified the role of default settings in comments of fitModel
- Brought softmax_binary_sim up to date

### v4.5
- Improved comments in softmax_binary_sim
- Improved comments in beta_obs.m
- Added beta_obs_{sim,namep}.m

### v4.4
- Added hgf_ar1_binary_namep.m
- Improved rw_binary

### v4.3
- Added bayes_optimal_categorical
- Improved hgf_categorical_plotTraj

### v4.2
- Adapted softmax_sim to hgf_categorical
- Added hgf_categorical
- Added datagen_categorical and categorical data example

### v4.1
- Improved hgf_jget

### v4.0
- Added PDF manual
- Added interactive demo in hgf_demo
- Added file of raw commands from hgf_demo in hgf_demo_commands
- Adapted fitModel to calculate AIC and BIC
- Renamed F (negative variational free energy) to LME (log-model evidence, to
  which it is an approximation)
- Calculate accuracy and complexity in fitModel
- Save everything relating to model quality under r.optim
- Improved output of fitModel
- Added hierarchical hidden Markov model (hhmm)
- Added hidden Markov model (hmm)
- Added WhatWorld (hgf_whatworld) model
- Added linear log-reaction time (logrt_linear_whatworld) model for WhatWorld
- Added WhichWorld (hgf_whichworld) model
- Added AR(1) model for binary outcomes (hgf_ar1_binary)
- Added Jumping Gaussian Estimation (hgf_jget) model
- Added unitsq_sgm_mu3 decision model
- Added binary multi-armed bandit model hgf_binary_mab
- Added beta_obs observation model for decision noise on the unit interval
- Added softmax decision model with different inverse temperature for each
  kind of binary decision (softmax_2beta)
- Added logrt_linear_binary decision model
- Added Rescorla-Wagner model with different learning rate for each kind of
  binary outcome (rw_binary_dual)
- Included additional trajectories in output of hgf, hgf_ar1, hgf_ar1_mab,
  hgf_binary, hgf_ar1_binary, hgf_binary_mab, hgf_whichworld, and
  hgf_whatworld
- Made infStates more consistent across models
- Removed deprecated hgf_binary3l
- Made fitModel explicitly return negative log-joint probability and negative
  log-likelihood
- Modified simModel to read configuration files of perceptual and observation
  models
- Abolished theta in hgf, hgf_binary, hgf_ar1, hgf_ar1_mab, hgf_ar1_binary,
  hgf_binary_mab, and hgf_jget
- Moved kappa estimation from logit-space to log-space for hgf, hgf_binary,
  hgf_ar1, hgf_ar1_mab, hgf_ar1_binary, hgf_binary_mab, and hgf_jget
- Introduced checking for implausible jumps in trajectories for hgf,
  hgf_binary, hgf_ar1, hgf_ar1_mab, hgf_ar1_binary, hgf_binary_mab, and
  hgf_jget
- Adapted fitModel to deal with cases the <prc_model>_transp() function
  performs operations important to the <model>() function
- Introduced multinomial softmax decision model
- Improved documentation for hgf_ar1_mab model
- Added error IDs for all errors

### v3.0
- Improved error handling in fitModel()
- Prefixed all function names with “tapas_”
- Added rs_precision
- Added rs_belief
- Added rs_surprise
- Added sutton_k1
- Added hgf_ar1_mab
- Added softmax for continuous responses
- Improved checking of trajectory validity in HGF models
- Debugged input handling in softmax_binary

### v2.1
- Introduced Bayesian parameter averaging
- Amended calculation of log-priors in fitModel.m
- Debugged construction of time axis in hgf_plotTraj
- Debugged removal of placeholder field in estimate structure

### v2.0
- Estimation of Bayes optimal parameters added
- infStates the same 3-dim array in hgf_binary as in hgf
- Changes to softmax_binary: trial-by-trial rewards read from input matrix
- hgf_binary generalized to n levels
- Old hgf_binary lives on as hgf_binary3l
- Input at irregular intervals enabled in hgf and hgf_binary
- Support for constant drift in hgf and hgf_binary
- Introduced use of placeholders in config files
- quasinewton_optim: increased default maximum number of regularizations to 16
- Automatic detection of upper bound on theta for hgf
- Improved input checks
- Support for AR(1) processes in new hgf_ar1
- quasinewton_optim: improved resetting after exhaustion of regularizations

### v1.0
- Original release
