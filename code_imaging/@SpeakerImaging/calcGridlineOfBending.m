function indBending = calcGridlineOfBending(innerPt, outerPt, ptCircleMidpoint, ptNPW_d)
    % derives position of VT bending in a radial grid based on ANS-PNS plane

    percentDeviation = 5; % default = 5

    nGrdLines = size(innerPt, 2);

    % find the gridline that devide pharynx from oral cavity, ...
    % hence, front cavity from back cavity 

    k = 1;
    isAngleGreaterFive = 1;
    while ((isAngleGreaterFive) && (k <= nGrdLines))

        nbGridLine = k;
        ptInnerTmp = innerPt(1:2, nbGridLine);
        ptOuterTmp = outerPt(1:2, nbGridLine);

        angleRadTmp = lines_exp_angle_nd(2, ptInnerTmp', ptOuterTmp', ptCircleMidpoint', ptNPW_d');
        angleDeg = radians_to_degrees(angleRadTmp);

        if angleDeg < percentDeviation
            isAngleGreaterFive = 0;
            grdLineBorder = nbGridLine;
        end  
        k = k + 1;
    end

    % assign values ---------------------------------------------------
    indBending = grdLineBorder;

end