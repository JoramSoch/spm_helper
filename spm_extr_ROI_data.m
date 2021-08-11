function Y = spm_extr_ROI_data(data, ROIs)
% _
% Extract ROI Averages from Data Images
% FORMAT Y = spm_extr_ROI_data(data, ROIs)
% 
%     data - an n x 1 cell array with file paths to data images
%     ROIs - an r x 1 cell array with file paths to ROI images
% 
%     Y    - an n x r matrix with ROI averages
% 
% FORMAT Y = spm_extr_ROI_data(data, ROIs) loads data images as well as
% region of interest images and returns ROI-wise averages from each data
% volume.
% 
% FORMAT Y = spm_extr_ROI_data; uses the SPM file selector, such that the
% user can enter data and ROI images via the GUI.
% 
% Author: Joram Soch, BCCN Berlin
% E-Mail: joram.soch@bccn-berlin.de
% 
% First edit: 02/07/2021, 15:53
%  Last edit: 02/07/2021, 16:35


% Get paths if required
%-------------------------------------------------------------------------%
if nargin < 1 || isempty(data)
    data = cellstr(spm_select(Inf, 'image', 'Please select data images to extract from!', [], pwd, '.*', '1'));
end;
if nargin < 2 || isempty(ROIs)
    ROIs = cellstr(spm_select(Inf, 'image', 'Please select ROI images to extract with!', [], pwd, '.*', '1'));
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
        Y(i,j) = mean(d_img(R(j,:)~=0),'omitnan');
    end;
    spm_progress_bar('Set',(i/n)*100);
end;
spm_progress_bar('Clear');
clear r_hdr r_img d_hdr d_img