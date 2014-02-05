function [] = plotLandmarks(obj, col)

    fieldNamesStr = fieldnames(obj.landmarks);
    nLandmarks = size(fieldNamesStr, 1);

    for k = 1:nLandmarks

        lab_tmp = fieldNamesStr{k};
        ptTmp = obj.landmarks.(lab_tmp)';
    
        plot(ptTmp(1), ptTmp(2), [col 'o'], 'MarkerFaceColor', col)
        text(ptTmp(1)+3, ptTmp(2)+3, lab_tmp, 'Color', col)
    
    end

end
