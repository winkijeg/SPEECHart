function obj = updateIdxVelum( obj )
% determine indices for velum contour
%   split outer contour into anatomical motivated parts.
%   The velum is represented by the contour 
%   between between two landmarks (PharH - Velum).

    grd = obj.grid;

    % anatomical landmarks necessary to split up the contour
    ptVelumStart = obj.xyPharH;
    ptVelumEnd = obj.xyVelum;

    % memory allocation
    distGrdLineTargetLandmarkVelumStart = ones(1, grd.nGridlines) * NaN;
    distGrdLineTargetLandmarkVelumEnd = ones(1, grd.nGridlines) * NaN;

    for k = 1:grd.nGridlines
    
        ptGrdInner = grd.innerPt(1:2, k)';
        ptGrdOuter = grd.outerPt(1:2, k)';
    
        distGrdLineTargetLandmarkVelumStart(k) = segment_point_dist_2d(...
            ptGrdInner, ptGrdOuter, ptVelumStart');
        distGrdLineTargetLandmarkVelumEnd(k) = segment_point_dist_2d(...
            ptGrdInner, ptGrdOuter, ptVelumEnd');
    end


    [~, idxStart] = min(distGrdLineTargetLandmarkVelumStart);
    [~, idxEnd] = min(distGrdLineTargetLandmarkVelumEnd);

    obj.idxVelum = [idxStart idxEnd];

end
