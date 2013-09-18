function [] = plotLandmarksDerived( obj, col )

    fieldNamesStr = fieldnames(obj.landmarksDerivedMorpho);
    nLandmarks = size(fieldNamesStr, 1);

    for k = 1:nLandmarks

        lab_tmp = fieldNamesStr{k};
        ptTmp = obj.landmarksDerivedMorpho.(fieldNamesStr{k})';
    
        plot(ptTmp(2), ptTmp(3), [col 'o'], 'MarkerFaceColor', col)
        text(ptTmp(2)+3, ptTmp(3)+3, lab_tmp, 'Color', col)
    
    end



end

