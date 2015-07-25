function [] = plot(obj, col, grdLines, h_axes)
% plot partially semipolar grid specified by the third argument
%   i.e. 3:7 or only one gridline (i.e. 10)

    if ~exist('grdLines', 'var') || isempty(grdLines)
        grdLines = 1:obj.nGridlines;
    end

    if ~exist('h_axes', 'var') || isempty(h_axes)
        figure;
        hold on;
        h_axes = gca;
    end

    nGrdLinesToPlot = length(grdLines);

    innerXval = obj.innerPt(1, grdLines(1):grdLines(end));
    outerXval = obj.outerPt(1, grdLines(1):grdLines(end));

    innerYval = obj.innerPt(2, grdLines(1):grdLines(end));
    outerYval = obj.outerPt(2, grdLines(1):grdLines(end));

    for nbGridLine = 1:nGrdLinesToPlot
    
        line([innerXval(nbGridLine) outerXval(nbGridLine)], ...
            [innerYval(nbGridLine) outerYval(nbGridLine)], ...
            'Color', col, 'Parent', h_axes);
    end

end
