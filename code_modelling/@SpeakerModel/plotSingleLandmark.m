function [] = plotSingleLandmark(obj, nameOfLandmark, col, repString)
% plot (and label) a single landmark of the vocal tract model
%
% an optional 4th input argument allows for label string substitution 
% before plotting
%
% written 01/2015 by winkler.phonetics@googlemail.com

    fieldNamesStr = fieldnames(obj.landmarks);

    k = strcmp(fieldNamesStr,nameOfLandmark);
    labelOriginal = fieldNamesStr{k};
    
    if (nargin == 3)
        drawLabel = fieldNamesStr{k};
    else
        drawLabel = repString;
    end
        
    ptTmp = obj.landmarks.(labelOriginal)';
    
    plot(ptTmp(1), ptTmp(2), [col '*'], 'MarkerFaceColor', col)
    text(ptTmp(1)+3, ptTmp(2)+3, drawLabel, 'Color', col)
    

end
