%% This script contains the raw commands of the tutorial demo (hgfTB_demo.m) for the HGF toolbox

if ~exist('fitModel', 'file')
    activeDoc = matlab.desktop.editor.getActive();
    toolboxRoot = fileparts(fileparts(activeDoc.Filename));
    run(fullfile(toolboxRoot, 'setup.m'));
end

demodir = fileparts(which('hgf_demo_commands'));
%%
u = load(fullfile(demodir, 'example_binary_input.txt'));

%%
bopars = fitModel([], u, 'hgf_binary_config', 'bayes_optimal_binary_config', 'quasinewton_optim_config');

%%
sim = simModel(u, 'hgf_binary', [NaN 0 1 NaN 1 1 NaN 0 0 NaN 1 NaN -2.5 -6], 'unitsq_sgm', 5);

%%
hgf_binary_plotTraj(sim)

%%
est = fitModel(sim.y, sim.u, 'hgf_binary_config', 'unitsq_sgm_config', 'quasinewton_optim_config');
%%
fit_plotCorr(est)
%%
disp(est.optim.Corr)
%%
disp(est.optim.Sigma)
%%
disp(est.p_prc)
%%
disp(est.p_obs)
%%
hgf_binary_plotTraj(est)
%%
disp(est.traj)

%%
est1a = fitModel(sim.y, sim.u, 'rw_binary_config', 'unitsq_sgm_config', 'quasinewton_optim_config');
%%
fit_plotCorr(est1a)
%%
rw_binary_plotTraj(est1a)

%%
usdchf = load(fullfile(demodir, 'example_usdchf.txt'));

%%
bopars2 = fitModel([], usdchf, 'hgf_config', 'bayes_optimal_config', 'quasinewton_optim_config');
%%
fit_plotCorr(bopars2)
%%
hgf_plotTraj(bopars2)

%%
sim2 = simModel(usdchf, 'hgf', [1.04 1 0.0001 0.1 0 0 1 -13  -2 1e4], 'gaussian_obs', 0.00002);
%%
hgf_plotTraj(sim2)

%%
sim2a = simModel(usdchf, 'hgf', [1.04 1 1 0.0001 0.1 0.1 0 0 0 1 1 -13  -2 -2 1e4], 'gaussian_obs', 0.00005);
%%
hgf_plotTraj(sim2a)
%%
figure
plot(sim2a.traj.wt)
xlim([1, length(sim2a.traj.wt)])
legend('1st level', '2nd level', '3rd level')
xlabel('Trading days from Jan 1, 2010')
ylabel('Weights')
title('Precision weights')

%%
est2 = fitModel(sim2.y, usdchf, 'hgf_config', 'gaussian_obs_config', 'quasinewton_optim_config');
%%
fit_plotCorr(est2)
%%
hgf_plotTraj(est2)

%%
sim2b = simModel(usdchf, 'hgf', [1.04 1 0.0001 0.1 0 0 1 -15  -2.5 1e4], 'gaussian_obs', 0.00002);
%%
hgf_plotTraj(sim2b)

%%
est2b = fitModel(sim2b.y, usdchf, 'hgf_config', 'gaussian_obs_config', 'quasinewton_optim_config');
%%
fit_plotCorr(est2b)
%%
hgf_plotTraj(est2b)

%%
bpa = bayesian_parameter_average(est2, est2b);
%%
fit_plotCorr(bpa)
%%
hgf_plotTraj(bpa)

%% Enhanced HGF (eHGF)
% The eHGF uses a safe precision update that prevents negative precision.
% It shares the same unified implementation as the classic HGF, controlled
% by the update_type flag ('hgf' or 'ehgf') in the config.

%%
esim = simModel(u, 'ehgf_binary', [NaN 0 1 NaN 1 1 NaN 0 0 1 1.5 NaN -4 3], 'unitsq_sgm', 5, 123456789);
%%
ehgf_binary_plotTraj(esim)
%%
eest = fitModel(esim.y, esim.u, 'ehgf_binary_config', 'unitsq_sgm_config', 'quasinewton_optim_config');
%%
ehgf_binary_plotTraj(eest)
