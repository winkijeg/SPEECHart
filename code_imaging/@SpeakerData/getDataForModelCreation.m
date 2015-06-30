function modelData = getDataForModelCreation( obj )
% extract MRI data relevant for model creation (by adaptation to generic model)

    modelData.xyStyloidProcess = obj.xyStyloidProcess;
    modelData.xyTongInsL = obj.xyTongInsL;
    modelData.xyTongInsH = obj.xyTongInsH;
    % ANS-PNS line is used for transformation
    modelData.xyANS = obj.xyANS;
    modelData.xyPNS = obj.xyPNS;

    % calculate "model origin" in mri coordinates 
    from = obj.idxTongue(1);
    to = obj.idxTongue(2);
    tongSurface = obj.xyInnerTrace(1:2, from:to);
    modelData.xyOrigin = mean(tongSurface, 2);

    
    % TODO: filtering contours has to be re-implemented ...
    modelData.outerPt(1:2, :) = obj.xyOuterTrace;
    modelData.innerPt(1:2, :) = obj.xyInnerTrace;
    
    modelData.idxTongue = obj.idxTongue;
    modelData.idxPharynx = obj.idxPharynx;
    modelData.idxVelum = obj.idxVelum;
    modelData.idxPalate = obj.idxPalate;
    
end
