function gridZoning = zoneGridIntoAnatomicalRegions(obj)
    % the inner and outer contours are splited into parts.
    %
    % The INNER contour is labels as: 
    %   - tongue surface between two landmarks (VallSin - TongTip).
    %
    % The OUTER contour is partinioned into three parts:
    %   - back pharyngeal wall (PharL - PharH)
    %   - velum (PharH - Velum)
    %   - palate (Velume - Palate)

    grd = obj.semipolarGrid;

    % anatomical landmarks necessary to zone the contours
    pt_tongStart = obj.landmarks.VallSin(2:3);
    pt_tongEnd = obj.landmarks.TongTip(2:3);
    
    pt_pharStart = obj.landmarks.PharL(2:3);
    pt_pharEnd = obj.landmarks.PharH(2:3);
    
    pt_velumStart = obj.landmarks.PharH(2:3);
    pt_velumEnd = obj.landmarks.Velum(2:3);
    
    pt_palateStart = obj.landmarks.Velum(2:3);
    pt_palateEnd = obj.landmarks.AlvRidge(2:3);

    % memory allocation
    distGrdLineTargetLandmarkTongStart = ones(1, grd.numberOfGridlines) * NaN;
    distGrdLineTargetLandmarkTongEnd = ones(1, grd.numberOfGridlines) * NaN;
    distGrdLineTargetLandmarkPharStart = ones(1, grd.numberOfGridlines) * NaN;
    distGrdLineTargetLandmarkPharEnd = ones(1, grd.numberOfGridlines) * NaN;
    distGrdLineTargetLandmarkVelumStart = ones(1, grd.numberOfGridlines) * NaN;
    distGrdLineTargetLandmarkVelumEnd = ones(1, grd.numberOfGridlines) * NaN;
    distGrdLineTargetLandmarkPalateStart = ones(1, grd.numberOfGridlines) * NaN;
    distGrdLineTargetLandmarkPalateEnd = ones(1, grd.numberOfGridlines) * NaN;
    
    for k = 1:grd.numberOfGridlines
        
        ptGrdInner = grd.innerPt(1:2, k)';
        ptGrdOuter = grd.outerPt(1:2, k)';

        distGrdLineTargetLandmarkTongStart(k) = segment_point_dist_2d(ptGrdInner, ...
            ptGrdOuter, pt_tongStart);
        distGrdLineTargetLandmarkTongEnd(k) = segment_point_dist_2d(ptGrdInner, ...
            ptGrdOuter, pt_tongEnd);
        distGrdLineTargetLandmarkPharStart(k) = segment_point_dist_2d(ptGrdInner, ...
            ptGrdOuter, pt_pharStart);
        distGrdLineTargetLandmarkPharEnd(k) = segment_point_dist_2d(ptGrdInner, ...
            ptGrdOuter, pt_pharEnd);
        distGrdLineTargetLandmarkVelumStart(k) = segment_point_dist_2d(ptGrdInner, ...
            ptGrdOuter, pt_velumStart);
        distGrdLineTargetLandmarkVelumEnd(k) = segment_point_dist_2d(ptGrdInner, ...
            ptGrdOuter, pt_velumEnd);
        distGrdLineTargetLandmarkPalateStart(k) = segment_point_dist_2d(ptGrdInner, ...
            ptGrdOuter, pt_palateStart);
        distGrdLineTargetLandmarkPalateEnd(k) = segment_point_dist_2d(ptGrdInner, ...
            ptGrdOuter, pt_palateEnd);
    end


    [~, indMinTongStart] = min(distGrdLineTargetLandmarkTongStart);
    [~, indMinTongEnd] = min(distGrdLineTargetLandmarkTongEnd);

    [~, indMinPharStart] = min(distGrdLineTargetLandmarkPharStart);
    [~, indMinPharEnd] = min(distGrdLineTargetLandmarkPharEnd);

    [~, indMinVelumStart] = min(distGrdLineTargetLandmarkVelumStart);
    [~, indMinVelumEnd] = min(distGrdLineTargetLandmarkVelumEnd);

    [~, indMinVelPalateStart] = min(distGrdLineTargetLandmarkPalateStart);
    [~, indMinPalateEnd] = min(distGrdLineTargetLandmarkPalateEnd);

    % assign values to the output structure
    gridZoning.tongue = [indMinTongStart indMinTongEnd];
    gridZoning.pharynx = [indMinPharStart indMinPharEnd];
    gridZoning.velum = [indMinVelumStart indMinVelumEnd];
    gridZoning.palate = [indMinVelPalateStart indMinPalateEnd];

end
