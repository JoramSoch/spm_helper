function spm_save_thr_SPM(SPM, con, FWE, p, k, fname)
% _
% Save Thresholded Statistical Parametric Map
% FORMAT spm_save_thr_SPM(SPM, con, FWE, p, k)
%     SPM   - a structure specifying an estimated GLM
%     con   - an integer indexing the contrast to be queried
%     FWE   - a logical indicating family-wise error correction
%     p     - a scalar, the significance level (e.g. p < 0.05)
%     k     - an integer, the extent threshold (e.g. k = 10)
%     fname - a string, the filename for the threshold SPM
% 
% FORMAT spm_save_thr_SPM(SPM, con, FWE, p, k) automatically performs
% statistical inference specified by multiple comparison correction (FWE),
% significance level (p) and extent threshold (k) and saves the resulting
% thresholded statistical parametric map (fname).
% 
% Author: Joram Soch, BCCN Berlin
% E-Mail: joram.soch@bccn-berlin.de
% 
% First edit: 10/04/2015, 16:50
%  Last edit: 06/08/2018, 15:00


% Set xSPM structure
%-------------------------------------------------------------------------%
xSPM.swd = SPM.swd;
xSPM.Ic  = con;
xSPM.Im  = [];
xSPM.u   = p;
xSPM.k   = k;
if FWE
    xSPM.thresDesc = 'FWE';
else
    xSPM.thresDesc = 'none';
end;

% Call spm_getSPM.m
%-------------------------------------------------------------------------%
[SPM, xSPM] = spm_getSPM(xSPM);
xSPM.Z(:)   = 1;

% Call spm_write_filtered.m
%-------------------------------------------------------------------------%
spm_write_filtered(xSPM.Z,xSPM.XYZ,xSPM.DIM,xSPM.M,'spm_save_thr_SPM: thresholded SPM',fname);