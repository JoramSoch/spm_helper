# spm_helper

<h3>Little Helpers for Statistical Parametric Mapping</h3>

<img src="https://vignette.wikia.nocookie.net/disney/images/2/25/Filament.PNG" alt="Little Helper" height=250>

In this repository, I collect some useful helper functions for [Statistical Parametric Mapping](https://www.fil.ion.ucl.ac.uk/spm/) (SPM):
- `spm_calc_vols`: performs arbitrary mathematical operations on several volumes
- `spm_corr_vols`: correlates a set of volumes, outputs correlations and p-values
- `spm_hist_vols`: histograms a set of volumes, outputs bin centers and voxel counts
- `spm_analyze_RPs`: analyzes and plots movement parameters estimated by SPM
- `spm_save_thr_SPM`: saves thresholded statistical parametric maps for estimated GLM
- `spm_plot_con_CI`: calculates and plots contrast estimates with confidence intervals
- `spm_plot_reg_CI`: calculates and plots regression lines with confidence intervals
- `spm_extr_ROI_data`: extracts average values from data images using ROI masks
- `spm_gen_con_paths`: generates contrast paths to be used in second-level analyses
- `spm_exec_mult_jobs`: executes multiple jobs created using the SPM batch editor
- `spm_skull_strip`: skull-strips an anatomical image using the segmentation of SPM12
- `bpm_edit_SPM_cons`: edits SPM contrast maps after [BPM analysis](https://www.nitrc.org/frs/?group_id=433&release_id=1909) has been performed

Most of these functions are written such that they can be called with all input arguments, e.g.

- `spm_skull_strip('C:\BIDS\sub-01\anat\sub-01_T1w.nii', 0.95)`
- `[out, V] = spm_calc_vols('sum(V~=0)', {'C:\BIDS\sub-01\glms\glm-0\mask.nii'})`,

or just using the function name, such that input arguments are specified via the SPM GUI, i.e.

- `spm_skull_strip`
- `out = spm_calc_vols`.

To get started, simply type `help spm_fct_name` into the command window, e.g.

```matlab
>> help spm_plot_con_CI
  _
  Plot Contrast with Confidence Intervals
  FORMAT [cb, CI] = spm_plot_con_CI(SPM, con, xyz, alpha, CI_plot)
  
      SPM     - a structure specifying an estimated GLM
      con     - an integer indexing the contrast to be used
      xyz     - a 1 x 3 vector of MNI coordinates [mm]
      alpha   - the significance level, CIs are (1-alpha)
      CI_plot - logical indicating whether to plot CIs
  
      cb      - a 1 x q vector of contrast estimates
      CI      - a 2 x q vector of confidence intervals
                where q is the 2nd dim of the contrast matrix and
                where 1st row is lower and 2nd row is upper end of CI
  
  FORMAT [cb, CI] = spm_plot_con_CI(SPM, con, xyz, alpha, CI_plot)
  computes and displays contrast estimates and (1-alpha) confidence
  intervals of a contrast indexed by con at selected coordinates xyz [1].
  
  References:
  [1] Carlin J (2010). Extracting beta, standard error and confidence
      intervals for a coordinate. URL: https://imaging.mrc-cbu.cam.ac.uk/
      imaging/Extracting_beta,_standard_error_and_confidence_interval_for_a_coordinate
```