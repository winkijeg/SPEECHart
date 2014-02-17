function strucOut = matchUpperIncisor(obj, palate, distRatioTeethInsertionPoints)
% connect standard upper incisor with palate with regard to incisor size

scaleFactor = 2;% min(1, distRatioTeethInsertionPoints);

palateLeftToRightOrder = fliplr(palate);
ptIncisorPalate = palateLeftToRightOrder(1:2, 1);

upperIncisorStandard = ...
    [-1.7639 -3.8806 -5.2917 -6.3500 -5.6444 -3.5278; ...
      8.8194  5.9972  2.1167 -2.4694 -5.6444 -3.5278];
nPointsIncisor = size(upperIncisorStandard, 2);

% adapt incisor size
incisorNew = nan(2, nPointsIncisor);
for nbPtIncisor = 1:nPointsIncisor
    
    incisorNew(1:2, nbPtIncisor) = ptIncisorPalate + ...
        scaleFactor * upperIncisorStandard(1:2, nbPtIncisor);
    
end

strucOut = [incisorNew palateLeftToRightOrder];

end

