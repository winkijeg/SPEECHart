function [] = plotMeasureConstriction(obj, featureName, col)

    switch featureName
        case 'relConstrHeight'
            
            ptConstrHeight = obj.UserData.relConstrHeight.ptConstrHeight;
            
            plot(ptConstrHeight(1), ptConstrHeight(2), [col 'o']);
            
    end


end

