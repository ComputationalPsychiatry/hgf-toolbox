function fit_plotResidualDiagnostics(r)
% Plots residual autocorrelation and residuals against predictions
% USAGE:
%     est = fitModel(responses, inputs);
%     fit_plotResidualDiagnostics(est)

% Set up display
scrsz = get(0,'screenSize');
outerpos = [0.2*scrsz(3),0.2*scrsz(4),0.8*scrsz(3),0.8*scrsz(4)];
figure(...
    'OuterPosition', outerpos,...
    'Name','Residual Diagnostics');

% Residual time series
subplot(3,1,1);
res = r.optim.res;
n = size(res,1);
plot(1:n, res);
xlim([1 n]);
xlabel('Trial number');
ylabel('Residuals');
title('Time series of Residuals');

% Residual autocorrelation
subplot(3,1,2);
resAC = fftshift(r.optim.resAC);
n = size(resAC,1);
upperend = n - ceil((n+1)/2);
lowerend = upperend-n+1;
plot(lowerend:upperend, resAC);
axis([lowerend, upperend, -1, 1]);
xlabel('Lag');
ylabel('Coefficient');
title('Autocorrelation of Residuals');

% Residuals against predictions
subplot(3,1,3);
yhat = r.optim.yhat;
n = size(yhat,1);
res = r.optim.res;
plot(yhat, res, '.');
range = max(yhat)-min(yhat);
xlim([min(yhat)-0.05*range, max(yhat)+0.05*range]);
xlabel('Predictions');
ylabel('Residuals');
title('Residuals against Predictions');
