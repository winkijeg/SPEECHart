function [] = plotMeasureTongueShape(obj, featureName, col, cAxes)
% plot one feature related to tongue shape
%   possible values are [ curvatureInversRadius | quadCoeff | tongLength ]

nPointsOnCircle = 100;

if nargin == 3
    % create new figure
    cAxes = initPlotFigure(obj, false);
end

switch featureName
    
    case 'curvatureInversRadius'
        
        ptLower = obj.UserData.invRadius.ptStart;
        ptOrigin = obj.UserData.invRadius.ptMid;
        ptUpper = obj.UserData.invRadius.ptEnd;
        
        [r, pc] = circle_exp2imp_2d(ptLower', ptOrigin', ptUpper');
        ptCircle = circle_imp_points_2d(r, pc, nPointsOnCircle);
        
        ptCenterHorizon = [pc(1) + nPointsOnCircle pc(2)];
        
        theta1 = -lines_exp_angle_nd(2, pc, ptCenterHorizon, pc, ptLower');
        theta2 = lines_exp_angle_nd(2, pc, ptCenterHorizon, pc, ptUpper');
        
        circSeg = circle_imp_points_arc_2d( r, pc, theta1, theta2, 25);
        
        plot(cAxes, ptLower(1), ptLower(2),[col '*'])
        plot(cAxes, ptOrigin(1), ptOrigin(2),[col '*'])
        plot(cAxes, ptUpper(1), ptUpper(2),[col '*'])
        
        plot(cAxes, ptCircle(1,:), ptCircle(2,:), [col '--'], 'LineWidth', 1)
        plot(cAxes, circSeg(1,:), circSeg(2,:), [col '-'], 'LineWidth', 2)
        
    case 'quadCoeff'
        
        contPart = obj.UserData.quadCoeff.contPartApproximated;
        
        plot(cAxes, contPart(1, :), contPart(2, :), [col '-'], 'Linewidth', 2)
        
    case 'tongLength'
        
        contPart = obj.UserData.tongLength.contPart;
        ptStart = obj.UserData.tongLength.ptStart;
        ptEnd = obj.UserData.tongLength.ptEnd;
        
        plot(cAxes, contPart(1, :), contPart(2, :), [col '-'], 'Linewidth', 2)
        
        plot(cAxes, ptStart(1), ptStart(2), [col 's'])
        plot(cAxes, ptEnd(1), ptEnd(2), [col 's'])
        
end

end

