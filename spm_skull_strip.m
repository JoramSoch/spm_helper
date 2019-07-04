function spm_skull_strip(anat_path, tp_thr)
% _
% Skull-Strip Anatomical Image using SPM12
% FORMAT spm_skull_strip(anat_path, tp_thr)
%     anat_path - path to an anatomical (e.g. T1 or PD) image
%     tp_thr    - tissue probability threshold applied to GM+WM+CSF
% 
% FORMAT spm_skull_strip(anat_path, tp_thr) segments an anatomical image
% and uses the segmentation components to skull-strip the image by applying
% a threshold to the combined probability of gray matter (GM), white matter
% (WM) and cerebro-spinal fluid (CSF).
% 
% Author: Joram Soch, BCCN Berlin
% E-Mail: joram.soch@bccn-berlin.de
% 
% First edit: 02/07/2019, 14:50
%  Last edit: 03/07/2019, 12:20


% Set parameters if required
%-------------------------------------------------------------------------%
if nargin == 0
    anat_path = spm_select(1, 'image', 'Please select anatomical (e.g. T1 or PD) image!');
    tp_thr    = spm_input('Tissue probability threshold:', 1, 'r', '0.95');
end;

% Load anatomical image
%-------------------------------------------------------------------------%
anat_hdr = spm_vol(anat_path);
anat_img = spm_read_vols(anat_hdr);

% Create segmentation job
%-------------------------------------------------------------------------%
spm_dir   = spm('Dir');
num_gauss = [1, 1, 2, 3, 4, 2];
nat_space = [1, 1, 1, 1, 1, 0];
matlabbatch{1}.spm.spatial.preproc.channel.vols{1}  = anat_path;
matlabbatch{1}.spm.spatial.preproc.channel.biasreg  = 0.001;
matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
matlabbatch{1}.spm.spatial.preproc.channel.write    = [0 0];
for i = 1:6
    matlabbatch{1}.spm.spatial.preproc.tissue(i).tpm{1} = strcat(spm_dir,'/tpm/TPM.nii,',int2str(i));
    matlabbatch{1}.spm.spatial.preproc.tissue(i).ngaus  = num_gauss(i);
    matlabbatch{1}.spm.spatial.preproc.tissue(i).native = [nat_space(i) 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(i).warped = [0 0];
end;
matlabbatch{1}.spm.spatial.preproc.warp.mrf     = 1;
matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
matlabbatch{1}.spm.spatial.preproc.warp.reg     = [0 0.001 0.5 0.05 0.2];
matlabbatch{1}.spm.spatial.preproc.warp.affreg  = 'mni';
matlabbatch{1}.spm.spatial.preproc.warp.fwhm    = 0;
matlabbatch{1}.spm.spatial.preproc.warp.samp    = 3;
matlabbatch{1}.spm.spatial.preproc.warp.write   = [0 0];

% Perform segmentation job
%-------------------------------------------------------------------------%
spm_jobman('run',matlabbatch);

% Load segmentation results
%-------------------------------------------------------------------------%
[work_dir, anat_name, img_ext] = fileparts(anat_path);
if ~isempty(strfind(img_ext,','))
    img_ext = img_ext(1:strfind(img_ext,',')-1);
end;
gm_str  = strcat(work_dir,'/','c1',anat_name,img_ext);
gm_hdr  = spm_vol(gm_str);
gm_img  = spm_read_vols(gm_hdr);
wm_str  = strcat(work_dir,'/','c2',anat_name,img_ext);
wm_hdr  = spm_vol(wm_str);
wm_img  = spm_read_vols(wm_hdr);
csf_str = strcat(work_dir,'/','c3',anat_name,img_ext);
csf_hdr = spm_vol(csf_str);
csf_img = spm_read_vols(csf_hdr);

% Skull-strip anatomical image
%-------------------------------------------------------------------------%
anat_img(gm_img+wm_img+csf_img < tp_thr) = NaN;
anat_hdr.fname   = strcat(work_dir,'/','ss',anat_name,img_ext);
anat_hdr.descrip = sprintf('spm_skull_strip: skull-stripped version of "%s%s"', anat_name, img_ext);
spm_write_vol(anat_hdr, anat_img);