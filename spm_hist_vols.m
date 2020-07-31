function [n, x] = spm_hist_vols(vols, bins)
% _
% Histograms over Volumes
% FORMAT [n, x] = spm_hist_vols(vols, bins)
% 
%     vols - an m x 1 cell array specifying file paths of images
%     bins - an integer indicating the number of bins for the histogram
% 
%     n    - an m x bins matrix of the number of elements in each bin
%     x    - an m x bins matrix with the locations of the bin centers
% 
% FORMAT [n, x] = spm_hist_vols(vols, bins) loads all the images specified
% by vols and plots a voxel-wide histogram with bins bars for each image.
% All images need to have the same dimensions.
% 
% If the input variable "bins" is left empty, it will be set to sqrt(v),
% rounded towars infinity, where v is the number of voxels in which all
% images are not NaN. If this number of bins is lower than 100, the number
% of bins is set to 100.
% 
% Exemplary usage:
%     [n, x] = spm_hist_vols({'C:\f0001.img'}, 100);
% 
% Author: Joram Soch, BCCN Berlin
% E-Mail: joram.soch@bccn-berlin.de
% 
% First edit: 18/11/2014, 18:40
%  Last edit: 31/07/2020, 16:11


% Get paths if required
%-------------------------------------------------------------------------%
if nargin < 1 || isempty(vols)
    vols = cellstr(spm_select(Inf, 'image', 'Please select all images that you want to see as a histogram!', [], pwd, '.*', '1'));
end;

% Load all volumes
%-------------------------------------------------------------------------%
[out, V] = spm_calc_vols('size(V)', vols);
m = length(vols);
clear out

% Remove NaN values
%-------------------------------------------------------------------------%
I = isnan(V);
J = sign(sum(I,1));
V = V(:,~J);
clear I J

% Get bins if required
%-------------------------------------------------------------------------%
if nargin < 2 || isempty(bins)
    bins = min([ceil(sqrt(size(V,2))) 100]);
end;
n = zeros(m,bins);
x = zeros(m,bins);

% Display histograms
%-------------------------------------------------------------------------%
figure;
a = ceil(sqrt(m));
b = ceil(m/a);

for i = 1:m
    
    % Discard outliers
    %---------------------------------------------------------------------%
    Vi = V(i,:);
    if all(Vi>=0 & Vi<=1)               % all values between 0 and 1
        qi = [0 1];
    else
        if all(Vi>=0)                   % all values greater than 0
            qi = [0 MF_quantile(Vi, 0.99)];
        else                            % none of these conditions
            qi = MF_quantile(Vi, [0.01 0.99]);
        end;
    end;
    Vi = Vi(Vi>=qi(1) & Vi<=qi(2));
    
    % Calculate bins
    %---------------------------------------------------------------------%
    [n(i,:), x(i,:)] = hist(Vi, bins);
    
    % Plot histogram
    %---------------------------------------------------------------------%
    subplot(b,a,i);
    hold on;
    bar(x(i,:), n(i,:), 'b');
    axis([qi 0 max(n(i,:))*(1+1/10)]);
    xlabel(sprintf('Value of Volume %s', num2str(i)), 'FontSize', 12);
    ylabel('Number of Voxels', 'FontSize', 12);
    
end;


% Quantile function (from MACS)
%-------------------------------------------------------------------------%
function q = MF_quantile(y,p)
% _
% Quantiles for univariate data
% FORMAT q = MF_quantile(y,p)
% 
%     y - a vector of sample data from a random variable
%     p - a k x 1 vector of percentages between 0 and 1
% 
%     q - a k x 1 vector of quantiles for these percentages
% 
% FORMAT q = MF_quantile(y,p) returns quantiles for data y at cut-offs p.
% For example, the q for p = 0.5 would be the median, a value chosen such
% that 50% of the data are smaller than this threshold.


% Sort data
%-------------------------------------------------------------------------%
ys = sort(y);

% Get quantiles
%-------------------------------------------------------------------------%
q = NaN(size(p));
for j = 1:length(p)
    i = 1;
    n = numel(ys);
    while (i/n) < p(j)
        i = i + 1;
    end;
    q(j) = ys(i);
end;