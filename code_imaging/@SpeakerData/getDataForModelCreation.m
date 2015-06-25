function modelData = getDataForModelCreation( obj )
% extract MRI data relevant for model creation (by adaptation to generic model)

    modelData.styloidProcess = obj.xyStyloidProcess;
    modelData.condyle = [obj.xyStyloidProcess(1); obj.xyStyloidProcess(2)+8];
    modelData.tongInsL = obj.xyTongInsL;
    modelData.tongInsH = obj.xyTongInsH;
    % ANS-PNS line is used for transformation
    modelData.ANS = obj.xyANS;
    modelData.PNS = obj.xyPNS;

    % calculate "model origin" in mri coordinates 
    from = obj.idxTongue(1);
    to = obj.idxTongue(2);
    tongSurface = obj.xyInnerTrace(1:2, from:to);
    modelData.origin = mean(tongSurface, 2);

    
    % TODO: filtering contours has to be re-implemented ...
    modelData.outerPt(1:2, :) = obj.xyOuterTrace;
    modelData.innerPt(1:2, :) = obj.xyInnerTrace;
    
    modelData.idxTongue = obj.idxTongue;
    modelData.idxPharynx = obj.idxPharynx;
    modelData.idxVelum = obj.idxVelum;
    modelData.idxPalate = obj.idxPalate;
    
end
