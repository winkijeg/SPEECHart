function [struc, gridZoning] = extractDataForModelCreation(obj)
% extract mri data relevant for model creation (by adaptation to generic model)

    struc.styloidProcess = obj.landmarks.Stylo;
    struc.condyle = [obj.landmarks.Stylo(1); obj.landmarks.Stylo(2)+8];
    struc.tongInsL = obj.landmarks.TongInsL;
    struc.tongInsH = obj.landmarks.TongInsH;
    % ANS-PNS line is used for transformation
    struc.ANS = obj.landmarks.ANS;
    struc.PNS = obj.landmarks.PNS;

    % calculate "model origin" in mri coordinates 
    from = obj.gridZoning.tongue(1);
    to = obj.gridZoning.tongue(2);
    tongSurface = obj.filteredContours.innerPt(1:2, from:to);
    struc.origin = mean(tongSurface, 2);

    struc.outerPt(1:2, :) = obj.filteredContours.outerPt;
    struc.innerPt(1:2, :) = obj.filteredContours.innerPt;

    gridZoning = obj.gridZoning;

end
