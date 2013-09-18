function [] = plotSemipolarGrid(obj, col)

    innerXval = obj.semipolarGrid.innerPt(1, :);
    outerXval = obj.semipolarGrid.outerPt(1, :);
    
    innerYval = obj.semipolarGrid.innerPt(2, :);
    outerYval = obj.semipolarGrid.outerPt(2, :);
    
    for k = 1:obj.semipolarGrid.numberOfGridlines
        
        line([innerXval(k) outerXval(k)], ...
            [innerYval(k) outerYval(k)], 'Color', col)
        
    end

end

