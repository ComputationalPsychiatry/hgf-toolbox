function y = tapas_condhalluc_obs_sim(r, infStates, p)
% Simulates responses according to the condhalluc_obs model

% Inverse decision temparature beta is the only parameter
be = p;

% Prediction trajectory
mu1hat = infStates(:,1,1);

% Get true-positive rate corresponding to stimuli
tp = r.u(:,2);

% Calculate belief x using Bayes' theorem
x = tp.*mu1hat./(tp.*mu1hat + (1-mu1hat).^2);

% Belief is mu1hat in trials where there is no tone
x(find(tp==0)) = mu1hat(find(tp==0));

% Apply the logistic sigmoid to the inferred beliefs
prob = tapas_sgm(be.*(2.*x-1),1);

% Initialize random number generator
if isnan(r.c_sim.seed)
    rng('shuffle');
else
    rng(r.c_sim.seed);
end

% Simulate
y = binornd(1, prob);

return;
