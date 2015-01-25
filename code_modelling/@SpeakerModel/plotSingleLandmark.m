function [] = plotSingleLandmark(obj, nameOfLandmark, col)

    fieldNamesStr = fieldnames(obj.landmarks);
    nLandmarks = size(fieldNamesStr, 1);

    k = strcmp(fieldNamesStr,nameOfLandmark);
    
    lab_tmp = fieldNamesStr{k};
    ptTmp = obj.landmarks.(lab_tmp)';
    
    plot(ptTmp(1), ptTmp(2), [col '*'], 'MarkerFaceColor', col)
    text(ptTmp(1)+3, ptTmp(2)+3, lab_tmp, 'Color', col)
    

end
