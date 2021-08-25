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

To get started, simply type `help spm_fct_name` into the MATLAB command window, e.g.

```matlab
>> help spm_save_thr_SPM
  _
  Save Thresholded Statistical Parametric Map
  FORMAT spm_save_thr_SPM(SPM, con, FWE, p, k)
      SPM   - a structure specifying an estimated GLM
      con   - an integer indexing the contrast to be queried
      FWE   - a logical indicating family-wise error correction
      p     - a scalar, the significance level (e.g. p < 0.05)
      k     - an integer, the extent threshold (e.g. k = 10)
      fname - a string, the filename for the threshold SPM
  
  FORMAT spm_save_thr_SPM(SPM, con, FWE, p, k) automatically performs
  statistical inference specified by multiple comparison correction (FWE),
  significance level (p) and extent threshold (k) and saves the resulting
  thresholded statistical parametric map (fname).
```