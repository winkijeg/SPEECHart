function [] = plotMeasureConstriction(obj, featureName, col, cAxes)
% plot one feature related to vowel constriction
%   So far only one feature is implemented: relConstrHeight

if nargin == 3
    % create new figure
    cAxes = initPlotFigure(obj, false);
end

switch featureName
    
    case 'relConstrHeight'
        
        ptConstrHeight = obj.UserData.relConstrHeight.ptConstrHeight;
        
        plot(cAxes, ptConstrHeight(1), ptConstrHeight(2), [col 'o']);
        
end

end
