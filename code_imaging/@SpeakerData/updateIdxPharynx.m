function obj = updateIdxPharynx( obj )
% determine indices for Pharynx contour
%   split outer contour into anatomical motivated parts.
%   The back pharyngeal wall is represented by the contour 
%   between between two landmarks (PharL - PharH).

    grd = obj.grid;

    % anatomical landmarks necessary to split up the contour
    ptPharStart = obj.xyPharL;
    ptPharEnd = obj.xyPharH;

    % memory allocation
    distGrdLineTargetLandmarkPharStart = ones(1, grd.nGridlines) * NaN;
    distGrdLineTargetLandmarkPharEnd = ones(1, grd.nGridlines) * NaN;

    for k = 1:grd.nGridlines
    
        ptGrdInner = grd.innerPt(1:2, k)';
        ptGrdOuter = grd.outerPt(1:2, k)';
    
        distGrdLineTargetLandmarkPharStart(k) = segment_point_dist_2d(...
            ptGrdInner, ptGrdOuter, ptPharStart');
        distGrdLineTargetLandmarkPharEnd(k) = segment_point_dist_2d(...
            ptGrdInner, ptGrdOuter, ptPharEnd');
    end

    [~, idxStart] = min(distGrdLineTargetLandmarkPharStart);
    [~, idxEnd] = min(distGrdLineTargetLandmarkPharEnd);

    obj.idxPharynx = [idxStart idxEnd];

end
