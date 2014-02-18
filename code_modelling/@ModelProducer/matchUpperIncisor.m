function [upperIncisorPalate, ptAttachLip] = matchUpperIncisor(obj, palate, distRatioTeethInsertionPoints)
% connect standard upper incisor with palate with regard to incisor size

% todo: scale factor should not be limited at the lower limit ...
scaleFactor = min(1, distRatioTeethInsertionPoints);

palateLeftToRightOrder = fliplr(palate);
ptAttachIncisor = palateLeftToRightOrder(1:2, 1);


mat = load('upperIncisorStandard.mat');
indexAttachLip = mat.indexAttachLip;
% todo : mat.indexLastIncisorPoint is not necessary after refactoring (scale and
% trans)
upperIncisorStandard = mat.upperIncisorStandard;
nPointsIncisor = size(upperIncisorStandard, 2);
upperIncisorStandard3D = [zeros(1, nPointsIncisor); upperIncisorStandard];

tMat = tmat_init();

% scale
scaleVec = [0 scaleFactor scaleFactor];
t1 = tmat_scale(tMat, scaleVec);
incisor3DTemp = tmat_mxp2(t1, nPointsIncisor, upperIncisorStandard3D);
% determine neccesary shift to attach upper incisor
translateVec = [0 ptAttachIncisor'] - incisor3DTemp(1:3, nPointsIncisor)';

% translate 
t2 = tmat_trans(t1, translateVec);

incisorTrans = tmat_mxp2(t2, nPointsIncisor, upperIncisorStandard3D);
incisorNew(1:2, :) = incisorTrans(2:3, :);

upperIncisorPalate = [incisorNew palateLeftToRightOrder];
ptAttachLip = upperIncisorPalate(1:2, indexAttachLip);

end

