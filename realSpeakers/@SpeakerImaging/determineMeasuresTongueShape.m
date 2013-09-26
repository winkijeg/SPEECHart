function [measures, basicData] = ...
    determineMeasuresTongueShape(obj)


    innerPt = obj.filteredContours.innerPt;
    landmarksDerivedMorpho = obj.landmarksDerivedMorpho;
    gridZoning = obj.gridZoning;
    
    % extract relevant part of the tongue contour
    ptPharH_d(1:2, 1) = landmarksDerivedMorpho.PharH_d(2:3);
    ptPharL_d(1:2, 1) = landmarksDerivedMorpho.PharL_d(2:3);

    % extract tongue back contour (feasable part) -------------------------
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

    nPointsPart = indexEnd - indexStart + 1;

    ptContMid = innerPtPart(1:2, round(nPointsPart / 2));
    ptContEnd = innerPtPart(1:2, nPointsPart);
    
    % start calculating tongue back curvature -----------------------------
    [curvInvRadius, bDataInvRadius] = ...
        obj.determineCurvatureInvRadius(ptContStart, ptContMid, ptContEnd);
        
    % start calculating the quadratic approximation -----------------------
    [curvQuadCoeff, bDataQuadCoeff] = ...
        obj.determineCurvatureQuadCoeff(innerPtPart);
    
    % assign values --------------------------------------------------------
    measures.curvatureInversRadius = curvInvRadius;
    measures.curvatureQuadCoeff = curvQuadCoeff;

    basicData.invRadius = bDataInvRadius;
    basicData.quadCoeff = bDataQuadCoeff;
    
end
