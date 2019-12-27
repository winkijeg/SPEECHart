function upperLip = matchUpperLip(obj, ptAttachIncisor, distRatioTeethInsertionPoints)
% connect standard upper lip with incisor with regard to lip size

% todo : scale factor should not be limited at the lower limit
scaleFactor = min(1, distRatioTeethInsertionPoints * 1.1);

mat = load('upperLipStandard.mat');
upperLipStandard = mat.upperLipStandard;

nPtUpperLip = length(upperLipStandard);
upperLipStandard3D = [zeros(1, nPtUpperLip); upperLipStandard];

tMat = tmat_init();

% scale
scaleVec = [0 scaleFactor scaleFactor];
t1 = tmat_scale(tMat, scaleVec);
lipTmp = tmat_mxp2(t1, nPtUpperLip, upperLipStandard3D);
% determine neccesary shift to attach upper incisor
translateVec = [0 ptAttachIncisor'] - lipTmp(1:3, nPtUpperLip)';

% translate 
t2 = tmat_trans(t1, translateVec);

% transform all lip points with final transformation matrix
lipTrans = tmat_mxp2(t2, nPtUpperLip, upperLipStandard3D);
upperLip(1:2, :) = lipTrans(2:3, :);

end

