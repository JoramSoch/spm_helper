function Y = spm_extr_ROI_data(data, ROIs, meth)
% _
% Extract ROI Averages from Data Images
% FORMAT Y = spm_extr_ROI_data(data, ROIs, meth)
% 
%     data - an n x 1 cell array with file paths to data images
%     ROIs - an r x 1 cell array with file paths to ROI images
%     meth - a string indicating the extraction method (see below)
% 
%     Y    - an n x r matrix with ROI averages
% 
% FORMAT Y = spm_extr_ROI_data(data, ROIs, meth) loads data images as well
% as region of interest images (ROIs) and returns ROI-wise averages from
% each data volume using the option meth.
% 
% FORMAT Y = spm_extr_ROI_data; uses the SPM file selector, such that the
% user can enter data and ROI images via the GUI.
% 
% Note that all data images and ROI images need to have the same dimensions,
% such that ROI voxels can be identified in the data volumes.
% 
% The input variable "meth" is a string indicating the extraction method:
% - 'mean'   : calculate average across all voxels within ROI
% - 'NaNmean': calculate average across ROI voxels, omitting NaN values
% - further options such as 'PCA' and 'eigenvariate' will be implemented
% The default value for this variable is 'NaNmean'.
% 
% Author: Joram Soch, BCCN Berlin
% E-Mail: joram.soch@bccn-berlin.de
% 
% First edit: 02/07/2021, 15:53
%  Last edit: 25/08/2021, 10:44


% Get paths if required
%-------------------------------------------------------------------------%
if nargin < 1 || isempty(data)
    data = cellstr(spm_select(Inf, 'image', 'Please select data images to extract from!', [], pwd, '.*', '1'));
end;
if nargin < 2 || isempty(ROIs)
    ROIs = cellstr(spm_select(Inf, 'image', 'Please select ROI images to extract with!', [], pwd, '.*', '1'));
end;
if nargin < 3 || isempty(meth)
    meth = 'NaNmean';
end;

% Get image dimensions
%-------------------------------------------------------------------------%
d1_hdr = spm_vol(data{1});
r1_hdr = spm_vol(ROIs{1});
if any(d1_hdr.dim ~= r1_hdr.dim)
    warning('spm_extr_ROI_data:InconsistentDimensions', 'Data images and ROI images must have the same dimensions!');
    Y = NaN(numel(data),numel(ROIs));
    return
end;

% Load ROI images
%-------------------------------------------------------------------------%
Finter = spm('FigName','spm_extr_ROI_data: load ROIs');
spm_progress_bar('Init',100,'Load ROI images...','');
r = numel(ROIs);
R = zeros(r,prod(r1_hdr.dim));
for j = 1:r
    r_hdr = spm_vol(ROIs{j});
    r_img = spm_read_vols(r_hdr);
    R(j,:)= reshape(r_img,[1 prod(r_hdr.dim)]);
    spm_progress_bar('Set',(j/r)*100);
end;
spm_progress_bar('Clear');

% Extract ROI averages
%-------------------------------------------------------------------------%
Finter = spm('FigName','spm_extr_ROI_data: load data');
spm_progress_bar('Init',100,'Extract ROI averages...','');
n = numel(data);
Y = zeros(n,r);
for i = 1:n
    d_hdr = spm_vol(data{i});
    d_img = spm_read_vols(d_hdr);
    for j = 1:r
        if strcmp(meth,'mean')
            Y(i,j) = mean(d_img(R(j,:)~=0));
        elseif strcmp(meth,'NaNmean')
            Y(i,j) = mean(d_img(R(j,:)~=0),'omitnan');
        end;
    end;
    spm_progress_bar('Set',(i/n)*100);
end;
spm_progress_bar('Clear');
clear r_hdr r_img d_hdr d_img