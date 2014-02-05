function [] = plotContours(obj, flagBspline, col)

    if flagBspline == true
        
        ptsContInner = obj.filteredContours.innerPt(1:2, :);
        ptsContOuter = obj.filteredContours.outerPt(1:2, :);
    
    else
        
        ptsContInner = obj.contours.innerPt(1:2, :);
        ptsContOuter = obj.contours.outerPt(1:2, :);
        
    end        

    plot(ptsContInner(1, :), ptsContInner(2, :), col)
    plot(ptsContOuter(1, :), ptsContOuter(2, :), col)

end

