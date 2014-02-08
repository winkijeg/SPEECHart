function grd = calcGrid(obj)
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

ptAlvRidge = obj.landmarks.AlvRidge;
p_Palate = obj.landmarks.Palate;
p_PharH = obj.landmarks.PharH;
p_PharL = obj.landmarks.PharL;
p_Lx = obj.landmarks.Lx;
p_LipU = obj.landmarks.LipU;
p_LipL = obj.landmarks.LipL;

ptCircleMidpoint = obj.landmarksDerivedGrid.circleMidpoint;

% determine length of each gridline (radius + overlength)
radius = points_dist_nd(2, ptCircleMidpoint', p_Palate');
gridlineLength = radius + gridlineOverlength;


% calculate H2 (line h2-midpointCircle is perpendicular to AlvRidge-palate-line)
h2(:, 1) = line_exp_point_near_2d(ptAlvRidge', p_Palate', ptCircleMidpoint');
% calculate lower right corner of first gridline
h3(:, 1) = line_exp_point_near_2d(p_PharH', p_PharL', p_Lx');
% calculate lower left corner of first gridline
h4(:, 1) = line_exp_point_near_2d(h3', p_Lx', ptCircleMidpoint');

% construct gridlines in the lower pharynx
% angle from vector is sensitiv to the sign of the angle !!
if h3(2) > h4(2)
    angleSign = -1;
else
    angleSign = 1;
end
angleTmp = vector_directions_nd(2, h3'-h4');
angleRot = angleSign * radians_to_degrees(angleTmp(1));

% determine grid lines in the pharyngeal region
% take the first grid line and transform one by one

ptInnerTmp(1:3, 1) = [0 0 0]';
ptOuterTmp(1:3, 1) = [0 gridlineLength 0]';

k = 1;
hasNext = 1;
while hasNext
    
    [ptInnerNew, ptOuterNew] = ...
        get_grdLine_Translation(ptInnerTmp, ptOuterTmp, (k-1)*distGridlines, ...
        [0; h4], [0 0 0]', angleRot);
    
    ptInner(1:3, k) = ptInnerNew;
    ptOuter(1:3, k) = ptOuterNew;
    
    k = k + 1;
    
    % check condition;
    valTmp = points_dist_nd(2, ptInnerNew(2:3), ptCircleMidpoint');
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
        [0; ptCircleMidpoint], [0 0 0]', angleRot + (nbTmp-1)*-angleGridlines);
    
    ptInner(1:3, k) = ptInnerNew;
    ptOuter(1:3, k) = ptOuterNew;
    
    k = k + 1;
    
    % check conditions
    angleTmp = angle_deg_2d(h2', ptCircleMidpoint', ptOuterNew(2:3));
    if angleTmp >= 1.25*angleGridlines
        hasNext = 1;
        nbTmp = nbTmp + 1;
    else
        hasNext = 0;
    end
end


% construct gridlines in the anterior oral cavity (until teeth ...)
angleTmp = vector_directions_nd(2, ptCircleMidpoint'-h2');
angleRot = radians_to_degrees(angleTmp(1));

nbTmp = 1;
hasNext = 1;
while hasNext
    
    [ptInnerNew, ptOuterNew] = ...
        get_grdLine_Translation(ptInnerTmp, ptOuterTmp, (nbTmp-1)*distGridlines, ...
        [0; ptCircleMidpoint], [0 0 0]', 180 + angleRot);
    
    % check conditions
    valTmp = halfplane_contains_point_2d(ptInnerNew(2:3), ...
        ptOuterNew(2:3), ptAlvRidge');
    if valTmp
        
        ptInner(1:3, k) = ptInnerNew;
        ptOuter(1:3, k) = ptOuterNew;
        
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
[~, h5Tmp] = lines_exp_int_2d(p_LipL', p_LipU', ptInner(2:3, k-1)',...
    ptOuter(2:3, k-1)');


h5(2:3, 1) = h5Tmp;

ptInnerTmp = ptInner(1:3, k-1);
ptOuterTmp = ptOuter(1:3, k-1);

% adjust angleGridlines so that the final grdLine crosses the two lip
% points ...
angTotal = angle_deg_2d(ptInnerTmp(2:3, 1)', h5(2:3, 1)', p_LipL');
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
    valTmp1 = halfplane_contains_point_2d(ptInnerNew(2:3), ptOuterNew(2:3), p_LipL');
    valTmp2 = halfplane_contains_point_2d(ptInnerNew(2:3), ptOuterNew(2:3), p_LipL');
    
    if valTmp1 && valTmp2
        
        ptInner(1:3, k) = ptInnerNew;
        ptOuter(1:3, k) = ptOuterNew;
        
        hasNext = 1;
        k = k + 1;
        nbTmp = nbTmp + 1;
    else
        hasNext = 0;
        k = k - 1;
    end
end

% determine gridline of bending ------------------------------------

ptNPW_d = obj.landmarksDerivedMorpho.NPW_d;

indBending = obj.calcGridlineOfBending(ptInner(2:3, :), ptOuter(2:3, :), ...
    ptCircleMidpoint, ptNPW_d);

% assign values ...
grd.innerPt = [ptInner(2, :); ptInner(3, :)];
grd.outerPt = [ptOuter(2, :); ptOuter(3, :)];
grd.numberOfGridlines = k;
grd.indexBending = indBending;

end