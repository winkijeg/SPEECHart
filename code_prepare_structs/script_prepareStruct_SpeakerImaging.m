% script prepares data structure for an object of class SpeakerImaging

clearvars

% specify whose data should be collected into a matlab structure
princInvestigator = 'PP';
speakerName = 'FF1';
phonLab = 'a';

% specify name of output mat-file with collected data 
fn_mat_out = [princInvestigator '_' speakerName '_' phonLab '.mat'];

% construct speaker-specific path names
[~, ~, pathImaging] = ...
    initPaths(princInvestigator, speakerName);

% read the landmarks determined within slicer3d
fn_fList_landmark = [princInvestigator '_' speakerName '_' phonLab '_ptPhysio.fcsv'];

% read the 2D midsagittal MRI slice
fn_img = [princInvestigator '_' speakerName '_' phonLab '_2d.mhd'];

% read the 2D segmentation file produced with InsightSNAP
fn_imgSeg = [princInvestigator '_' speakerName '_' phonLab '_2d_seg.mhd'];

% read (and calculate) remaining data
ptPhysio = read_fiducialList([pathImaging fn_fList_landmark]);
posMidSagittalSlice = ptPhysio.TongInsL(1);

sliceInfo = mha_read_header([pathImaging fn_img]);

img1 = mha_read_volume(sliceInfo);
img2 = squeeze(permute(img1, [2 3 1]));
sliceData = flipud(img2);

infoSegmentation = mha_read_header([pathImaging fn_imgSeg]);
img_seg_tmp = mha_read_volume(infoSegmentation);
img_seg2 = permute(img_seg_tmp, [2 3 1]);
sliceSegmentationData = logical(squeeze(img_seg2));

% save output mat-file with collected data
save ([pathImaging fn_mat_out], 'ptPhysio', 'princInvestigator', ...
    'speakerName', 'phonLab', 'sliceInfo', 'sliceData', ...
    'sliceSegmentationData')
