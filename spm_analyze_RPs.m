function [TPs, RPs] = spm_analyze_RPs(RP_file, RP_plot)
% _
% Analyze Realignment Parameters from SPM
% FORMAT [TPs, RPs] = spm_analyze_RPs(RP_file, RP_plot)
% 
%     RP_file - string indicating realignment parameter filename
%     RP_plot - logical indicating whether to plot parameters
% 
%     TPs     - n x 3 matrix with translation parameters
%     RPs     - n x 3 matrix with rotation parameters
% 
% FORMAT [TPs, RPs] = spm_analyze_RPs(RP_file, RP_plot) loads realignment
% parameters and returns minima, maxima and ranges for translation as well
% as rotation parameters. Optionally, parameters can be plotted.
% 
% Author: Joram Soch, BCCN Berlin
% E-Mail: joram.soch@bccn-berlin.de
% 
% First edit: 19/02/2015, 06:45
%  Last edit: 27/04/2021, 11:10


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
[n, p]  = size(RP_data);

% Analyze realignment paramerters
%-------------------------------------------------------------------------%
RP_data(:,4:6) = RP_data(:,4:6) * (180/pi); % radians to degrees
TPs = RP_data(:,1:3);                       % translations
RPs = RP_data(:,4:6);                       % rotations

% Display realignment parameters
%-------------------------------------------------------------------------%
if RP_plot
    
    figure('Name', 'Realignment Parameters', 'Color', [1 1 1], 'Position', [50 50 1600 900]);
    
    % Translations
    %---------------------------------------------------------------------%
    subplot(2,1,1);
    hold on;
    plot([1:n],TPs(:,1),'-b', 'LineWidth', 2);
    plot([1:n],TPs(:,2),'-g', 'LineWidth', 2);
    plot([1:n],TPs(:,3),'-r', 'LineWidth', 2);
    axis([(1-1), (n+1), -(11/10)*max(max(abs(TPs))), +(11/10)*max(max(abs(TPs)))]);
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
    plot([1:n],RPs(:,1),'-b', 'LineWidth', 2);
    plot([1:n],RPs(:,2),'-g', 'LineWidth', 2);
    plot([1:n],RPs(:,3),'-r', 'LineWidth', 2);
    axis([(1-1), (n+1), -(11/10)*max(max(abs(RPs))), +(11/10)*max(max(abs(RPs)))]);
    grid on;
    set(gca,'Box','On');
    legend('pitch', 'roll', 'yaw', 'Location', 'NorthWest');
    xlabel('image','FontSize',16);
    ylabel('degrees','FontSize',16);
    title('Rotations','FontSize',20);
    
end;