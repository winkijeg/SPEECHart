function measuresTongueShape = determineMeasuresTongueShape(obj)

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

    
%     [r, pc] = circle_exp2imp_2d(ptLower, ptOrigin, ptUpper);
%     ptCircle = circle_imp_points_2d(r, pc, 100);
% 
%     ptCenterHorizon = [pc(1)+100 pc(2)];

%     theta1 = -lines_exp_angle_nd(2, pc, ptCenterHorizon, pc, ptLower);
%     theta2 = lines_exp_angle_nd(2, pc, ptCenterHorizon, pc, ptUpper);

    % circSeg = circle_imp_points_arc_2d( r, pc, theta1, theta2, 25);

    % plot(ptLower(1), ptLower(2),'g*')
    % plot(ptOrigin(1), ptOrigin(2),'g*')
    % plot(ptUpper(1), ptUpper(2),'g*')

    % plot(ptCircle(1,:), ptCircle(2,:), 'g--', 'LineWidth', 1)
    % plot(circSeg(1,:), circSeg(2,:), 'g-', 'LineWidth', 2)

  
    
end
