function [measuresTongueShape, derivedPointsTongueShape] = ...
    determineMeasuresTongueShape(obj)

    innerPt = obj.filteredContours.innerPt;
    ptPhysioDerivedMorpho = obj.landmarksDerivedMorpho;
    gridZoning = obj.gridZoning;
    
    % extract relevant part of the tongue contour
    ptPharH_d(1:2, 1) = ptPhysioDerivedMorpho.PharH_d(2:3);
    ptPharL_d(1:2, 1) = ptPhysioDerivedMorpho.PharL_d(2:3);

    indexStart = gridZoning.tongue(1) + 1;
    
    ptContStart = innerPt(1:2, indexStart);

    distancePtStartPharWall = line_exp_point_dist_2d(ptPharH_d', ptPharL_d', ...
        ptContStart');

    % find end point of the relevant part of the contour
    hasNext = 1;
    indexTmp = indexStart + 1;
    
    while hasNext

        ptTongTmp(1:2, 1) = innerPt(1:2, indexTmp);
        distanceTmp = line_exp_point_dist_2d(ptPharH_d', ptPharL_d', ptTongTmp');

        if ((distancePtStartPharWall - distanceTmp) > 0)
            hasNext = 1;
            indexTmp = indexTmp + 1;
        else
            hasNext = 0;
        end

    end

    indexEnd = indexTmp;

    innerPtPart = innerPt(1:2, indexStart:indexEnd);

    
    % start calculating tongue back curvature
    nPointsPart = indexEnd - indexStart + 1;

    ptMid = innerPtPart(1:2, round(nPointsPart / 2));
    ptEnd = innerPtPart(1:2, nPointsPart);

    curvatureInversRadius = segments_curvature_2d(ptContStart', ptMid', ptEnd');

    % assign values
    % ---------------------------------------------------------
    measuresTongueShape.curvatureInversRadius = curvatureInversRadius;
    derivedPointsTongueShape.ptStart = ptContStart;
    derivedPointsTongueShape.ptMid = ptMid;
    derivedPointsTongueShape.ptEnd = ptEnd;
    
    
end
