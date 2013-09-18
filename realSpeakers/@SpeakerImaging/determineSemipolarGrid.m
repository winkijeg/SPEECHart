function grd = determineSemipolarGrid(obj)
    % calulates speaker-specific grid based on segmented points (see below)
    % this grid is fitted based on:
    %  - four landmarks labeled within slicer3d, 
    %    namely p_AlvRidge, p_Palate, p_PharH_d, and p_PharL_d

    % 3 mm in lower pharynx and anterior oral cavity
    distGridlines = 3;

    % 5 degree, used in the upper phynx/ posterior oral cavity
    angleGridlines = 5;

    % gridlines should have overlength in order to intersect the contour 
    gridlineOverlength = 15;
    
    
    p_ANS = obj.landmarks.ANS;
    p_VallSin = obj.landmarks.VallSin;
    p_AlvRidge = obj.landmarks.AlvRidge;
    p_Palate = obj.landmarks.Palate;
    p_PharH = obj.landmarks.PharH;
    p_PharL = obj.landmarks.PharL;
    p_Lx = obj.landmarks.Lx;
    p_LipU = obj.landmarks.LipU;
    p_LipL = obj.landmarks.LipL;

    p_PharH_d = obj.landmarksDerivedMorpho.PharH_d;
    p_PharL_d = obj.landmarksDerivedMorpho.PharL_d;

    p_circleMidpoint = obj.landmarksDerivedGrid.circleMidpoint;
    
    % determine value for left-right dimension
    valLR = p_ANS(1);

    % determine length of each gridline (radius + overlength)
    radius = points_dist_nd(2, p_circleMidpoint(2:3), p_Palate(2:3));
    gridlineLength = radius + gridlineOverlength;

    
    
    % calculate H1 (line h1-midpointCircle is perpendiculat to PharH_d-PharL_d-line)
    h1 = line_exp_point_near_3d(p_PharH, p_PharL, p_circleMidpoint);
    % calculate H2 (line h2-midpointCircle is perpendicular to AlvRidge-palate-line)
    h2 = line_exp_point_near_3d(p_AlvRidge, p_Palate, p_circleMidpoint);
    % calculate lower right corner of first gridline
    h3 = line_exp_point_near_3d(p_PharH, p_PharL, p_Lx);
    % calculate lower left corner of first gridline
    h4 = line_exp_point_near_3d ( h3, p_Lx, p_circleMidpoint);

    % construct gridlines in the lower pharynx
    % angle from vector is sensitiv to the sign of the angle !!
    if h3(3) > h4(3)
        angleSign = -1;
    else
        angleSign = 1;
    end
    angleTmp = vector_directions_nd(3, h3-h4);
    angleRot = angleSign * radians_to_degrees(angleTmp(2));

    % determine grid lines in the pharyngeal region
    % take the first grid line and transform one by one

    ptInnerTmp = [0 0 0];
    ptOuterTmp = [0 gridlineLength 0];

    k = 1;
    hasNext = 1;
    while hasNext

        [ptInnerNew, ptOuterNew] = ...
            get_grdLine_Translation(ptInnerTmp, ptOuterTmp, (k-1)*distGridlines, ...
            h4, [0 0 0], angleRot);

        ptInner(k, 1:3) = ptInnerNew;
        ptOuter(k, 1:3) = ptOuterNew;
        
        k = k + 1;
    
        % check condition; 
        valTmp = points_dist_nd(3, ptInnerNew, p_circleMidpoint);
        if valTmp >= 1.5*distGridlines
            hasNext = 1;
        else
            hasNext = 0;
        end
    end


    % construct gridlines in the upper pharynx/ posterior oral cavity
    nbTmp = 1;
    hasNext = 1;
    while hasNext

        [ptInnerNew, ptOuterNew] = ...
            get_grdLine_Translation(ptInnerTmp, ptOuterTmp, 0, ...
            p_circleMidpoint, [0 0 0], angleRot + (nbTmp-1)*-angleGridlines);

        ptInner(k, 1:3) = ptInnerNew;
        ptOuter(k, 1:3) = ptOuterNew;
        
        k = k + 1;

        % check conditions
        angleTmp = angle_deg_2d(h2(2:3), p_circleMidpoint(2:3), ptOuterNew(2:3));
        if angleTmp >= 1.25*angleGridlines
            hasNext = 1;
            nbTmp = nbTmp + 1;
        else
            hasNext = 0;
        end
    end
   
    
    % construct gridlines in the anterior oral cavity (until teeth ...)
    angleTmp = vector_directions_nd(3, p_circleMidpoint-h2);
    angleRot = radians_to_degrees(angleTmp(2));

    nbTmp = 1;
    hasNext = 1;
    while hasNext

        [ptInnerNew, ptOuterNew] = ...
            get_grdLine_Translation(ptInnerTmp, ptOuterTmp, (nbTmp-1)*distGridlines, ...
            p_circleMidpoint, [0 0 0], 180 + angleRot);

        % check conditions
        valTmp = halfplane_contains_point_2d(ptInnerNew(2:3), ...
            ptOuterNew(2:3), p_AlvRidge(2:3));
        if valTmp
        
            ptInner(k, 1:3) = ptInnerNew;
            ptOuter(k, 1:3) = ptOuterNew;
            
            k = k + 1;
        
            hasNext = 1;
            nbTmp = nbTmp + 1;
        else
            hasNext = 0;
        end
    end

    % determine gridlines in the teeth/lips region ...
    % find intersection point between two lines: (1) line crossing the upper
    % and lower lip point, and (2) the last gridline
    [~, h5] = lines_exp_int_2d(p_LipL(2:3), p_LipU(2:3), ptInner(k-1, 2:3),...
        ptOuter(k-1, 2:3));
    h5 = [valLR h5];
    
    ptInnerTmp = ptInner(k-1, 1:3);
    ptOuterTmp = ptOuter(k-1, 1:3);

    % adjust angleGridlines so that the final grdLine crosses the two lip
    % points ...
    angTotal = angle_deg_2d(ptInnerTmp(2:3), h5(2:3), p_LipL(2:3));
    angleGridlinesNew = (angTotal / (ceil(angTotal / angleGridlines)));

    nbTmp = 1;
    hasNext = 1;
    clear angleTmp
    
    while hasNext
    
        [ptInnerNew, ptOuterNew] = ...
            get_grdLine_Translation(ptInnerTmp, ptOuterTmp, 0, ...
            h5, h5, (nbTmp)*angleGridlinesNew);
    
        % check conditions; both lip mpoints have to lie anterior to the final
        % gridline
        valTmp1 = halfplane_contains_point_2d(ptInnerNew(2:3), ptOuterNew(2:3), p_LipL(2:3));
        valTmp2 = halfplane_contains_point_2d(ptInnerNew(2:3), ptOuterNew(2:3), p_LipL(2:3));
    
        if valTmp1 && valTmp2

            ptInner(k, 1:3) = ptInnerNew;
            ptOuter(k, 1:3) = ptOuterNew;
            
            hasNext = 1;
            k = k + 1;
            nbTmp = nbTmp + 1;
        else
            hasNext = 0;
            k = k - 1;
        end
    end

    

% assign values ...
grd.innerPt = [ptInner(:, 2) ptInner(:, 3)]';
grd.outerPt = [ptOuter(:, 2) ptOuter(:, 3)]';
grd.numberOfGridlines = k;

% grd.slice_number_total = k;
% grd.mean_alpha_thres1 = ones(k, 1) * NaN;
% grd.mean_alpha_thres2 = ones(k, 1) * NaN;
% grd.threshold1 = NaN;
% grd.threshold2 = NaN;
% grd.slice_select_list = [1:k]';


% determine range of pharyngeal gridlines

% hasNext = 1;
% nbGrdLine = 1;
% distPrec = Inf;
% while ((hasNext) && (nbGrdLine<20))
%     
%     distTmp = line_exp_point_dist_2d([grd.x(nbGrdLine) grd.y(nbGrdLine)], ...
%         [grd.xx(nbGrdLine) grd.yy(nbGrdLine)], p_VallSin(2:3));
%     
%     if distPrec <= distTmp
%         nbGrdLineFinal = nbGrdLine;
%         hasNext = 0;
%     else
%         distPrec = distTmp;
%         nbGrdLine = nbGrdLine + 1;
%     end
%     
% end
% 
% grd.pharEnd = get_grdLine_of_bending(grd, ptPhysio);
% grd.pharStart = nbGrdLineFinal;



end