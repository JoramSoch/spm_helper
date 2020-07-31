function [R, P] = spm_corr_vols(vols)
% _
% Correlations between Volumes
% FORMAT [R, P] = spm_corr_vols(vols)
% 
%     vols - an n x 1 cell array specifying file paths of images
% 
%     R    - an n x n matrix of Pearson correlation coefficients
%     P    - an n x n matrix of p-values for these correlations
% 
% FORMAT [R, P] = spm_corr_vols(vols) loads all the images specified by vols
% and computes voxel-wide correlation coefficients for all pairs of images.
% All images need to have the same dimensions.
% 
% Exemplary usage:
%     [R, P] = spm_corr_vols({'C:\f0001.img'; 'C:\f0002.img'})
% 
% Author: Joram Soch, BCCN Berlin
% E-Mail: joram.soch@bccn-berlin.de
% 
% First edit: 13/11/2014, 10:55
%  Last edit: 31/07/2020, 16:16


% Get paths if required
%-------------------------------------------------------------------------%
if nargin < 1 || isempty(vols)
    vols = cellstr(spm_select(Inf, 'image', 'Please select all images that you want to correlate!', [], pwd, '.*', '1'));
end;

% Load all volumes
%-------------------------------------------------------------------------%
[out, V] = spm_calc_vols('size(V)', vols);
n = size(V,1);
V = V';
clear out

% Remove NaN values
%-------------------------------------------------------------------------%
I = isnan(V);
J = sign(sum(I,2));
V = V(~J,:);
clear I J

% Correlate images
%-------------------------------------------------------------------------%
[R, P] = corr(V);

% Display correlations
%-------------------------------------------------------------------------%
figure;

% Plot correlations
%-------------------------------------------------------------------------%
subplot(1,2,1);
hold on;
imagesc(R);
caxis([-1 +1]);
axis([(1-0.5) (n+0.5) (1-0.5) (n+0.5)]);
axis ij square
if n <= 10
    for i1 = 1:n
        for i2 = 1:n
            text(i1, i2, num2str(R(i1,i2),3), 'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Middle');
        end;
    end;
    set(gca,'XTick',[1:n]);
    set(gca,'YTick',[1:n]);
end;
colorbar('Location', 'EastOutside');
title('Correlations', 'FontSize', 20);

% Plot p-values
%-------------------------------------------------------------------------%
subplot(1,2,2);
hold on;
imagesc(P);
caxis([0 1]);
axis([(1-0.5) (n+0.5) (1-0.5) (n+0.5)]);
axis ij square
if n <= 10
    for i1 = 1:n
        for i2 = 1:n
            text(i1, i2, num2str(P(i1,i2),3), 'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Middle');
        end;
    end;
    set(gca,'XTick',[1:n]);
    set(gca,'YTick',[1:n]);
end;
colorbar('Location', 'EastOutside');
title('P-values', 'FontSize', 20);

% Display scatterplots
%-------------------------------------------------------------------------%
figure;
n = min([6, n]);

for i1 = 1:n
    for i2 = 1:n
        if i1 ~= i2

            % Find regression line
            %-------------------------------------------------------------%
            p = polyfit(V(:,i1)',V(:,i2)',1);
            x = [min(V(:,i1)) max(V(:,i1))];
            y = p(1)*x + p(2);

            % Plot data and line
            %-------------------------------------------------------------%
            subplot(n,n,(i2-1)*n+i1);
            hold on;
            plot(V(:,i1)', V(:,i2)', '.b', 'MarkerSize', 1);
            plot(x, y, '-k', 'LineWidth', 1);
            axis([min(V(:,i1)) max(V(:,i1)) min(V(:,i2)) max(V(:,i2))]);
            xlabel(sprintf('Volume %s', num2str(i1)), 'FontSize', 12);
            ylabel(sprintf('Volume %s', num2str(i2)), 'FontSize', 12);

        end;
    end;
end;