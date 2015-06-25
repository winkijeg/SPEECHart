function obj = updateIdxPalate( obj )
% determine indices for palate contour
%   split outer contour into anatomical motivated parts.
%   The palate is represented by the contour 
%   between between two landmarks (Velume - Palate).

    grd = obj.grid;

    % anatomical landmarks necessary to split up the contour
    ptPalateStart = obj.xyVelum;
    ptPalateEnd = obj.xyAlvRidge;

    % memory allocation
    distGrdLineTargetLandmarkPalateStart = ones(1, grd.nGridlines) * NaN;
    distGrdLineTargetLandmarkPalateEnd = ones(1, grd.nGridlines) * NaN;

    for k = 1:grd.nGridlines

        ptGrdInner = grd.innerPt(1:2, k)';
        ptGrdOuter = grd.outerPt(1:2, k)';

        distGrdLineTargetLandmarkPalateStart(k) = segment_point_dist_2d(...
            ptGrdInner, ptGrdOuter, ptPalateStart');
        distGrdLineTargetLandmarkPalateEnd(k) = segment_point_dist_2d(...
            ptGrdInner, ptGrdOuter, ptPalateEnd');
    end

    [~, idxStart] = min(distGrdLineTargetLandmarkPalateStart);
    [~, idxEnd] = min(distGrdLineTargetLandmarkPalateEnd);

    obj.idxPalate = [idxStart idxEnd];
    
end
