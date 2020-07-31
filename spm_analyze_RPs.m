function [TPs, RPs] = spm_analyze_RPs(RP_file, RP_plot)
% _
% Analyze Realignment Parameters from SPM
% FORMAT [TPs, RPs] = spm_analyze_RPs(RP_file, RP_plot)
% 
%     RP_file - string indicating realignment parameter filename
%     RP_plot - logical indicating whether to plot parameters
% 
%     TPs     - 3 x 3 matrix with translation parameter min, max & range
%     RPs     - 3 x 3 matrix with rotation    parameter min, max & range
% 
% FORMAT [TPs, RPs] = spm_analyze_RPs(RP_file, RP_plot) loads realignment
% parameters and returns minima, maxima and ranges for translation as well
% as rotation parameters. Optionally, parameters can be plotted.
% 
% Author: Joram Soch, BCCN Berlin
% E-Mail: joram.soch@bccn-berlin.de
% 
% First edit: 19/02/2015, 06:45
%  Last edit: 31/07/2020, 16:21


% Select file if required
%-------------------------------------------------------------------------%
if nargin == 0
    RP_file    = spm_select(1, 'any', 'Please select realignment parameter file!', [], pwd, 'rp.*', '1');
    [TPs, RPs] = spm_analyze_RPs(RP_file, true);
    return
end;

% Activate plot if necessary
%-------------------------------------------------------------------------%
if nargin < 2 || isempty(RP_plot), RP_plot = true; end;

% Load realignment paramerters
%-------------------------------------------------------------------------%
RP_data = load(RP_file);
[n p]   = size(RP_data);

% Analyze realignment paramerters
%-------------------------------------------------------------------------%
RP_data(:,4:6) = RP_data(:,4:6) * (180/pi); % radians to degrees
TPs = [min(RP_data(:,1:3)); max(RP_data(:,1:3))];
RPs = [min(RP_data(:,4:6)); max(RP_data(:,4:6))];
TPs = [TPs; (TPs(2,:)-TPs(1,:))];           % translations
RPs = [RPs; (RPs(2,:)-RPs(1,:))];           % rotations

% Display realignment parameters
%-------------------------------------------------------------------------%
if RP_plot
    
    figure;
    
    % Translations
    %---------------------------------------------------------------------%
    subplot(2,1,1);
    hold on;
    plot([1:n],RP_data(:,1),'-b', 'LineWidth', 2);
    plot([1:n],RP_data(:,2),'-g', 'LineWidth', 2);
    plot([1:n],RP_data(:,3),'-r', 'LineWidth', 2);
    xlim([1 n]);
    grid on;
    set(gca,'Box','On');
    legend('x-axis', 'y-axis', 'z-axis', 'Location', 'NorthWest');
    xlabel('image','FontSize',16);
    ylabel('millimeters','FontSize',16);
    title('Translations','FontSize',20);
    
    % Rotations
    %---------------------------------------------------------------------%
    subplot(2,1,2);
    hold on;
    plot([1:n],RP_data(:,4),'-b', 'LineWidth', 2);
    plot([1:n],RP_data(:,5),'-g', 'LineWidth', 2);
    plot([1:n],RP_data(:,6),'-r', 'LineWidth', 2);
    xlim([1 n]);
    grid on;
    set(gca,'Box','On');
    legend('pitch', 'roll', 'yaw', 'Location', 'NorthWest');
    xlabel('image','FontSize',16);
    ylabel('degrees','FontSize',16);
    title('Rotations','FontSize',20);
    
end;