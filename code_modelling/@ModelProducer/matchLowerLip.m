function lowerLip = matchLowerLip(ptAttachIncisor, distRatioTeethInsertionPoints)
% connect standard lower lip with incisor with regard to lip size
%   todo : at some time there schould be added a rotation component (I guess)
%   todo : scale factor should not be limited at the lower limit

    % so far, lips can only be enlarged with respect to standard lips
    scaleFactor = min(1, distRatioTeethInsertionPoints);

    mat = load('lowerLipStandard.mat');
    lowerLipStandard = mat.lowerLipStandard;
    nPtLowerLip = length(lowerLipStandard);
    lowerLipStandard3D = [zeros(1, nPtLowerLip); lowerLipStandard];

    tMat = tmat_init();

    % scale
    scaleVec = [0 scaleFactor scaleFactor];
    t1 = tmat_scale(tMat, scaleVec);
    lipTmp = tmat_mxp2(t1, nPtLowerLip, lowerLipStandard3D);

    % determine neccesary shift to attach upper incisor
    translateVec = [0 ptAttachIncisor'] - lipTmp(1:3, nPtLowerLip)';

    % translate 
    t2 = tmat_trans(t1, translateVec);

    % transform all lip points with final transformation matrix
    lipTrans = tmat_mxp2(t2, nPtLowerLip, lowerLipStandard3D);
    lowerLip(1:2, :) = lipTrans(2:3, :);

end
