function bpm_edit_SPM_cons(BPM)
% _
% Edit SPM Contrast Maps after Biological Parametric Mapping
% FORMAT bpm_edit_SPM_cons(BPM)
%     BPM - a structure specifying a finished BPM analysis
% 
% FORMAT bpm_edit_SPM_cons(BPM) loads the SPM.mat and contrast images
% associated with a Biological Parametric Mapping (BPM) [1] analysis
% and converts contrasts from two-file img/hdr to one-file nii images.
% 
% This function requires that
%   (i) a BPM analysis has been performed (-> BPM.mat),
%  (ii) contrasts have been generated ("BPM Contrast Manager") and
% (iii) contrasts have been prepare for SPM ("SPM Insertion Tool").
% The code has been validated for use with BPMe 3.1 [1] and SPM12.
% 
% References:
% [1] Jang et al. (2019). Robust Biological Parametric Mapping Toolbox;
%     URL: https://www.nitrc.org/frs/download.php/5081/BPMe_3.1.zip.
% 
% Author: Joram Soch, DZNE Göttingen
% E-Mail: Joram.Soch@DZNE.de
% 
% First edit: 19/07/2021, 14:11
%  Last edit: 26/07/2021, 16:03

% Edits by Jasmin Kizilirmak: 09/11/2021


% Load SPM.mat file
%-------------------------------------------------------------------------%
SPM_mat = strcat(BPM.result_dir,'/','SPM.mat');
load(SPM_mat);
cd(SPM.swd);

% Edit contrast images
%-------------------------------------------------------------------------%
num_con = numel(SPM.xCon);
for i = 1:num_con
    filename = strcat(SPM.swd,'/',SPM.xCon(i).Vspm.fname);
    con_hdr  = spm_vol(filename);
    con_img  = spm_read_vols(con_hdr);
    con_hdr.fname    = strcat(SPM.xCon(i).Vspm.fname(1:end-4),'.nii');
    spm_write_vol(con_hdr, con_img);
    % SPM.xCon.Vspm - Name of SPM image
    SPM.xCon(i).Vspm = con_hdr;
    % get correct plane info from 1st subject, overwrite pinfo in contrasts
    SPM.xCon(i).Vspm.pinfo = SPM.xY.VY(1,1).pinfo;
    % SPM.xCon.c - Contrast weights
    if iscell(BPM.contrast) % for multiple regression
        SPM.xCon(i).c = BPM.contrast{i};
    else % for ANOVA and ANCOVA
        SPM.xCon(i).c = BPM.contrast(i,:);
    end
    % SPM.xX.X - Design matrix; BPM does not include one in BPM.mat
end
clear filename con_hdr con_img

% Save SPM.mat file
%-------------------------------------------------------------------------%
save(SPM_mat, 'SPM');