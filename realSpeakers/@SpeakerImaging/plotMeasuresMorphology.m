function [] = plotMeasuresMorphology(obj, col)

    lengthHead = 5;
    
    pt_ANS = obj.landmarks.ANS;
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

end

