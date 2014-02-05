function indBending = calcGridlineOfBending(innerPt, outerPt, ...
    ptCircleMidpoint, ptNPW_d)
% derive VT bending position based on a radial grid relative to ANS-PNS plane

maxTolerance = 5; % default deviation allowed = 5 degrees

nGrdLines = size(innerPt, 2);

% find the gridline that devide pharynx from oral cavity, ...
% hence, front cavity from back cavity
k = 1;
isAngleAboveMaxTolerance = true;
while ((isAngleAboveMaxTolerance) && (k <= nGrdLines))
    
    nbGridLine = k;
    ptInnerTmp = innerPt(1:2, nbGridLine);
    ptOuterTmp = outerPt(1:2, nbGridLine);
    
    angleRadTmp = lines_exp_angle_nd(2, ptInnerTmp', ptOuterTmp', ...
        ptCircleMidpoint', ptNPW_d');
    angleDeg = radians_to_degrees(angleRadTmp);
    
    if angleDeg < maxTolerance
        isAngleAboveMaxTolerance = false;
        grdLineBorder = nbGridLine;
    end
    
    k = k + 1;
    
end

indBending = grdLineBorder;

end