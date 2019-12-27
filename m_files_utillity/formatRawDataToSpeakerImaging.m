function struc = formatRawDataToSpeakerImaging( pathImaging, ...
    speakerName, phonLab )
% import landmarks and images from mri speaker preparation


% read the landmarks determined within slicer3d
fn_fList_landmark = [speakerName '_' phonLab '_ptPhysio.fcsv'];
ptPhysio = read_fiducialList([pathImaging fn_fList_landmark]);

% read the 2D midsagittal MRI slice
fn_img = [speakerName '_' phonLab '_2d.mhd'];

% read the 2D segmentation file produced with InsightSNAP
fn_imgSeg = [speakerName '_' phonLab '_2d_seg.mhd'];
sliceInfo = mha_read_header([pathImaging fn_img]);

img1 = mha_read_volume(sliceInfo);
img2 = squeeze(permute(img1, [2 3 1]));
sliceData = flipud(img2);

infoSegmentation = mha_read_header([pathImaging fn_imgSeg]);
img_seg_tmp = mha_read_volume(infoSegmentation);
img_seg2 = permute(img_seg_tmp, [2 3 1]);
sliceSegmentationData = logical(squeeze(img_seg2));

struc.ptPhysio = ptPhysio;
struc.speakerName = speakerName;
struc.princInvestigator = speakerName(1:2);
struc.phonLab = phonLab;
struc.sliceInfo = sliceInfo;
struc.sliceData = sliceData;
struc.sliceSegmentationData = sliceSegmentationData;

end
