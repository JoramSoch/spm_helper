function con_paths = spm_gen_con_paths(work_dir,subj_file,stat_dir,img_file)
% _
% Generate Contrast Pathes for SPM Second-Level Analyses
% FORMAT con_paths = spm_gen_con_paths(work_dir,subj_file,stat_dir,img_file)
% 
%     work_dir  - string indicating the root working directory
%     subj_file - string indicating file path to subjects file
%     stat_dir  - string indicating single-subject statistics directory
%     img_file  - string indicating first-level beta or contrast image
% 
%     con_paths - cell array of contrast paths composed from input data
% 
% FORMAT con_paths = spm_gen_con_paths(work_dir,subj_file,stat_dir,img_file)
% loads a text file containing subject IDs and uses them to generate
% contrast paths to simplify second-level analysis model specification.
%
% In order to use this tool, your data must be structured as follows:
%     [work_dir]\                      - directory of functional data
%     [work_dir]\[subj_id]\            - an individual subject's folder
%     [work_dir]\[subj_id]\[stat_dir]\ - a first-level analysis folder
% 
% The input variable "stat_dir" refers to the statistics directory name in
% a single-subject folder (e.g. "GLM_1") and can also specify sub-
% directories (e.g. "MS_A\GLM_1") when model spaces are used.
% 
% The input variable "img_file" can refer to any image that is located in
% these single-subject folders, i.e. SPM beta estimates ("beta_0001.nii")
% or contrast maps ("con_0001.nii") as well as any other image that was
% generated for this model (e.g. "LogModEv.img").
% 
% Author: Joram Soch, BCCN Berlin
% E-Mail: joram.soch@bccn-berlin.de
% 
% First edit: 07/08/2014, 16:10
%  Last edit: 06/08/2018, 15:10


% Set parameters if required
%-------------------------------------------------------------------------%
if nargin == 0
    work_dir  = spm_select(1, 'dir', 'Please select the root working directory!', [], pwd, '.*', '1');
    subj_file = spm_select(1, 'any', 'Please select file containing Subject IDs!', [], pwd, '.*', '1');
    stat_dir  = spm_input('Statistics Directory:',1,'s','GLM_');
    img_file  = spm_input('Beta or Contrast Image:','+1','s','con_0001.nii');
end;

% Read file with subject IDs
%-------------------------------------------------------------------------%
subj_fid = fopen(subj_file);
subj_ids = textscan(subj_fid,'%s');
subj_ids = subj_ids{1};
fclose(subj_fid);

% Generate contrast pathes
%-------------------------------------------------------------------------%
num_subj  = numel(subj_ids);
con_paths = cell(num_subj,1);
for i = 1:num_subj
    con_paths{i} = strcat(work_dir,'/',subj_ids{i},'/',stat_dir,'/',img_file);
end;

% Display contrast pathes
%-------------------------------------------------------------------------%
fprintf('\n');
for i = 1:num_subj
    fprintf('%s\n',con_paths{i});
end;
fprintf('\n');