function [cb, CI] = spm_plot_con_CI(SPM, con, xyz, alpha, CI_plot)
% _
% Plot Contrast with Confidence Intervals
% FORMAT [cb, CI] = spm_plot_con_CI(SPM, con, xyz, alpha, CI_plot)
% 
%     SPM     - a structure specifying an estimated GLM
%     con     - an integer indexing the contrast to be used
%     xyz     - a 1 x 3 vector of MNI coordinates [mm]
%     alpha   - the significance level, CIs are (1-alpha)
%     CI_plot - logical indicating whether to plot CIs
% 
%     cb      - a 1 x q vector of contrast estimates
%     CI      - a 1 x q vector of confidence intervals
%               where q is the 2nd dim of the contrast matrix
% 
% FORMAT [cb, CI] = spm_plot_con_CI(SPM, con, xyz, alpha, CI_plot) com-
% putes and displays contrast estimates and (1-alpha) confidence intervals
% of a contrast indexed by con at selected coordinates xyz [1].
% 
% References:
% [1] Carlin J (2010). Extracting beta, standard error and confidence
%     intervals for a coordinate. URL: https://imaging.mrc-cbu.cam.ac.uk/
%     imaging/Extracting_beta,_standard_error_and_confidence_interval_for_a_coordinate
% 
% Author: Joram Soch, BCCN Berlin
% E-Mail: joram.soch@bccn-berlin.de
% 
% First edit: 20/08/2020, 22:45
%  Last edit: 24/08/2020, 14:33


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

% Load betas and sigma^2
%-------------------------------------------------------------------------%
p = numel(SPM.Vbeta);
b = zeros(p,1);
for j = 1:p
    b_img = spm_read_vols(SPM.Vbeta(j));
    b(j)  = b_img(xyz_ind);
end;
s2_img = spm_read_vols(SPM.VResMS);
s2     = s2_img(xyz_ind);
covB   = SPM.xX.Bcov;
clear b_img s2_img

% Get contrast estimates
%-------------------------------------------------------------------------%
c  = SPM.xCon(con).c;
q  = size(c,2);
cb = c'*b;

% Get confidence intervals
%-------------------------------------------------------------------------%
SE = diag(sqrt(s2 * c'*covB*c));
CI = 2*SE*norminv(1-alpha/2, 0, 1);

% Plot estimates and intervals
%-------------------------------------------------------------------------%
if CI_plot

    figure;
    hold on;
    bar([1:q], cb, 'b');
    errorbar([1:q], cb, CI./2, CI./2, '.k', 'LineWidth', 2, 'CapSize', 20);
    axis([(1-0.5), (q+0.5), (11/10)*min([min(cb), 0])-max(CI)/2, (11/10)*max([max(cb), 0])+max(CI)/2]);
    set(gca,'Box','On');
    set(gca,'XTick',[1:q]);
    xlabel('contrast row/column', 'FontSize', 12);
    ylabel(sprintf('contrast estimate at [%d, %d, %d]', xyz(1), xyz(2), xyz(3)), 'FontSize', 12);
    title(sprintf('Contrast estimates and %d%% confidence intervals: %s', round((1-alpha)*100), SPM.xCon(con).name), 'FontSize', 16);

end;