function [] = plotMeasureTongueShape(obj, featureName, col)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    
    nPointsOnCircle = 100;

    switch featureName
        
        case 'curvatureInversRadius'
        
            ptLower = obj.basicData.invRadius.ptStart;
            ptOrigin = obj.basicData.invRadius.ptMid;
            ptUpper = obj.basicData.invRadius.ptEnd;
            
            [r, pc] = circle_exp2imp_2d(ptLower', ptOrigin', ptUpper');
            ptCircle = circle_imp_points_2d(r, pc, nPointsOnCircle);
    
            ptCenterHorizon = [pc(1)+nPointsOnCircle pc(2)];

            theta1 = -lines_exp_angle_nd(2, pc, ptCenterHorizon, pc, ptLower');
            theta2 = lines_exp_angle_nd(2, pc, ptCenterHorizon, pc, ptUpper');

            circSeg = circle_imp_points_arc_2d( r, pc, theta1, theta2, 25);

            plot(ptLower(1), ptLower(2),[col '*'])
            plot(ptOrigin(1), ptOrigin(2),[col '*'])
            plot(ptUpper(1), ptUpper(2),[col '*'])

            plot(ptCircle(1,:), ptCircle(2,:), [col '--'], 'LineWidth', 1)
            plot(circSeg(1,:), circSeg(2,:), [col '-'], 'LineWidth', 2)
            
        case 'quadCoeff'
            
            contPart = obj.basicData.quadCoeff.contPartApproximated;
                        
            plot(contPart(2, :), contPart(3, :), [col '-'], 'Linewidth', 2)
            
        case 'tongLength'
            
            contPart = obj.basicData.tongLength.contPart;
            ptStart = obj.basicData.tongLength.ptStart;
            ptEnd = obj.basicData.tongLength.ptEnd;
            
            plot(contPart(1, :), contPart(2, :), [col '-'], 'Linewidth', 2)
            
            plot(ptStart(1), ptStart(2), [col 's'])
            plot(ptEnd(1), ptEnd(2), [col 's'])
            
    end

end
