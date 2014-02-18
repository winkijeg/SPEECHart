function [upperIncisorPalate, ptAttachLip] = matchUpperIncisor(obj, palate, distRatioTeethInsertionPoints)
% connect standard upper incisor with palate with regard to incisor size

% todo: scale factor should not be limited at the lower limit ...
scaleFactor = min(1, distRatioTeethInsertionPoints);

palateLeftToRightOrder = fliplr(palate);
ptIncisorPalate = palateLeftToRightOrder(1:2, 1);

mat = load('upperIncisorStandard.mat');

nPointsIncisor = mat.indexLastIncisorPoint;
upperIncisorStandard = mat.upperIncisorStandard(1:2, 1:nPointsIncisor);

% adapt incisor size
incisorNew = nan(2, nPointsIncisor);
for nbPtIncisor = 1:nPointsIncisor
    
    incisorNew(1:2, nbPtIncisor) = ptIncisorPalate + ...
        scaleFactor * upperIncisorStandard(1:2, nbPtIncisor);
    
end

upperIncisorPalate = [incisorNew palateLeftToRightOrder];
ptAttachLip = upperIncisorPalate(1:2, mat.indexAttachLip);


end

