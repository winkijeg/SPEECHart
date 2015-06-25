function obj = updateIdxTongue( obj )
% determine indices for tongue contour
%   split inner contour into anatomical motivated parts
%   The tongue surface is represented by the contour 
%   between between two landmarks (VallSin - TongTip).

    grd = obj.grid;

    % anatomical landmarks necessary to split up the contours
    ptTongStart = obj.xyVallSin;
    ptTongEnd = obj.xyTongTip;

    % memory allocation
    distGrdLineTargetLandmarkTongStart = ones(1, grd.nGridlines) * NaN;
    distGrdLineTargetLandmarkTongEnd = ones(1, grd.nGridlines) * NaN;

    for k = 1:grd.nGridlines
    
        ptGrdInner = grd.innerPt(1:2, k)';
        ptGrdOuter = grd.outerPt(1:2, k)';
    
        distGrdLineTargetLandmarkTongStart(k) = segment_point_dist_2d(...
            ptGrdInner, ptGrdOuter, ptTongStart');
        distGrdLineTargetLandmarkTongEnd(k) = segment_point_dist_2d(...
            ptGrdInner, ptGrdOuter, ptTongEnd');
    end

    [~, idxStart] = min(distGrdLineTargetLandmarkTongStart);
    [~, idxEnd] = min(distGrdLineTargetLandmarkTongEnd);
    
    obj.idxTongue = [idxStart idxEnd];

end
