function struc = extractDataForModelCreation(obj)
% extract mri data relevant for model creation (by adaptation to generic model)

    struc.xyStyloidProcess = obj.landmarks.Stylo;
    struc.xyCondyle = [obj.landmarks.Stylo(1); obj.landmarks.Stylo(2)+8];
    struc.xyTongInsL = obj.landmarks.TongInsL;
    struc.xyTongInsH = obj.landmarks.TongInsH;
    % ANS-PNS line is used for transformation
    struc.xyANS = obj.landmarks.ANS;
    struc.xyPNS = obj.landmarks.PNS;

    % calculate "model origin" in mri coordinates 
    from = obj.gridZoning.tongue(1);
    to = obj.gridZoning.tongue(2);
    tongSurface = obj.filteredContours.innerPt(1:2, from:to);
    struc.xyOrigin = mean(tongSurface, 2);

    
    
    struc.outerPt(1:2, :) = obj.filteredContours.outerPt;
    struc.innerPt(1:2, :) = obj.filteredContours.innerPt;

    struc.idxTongue = obj.gridZoning.tongue;
    struc.idxPharynx = obj.gridZoning.pharynx;
    struc.idxVelum = obj.gridZoning.velum;
    struc.idxPalate = obj.gridZoning.palate;

end
