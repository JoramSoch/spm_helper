# spm_helper

<h3>Little Helpers for Statistical Parametric Mapping</h3>

<img src="https://vignette.wikia.nocookie.net/disney/images/2/25/Filament.PNG" alt="Little Helper" height=250>

In this repository, I collect some useful helper functions for Statistical Parametric Mapping (SPM):
- `spm_analyze_RPs`: analyzes and plots movement parameters estimated by SPM
- `spm_calc_vols`: performs arbitrary mathematical operations on several volumes
- `spm_exec_mult_jobs`: executes multiple jobs created using the SPM batch editor
- `spm_gen_con_paths`: generates contrast paths to be used in second-level analyses
- `spm_save_thr_SPM`: saves thresholded statistical parametric maps for estimated GLM
- `spm_skull_strip`: skull-strips an anatomical image using the segmentation of SPM12

Most of these functions are written such that they can be called with all input arguments, e.g.

- `spm_skull_strip('C:\BIDS\sub-01\anat\sub-01_T1w.nii', 0.95)`
- `[out, V] = spm_calc_vols('sum(V~=0)', {'C:\BIDS\sub-01\glms\glm-0\mask.nii'})`,

or just using the function name, such that input arguments are specified via the SPM GUI, i.e.

- `spm_skull_strip`
- `out = spm_calc_vols`.