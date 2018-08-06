function err_list = spm_exec_mult_jobs(job_list)
% _
% Execute Multiple Jobs using SPM
% FORMAT err_list = spm_exec_mult_jobs(job_list)
% 
%     job_list - cell array of batch editor job filenames
%     err_list - cell array of jobs that didn't work out
% 
% FORMAT spm_exec_mult_jobs(job_list) loads the batch editor job filenames
% specified by job_list and executes all batches using spm_jobman.m.
% 
% FORMAT spm_exec_mult_jobs opens the SPM file selector using spm_select.m
% and lets you select the batch editor jobs to be executed.
% 
% FORMAT err_list = spm_exec_mult_jobs(...) outputs all job filenames that
% caused an error message in MATLAB when being executed.
% 
% Author: Joram Soch, BCCN Berlin
% E-Mail: joram.soch@bccn-berlin.de
% 
% First edit: 19/12/2013, 16:10
%  Last edit: 06/08/2018, 15:00


% Determine origin
%-------------------------------------------------------------------------%
orig_dir = pwd;
fprintf('\n');

% Select jobs if required
%-------------------------------------------------------------------------%
if nargin == 0
    job_list = cellstr(spm_select(Inf, 'batch', 'Please select all batches that you want to run!', [], pwd, '.mat', '1'));
    err_list = spm_exec_mult_jobs(job_list);
    return
end;

% Execute batch editor jobs
%-------------------------------------------------------------------------%
num_jobs = numel(job_list);
err_jobs = zeros(num_jobs,1);
for i = 1:num_jobs
    % get filename of batch
    filename = job_list{i};
    prefix   = filename(1:floor(1/3*length(filename)));
    suffix   = filename(ceil(2/3*length(filename)):end);
    fprintf('-> Batch %s out of %s: "%s...%s"', num2str(i), num2str(num_jobs), prefix, suffix);
    % try to execute batch
    try
        spm_jobman('run',filename);
    catch
        err_jobs(i) = 1;
    end
end;

% Display erroneous batches
%-------------------------------------------------------------------------%
num_errs = sum(err_jobs);
err_list = job_list(err_jobs==1);
if num_errs > 0
    fprintf('\n-> The following batches did not run properly:\n');
    for j = 1:num_errs
        fprintf('   - "%s" \n', err_list{j});
    end;
else
    err_list = {};
end;

% Return to origin
%-------------------------------------------------------------------------%
cd(orig_dir);
fprintf('\n');