function [] = plotLandmarksDerived( obj, col )

    fieldNamesStr = fieldnames(obj.landmarksDerivedMorpho);
    nLandmarks = size(fieldNamesStr, 1);

    for k = 1:nLandmarks

        lab_tmp = fieldNamesStr{k};
        ptTmp = obj.landmarksDerivedMorpho.(fieldNamesStr{k})';
    
        plot(ptTmp(1), ptTmp(2), [col 'o'], 'MarkerFaceColor', col)
        text(ptTmp(1)+3, ptTmp(2)+3, lab_tmp, 'Color', col)
    
    end



end

