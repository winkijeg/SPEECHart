function [] = plotMeasureMorphology(obj, featureName, col, cAxes)
% plot one feature related to speaker morpology [ ratioVH | palateAngle ]

if nargin == 3
    % create new figure
    cAxes = initPlotFigure(obj, false);
end

ptANS = obj.landmarks.ANS;
ptPNS = obj.landmarks.PNS;
ptAlvRidge = obj.landmarks.AlvRidge;

switch featureName
    
    case 'ratioVH'
        
        pt_PharL = obj.landmarks.PharL;
        pt_NPW_d = obj.landmarksDerivedMorpho.NPW_d;
        pt_ppdPharL_d = obj.landmarksDerivedMorpho.ppdPharL_d;
        
        
        line([pt_PharL(1) pt_NPW_d(1)], ...
            [pt_PharL(2) pt_NPW_d(2)],...
            'Color', col, 'LineWidth', 2, 'LineStyle', '--', 'Parent', cAxes)
        
        
        line([ptANS(1) pt_NPW_d(1)], [ptANS(2) pt_NPW_d(2)], ...
            'Color', col, 'LineWidth', 2, 'LineStyle', '-', 'Parent', cAxes);

        hTmp = line([pt_PharL(1) pt_ppdPharL_d(1)], [pt_PharL(2) pt_ppdPharL_d(2)], ...
            'Color', col, 'LineWidth', 2, 'LineStyle', '-', 'Parent', cAxes);
        
        axes(cAxes)
        line2arrow(hTmp);
        
    case 'palateAngle'
        
        radiusCircle = 10;
        nSamplePointsArc = 150;
        
        ptPalate = obj.landmarks.Palate;
        
        pt_help1 = line_exp_point_near_2d(ptANS', ptPNS', ptAlvRidge');
        
        plot(cAxes, [ptAlvRidge(1) pt_help1(1)], [ptAlvRidge(2) pt_help1(2)], col)
        plot(cAxes, [ptAlvRidge(1) ptPalate(1)], [ptAlvRidge(2) ptPalate(2)], col)
        
        ptTmp = [ptPalate(1) ptAlvRidge(2)]';
        theta1Degree = angle_deg_2d(ptPalate', ptAlvRidge', ptTmp');
        theta1 = degrees_to_radians(theta1Degree);
        theta2 = degrees_to_radians(theta1Degree + ...
            obj.measuresMorphology.palateAngle);
        
        pt_circleArc = circle_imp_points_arc_2d(radiusCircle, ...
            ptAlvRidge', theta1, theta2, nSamplePointsArc );
        
        plot(cAxes, pt_circleArc(1,:), pt_circleArc(2,:), col)
        
end

end
