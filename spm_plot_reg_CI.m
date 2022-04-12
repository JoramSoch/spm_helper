function [x, y, xr, yr, CI] = spm_plot_reg_CI(SPM, cov, xyz, alpha, reg_plot)
% _
% Plot Regression with Confidence Interval
% FORMAT [x, y, xr, yr, CI] = spm_plot_reg_CI(SPM, cov, xyz, alpha, reg_plot)
% 
%     SPM      - a structure specifying an estimated GLM
%     cov      - an integer indexing the covariate to be used
%     xyz      - a 1 x 3 vector of MNI coordinates [mm]
%     alpha    - the significance level, CIs are (1-alpha)
%     reg_plot - logical indicating whether to plot regression
% 
%     x        - an  n x 1 vector of independent variable values
%     y        - an  n x 1 vector of dependent variable values
%     xr       - a 100 x 1 vector of regression line x-values
%     yr       - a 100 x 1 vector of regression line y-values
%     CI       - a 2 x 100 matrix of regression confidence bands
% 
% FORMAT [x, y, xr, yr, CI] = spm_plot_reg_CI(SPM, cov, xyz, alpha, reg_plot)
% computes and displays regression line as well as (1-alpha) confidence
% bands [1,2] for a linear relationship of measured responses with the
% covariate indexed by cov at selected coordinates xyz.
% 
% References:
% [1] Schlegel A (2016). Linear Regression Confidence Intervals.
%     URL: https://rstudio-pubs-static.s3.amazonaws.com/195401_
%     20b3272a8bb04615ae7ee4c81d18ffb5.html.
% [2] Alexis (2014). Understanding shape and calculation of confidence bands
%     in linear regression. URL: https://stats.stackexchange.com/a/101327.
% [3] Glen_b (2014). Shape of confidence interval for predicted values
%     in linear regression. URL: https://stats.stackexchange.com/a/85565.
% 
% Author: Joram Soch, BCCN Berlin
% E-Mail: joram.soch@bccn-berlin.de
% 
% First edit: 16/08/2021, 11:57
%  Last edit: 17/08/2021, 15:03


% Set defaults
%-------------------------------------------------------------------------%
if isempty(cov)      || nargin < 2, cov      = 1;      end;
if isempty(xyz)      || nargin < 3, xyz      =[0,0,0]; end;
if isempty(alpha)    || nargin < 4, alpha    = 0.1;    end;
if isempty(reg_plot) || nargin < 5, reg_plot = true;   end;

% Change directory
%-------------------------------------------------------------------------%
try
    cd(SPM.swd);
catch
    SPM.swd = pwd;
end

% Load mask image
%-------------------------------------------------------------------------%
m_dim = SPM.VM.dim;
[m_img, m_xyz]   = spm_read_vols(SPM.VM);
d_img = sqrt(sum((m_xyz - repmat(xyz',[1 prod(m_dim)])).^2, 1));
[d_min, xyz_ind] = min(d_img);
clear m_dim m_img m_xyz d_img d_min

% Get covariate values
%-------------------------------------------------------------------------%
x  = SPM.xC(cov).rc;
xL = SPM.xC(cov).rcname;

% Get signal values
%-------------------------------------------------------------------------%
n = numel(x);
y = zeros(n,1);
for i = 1:n
    y_img = spm_read_vols(SPM.xY.VY(i));
    y(i)  = y_img(xyz_ind);
end;
clear y_img

% Perform linear regression
%-------------------------------------------------------------------------%
X = [ones(n,1), x];
b = (X'*X)^(-1) * X'*y;

% Find variable ranges
%-------------------------------------------------------------------------%
y_min = min(y)-1/20*range(y);
y_max = max(y)+1/20*range(y);
x_min = min(x)-1/20*range(x);
x_max = max(x)+1/20*range(x);

% Create regression line
%-------------------------------------------------------------------------%
m  = 100;
xr = [x_min:((x_max-x_min)/(m-1)):x_max]';
Xr = [ones(m,1), xr];
yr = Xr*b;

% Create confidence intervals
%-------------------------------------------------------------------------%
SSX   = sum((x - mean(x)).^2);
SSE   = sum((y - X*b).^2);
SE_yr = sqrt(SSE/(n-2)) * sqrt( 1/n + 1/SSX*((xr-mean(x)).^2) );
CI_yr = SE_yr * tinv(1-alpha, n-2);
CI    = [yr - CI_yr, yr + CI_yr]';

% Plot estimates and intervals
%-------------------------------------------------------------------------%
if reg_plot

    figure;
    hold on;
    plot(x, y, '.k', 'MarkerSize', 15);
    plot(xr, yr, '-b', 'LineWidth', 2);
    plot(xr', CI(1,:), '--b', 'LineWidth', 2);
    plot(xr', CI(2,:), '--b', 'LineWidth', 2);
    axis([x_min, x_max, y_min y_max]);
    set(gca,'Box','On');
    xlabel('covariate value', 'FontSize', 12);
    ylabel(sprintf('measured response at [%d, %d, %d]', xyz(1), xyz(2), xyz(3)), 'FontSize', 12);
    title(sprintf('Predicted responses and %d%% confidence bands: %s', round((1-alpha)*100), xL), 'FontSize', 16);

end;