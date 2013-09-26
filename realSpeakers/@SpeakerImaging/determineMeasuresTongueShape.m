function [measuresTongueShape, derivedPointsTongueShape] = ...
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

    
    % start calculating tongue back curvature -----------------------------
    nPointsPart = indexEnd - indexStart + 1;

    ptMid = innerPtPart(1:2, round(nPointsPart / 2));
    ptEnd = innerPtPart(1:2, nPointsPart);

    % calculate inverse radius of circle paasing three points
    curvatureInversRadius = segments_curvature_2d(ptContStart', ptMid', ptEnd');

    % start calculating the quadratic approximation -----------------------
    
    % determine contour length in mm
    lenCont = 0;
    for k = 2:nPointsPart
        p1 = innerPtPart(1:2, k-1);
        p2 = innerPtPart(1:2, k);
        lenCont = lenCont + points_dist_nd(2, p1, p2);
    end

    % determine number of points; point to point distance is 1mm
    nPointsPartSubSampl = round(lenCont);

    innerPtPartSubSampl(1:2, :) = curvspace(innerPtPart', nPointsPartSubSampl)';
    
    % incice of the origin (for rotation, roughly approximates the constriction
    % location
    indexRotationPoint = round(nPointsPartSubSampl / 2);

    % calculate rotation angle
    ptStartSubSampl(2:3) = innerPtPartSubSampl(1:2, 1);
    ptMidSubSampl(2:3) = innerPtPartSubSampl(1:2, indexRotationPoint);
    ptEndSubSampl(2:3) = innerPtPartSubSampl(1:2, end);
    
    innerPtSubSampl3D(2:3, :) = innerPtPartSubSampl(1:2, :);

    angleTmp = vector_directions_nd(3, ptEndSubSampl'-ptStartSubSampl');
    angleRot = radians_to_degrees(angleTmp(2));

    % transform to enable quadratic function approximation
    tMat = tmat_init;
    tMat = tmat_trans(tMat, -ptMidSubSampl);
    tMat = tmat_rot_axis(tMat, -angleRot, 'X');

    % transform points
    innerPtSubSampl3DTrans = tmat_mxp2(tMat, nPointsPartSubSampl, ...
        innerPtSubSampl3D);
    
    plot(innerPtSubSampl3DTrans(2, :), innerPtSubSampl3DTrans(3,:), 'g-')

    % approximate quadratic function
    polynomialCoeff = polyfit(innerPtSubSampl3DTrans(2, :), ...
        innerPtSubSampl3DTrans(3, :), 2);

    xMin = innerPtSubSampl3DTrans(2, 1);
    xMax = innerPtSubSampl3DTrans(2, nPointsPartSubSampl);

    xValsNew = xMin:0.1:xMax;
    yValsNew = polyval(polynomialCoeff, xValsNew);
    nVals = length(xValsNew);
    

    contPartApproximated(1:3, :) = [zeros(1, nVals); xValsNew; yValsNew];

    tMatInv = inv(tMat);
    cFin(1:3, :) = tmat_mxp2(tMatInv, nVals, contPartApproximated);

    figure
    hold on
    plot(cFin(2, :), cFin(3, :), 'g-', 'Linewidth', 2)
%     plot(ptLower(2), ptLower(3),'ro')
%     plot(ptOrigin(2), ptOrigin(3),'ro')
%     plot(ptUpper(2), ptUpper(3),'ro')
    
    % assign values
    % ---------------------------------------------------------
    measuresTongueShape.curvatureInversRadius = curvatureInversRadius;
    measuresTongueShape.curvatureQuadCoeff = polynomialCoeff(1);

    derivedPointsTongueShape.ptStart = ptContStart;
    derivedPointsTongueShape.ptMid = ptMid;
    derivedPointsTongueShape.ptEnd = ptEnd;
    
end
