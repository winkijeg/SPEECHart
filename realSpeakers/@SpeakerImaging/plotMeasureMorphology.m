function [] = plotMeasureMorphology(obj, featureName, col)

    % specification for ratio
    lengthHead = 5;
    
    pt_ANS = obj.landmarks.ANS;
    pt_PNS = obj.landmarks.PNS;
    pt_AlvRidge = obj.landmarks.AlvRidge;
        
    switch featureName
        
        case 'ratioVH'

            pt_PharL = obj.landmarks.PharL;
            pt_NPW_d = obj.landmarksDerivedMorpho.NPW_d;
            pt_ppdPharL_d = obj.landmarksDerivedMorpho.ppdPharL_d;

            
            line([pt_PharL(2) pt_NPW_d(2)], ...
                [pt_PharL(3) pt_NPW_d(3)],...
                'Color', col, 'LineWidth', 2, 'LineStyle', '--')

            arrow(pt_ANS(2:3), pt_NPW_d(2:3), 'Ends', [1 2],...
                'EdgeColor', col, 'FaceColor', col, 'LineWidth', 2, ...
                'Length', lengthHead);

            arrow(pt_PharL(2:3), pt_ppdPharL_d(2:3), 'Ends', [1 2], ...
                'EdgeColor', col, 'FaceColor', col, 'LineWidth', 2, ...
                'Length', lengthHead);
    
            
        case 'palateAngle'
            
            radiusCircle = 10;
            nSamplePointsArc = 150;  

            pt_Palate = obj.landmarks.Palate;
            
            pt_help1 = line_exp_point_near_3d(pt_ANS, pt_PNS, pt_AlvRidge);

            plot([pt_AlvRidge(2) pt_help1(2)], [pt_AlvRidge(3) pt_help1(3)], col)
            plot([pt_AlvRidge(2) pt_Palate(2)], [pt_AlvRidge(3) pt_Palate(3)], col)

            ptTmp = [pt_Palate(2) pt_AlvRidge(3)]';
            theta1Degree = angle_deg_2d(pt_Palate(2:3), pt_AlvRidge(2:3), ptTmp);
            theta1 = degrees_to_radians(theta1Degree);
            theta2 = degrees_to_radians(theta1Degree + obj.measuresMorphology.palateAngle);

            pt_circleArc = circle_imp_points_arc_2d(radiusCircle, pt_AlvRidge(2:3), theta1, theta2, nSamplePointsArc );

            plot(pt_circleArc(1,:), pt_circleArc(2,:), col)
            
    end

end

