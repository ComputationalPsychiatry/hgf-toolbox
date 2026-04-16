# Changelog

All notable changes to the HGF Toolbox are documented here.

---

## [8.1.0] — 16 April 2026

### Added
- **Unbounded HGF (uHGF)**: A third update variant alongside the classic
  HGF and eHGF. The uHGF uses a dual quadratic approximation with
  sigmoid-based interpolation at volatility levels, ensuring positive
  posterior precision throughout. The parameter space is truly unbounded —
  removing the constraints that cause the classic HGF to fail and that
  the eHGF only partially relaxes. Selected via
  `r.c_prc.update_type = 'uhgf'`
- `uhgf` and `uhgf_binary` wrappers, configs, transp, and namep files
  (introduced silently in v8.0.0, now fully documented)
- uHGF variants of all specialised binary model families:
  `uhgf_ar1_binary`, `uhgf_ar1_binary_mab`, `uhgf_binary_pu`,
  `uhgf_binary_pu_tbt`, `uhgf_jget` (wrappers, configs, transp, namep)

### Changed
- Extended all `*_config_base.m` factory functions to accept `'uhgf'`
  as a third `update_type` argument
- `hgf_ar1_binary_mab_unified.m`: Fixed uHGF compatibility
- `hgf_demo.m` / `hgf_demo.mlx`: Added uHGF sections alongside HGF and
  eHGF — binary inputs, continuous inputs, and the AR(1) binary model —
  so all three variants can be compared on the same time series

---

## [8.0.1] — 15 April 2026

### Fixed
- uHGF precision update: correctly account for time dependency and
  transformation from canonical space (`hgf_volatility_update.m`)

---

## [8.0.0] — 8 March 2026

### Added
- **Unified HGF/eHGF architecture**: All HGF and eHGF model variants now
  share the same update equations via unified implementation files (e.g.,
  `hgf_binary_unified.m`). Controlled by `r.c_prc.update_type`
- Shared building-block functions (`hgf_volatility_update.m`,
  `hgf_prediction.m`, `hgf_pihat.m`, etc.)
- `*_config_base.m` factory files for HGF/eHGF config generation
- `setup.m`: adds all subdirectories to the MATLAB path in one call
- `ARCHITECTURE.md`: comprehensive guide to file organisation, naming
  conventions, model inventory, parameter notation, and data structures
- uHGF update type (`'uhgf'`) in `hgf_volatility_update.m` and base
  configs; `uhgf`/`uhgf_binary` wrappers (stealth release)

### Changed
- Reorganised directory structure into `core/`, `building_blocks/`,
  `perceptual/`, `observation/`, `plotting/`, `utilities/`, `demo/`
- Original model files (e.g., `hgf_binary.m`, `ehgf_binary.m`) are now
  thin backward-compatible wrappers
- eHGF transp/namep/plotTraj files now delegate to their HGF counterparts
- Replaced `eval()` calls in `fitModel.m` and `sampleModel.m` with
  `str2func()`
- Updated `hgf_demo` with unified architecture explanations, auto path
  setup, and equation fixes

### Removed
- Outdated `Manual.pdf` (superseded by `ARCHITECTURE.md` and
  `hgf_demo.mlx`)

---

## [7.2.0] — 5 March 2026

- Switched to MIT licence
- Fix MIT licence file
- Update seed in fitModel
- Remove unneeded return statements at the end of files
- Undo mistaken LME calculation bugfix
- Minor bug fixes and additions

## [7.1.3]

- Minor additions and bug fixes

## [7.1.2]

- Add `ehgf_ar1_plotTraj`
- Bugfix

## [7.0.0]

- Numerical stability improvements to optimisation
- Combined response models (more than one observation per trial)
- Various bugfixes and minor improvements

## [6.1.0]

- Improved functionality of `beta_obs` response model
- Included reference to TAPAS paper

## [6.0.0]

- Introduced first eHGF models (`ehgf`, `ehgf_binary`, `ehgf_jget`)
- Enabled calling `fitModel` with config structures as arguments
- Enabled changing config structures on the fly
- Introduced `sampleModel` for sampling from the prior
- Various other additions, improvements, and bugfixes

## [5.3.0]

- Enabled setting and storing of seed for random number generator in simulations
- Fixed reading of response model configuration in `simModel`
- Reduced default `maxStep` from 2 to 1 in `quasinewton_optim_config`
- Improved readability of sim files for `unitsq_sgm` and `softmax_binary`
- Added simulation capability for `softmax_wld` and `softmax_mu3_wld`
- Added `softmax_wld` response model
- Improved readability of `softmax_mu3_wld`, `softmax`, `softmax_mu3` code

## [5.2.0]

- Brought `hgf_demo.pdf` up to date
- Added `gaussian_obs_offset` response model
- Brought example in `simModel` up to date
- Added sim and namep files for `unitsq_sgm_mu3`
- Introduced `softmax_mu3_wld` decision model
- Estimate `mu0_2` by default in `hgf_ar1_binary_mab`
- Enabled simulation for `hgf_ar1_binary_mab`
- Added `softmax_mu3`, `hgf_ar1_binary_mab`
- Fixed automatic detection of number of levels in `hgf_ar1_binary`
- Fixed `hgf_binary_mab_plotTraj` and trajectory calculations in `hgf_binary_mab`
- Adapted `riddersgradient` and `riddershessian` to new Matlab versions
- Quashed bug in `rw_binary_dual`

## [5.1.0]

- Added `condhalluc_obs` and `condhalluc_obs2` models
- Introduced `kappa1` in all binary HGF models

## [5.0.0]

- Ported interactive demo to Matlab LiveScript
- Various additional small improvements
- Updated manual
- Updated and renamed README to README.md

## [4.17.0]

- Improvements to `logrt_linear_binary_minimal`

## [4.16.0]

- Added `hgf_binary_pu_tbt` (binary HGF with trial-by-trial perceptual uncertainty)

## [4.15.0]

- Added the Kalman filter (`kf`)

## [4.14.0]

- Improved the `beta_obs` model
- Improved calculation of implied 1st-level learning rate

## [4.13.0]

- Corrected sign of update trajectories
- Added option to base responses on predictions or posteriors in `beta_obs`

## [4.12.0]

- Added `tapas_autocorr.m`

## [4.11.0]

- Predictions and residuals returned by all observation models
- Added `fit_plotResidualDiagnostics()`

## [4.10.0]

- Added `hgf_categorical_norm`
- Added Boltzmann distribution (softmax normalisation) as `tapas_boltzmann()`

## [4.9.0]

- Set implied learning rate at first level to 0 if update is zero

## [4.8.0]

- Choice of using predictions or posteriors with `softmax_binary`

## [4.7.0]

- Added `cdfgaussian_obs` model
- Added `hgf_binary_pu` (perceptual uncertainty) model
- Improvements for `beta_obs` with `hgf_whichworld`

## [4.6.0]

- Adapted `beta_obs` to work with `ph_binary`
- Added Pearce-Hall model (`ph_binary`)
- Clarified role of default settings in `fitModel` comments
- Brought `softmax_binary_sim` up to date

## [4.5.0]

- Improved comments in `softmax_binary_sim` and `beta_obs`
- Added `beta_obs_sim` and `beta_obs_namep`

## [4.4.0]

- Added `hgf_ar1_binary_namep`
- Improved `rw_binary`

## [4.3.0]

- Added `bayes_optimal_categorical`
- Improved `hgf_categorical_plotTraj`

## [4.2.0]

- Adapted `softmax_sim` to `hgf_categorical`
- Added `hgf_categorical` and categorical data example

## [4.1.0]

- Improved `hgf_jget`

## [4.0.0]

- Added PDF manual and interactive demo (`hgf_demo`)
- Added `hgf_demo_commands` file of raw demo commands
- Adapted `fitModel` to calculate AIC and BIC
- Renamed F (negative variational free energy) to LME (log-model evidence)
- Added `hhmm`, `hmm`, `hgf_whatworld`, `hgf_whichworld`, `hgf_ar1_binary`,
  `hgf_jget`, `hgf_binary_mab`, `softmax_2beta`, `logrt_linear_binary`,
  `rw_binary_dual`, `unitsq_sgm_mu3`, `beta_obs`
- Abolished theta; moved kappa estimation to log-space
- Introduced trajectory validity checking

## [3.0.0]

- Improved error handling in `fitModel`
- Prefixed all function names with `tapas_`
- Added `rs_precision`, `rs_belief`, `rs_surprise`, `sutton_k1`, `hgf_ar1_mab`
- Added softmax for continuous responses
- Improved trajectory validity checking

## [2.1.0]

- Introduced Bayesian parameter averaging
- Fixed calculation of log-priors in `fitModel`
- Fixed construction of time axis in `hgf_plotTraj`

## [2.0.0]

- Estimation of Bayes optimal parameters added
- Generalised `hgf_binary` to n levels
- Input at irregular intervals enabled
- Support for constant drift and AR(1) processes
- Various structural improvements

## [1.0.0]

- Original release
