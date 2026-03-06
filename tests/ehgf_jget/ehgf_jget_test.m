% Scritp to test the ehgf_jget model

% ADAPT gaussian_obs_config.m TO CONTAIN THE FOLLOWING SETTINGS:
% c.logzemu = log(10);
% c.logzesa = 5^2;

% Start from clean slate
close all; clear variables; clc;
% Add path to toolbox
addpath(genpath('../..'));
% Load trajectories of input and ground truth
load('TRT_5trajs.mat');
% Which of the five possible input sequences?
inseq = 1;
% Number of inputs
n = size(TRT_Data.rew_traj_set, 1);
% Initialize inputs
u = NaN(n, 3);
% Fill inputs
u(:,1) = TRT_Data.rew_traj_set(:, inseq);
u(:,2) = TRT_Data.mu_traj_set(:, inseq);
u(:,3) = TRT_Data.sd_traj_set(:, inseq);
% Perceptual parameters
c_prc = [u(1,1) 1 16 1 -4 -4 1 4 1 1 1 8 -1 0 4 2];
% Observation parameters
c_obs = [log(10)];
% Simulate responses
sim = simModel(u, 'ehgf_jget', c_prc, 'gaussian_obs', c_obs, 123456789);
% Plot simulation
ehgf_jget_plotTraj(sim)
% Estimate from simulated values
est = fitModel(sim.y, sim.u, 'ehgf_jget_config', 'gaussian_obs_config');
% Plot estimation
ehgf_jget_plotTraj(est)
